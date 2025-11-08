# 快速参考

## 🚀 快速开始

```bash
# 1. 修复权限并启动 Nix daemon（首次安装必需）
cd ~/.nixconfigs
./fix-permissions.sh
# 如果提示需要重新登录，请先重新登录

# 2. 配置 GitHub token（避免速率限制）
# 如果还没有 nix.conf：
cp nix.conf.example nix.conf
# 编辑 nix.conf，添加您的 GitHub token
# 获取 token: https://github.com/settings/tokens

# 3. 运行安装脚本
./install.sh
```

## 📝 日常使用

```bash
# 应用配置更改
hmswitch

# 更新依赖并应用配置
hmupdate

# 手动应用配置
home-manager switch --flake ~/.nixconfigs#cake
```

## � GitHub Token 配置

```bash
# 获取 token
# 1. 访问 https://github.com/settings/tokens
# 2. "Generate new token (classic)"
# 3. 勾选 "public_repo" 权限
# 4. 生成并复制

# 配置 token
echo 'access-tokens = github.com=YOUR_TOKEN' >> ~/.nixconfigs/nix.conf

# 重新创建软链接
mkdir -p ~/.config/nix
ln -sf ~/.nixconfigs/nix.conf ~/.config/nix/nix.conf
```

## �🔧 启用开发环境

编辑 `home.nix`，在 `imports` 中取消注释需要的环境：

```nix
imports = [
  # 核心模块
  ./modules/fish.nix
  ./modules/starship.nix
  ./modules/nixvim.nix
  
  # 开发环境（按需启用）
  ./dev-envs/python.nix
  # ./dev-envs/nodejs.nix
  # ./dev-envs/rust.nix
  # ./dev-envs/go.nix
];
```

## ⌨️ Nixvim 快捷键

- Leader: `Space`
- `<leader>e` - 切换文件树
- `<leader>ff` - 查找文件
- `<leader>fg` - 全局搜索
- `<leader>fb` - 缓冲区列表
- `<leader>w` - 保存
- `<leader>q` - 退出

## 📂 项目结构

```
.nixconfigs/
├── flake.nix          # 主入口
├── home.nix           # 用户配置
├── nix.conf           # Nix 设置
├── modules/           # 工具模块
│   ├── fish.nix
│   ├── starship.nix
│   └── nixvim.nix
└── dev-envs/          # 开发环境
    ├── python.nix
    ├── nodejs.nix
    ├── rust.nix
    └── go.nix
```

## 🔄 Git 工作流

```bash
# 初始化 Git 仓库
cd ~/.nixconfigs
git init
git add .
git commit -m "Initial Nix configuration"

# 添加远程仓库
git remote add origin <your-repo-url>
git push -u origin main
```

## 🛠️ 维护命令

```bash
# 清理旧版本
nix-collect-garbage -d

# 查看配置历史
home-manager generations

# 回滚到上一版本
home-manager generations | head -2 | tail -1 | awk '{print $7}' | xargs home-manager rollback
```

## 🆘 故障排除

### 权限问题
```bash
# 修复 Nix 权限和服务
./fix-permissions.sh

# 检查 Nix daemon 状态
systemctl status nix-daemon.service

# 确认用户在 nix-users 组中
groups | grep nix-users
```

### Flake 相关
```bash
# 更新 flake.lock
nix flake update ~/.nixconfigs

# 检查 flake 元数据
nix flake metadata ~/.nixconfigs

# 显示 flake 输出
nix flake show ~/.nixconfigs
```

### Home Manager 相关
```bash
# 验证配置语法
nix flake check ~/.nixconfigs

# 查看将要安装的包
home-manager packages
```

## 📱 更多资源

- [README.md](./README.md) - 完整文档
- [dev-envs/README.md](./dev-envs/README.md) - 开发环境说明
