# Compiler Architecture

This compiler is intentionally simple: it is mostly a direct pipeline from source to assembly text, then delegated assembly/linking via system C toolchain.

## High-Level Pipeline

Entry point: `src/main.c`

1. Parse CLI args (`src/cli.c`)
2. Configure compilation context (`Cctrl`)
3. Lex + preprocess + parse to AST (`src/compile.c`, `src/lexer.c`, `src/parser.c`)
4. Optional debug/inspection exits (`-tokens`, `-ast`, `--dump-ir`, CFG outputs)
5. Generate assembly (`src/x86.c` for current x86 path)
6. Write temporary assembly file (`/tmp/holyc-asm.s`)
7. Invoke system compiler/linker (`gcc` or target-specific command) via `system(...)`

The implementation is intentionally non-optimizing and prioritizes simplicity/readability over advanced backend sophistication.

## Why It Works This Way

- Fast iteration: text assembly + external assembler/linker avoids re-implementing object emission and full linker behavior.
- Small core: parser and AST/codegen logic stay centralized in C, without requiring a full custom backend stack.
- C interop by design: linking against libc and custom libs is straightforward.

Tradeoff:

- Less control over optimization and low-level binary details.
- Diagnostics are improving but still less polished than mature production compilers.

## Main Components

## CLI and Command Routing

- `src/cli.c`
- `src/cli.h`

Responsibilities:

- option parsing,
- input file classification (`.HC`, `.HH`, `.s`),
- global mode switches (`-run`, `-S`, `-transpile`, etc.),
- usage/version/help text.

## Frontend (Lexing + Parsing)

- `src/lexer.c`
- `src/parser.c`
- `src/prslib.c`, `src/prsasm.c`, `src/prsutil.c`

Responsibilities:

- tokenization/preprocessing,
- AST construction,
- semantic checks and parse-time diagnostics.

Builtin runtime header injection:

- `compileToAst` pushes `<install-prefix>/include/tos.HH` before parsing source.

## AST / Control Context

- `src/ast.c`, `src/ast.h`
- `src/cctrl.c`, `src/cctrl.h`

`Cctrl` is the central compile context carrying:

- macro definitions,
- parse state,
- AST list,
- error reporting context.

## IR and CFG Utilities

- `src/ir*.c`
- `src/cfg*.c`

These support debug visibility (`--dump-ir`) and control-flow graph export (`-cfg`, `-cfg-png`, `-cfg-svg`).

## Codegen and Emission

- x86 path: `src/x86.c`
- aarch64 codegen support: `src/codegen-aarch64.c` (backend path gated in `main.c`)

Assembly emission flow:

- AST to assembly buffer (`AoStr`)
- assembly buffer to `/tmp/holyc-asm.s`
- shell out to C compiler for object/binary/library creation.

## Runtime Library Packaging

Install flow (`src/CMakeLists.txt`) installs:

- `hcc` binary,
- `tos.HH` header,
- and uses `hcc -lib tos src/holyc-lib/all.HC` to build/install `libtos.a` (and dynlib path where enabled).

This makes HolyC runtime helpers available to compiled programs.

## Memory Model

The project uses custom arena/pool style allocators:

- `src/arena.*`
- `src/mempool.*`
- `src/memory.*`
- `src/aostr.*`

Why:

- compiler phases allocate many short-lived objects,
- whole-program lifetime allocation is simple,
- teardown happens mostly at end of compile invocation.

Implication:

- code must avoid `free()` on arena-backed allocations.

## Build and Test Integration

- Root `Makefile` wraps CMake build/install/test calls.
- `make test` executes full `src/tests/*.HC` compile+run loop.
- `make unit-test` uses CMake custom target around `src/tests/run.HC`.

## Reading Order for New Contributors

1. `src/main.c`
2. `src/cli.c`
3. `src/compile.c`
4. `src/lexer.c` and `src/parser.c`
5. `src/x86.c`
6. `src/tests/*.HC`
