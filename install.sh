#!/usr/bin/env bash
# Nix 开发环境快速安装脚本

set -e

echo "🚀 开始配置 Nix 开发环境..."

# 检查 Nix 是否已安装
if ! command -v nix &> /dev/null; then
    echo "❌ 未检测到 Nix，请先安装 Nix："
    echo "   sh <(curl -L https://nixos.org/nix/install) --daemon"
    exit 1
fi

echo "✅ 检测到 Nix 已安装"

# 创建 Nix 配置目录并创建软链接
echo "📝 配置 nix.conf..."
mkdir -p ~/.config/nix
if [ -L ~/.config/nix/nix.conf ]; then
    echo "⚠️  nix.conf 软链接已存在，跳过"
elif [ -f ~/.config/nix/nix.conf ]; then
    echo "⚠️  nix.conf 文件已存在，备份为 nix.conf.backup"
    mv ~/.config/nix/nix.conf ~/.config/nix/nix.conf.backup
    ln -sf ~/.nixconfigs/nix.conf ~/.config/nix/nix.conf
else
    ln -sf ~/.nixconfigs/nix.conf ~/.config/nix/nix.conf
fi

echo "✅ nix.conf 配置完成"

# 初始化 Flake
echo "📦 初始化 Flake..."
cd ~/.nixconfigs
nix flake update

echo "✅ Flake 初始化完成"

# 应用 Home Manager 配置
echo "🏠 安装并应用 Home Manager 配置..."
nix run home-manager/master -- switch --flake ~/.nixconfigs#cake

echo ""
echo "✨ 配置完成！"
echo ""
echo "📌 后续步骤："
echo "   1. 重新登录以使环境变量生效"
echo "   2. 如果要将 Fish 设为默认 Shell，运行："
echo "      echo \$(which fish) | sudo tee -a /etc/shells"
echo "      chsh -s \$(which fish)"
echo ""
echo "📚 常用命令："
echo "   hmswitch  - 应用配置更改"
echo "   hmupdate  - 更新依赖并应用配置"
echo ""
echo "🎉 享受您的 Nix 开发环境吧！"
