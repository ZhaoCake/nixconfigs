# SystemVerilog Project with Verilator

## Quick Start

```bash
# 复制模板到你的项目目录
cp -r ~/.nixconfigs/devShells/systemverilog ~/projects/my-sv-project
cd ~/projects/my-sv-project

# 激活开发环境
direnv allow  # 或者 nix develop

# 构建和运行
make sim       # 构建并运行仿真
make trace     # 运行并生成波形
make lint      # 检查代码
make clean     # 清理
```

## Project Structure

```
.
├── flake.nix          # Nix 开发环境定义
├── .envrc             # direnv 自动激活配置
├── Makefile           # 构建配置
├── rtl/
│   └── top.sv        # SystemVerilog RTL
├── tb/
│   └── testbench.cpp # C++ testbench
└── build/            # 构建输出 (gitignored)
    ├── sim           # 编译后的仿真器
    └── wave.vcd      # 波形文件
```

## Tools

- **Verilator**: 高性能 SystemVerilog 仿真器
- **GTKWave**: 波形查看器
- **Verible**: SystemVerilog linter 和 formatter

## Viewing Waveforms

```bash
make trace
gtkwave build/wave.vcd
```
