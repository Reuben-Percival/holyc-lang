# Testing

This repository currently has two test entry points:

- `make test` (root Makefile target)
- `make unit-test` (CMake custom target)

## Recommended: `make test`

From repo root:

```bash
make test
```

What it does:

1. Builds `hcc` via `make all`.
2. Iterates over `src/tests/*.HC`.
3. Compiles each test file to a temporary `.bin` executable.
4. Runs each executable and streams stdout/stderr live.
5. Deletes generated binaries and known artifacts after each test and at end.
6. Prints a final summary and returns non-zero exit if any test failed.

Skipped files:

- `run.HC`
- `testhelper.HC`
- `32_sql.HC` if sqlite support is not enabled.

Cleanup performed:

- `src/tests/*.bin`
- `src/tests/a.out`
- `src/tests/test-runner`
- `src/tests/_test.db`

## CMake `unit-test` target

```bash
make unit-test
```

This path compiles and runs `src/tests/run.HC` through an installed `hcc` path.

Important:

- It expects `hcc` at `<install-prefix>/bin/hcc`.
- If you changed prefix, run with matching install prefix first.

Example:

```bash
make INSTALL_PREFIX=/tmp/holyc-install
mkdir -p /tmp/holyc-install/lib
make INSTALL_PREFIX=/tmp/holyc-install install
make INSTALL_PREFIX=/tmp/holyc-install unit-test
```

## SQLite-Related Tests

`32_sql.HC` requires sqlite support.

Enable at configure/build time:

```bash
make CFLAGS='-Wextra -Wall -Wpedantic' BUILD_TYPE=Release
cmake -S ./src -B ./build -DHCC_LINK_SQLITE3=1
make -C ./build
```

Or add `-DHCC_LINK_SQLITE3=1` to your CMake/Make wrapper flow.

## Test File Conventions

The `src/tests` files function as executable language examples.
Use these when:

- validating parser/codegen behavior,
- adding language features,
- confirming regressions stay fixed.
