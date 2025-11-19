#!/usr/bin/env bash

set -e

echo "=========================================="
echo "🚀 Setting up Nix Development Environment"
echo "=========================================="

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查 Nix 是否已安装
if command -v nix &> /dev/null; then
    echo -e "${GREEN}✓${NC} Nix is already installed"
    nix --version
else
    echo -e "${BLUE}→${NC} Installing Nix (single-user mode for Codespaces)..."
    
    # 在 Codespaces 中使用单用户安装模式
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
        sh -s -- install linux \
        --extra-conf "sandbox = false" \
        --init none \
        --no-confirm
    
    # 加载 Nix 环境
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
    
    echo -e "${GREEN}✓${NC} Nix installed successfully"
fi

# 确保 Nix 在 PATH 中
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
    . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
elif [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
    . "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

# 配置 Nix
echo -e "${BLUE}→${NC} Configuring Nix..."
mkdir -p ~/.config/nix

# 创建 nix.conf（如果不存在）
if [ ! -f ~/.config/nix/nix.conf ]; then
    cat > ~/.config/nix/nix.conf << 'EOF'
experimental-features = nix-command flakes
sandbox = false
filter-syscalls = false

# GitHub token (如果设置了 GITHUB_TOKEN 环境变量)
# access-tokens = github.com=YOUR_TOKEN
EOF
    echo -e "${GREEN}✓${NC} Created nix.conf"
fi

# 如果有 GITHUB_TOKEN 环境变量，添加到配置中
if [ -n "$GITHUB_TOKEN" ]; then
    echo -e "${BLUE}→${NC} Configuring GitHub token..."
    if ! grep -q "access-tokens" ~/.config/nix/nix.conf; then
        echo "access-tokens = github.com=$GITHUB_TOKEN" >> ~/.config/nix/nix.conf
        echo -e "${GREEN}✓${NC} GitHub token configured"
    fi
fi

# 检查 Home Manager 是否已安装
if command -v home-manager &> /dev/null; then
    echo -e "${GREEN}✓${NC} Home Manager is already installed"
else
    echo -e "${BLUE}→${NC} Installing Home Manager..."
    nix run home-manager/master -- init --switch
    echo -e "${GREEN}✓${NC} Home Manager installed"
fi

# 进入仓库目录
cd /workspaces/$(basename $PWD) || cd $PWD

# 应用 Home Manager 配置
echo -e "${BLUE}→${NC} Applying Home Manager configuration..."

# 复制 nix.conf.example 到 nix.conf（如果不存在）
if [ -f "nix.conf.example" ] && [ ! -f "nix.conf" ]; then
    cp nix.conf.example nix.conf
    echo -e "${YELLOW}⚠${NC}  Created nix.conf from example"
    echo -e "${YELLOW}⚠${NC}  You may want to add your GitHub token to nix.conf"
fi

# 创建 nix.conf 的软链接
if [ -f "nix.conf" ]; then
    mkdir -p ~/.config/nix
    ln -sf "$PWD/nix.conf" ~/.config/nix/nix.conf
    echo -e "${GREEN}✓${NC} Linked nix.conf"
fi

# 应用 Home Manager 配置
if [ -f "flake.nix" ]; then
    echo -e "${BLUE}→${NC} Building and applying configuration..."
    
    # 获取用户名（从 home.nix 中读取，或使用当前用户）
    USERNAME=$(grep 'home.username' home.nix | sed 's/.*"\(.*\)".*/\1/' | head -1)
    if [ -z "$USERNAME" ]; then
        USERNAME=$(whoami)
    fi
    
    # 应用配置
    home-manager switch --flake ".#${USERNAME}" || {
        echo -e "${YELLOW}⚠${NC}  Failed to apply configuration, but setup will continue..."
        echo -e "${YELLOW}⚠${NC}  You can manually run: home-manager switch --flake .#${USERNAME}"
    }
fi

# 设置 Fish 为默认 shell（如果安装了）
if command -v fish &> /dev/null; then
    echo -e "${BLUE}→${NC} Setting Fish as default shell..."
    
    # 将 fish 添加到 /etc/shells（如果需要）
    FISH_PATH=$(which fish)
    if ! grep -q "$FISH_PATH" /etc/shells 2>/dev/null; then
        echo "$FISH_PATH" | sudo tee -a /etc/shells > /dev/null
    fi
    
    # 更改默认 shell
    if [ "$SHELL" != "$FISH_PATH" ]; then
        sudo chsh -s "$FISH_PATH" $(whoami) || echo -e "${YELLOW}⚠${NC}  Could not change default shell"
    fi
    
    echo -e "${GREEN}✓${NC} Fish shell configured"
fi

echo ""
echo "=========================================="
echo -e "${GREEN}✨ Setup Complete!${NC}"
echo "=========================================="
echo ""
echo "Your Nix development environment is ready!"
echo ""
echo "Useful commands:"
echo "  hmswitch  - Apply home-manager configuration"
echo "  hmupdate  - Update and apply configuration"
echo "  ll        - List files with exa"
echo "  cat       - View files with bat"
echo ""
echo "To start using Fish shell, run: fish"
echo ""
