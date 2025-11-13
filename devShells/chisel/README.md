# Chisel Project (Mill + Makefile)

## Quick Start

```bash
# 复制模板到你的项目目录
cp -r ~/.nixconfigs/devShells/chisel ~/projects/my-chisel-project
cd ~/projects/my-chisel-project

# 激活开发环境
direnv allow  # 或者 nix develop

# 构建和运行
make verilog      # Generate Verilog
make vsim         # Run Verilator simulation
make vsim-trace   # Run with VCD tracing
make test         # Run tests
make clean        # Clean build artifacts
```

## Using Mill directly

```bash
mill your_package_name.compile
mill your_package_name.test
mill your_package_name.runMain your_package_name.Elaborate --target-dir build
```

## Project Structure

```
.
├── flake.nix                     # Nix 开发环境
├── build.mill                    # Mill build definition
├── Makefile                      # Build commands
├── your_package_name/
│   ├── src/
│   │   ├── Elaborate.scala      # Verilog generator
│   │   └── YourMain.scala       # Main module
│   └── test/src/
│       └── YourMainTest.scala   # Tests
├── verilator_csrc/
│   └── sim_main.cc              # C++ testbench
└── build/                        # Generated Verilog (gitignored)
```

## IDE Support

```bash
make bsp          # Generate BSP for Metals/VSCode
make idea         # Generate IntelliJ IDEA project
```

## Notes

- Uses **Mill** as the build tool (faster than sbt)
- **Makefile** provides convenient command shortcuts
- Chinese mirrors (Aliyun) configured for faster downloads
- All dependencies managed by Nix environment
