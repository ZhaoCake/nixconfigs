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
    ./modules/tmux.nix        # 终端复用器
    ./modules/alacritty.nix   # 终端模拟器配置
    # 开发环境配置（通用工具，全局启用）
    ./dev-envs/rust.nix       # Rust 环境
    ./dev-envs/cpp.nix        # C/C++ 环境
    ./dev-envs/python.nix     # Python 环境
    # ./dev-envs/nodejs.nix   # Node.js 环境（按需启用）
    
    # 硬件开发环境已移至 devShells/ 目录，使用 direnv 按需激活
    # 见 devShells/README.md
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
    openssh    # SSH 客户端
    less       # 分页器（git log 等命令需要）
    
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
      user.email = "zhaocake@foxmail.com";
      init.defaultBranch = "main";  # 设置默认分支为 main
      advice.defaultBranchName = false;  # 禁用分支名警告
    };
  };

  # SSH 配置
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;  # 禁用默认配置，手动指定
    
    # SSH 配置
    matchBlocks = {
      # 全局默认配置（相当于 Host *）
      "*" = {
        # 保持连接活跃
        serverAliveInterval = 60;
        serverAliveCountMax = 3;
        
        # 启用连接复用
        controlMaster = "auto";
        controlPath = "~/.ssh/control-%r@%h:%p";
        controlPersist = "10m";
        
        # 其他常用默认配置
        forwardAgent = false;
        compression = true;
      };
      
      # GitHub 配置
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
      };
      
      # 示例：服务器配置
      # "myserver" = {
      #   hostname = "192.168.1.100";
      #   user = "cake";
      #   port = 22;
      #   identityFile = "~/.ssh/id_rsa";
      # };
    };
  };
}
