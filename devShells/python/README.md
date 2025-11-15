# Python Project

## Quick Start

```bash
# 使用 nix-init 创建项目
nix-init python my-python-project
cd my-python-project

# 创建虚拟环境
uv venv
source .venv/bin/activate.fish  # 或 activate (bash)

# 安装依赖
uv pip install requests pandas numpy

# 运行
python main.py
# 或
uv run python main.py
```

## Tools

- **Python 3.12**: 解释器
- **uv**: 现代包管理器（比 pip 快很多）
- **pytest**: 测试框架
- **black**: 代码格式化
- **ruff**: 快速 linter
- **mypy**: 类型检查
- **ipython**: 交互式 shell

## Using uv

```bash
# 初始化项目
uv init

# 创建虚拟环境
uv venv

# 安装包
uv pip install package-name

# 运行脚本
uv run python script.py

# 同步依赖（从 pyproject.toml）
uv sync
```

## 配置镜像源

pip 和 uv 的镜像源配置在 `~/.pip/pip.conf` 和 `~/.config/uv/uv.toml`。
