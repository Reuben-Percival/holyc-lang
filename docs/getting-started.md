# Getting Started

This guide gets you from clone to running HolyC programs with this repository's compiler.

## Requirements

- Linux or macOS (x86_64 tested most heavily)
- `gcc` or `clang`
- `make`
- `cmake`

## Build

From repo root:

```bash
make
```

This configures CMake in `./build` and builds `./hcc`.

## Install

Default install prefix is `/usr/local`:

```bash
make install
```

If your system requires elevated permissions for `/usr/local`, use:

```bash
sudo make install
```

### Install to a custom prefix

```bash
make INSTALL_PREFIX=/tmp/holyc-install
make INSTALL_PREFIX=/tmp/holyc-install install
```

Installed paths:

- compiler: `<prefix>/bin/hcc`
- runtime header: `<prefix>/include/tos.HH`
- runtime static lib (built at install time): `<prefix>/lib/libtos.a`

## First Program

Create `hello.HC`:

```hc
U0 Main()
{
  "Hello world\n";
}
Main;
```

Compile:

```bash
hcc hello.HC -o hello
```

Run:

```bash
./hello
```

## Common Workflows

Compile and run:

```bash
hcc file.HC -run
```

Emit assembly only:

```bash
hcc -S file.HC
```

Print tokens:

```bash
hcc -tokens file.HC
```

Print AST:

```bash
hcc -ast file.HC
```

Transpile to C:

```bash
hcc -transpile file.HC > file.c
```

## Troubleshooting

### `permission denied` during `make install`

Use `sudo make install`, or install to a user-writable prefix:

```bash
make INSTALL_PREFIX=/tmp/holyc-install install
```

### `Failed to open file: /usr/local/include/tos.HH`

`hcc` looks for runtime headers under its configured install prefix.
Install to that prefix, or rebuild with a different `INSTALL_PREFIX`.

### Runtime/test linking errors for `-ltos`

Ensure install step created `libtos.a` in `<prefix>/lib`.
If needed, create the `lib` directory first for custom prefixes:

```bash
mkdir -p /tmp/holyc-install/lib
```
