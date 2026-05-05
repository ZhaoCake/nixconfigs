# Nix 开发环境配置

![CI Status](https://github.com/zhaocake/nixconfigs/workflows/CI/badge.svg)

这是一个优雅的、模块化的 Nix + Home Manager 配置，用于管理用户级别的开发环境。

> **✨ 特性**: 
> - 🏠 本地安装：支持 Arch Linux 等发行版的用户级 Nix 安装
> - ☁️ 云端使用：也可在 GitHub Codespaces 中使用（详见 [CODESPACES.md](CODESPACES.md)）
> - 🔒 密钥加密：通过 agenix 安全管理 API 密钥，加密存储可随 Git 同步
> - 🤖 AI 助手：集成 OpenCode + oh-my-openagent 插件，多模型多 Agent 编排
> - 🔄 自动化测试：每次推送代码时自动验证配置正确性

## 📁 项目结构

```
~/.nixconfigs/
├── flake.nix              # Flake 主入口文件
├── home.nix               # Home Manager 用户配置
├── nix.conf               # Nix 配置文件（包含 GitHub token，不提交）
├── nix.conf.example       # Nix 配置模板（提交到 Git）
├── install.sh             # 自动安装脚本
├── fix-permissions.sh     # 权限修复脚本
├── .gitignore             # Git 忽略文件
├── secrets/               # 加密的 API 密钥（agenix）
│   ├── README.md          # 密钥管理说明
│   ├── anthropic_api_key.age
│   ├── chatanywhere_api_key.age
│   ├── siliconflow_api_key.age
│   ├── deepseek_api_key.age
│   └── ark_api_key.age
├── modules/               # 工具配置模块
│   ├── aiassistant.nix   # AI 助手统一入口（导入下方三个模块 + 密钥管理）
│   ├── claudecode.nix    # Claude Code CLI 配置
│   ├── codex.nix         # OpenAI Codex CLI 配置
│   ├── opencode.nix      # OpenCode CLI + oh-my-openagent 插件配置
│   ├── secrets.nix       # agenix 密钥声明与解密路径
│   ├── fish.nix          # Fish Shell 配置
│   ├── starship.nix      # Starship 提示符配置
│   ├── fastfetch.nix     # 系统信息显示
│   ├── tmux.nix          # Tmux 终端复用器
│   ├── zellij.nix        # Zellij 终端复用器
│   ├── uv.nix            # Python uv 包管理器
│   ├── fvim.nix          # 独立 Fennel/Hotpot Neovim
│   └── vim/              # Nixvim (Neovim) 模块化配置
│       ├── default.nix
│       ├── packages.nix
│       └── nixvim/       # Nixvim 子模块（LSP, 补全, AI, 导航等）
├── devShells/             # Per-project 开发环境 (direnv)
│   └── README.md         # DevShell 使用说明
├── hosts/                 # NixOS 机器配置
│   ├── matebook/         # Matebook 笔记本
│   └── nixos-vm/         # NixOS 虚拟机
├── README.md             # 本文件
└── QUICKREF.md           # 快速参考
```

## 🚀 快速开始

### 1. 安装 Nix

如果还没有安装 Nix，在 Arch Linux 上执行：

```bash
# 安装 Nix（推荐多用户安装）
sh <(curl -L https://nixos.org/nix/install) --daemon
```

**注意**: 安装后需要重新登录以加载环境变量。

### 2. 修复权限并启动 Nix 服务

对于多用户安装（推荐），需要确保 Nix daemon 正在运行：

```bash
cd ~/.nixconfigs
./fix-permissions.sh
```

### 3. 配置 GitHub Token（避免速率限制）

```bash
cp ~/.nixconfigs/nix.conf.example ~/.nixconfigs/nix.conf
# 编辑 nix.conf，填入 GitHub token
```

### 4. 应用配置

```bash
cd ~/.nixconfigs
./install.sh
```

### 5. 设置 Fish 为默认 Shell（可选）

```bash
echo $(which fish) | sudo tee -a /etc/shells
chsh -s $(which fish)
```

## 🔒 密钥管理 (agenix)

本仓库使用 [agenix](https://github.com/ryantm/agenix) + [age](https://github.com/FiloSottile/age) 加密管理所有 API 密钥，密钥文件以 `.age` 格式存储在 `secrets/` 目录，可安全提交至 Git。

- **加密**: 使用 age 专用公钥（独立于 SSH 密钥）
- **解密**: `home-manager switch` 时 agenix 自动读取 `~/.config/sops/age/keys.txt` 解密到 `~/.config/ai-secrets/`
- **多机器**: 只需将 age 私钥复制到新机器即可

详细文档见 [secrets/README.md](secrets/README.md)。

### 常用操作

```bash
# 编辑密钥（自动解密/加密）
nix run github:ryantm/agenix -- -e secrets/anthropic_api_key.age

# 手动解密
age --decrypt -i ~/.config/sops/age/keys.txt secrets/anthropic_api_key.age
```

## 🤖 AI 助手配置

本仓库集成了多个 AI 编码助手，统一在 `modules/aiassistant.nix` 中管理：

| 工具 | 模块 | 说明 |
|------|------|------|
| **OpenCode** | `opencode.nix` | 主力编码工具，集成 oh-my-openagent 插件 |
| **Claude Code** | `claudecode.nix` | Anthropic Claude CLI |
| **Codex** | `codex.nix` | OpenAI Codex CLI |

### OpenCode + oh-my-openagent

OpenCode 配置了 [oh-my-openagent](https://github.com/code-yeongyu/oh-my-openagent) 插件，提供多 Agent 编排能力：

| Agent | 主模型 | 用途 |
|-------|--------|------|
| **Sisyphus** | Claude Opus 4.6 (NewCLI) | 主力编码 Agent |
| **Prometheus** | Claude Opus 4.6 (NewCLI) | 战略规划 |
| **Atlas** | Claude Opus 4.6 (NewCLI) | Todo 编排 |
| **Oracle** | DeepSeek V4 Pro | 架构/调试 |
| **Hephaestus** | DeepSeek V4 Pro | 深度自主工作 |
| **Explore** | DeepSeek V4 Flash | 快速代码搜索 |
| **Librarian** | DeepSeek V4 Flash | 文档/代码检索 |

### Provider 列表

| Provider | 端点 | 模型 |
|----------|------|------|
| NewCLI Anthropic | `code.newcli.com` | Claude Opus 4.6, Claude Sonnet 4.6 |
| DeepSeek | `api.deepseek.com` | V4 Pro, V4 Flash |
| ChatAnywhere | `api.chatanywhere.tech` | GPT-5.3-Codex |
| SiliconFlow | `api.siliconflow.cn` | GLM-5.1 |
| Ark (Volcengine) | `ark.cn-beijing.volces.com` | GLM-5.1 |

配置文件：`~/.config/opencode/opencode.jsonc` + `~/.config/opencode/oh-my-openagent.json`

## ⚠️ 故障排除

### 权限错误："Permission denied" 访问 /nix/store

```bash
cd ~/.nixconfigs && ./fix-permissions.sh
```

### agenix 解密失败

确保 `~/.config/sops/age/keys.txt` 存在且权限正确（600）。如果更换了 age 密钥，需用新公钥重新加密所有 `.age` 文件：

```bash
AGE_PUB=$(age-keygen -y ~/.config/sops/age/keys.txt)
for f in secrets/*.age; do
  plaintext=$(age --decrypt -i ~/.config/sops/age/keys.txt "$f")
  echo "$plaintext" | age --encrypt -r "$AGE_PUB" -o "$f"
done
```

### Nix daemon 未运行

```bash
systemctl status nix-daemon.service
sudo systemctl start nix-daemon.service
sudo systemctl enable nix-daemon.service
```

## 📝 使用说明

### 更新配置

```bash
hmswitch        # 应用配置变更
hmupdate        # 更新 flake 输入并应用
```

### 添加开发环境

使用 `nix-init` 命令快速创建项目：

```bash
nix-init cpp my-app       # 创建 C++ 项目
nix-init scala             # 在当前目录初始化 Scala
```

见 [devShells/README.md](devShells/README.md)。

## 📦 包含的工具

### 基础工具
- git, curl, wget, tree, htop, btop
- ripgrep (rg), fd, bat, eza, fzf, jq, yazi

### Shell 环境
- Fish Shell + Starship 提示符

### 编辑器
- Nixvim (Neovim) + 独立 Fennel Neovim (fvim)

### AI 助手
- OpenCode + oh-my-openagent
- Claude Code, Codex

### 终端复用
- Tmux, Zellij

## 🔗 有用的命令

```bash
home-manager packages              # 查看已安装的包
home-manager generations           # 查看配置历史
nix flake show ~/.nixconfigs      # 查看 Flake 信息
nix-collect-garbage --delete-older-than 7d  # 清理旧版本
```

## 📚 资源链接

- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nixvim Documentation](https://nix-community.github.io/nixvim/)
- [Nix Package Search](https://search.nixos.org/packages)
- [agenix](https://github.com/ryantm/agenix)
- [oh-my-openagent](https://github.com/code-yeongyu/oh-my-openagent)

## 📄 许可证

MIT License
