# HolyC Compiler Docs

This directory contains local, repo-focused documentation for `hcc`.

If you want language theory and broader website docs, see:
- https://holyc-lang.com/

If you want practical guidance for this codebase, start here.

## Quick Start

1. Read [Getting Started](./getting-started.md)
2. Read [CLI Reference](./cli-reference.md)
3. Run tests with [Testing](./testing.md)

## For Contributors

1. Read [Compiler Architecture](./compiler-architecture.md)
2. Read [Language Guide](./language-guide.md)
3. Use `src/tests/*.HC` as executable examples/specs

## Document Map

- [Getting Started](./getting-started.md): build, install, run your first `.HC` program.
- [CLI Reference](./cli-reference.md): every compiler option currently implemented in `src/cli.c`.
- [Testing](./testing.md): `make test`, `make unit-test`, sqlite-related behavior, and cleanup details.
- [Compiler Architecture](./compiler-architecture.md): how lexing/parsing/codegen/transpiling fit together, with file-level pointers.
- [Language Guide](./language-guide.md): HolyC usage patterns supported by this compiler, with links to tests.
