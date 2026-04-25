# NEST Simulator Install Script

Builds and installs [NEST Simulator](https://www.nest-simulator.org/) from source into `~/nest/`, self-contained with no system-wide installation required.

## Requirements

- Ubuntu/Debian-based Linux
- `sudo` access (for `apt`)
- Python 3

## Usage

```bash
chmod +x install.sh
./install.sh
source ~/.bashrc
```

Then verify:

```bash
python3 -c 'import nest; print(nest.__version__)'
```

## What it does

1. Installs system dependencies via `apt`
2. Creates a temporary venv at `~/nest/nest-venv/` to build Python extensions
3. Clones the NEST source into `~/nest/nest-simulator/`
4. Configures with CMake (MPI and Python bindings enabled)
5. Builds with all available CPU cores
6. Installs everything into `~/nest/`
7. Adds `PATH`, `LD_LIBRARY_PATH`, and `PYTHONPATH` to `~/.bashrc`

The venv is only used during the build — NEST itself runs under your system Python via the `PYTHONPATH` export.

## Layout

```
~/nest/
├── bin/            # NEST executables
├── lib/            # Shared libraries + PyNEST
├── nest-simulator/ # Source code
├── nest-build/     # Build artifacts
└── nest-venv/      # Build-time venv (not needed after install)
```
