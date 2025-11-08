# Python 开发环境使用指南

## 🚀 快速开始

### 创建新项目

```bash
# 使用 uv 创建项目
new-python-project my-awesome-app

# 或手动创建
uv init my-project
cd my-project
```

### 基本工作流

```bash
# 1. 创建虚拟环境
uv venv

# 2. 激活环境 (Fish shell)
source .venv/bin/activate.fish

# 3. 安装依赖
uv pip install requests numpy pandas

# 4. 运行代码
python main.py

# 或使用 uv 直接运行（推荐）
uv run python main.py
```

---

## 📦 uv 包管理器

uv 是一个极快的 Python 包管理器，由 Rust 编写，可替代 pip、pip-tools、virtualenv 等工具。

### 常用命令

```bash
# 创建虚拟环境
uv venv

# 安装包
uv pip install requests
uv pip install -r requirements.txt

# 安装开发依赖
uv pip install pytest black ruff mypy

# 列出已安装的包
uv pip list

# 冻结依赖
uv pip freeze > requirements.txt

# 运行脚本
uv run python script.py

# 运行命令（自动使用虚拟环境）
uv run pytest
uv run black .
```

### 使用 pyproject.toml

创建 `pyproject.toml`：

```toml
[project]
name = "my-project"
version = "0.1.0"
description = "My awesome project"
requires-python = ">=3.12"
dependencies = [
    "requests>=2.31.0",
    "numpy>=1.26.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.4.0",
    "black>=23.0.0",
    "ruff>=0.1.0",
    "mypy>=1.7.0",
]
```

然后：

```bash
# 安装项目依赖
uv pip install -e .

# 安装开发依赖
uv pip install -e ".[dev]"
```

---

## 🔧 已配置的镜像源

### pip 配置（清华源）

配置文件：`~/.pip/pip.conf`

```ini
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple

[install]
trusted-host = pypi.tuna.tsinghua.edu.cn
```

### uv 配置（清华源）

配置文件：`~/.config/uv/uv.toml`

```toml
[pip]
index-url = "https://pypi.tuna.tsinghua.edu.cn/simple"
```

### 其他可用镜像源

- 清华：`https://pypi.tuna.tsinghua.edu.cn/simple`
- 中科大：`https://mirrors.ustc.edu.cn/pypi/simple`
- 阿里云：`https://mirrors.aliyun.com/pypi/simple`

临时使用其他源：

```bash
uv pip install -i https://mirrors.aliyun.com/pypi/simple requests
```

---

## 🛠️ 开发工具

### 已安装的全局工具

- **python312** - Python 3.12 解释器
- **uv** - 快速包管理器
- **ipython** - 增强的交互式 shell
- **black** - 代码格式化工具
- **ruff** - 极快的 linter（替代 flake8/pylint）
- **pytest** - 测试框架
- **mypy** - 类型检查工具

### 代码格式化

```bash
# 使用 black
black .

# 使用 ruff
ruff format .
```

### 代码检查

```bash
# 使用 ruff（推荐，速度快）
ruff check .

# 自动修复
ruff check --fix .
```

### 类型检查

```bash
mypy .
```

---

## ⌨️ Nixvim LSP

Python LSP (pyright) 已配置，提供：

- 自动补全
- 类型检查
- 跳转到定义
- 查找引用
- 重命名

**快捷键：**
- `gd` - 跳转到定义
- `gr` - 查找引用
- `K` - 显示文档
- `<leader>ca` - 代码操作
- `<leader>rn` - 重命名
- `<leader>f` - 格式化代码

---

## 📝 项目结构示例

### 简单脚本项目

```
my-project/
├── .venv/              # 虚拟环境
├── main.py             # 主程序
├── requirements.txt    # 依赖列表
└── .gitignore
```

### 包项目

```
my-package/
├── .venv/
├── src/
│   └── my_package/
│       ├── __init__.py
│       └── core.py
├── tests/
│   └── test_core.py
├── pyproject.toml      # 项目配置
├── README.md
└── .gitignore
```

---

## 🎯 最佳实践

### 1. 使用虚拟环境

**始终**在项目中使用虚拟环境：

```bash
uv venv
source .venv/bin/activate.fish
```

### 2. 锁定依赖版本

```bash
# 开发时
uv pip install requests

# 部署前冻结版本
uv pip freeze > requirements.txt
```

### 3. 使用 pyproject.toml

现代 Python 项目推荐使用 `pyproject.toml` 而不是 `setup.py`。

### 4. 配置 .gitignore

```gitignore
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
.venv/
venv/
env/

# IDE
.vscode/
.idea/
*.swp

# Testing
.pytest_cache/
.coverage
htmlcov/
```

---

## 🔍 常见问题

### uv vs pip 的优势

- ⚡ **速度快** - 比 pip 快 10-100 倍
- 🔒 **更好的锁定** - 依赖解析更可靠
- 🚀 **一体化** - 集成虚拟环境、包安装等功能
- 📦 **兼容 pip** - 完全兼容 pip 的命令和 requirements.txt

### 为什么使用 uv 而不是 Nix 管理 Python 包？

- ✅ **通用性** - 在任何机器上都能用
- ✅ **生态兼容** - 与 Python 生态无缝集成
- ✅ **团队协作** - 不需要团队成员都使用 Nix
- ✅ **灵活性** - 可以快速切换 Python 版本和包版本

Nix 提供基础的 Python 和工具，uv 管理项目依赖。

### 激活虚拟环境

```bash
# Fish shell
source .venv/bin/activate.fish

# Bash/Zsh
source .venv/bin/activate

# 或使用 uv run（无需激活）
uv run python script.py
```

---

## 📚 相关链接

- [uv 文档](https://github.com/astral-sh/uv)
- [Python 3.12 新特性](https://docs.python.org/3.12/whatsnew/3.12.html)
- [清华 PyPI 镜像](https://mirrors.tuna.tsinghua.edu.cn/help/pypi/)
- [ruff 文档](https://docs.astral.sh/ruff/)
