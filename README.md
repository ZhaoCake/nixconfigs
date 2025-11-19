# Nix 开发环境配置

![CI Status](https://github.com/YOUR_USERNAME/nixconfigs/workflows/CI%20-%20Nix%20Configuration%20Check/badge.svg)

这是一个优雅的、模块化的 Nix + Home Manager 配置，用于管理用户级别的开发环境。

> **✨ 特性**: 
> - 🏠 本地安装：支持 Arch Linux 等发行版的用户级 Nix 安装
> - ☁️ 云端使用：也可在 GitHub Codespaces 中使用（详见 [CODESPACES.md](CODESPACES.md)）
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
├── modules/               # 工具配置模块
│   ├── fish.nix          # Fish Shell 配置
│   ├── starship.nix      # Starship 提示符配置
│   └── nixvim.nix        # Nixvim (Neovim) 配置
├── dev-envs/             # 开发环境配置
│   ├── python.nix        # Python 环境
│   ├── nodejs.nix        # Node.js 环境
│   ├── rust.nix          # Rust 环境
│   ├── go.nix            # Go 环境
│   └── README.md         # 开发环境说明
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

这个脚本会：
- 将您添加到 `nix-users` 组（如果需要）
- 创建 `/nix/store` 目录并设置正确权限
- 启动并启用 `nix-daemon` 服务

**如果脚本添加了您到 `nix-users` 组，需要重新登录后再继续。**

### 3. 配置 GitHub Token（重要！避免速率限制）

为了避免从 GitHub 拉取 Flake 时遇到速率限制，需要配置 GitHub Personal Access Token：

**首次设置（如果您还没有 nix.conf）：**

```bash
# 复制示例配置
cp ~/.nixconfigs/nix.conf.example ~/.nixconfigs/nix.conf

# 然后编辑 nix.conf，填入您的 GitHub token
# 获取 token: https://github.com/settings/tokens
# 需要勾选 "public_repo" 权限
```

**如何获取 GitHub Token：**

1. 访问 https://github.com/settings/tokens
2. 点击 "Generate new token" -> "Generate new token (classic)"
3. 设置过期时间（建议选择 "No expiration" 或较长时间）
4. 勾选权限：
   - `public_repo`（访问公共仓库）
   - 或 `repo`（如果需要访问私有仓库）
5. 生成并复制 token
6. 在 `nix.conf` 中添加：
   ```
   access-tokens = github.com=YOUR_TOKEN_HERE
   ```

**⚠️ 安全提示：**
- `nix.conf` 已添加到 `.gitignore`，不会被提交到 Git
- 不要分享您的 token 或提交到公共仓库
- 使用 `nix.conf.example` 作为模板文件提交到 Git

### 4. 运行安装脚本

```bash
cd ~/.nixconfigs
./install.sh
```

这个脚本会自动完成：
- 配置 `nix.conf`（创建软链接）
- 初始化 Flake
- 安装并应用 Home Manager 配置

### 4. 设置 Fish 为默认 Shell（可选）

```bash
# 将 Fish 添加到可用 shell 列表
echo $(which fish) | sudo tee -a /etc/shells

# 更改默认 shell
chsh -s $(which fish)
```

## ⚠️ 故障排除

### 权限错误："Permission denied" 访问 /nix/store

如果遇到权限错误，运行修复脚本：

```bash
cd ~/.nixconfigs
./fix-permissions.sh
```

然后重新登录，再运行 `./install.sh`。

### Nix daemon 未运行

```bash
# 检查服务状态
systemctl status nix-daemon.service

# 启动服务
sudo systemctl start nix-daemon.service
sudo systemctl enable nix-daemon.service
```

## 📝 使用说明

### 更新配置

修改配置文件后，应用更改：

```bash
home-manager switch --flake ~/.nixconfigs#cake
```

或使用 Fish 中定义的别名：

```bash
hmswitch
```

### 更新 Flake 输入

更新所有依赖并应用配置：

```bash
nix flake update ~/.nixconfigs
home-manager switch --flake ~/.nixconfigs#cake
```

或使用别名：

```bash
hmupdate
```

### 添加开发环境

要启用某个开发环境，编辑 `home.nix` 文件，在 `imports` 部分取消注释：

```nix
imports = [
  ./modules/fish.nix
  ./modules/starship.nix
  ./modules/nixvim.nix
  
  # 取消注释需要的开发环境
  ./dev-envs/python.nix
  # ./dev-envs/nodejs.nix
  # ./dev-envs/rust.nix
  # ./dev-envs/go.nix
];
```

然后运行 `hmswitch` 应用配置。

## 🔧 配置说明

### Fish Shell

- **配置文件**: `modules/fish.nix`
- **特性**:
  - 现代化的命令别名（使用 exa, bat, ripgrep 等）
  - Git 快捷别名
  - Nix/Home Manager 快捷命令
  - 自定义函数

### Starship

- **配置文件**: `modules/starship.nix`
- **特性**:
  - 美观的命令行提示符
  - Git 状态显示
  - 编程语言版本显示
  - 命令执行时间显示

### Nixvim

- **配置文件**: `modules/nixvim.nix`
- **特性**:
  - 基于 Nixvim 的 Neovim 配置
  - LSP 支持（Nix, Python, Lua）
  - 自动补全
  - 文件浏览器（Neo-tree）
  - 模糊查找（Telescope）
  - Git 集成（Gitsigns）
  - Tokyo Night 主题

**快捷键**:
- Leader 键: `Space`
- `<leader>e`: 切换文件浏览器
- `<leader>ff`: 查找文件
- `<leader>fg`: 全局搜索
- `<leader>w`: 保存文件
- `<leader>q`: 退出

## 🛠️ 自定义配置

### 添加新的工具模块

1. 在 `modules/` 目录下创建新的 `.nix` 文件
2. 在 `home.nix` 的 `imports` 中添加该模块
3. 运行 `hmswitch` 应用配置

### 添加新的开发环境

1. 在 `dev-envs/` 目录下创建新的 `.nix` 文件
2. 参考现有的配置文件（如 `python.nix`）
3. 在 `home.nix` 的 `imports` 中添加该模块
4. 运行 `hmswitch` 应用配置

### 修改用户信息

编辑 `home.nix` 文件，修改以下内容：

```nix
home.username = "cake";  # 您的用户名
home.homeDirectory = "/home/cake";  # 您的家目录

programs.git = {
  userName = "Your Name";
  userEmail = "your.email@example.com";
};
```

## 📦 包含的工具

### 基础工具
- git, curl, wget
- tree, htop
- ripgrep (rg), fd, bat, exa

### Shell 环境
- Fish Shell
- Starship 提示符

### 编辑器
- Nixvim (Neovim)

### 开发环境（可选启用）
- Python
- Node.js
- Rust
- Go

## 🔗 有用的命令

```bash
# 查看已安装的包
home-manager packages

# 查看配置历史
home-manager generations

# 回滚到上一个版本
home-manager generations | head -2 | tail -1 | awk '{print $7}' | xargs home-manager rollback

# 清理旧版本（保留最近 3 个）
nix-collect-garbage --delete-older-than 7d

# 查看 Flake 信息
nix flake show ~/.nixconfigs
nix flake metadata ~/.nixconfigs
```

## 📚 资源链接

- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nixvim Documentation](https://nix-community.github.io/nixvim/)
- [Nix Package Search](https://search.nixos.org/packages)
- [Home Manager Options](https://nix-community.github.io/home-manager/options.html)

## 🤝 贡献

这是个人配置仓库，但欢迎提出建议和改进！

## 📄 许可证

MIT License

---

**注意事项**:
- 首次安装可能需要一些时间来下载和构建包
- 确保您的用户在 `nix-users` 组中（多用户安装）
- 配置文件可以通过 Git 进行版本控制
- 定期运行 `nix flake update` 来更新依赖
