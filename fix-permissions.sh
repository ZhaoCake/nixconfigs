#!/usr/bin/env bash
# Nix 权限修复和服务启动脚本

set -e

echo "🔧 修复 Nix 权限问题..."

# 检查是否为多用户安装
if [ -d /nix/var ] || [ -d /nix ]; then
    echo "✅ 检测到多用户 Nix 安装"
    
    # 检查 nix-users 组是否存在
    if ! getent group nix-users > /dev/null; then
        echo "⚠️  nix-users 组不存在，正在创建..."
        sudo groupadd -r nix-users
        echo "✅ nix-users 组已创建"
    fi
    
    # 检查用户是否在 nix-users 组
    if groups | grep -q nix-users; then
        echo "✅ 用户已在 nix-users 组中"
    else
        echo "⚠️  将用户添加到 nix-users 组..."
        sudo usermod -aG nix-users $USER
        echo "✅ 已添加到 nix-users 组，请重新登录后继续"
        exit 0
    fi
    
    # 确保 /nix/store 存在并有正确权限
    if [ ! -d /nix/store ]; then
        echo "📁 创建 /nix/store 目录..."
        sudo mkdir -p /nix/store
        sudo chown root:nix-users /nix/store
        sudo chmod 1775 /nix/store
    fi
    
    # 启动并启用 nix-daemon
    echo "🚀 启动 Nix daemon 服务..."
    sudo systemctl enable nix-daemon.service
    sudo systemctl start nix-daemon.service
    
    # 检查服务状态
    if systemctl is-active --quiet nix-daemon.service; then
        echo "✅ Nix daemon 服务已启动"
    else
        echo "❌ Nix daemon 服务启动失败"
        systemctl status nix-daemon.service --no-pager
        exit 1
    fi
    
    # 确保环境变量已设置
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        echo "✅ 正在加载 Nix 环境..."
        source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
    
    echo ""
    echo "✨ Nix 权限修复完成！"
    echo ""
    echo "📌 重要提示："
    echo "   如果刚刚添加了 nix-users 组，请务必重新登录（或重启）"
    echo "   然后再次运行 ./install.sh"
    echo ""
    
else
    echo "❌ 未检测到标准的 Nix 安装，请先安装 Nix："
    echo "   sh <(curl -L https://nixos.org/nix/install) --daemon"
    exit 1
fi
