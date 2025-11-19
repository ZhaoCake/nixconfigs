# GitHub Codespaces 配置指南

本仓库已配置为可直接在 GitHub Codespaces 中使用，提供完整的 Nix 开发环境。

## 🌟 特性

- ✅ 自动安装 Nix 包管理器（用户级安装）
- ✅ 自动应用 Home Manager 配置
- ✅ 预配置的开发工具（Fish、Starship、Nixvim 等）
- ✅ VS Code 扩展自动安装（Nix IDE、direnv 支持）
- ✅ 完整的开发环境模板（Python、Rust、C++、Chisel、SystemVerilog 等）
- ✅ 开箱即用的 Git 配置

## 🚀 快速开始

> **💰 关于额度**: 使用 Codespaces 时，消耗的是**使用者自己的 GitHub 账号额度**（个人账号免费 60小时/月），不是仓库所有者的额度。所以可以放心分享配置！

### 方法 1: 通过 GitHub 网页创建

1. Fork 本仓库到你的 GitHub 账号
2. 在你 fork 的仓库页面，点击绿色的 `Code` 按钮
3. 选择 `Codespaces` 标签
4. 点击 `Create codespace on main`

### 方法 2: 通过 GitHub CLI

```bash
gh codespace create -r YOUR_USERNAME/nixconfigs
```

## 📋 首次启动流程

当你首次启动 Codespace 时，以下操作会自动执行：

1. **基础环境准备** (约 2-3 分钟)
   - 拉取 Codespaces 基础镜像
   - 安装基础工具

2. **Nix 安装** (约 3-5 分钟)
   - 自动下载并安装 Nix 包管理器（单用户模式）
   - 配置 Nix 实验性特性（Flakes）
   - 设置 GitHub token（如果可用）

3. **Home Manager 配置** (约 5-10 分钟)
   - 安装 Home Manager
   - 应用个人配置（Fish、Starship、Nixvim 等）
   - 构建开发环境

4. **VS Code 扩展安装** (约 1-2 分钟)
   - 自动安装 Nix IDE 扩展
   - 配置 direnv 支持
   - 设置 Nix 语言服务器

**总计：首次启动约需 10-20 分钟**

后续启动 Codespace 会快很多（1-2 分钟），因为环境已经构建好了。

## 🔧 配置说明

### .devcontainer/devcontainer.json

这是 Codespaces 的主配置文件：

```json
{
  "name": "Nix Development Environment",
  "image": "mcr.microsoft.com/devcontainers/universal:2",
  "postCreateCommand": "bash .devcontainer/setup.sh",
  ...
}
```

主要配置项：
- **基础镜像**: 使用 Microsoft 的 Universal 镜像（包含常用开发工具）
- **启动脚本**: 运行 `setup.sh` 安装 Nix 和应用配置
- **VS Code 扩展**: 自动安装 Nix 相关扩展
- **终端**: 默认使用 Fish shell

### .devcontainer/setup.sh

自动化安装脚本，执行以下操作：

1. 检查并安装 Nix（使用 Determinate Systems 安装器）
2. 配置 Nix（启用 Flakes、禁用 sandbox）
3. 安装 Home Manager
4. 应用 Home Manager 配置
5. 设置 Fish 为默认 shell

## 🔐 GitHub Token 配置

为了避免 GitHub API 速率限制，建议配置 GitHub token：

### 方法 1: 使用 Codespaces Secrets（推荐）

1. 访问 GitHub Settings → Codespaces → [Secrets](https://github.com/settings/codespaces)
2. 点击 `New secret`
3. 名称: `GITHUB_TOKEN`
4. 值: 你的 Personal Access Token
   - 访问 https://github.com/settings/tokens
   - 生成 token，勾选 `public_repo` 或 `repo` 权限
5. 选择仓库访问权限（推荐选择 "Selected repositories" 并添加本仓库）

设置后，所有 Codespace 都会自动使用这个 token。

### 方法 2: 手动配置

在 Codespace 启动后，编辑 `nix.conf`：

```bash
echo "access-tokens = github.com=YOUR_TOKEN" >> nix.conf
```

然后重新应用配置：
```bash
hmswitch
```

## 💡 使用技巧

### 1. 使用预配置的别名

配置中包含了许多有用的别名：

```bash
# 文件操作
ll          # 使用 eza 列出文件
cat FILE    # 使用 bat 查看文件
tree        # 使用 eza 显示树状结构

# Git 操作
gs          # git status
ga          # git add
gc          # git commit
gp          # git push
gl          # git log

# Nix/Home Manager
hmswitch    # 应用配置
hmupdate    # 更新并应用配置
```

### 2. 使用 direnv 自动加载项目环境

本配置已启用 direnv，进入 `devShells/` 下的任何项目时会自动激活对应环境：

```bash
cd devShells/python    # 自动激活 Python 环境
cd devShells/rust      # 自动激活 Rust 环境
```

### 3. 快速创建新项目

```bash
# 复制模板
cp -r devShells/python my-project
cd my-project

# direnv 会自动激活环境
# 开始编码！
```

### 4. 自定义配置

修改配置文件后，应用更改：

```bash
# 编辑配置
vim home.nix
# 或
vim modules/nixvim.nix

# 应用更改
hmswitch
```

## 📦 预装工具

启动后，你将拥有以下工具：

### 基础工具
- `git`, `curl`, `wget`, `tree`, `htop`, `btop`
- `ripgrep` (rg), `fd`, `bat`, `eza`
- `glow` - Markdown 预览工具

### Shell 环境
- **Fish Shell** - 现代化的交互式 shell
- **Starship** - 跨 shell 的提示符

### 编辑器
- **Nixvim** - 预配置的 Neovim
  - LSP 支持（Nix、Python、Rust、C/C++、Scala 等）
  - 文件树、模糊查找、Git 集成
  - 语法高亮、自动补全
  - Markdown 预览支持

### 开发环境（按需激活）
- Python（通过 direnv）
- Rust（通过 direnv）
- C/C++（通过 direnv）
- SystemVerilog + Verilator（通过 direnv）
- Chisel + Scala（通过 direnv）
- Bluespec SystemVerilog（通过 direnv）

## 🐛 故障排除

### 问题 1: Nix 安装失败

**症状**: 看到 "Failed to install Nix" 错误

**解决方法**:
```bash
# 手动运行安装脚本
bash .devcontainer/setup.sh
```

### 问题 2: Home Manager 配置失败

**症状**: 看到 "Failed to apply configuration" 警告

**解决方法**:
```bash
# 检查用户名配置
grep 'home.username' home.nix

# 手动应用配置（替换 USERNAME）
home-manager switch --flake .#USERNAME
```

### 问题 3: GitHub 速率限制

**症状**: 看到 "GitHub API rate limit exceeded"

**解决方法**:
1. 配置 GitHub token（见上文）
2. 或者等待速率限制重置（通常 1 小时）

### 问题 4: Fish 未设为默认 shell

**症状**: 终端仍使用 bash

**解决方法**:
```bash
# 手动启动 Fish
fish

# 或重新打开终端
```

### 问题 5: 磁盘空间不足

**症状**: "No space left on device"

**解决方法**:
```bash
# 清理 Nix store
nix-collect-garbage -d

# 清理旧的 home-manager 版本
home-manager expire-generations "-7 days"
```

## 🔄 更新配置

### 在 Codespace 中更新

```bash
# 拉取最新代码
git pull

# 更新 flake.lock
nix flake update

# 应用更新
hmswitch
```

### 重建 Codespace

如果遇到严重问题，可以删除并重建 Codespace：

1. 访问 https://github.com/codespaces
2. 找到你的 Codespace
3. 点击 `...` → `Delete`
4. 重新创建 Codespace

## 📊 资源使用

Codespaces 提供不同的机器类型：

| 机型 | CPU | RAM | 存储 | 适用场景 |
|------|-----|-----|------|----------|
| 2-core | 2 | 8GB | 32GB | 轻量开发（推荐） |
| 4-core | 4 | 16GB | 32GB | 一般开发 |
| 8-core | 8 | 32GB | 64GB | 重度开发、大型编译 |

对于本配置，**2-core 机型完全够用**。

## 🎯 最佳实践

### 1. 定期提交配置

在 Codespace 中修改配置后，记得提交：

```bash
git add home.nix modules/
git commit -m "Update configuration"
git push
```

### 2. 使用 prebuild（可选）

为了更快启动，可以配置 [Codespaces Prebuilds](https://docs.github.com/en/codespaces/prebuilding-your-codespaces)：

1. 访问仓库 Settings → Codespaces
2. 启用 Prebuilds
3. 选择触发条件（如 push to main）

这样每次推送代码后，GitHub 会自动构建环境，后续启动只需 1-2 分钟。

### 3. 本地开发 + Codespaces

你可以在本地和 Codespaces 之间无缝切换：

- **本地**: 完整功能，离线可用
- **Codespaces**: 快速启动，随时随地，无需配置

配置文件是同步的，两边体验一致！

### 4. 停用不用的 Codespace

Codespaces 闲置 30 分钟会自动停止，但建议主动停用：

```bash
# 在 Codespace 中
gh codespace stop
```

或在网页上操作：https://github.com/codespaces

## 🆚 Codespaces vs 本地开发

| 对比项 | Codespaces | 本地开发 |
|--------|------------|----------|
| 启动速度 | ⚡ 快（预构建） | 🐌 慢（首次需构建） |
| 网络依赖 | ✅ 必需 | ❌ 可离线 |
| 配置同步 | ✅ 自动 | ⚠️ 需手动 git |
| 机器性能 | ☁️ GitHub 提供 | 💻 取决于本地 |
| 免费额度 | 60小时/月（个人） | ♾️ 无限制 |
| 数据安全 | ☁️ 托管在 GitHub | 🔒 本地存储 |

**推荐用法**:
- 💡 快速测试/演示 → Codespaces
- 🏗️ 长期开发项目 → 本地
- 🚀 两者结合 → 最佳体验

## 📚 相关资源

- [GitHub Codespaces 文档](https://docs.github.com/en/codespaces)
- [Dev Container 规范](https://containers.dev/)
- [Nix on Codespaces 最佳实践](https://nixos.wiki/wiki/Codespaces)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)

## 💬 反馈与支持

如果遇到问题或有改进建议：

1. 检查本文档的故障排除部分
2. 查看 GitHub Issues
3. 提交新的 Issue

---

**享受你的云端开发环境！** ☁️✨
