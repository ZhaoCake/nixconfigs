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
    # 开发环境配置
    # ./dev-envs/python.nix
    # ./dev-envs/nodejs.nix
    # ./dev-envs/rust.nix
  ];

  # 基础包安装
  home.packages = with pkgs; [
    # 基础工具
    git
    curl
    wget
    tree
    htop
    
    # 开发工具
    ripgrep
    fd
    bat
    eza  # exa 已更名为 eza
  ];

  # 环境变量
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
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
