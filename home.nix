{ config, pkgs, ... }:

{
  # 用户信息
  home.username = "cake";
  home.homeDirectory = "/home/cake";

  # 启用 home-manager 管理
  programs.home-manager.enable = true;

  # Home Manager 版本
  home.stateVersion = "24.05";

  # 导入模块化配置
  imports = [
    ./modules/fish.nix
    ./modules/starship.nix
    ./modules/nixvim.nix
    ./modules/fastfetch.nix   # 系统信息显示
    # 开发环境配置
    ./dev-envs/rust.nix       # 默认启用 Rust 环境
    ./dev-envs/cpp.nix        # 默认启用 C/C++ 环境
    ./dev-envs/python.nix     # 默认启用 Python 环境
    # ./dev-envs/nodejs.nix
  ];

  # 基础包安装
  home.packages = with pkgs; [
    # 基础工具
    git
    curl
    wget
    tree
    htop
    btop
    fastfetch  # 系统信息显示工具
    
    # 开发工具
    ripgrep
    fd
    bat
    eza  # exa 已更名为 eza
    
    # 格式化工具
    nixpkgs-fmt  # Nix 代码格式化
  ];

  # 环境变量
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
  
  # direnv 配置（自动加载项目环境）
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Git 基础配置（可以根据需要调整）
  programs.git = {
    enable = true;
    settings = {
      user.name = "cake";
      user.email = "zhaocake@foxmail.com";  # 请修改为您的邮箱
    };
  };
}
