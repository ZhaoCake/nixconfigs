# SystemC Project Template (Flake + Direnv)

This is a template for a SystemC project using Nix Flakes and `direnv`.

## Prerequisites

- Nix package manager
- direnv (recommended)

## Setup

1.  Allow direnv to load the environment:
    ```bash
    direnv allow
    ```
    Or use `nix develop` directly.

2.  Build the project:
    ```bash
    mkdir build && cd build
    cmake ..
    make
    ```

3.  Run the executable:
    ```bash
    ./hello_sc
    ```

## Structure

- `flake.nix`: Defines the development environment with SystemC.
- `.envrc`: Loads the flake environment automatically.
- `CMakeLists.txt`: Build configuration.
- `src/main.cpp`: Simple SystemC example.

## Notes

- The environment uses `pkg-config` to find SystemC.
- You can add more dependencies in `flake.nix`.
