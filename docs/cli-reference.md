# CLI Reference

This reflects options implemented in `src/cli.c`.

## Usage

```bash
hcc [OPTIONS] file
```

Input file types:

- `.HC` (source)
- `.HH` (header)
- `.s` (assembly input for assemble mode)

Extensions are case-insensitive.

## Core Compile Options

- `-o <name>`
  - Output binary filename.
- `-run`
  - Compile and immediately run the result (not a JIT).
- `-S`
  - Emit assembly only.
- `-o-`
  - Print assembly to stdout; valid only with `-S`.
- `-obj`
  - Emit an object file.
- `-lib <libname>`
  - Emit static and dynamic library artifacts.
- `-clibs <libs>`
  - Extra C libs passed to linker, for example:
  - `-clibs='-lSDL2 -lxml2 -lcurl'`

## Debug/Inspection Options

- `-tokens`
  - Print lexer tokens and exit.
- `-ast`
  - Print AST and exit.
- `--dump-ir`
  - Dump IR to stdout.
- `--mem-stats`
  - Print allocator/memory usage stats.

## CFG (Control Flow Graph) Options

- `-cfg`
  - Create Graphviz `.dot` control-flow graph output.
- `-cfg-png`
  - Create CFG and render PNG via `dot`.
- `-cfg-svg`
  - Create CFG and render SVG via `dot`.

`-cfg-png` and `-cfg-svg` require Graphviz installed (`dot` in `PATH`).

## Preprocessor/Defines

- `-D<NAME>`
  - Define a compiler macro symbol.
  - Value assignment is not currently supported here; this flag is symbol-only.

Examples:

```bash
hcc -DDEBUG file.HC
hcc -D__HCC_LINK_SQLITE3__ file.HC
```

## Transpiler

- `-transpile`
  - Transpile HolyC to C (best effort).

Example:

```bash
hcc -transpile file.HC > file.c
```

## Metadata and Help

- `--help`
  - Show command usage and options.
- `--version`
  - Show compiler version, commit hash, arch, and build mode.
- `--terry`
  - Print short Terry A. Davis info text.

## Behavior Notes

- `-o-` without `-S` is rejected.
- If no input file is provided, compiler exits with fatal error.
- `.s` input triggers assemble mode.
