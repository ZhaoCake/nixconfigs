# Bluespec SystemVerilog Project

## Quick Start

```bash
# 复制模板到你的项目目录
cp -r ~/.nixconfigs/devShells/bsv ~/projects/my-bsv-project
cd ~/projects/my-bsv-project

# 激活开发环境
direnv allow  # 或者 nix develop

# 编译和运行
make verilog   # BSV → Verilog
make verilator # 使用 Verilator 仿真
make iverilog  # 使用 Icarus Verilog 仿真
```

## Project Structure

```
.
├── flake.nix              # Nix 开发环境
├── .envrc                 # direnv 配置
├── Makefile               # 构建脚本
├── bsv_src/
│   └── Top.bsv           # BSV 源代码
├── verilator_src/
│   └── sim_main.cpp      # Verilator testbench
└── build/
    └── verilog/          # 生成的 Verilog
```

## Tools

- **bsc**: Bluespec 编译器
- **Verilator**: 快速 cycle-accurate 仿真
- **Icarus Verilog**: 传统 Verilog 仿真器
- **GTKWave**: 波形查看器

## Viewing Waveforms

```bash
make verilator  # 或 make iverilog
gtkwave wave.vcd
```
