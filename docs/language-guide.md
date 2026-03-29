# HolyC Language Guide (This Compiler)

This is a practical guide for what this implementation supports, with references to runnable examples in `src/tests`.

For broader spec-level docs, see https://holyc-lang.com/.

## Program Entry

Typical pattern:

```hc
U0 Main()
{
  "Hello world\n";
}
Main;
```

## Types

Common primitive aliases:

- `I8`, `I16`, `I32`, `I64`
- `U8`, `U16`, `U32`, `U64`
- `F64`
- `Bool`
- `U0` (void-like)

Examples:

- `src/tests/16_types.HC`
- `src/tests/26_f64.HC`

## Variables, `auto`, and Scope

- explicit typing is supported,
- `auto` inference is supported.

Examples:

- `src/tests/27_auto.HC`
- `src/tests/33_static.HC`

## Pointers and Memory

Pointer declarations, addressing, dereference, and heap allocation are heavily used across tests.

Examples:

- `src/tests/22_pointers.HC`
- `src/tests/01_pointer_simple.HC`
- `src/tests/03_malloc_array.HC`

## Arrays

Supports standard arrays and multi-dimensional arrays.

Examples:

- `src/tests/28_arrays.HC`
- `src/tests/34_global_array.HC`

## Control Flow

Supported:

- `if` / `else`
- `switch` / `case`
- `for`
- `while`
- `do while`
- `goto`
- `break`
- `continue`

Examples:

- `src/tests/conditions.HC`
- `src/tests/19_switch.HC`
- `src/tests/20_loops.HC`
- `src/tests/21_goto.HC`
- `src/tests/08_break_continue.HC`

## Functions

Supported:

- regular functions,
- default function parameters,
- function pointers,
- varargs.

Examples:

- `src/tests/09_default_function_parameters.HC`
- `src/tests/repro_171_default_function_pointers.HC`
- `src/tests/12_function_pointer.HC`
- `src/tests/17_varargs.HC`

## Classes, Inheritance, and Unions

Class definitions and inheritance are supported, including recursive class references.

Examples:

- `src/tests/06_class_defs.HC`
- `src/tests/07_recursive_classdef.HC`
- `src/tests/24_union.HC`

## Operators and Casting

- arithmetic/bitwise operators,
- assignment compound operators,
- type casting support.

Examples:

- `src/tests/14_maths.HC`
- `src/tests/11_assignment.HC`
- `src/tests/18_type_casting.HC`

## Preprocessor and Macros

Preprocessor/macro capabilities exist and are tested.

Examples:

- `src/tests/29_macros.HC`
- use CLI `-D<NAME>` to define symbols.

## Runtime Library Usage

Many standard-style helpers are provided via installed `tos.HH` and `libtos` from `src/holyc-lib`.

Examples:

- `src/tests/31_json.HC`
- `src/tests/35_io.HC`
- `src/tests/13_threads.HC`
- `src/tests/30_fzf.HC`
- `src/tests/32_sql.HC` (sqlite-enabled builds)

## Inline Assembly and Transpiler

- Inline assembly usage is supported in the language and handled by the compiler/transpiler flow.
- `hcc -transpile` produces best-effort C output.

See transpiler section in root README for an example.

## Practical Advice

- Treat `src/tests/*.HC` as executable documentation.
- When adding features, add or extend one focused test file.
- If behavior differs from your expectation, inspect `-tokens`, `-ast`, and `--dump-ir` output for the file.
