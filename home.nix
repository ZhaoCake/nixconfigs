{ config, pkgs, ... }:

{
  # 用户信息
  home = {
    username = "cake";
    homeDirectory = "/home/cake";
    stateVersion = "24.05";
  };

  # 导入模块化配置
  imports = [
    ./modules/secrets.nix
    ./modules/fish.nix
    ./modules/starship.nix
    # ./modules/emacs.nix # Emacs + Org-mode 配置
    ./modules/fastfetch.nix # 系统信息显示
    ./modules/tmux.nix # 终端复用器（保留）
    ./modules/zellij.nix # 终端复用器（新增）
    ./modules/vim # Vim 配置 (Nixvim)
    ./modules/uv.nix # uv 配置 (Python)
    ./modules/aiassistant.nix # AI 助手统一配置（Claude Code/Codex/OpenCode）
    ./modules/fvim.nix # 独立 Fennel/Hotpot Neovim
    # ./modules/niri.nix # Niri + Noctalia 配置

    # 所有开发环境已移至 devShells/ 目录，使用 direnv 按需激活
    # 使用 nix-init 命令快速创建项目
    # 见 devShells/README.md
  ];

  # 基础包安装
  home.packages =
    with pkgs;
    [
      # 基础工具
      git
      curl
      wget
      tree
      htop
      btop
      unzip
      zip
      fzf # 模糊查找工具
      fastfetch # 系统信息显示工具
      openssh # SSH 客户端
      less # 分页器（git log 等命令需要）
      inetutils # ifconfig, hostname, ping 等网络工具
      wl-clipboard # Wayland 剪贴板工具
      xclip # X11 剪贴板工具

      # WSL 常用工具
      dos2unix # 转换 Windows/Linux 换行符

      # 效率工具
      jq # JSON 处理
      ncdu # 磁盘占用分析

      # 开发工具
      ripgrep
      fd
      bat
      eza # exa 已更名为 eza
      gnumake # GNU Make 构建工具
      yazi

      # 格式化工具
      nixpkgs-fmt # Nix 代码格式化

      # Markdown 工具
      glow # Markdown 预览工具

      # 字体
      maple-mono."NF-CN" # Maple Mono Nerd Font Chinese

      # 编程语言和构建工具
      # Rust
      cargo
      rustc
      rust-analyzer
      rustfmt
      clippy

      # C/C++
      gcc
      clang-tools # 包含 clangd
      cmake

      # Python
      # python3
      uv

      # Node.js (for CoC)
      nodejs

      # 命令运行器
      just
      devbox
    ];

  # 启用用户级 Nix 垃圾回收
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # npm 全局包目录（避开 /nix/store 只读限制）
  home.sessionVariables = {
    NPM_CONFIG_PREFIX = "${config.home.homeDirectory}/.npm-global";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.npm-global/bin"
  ];

  home.activation = {
    createNpmGlobalDir = config.lib.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD mkdir -p "${config.home.homeDirectory}/.npm-global"
    '';
  };

  # 环境变量由 Nixvim 的 defaultEditor 选项自动设置

  # 统一 programs 配置，避免 repeated assignments 警告
  programs = {
    # 启用 home-manager 管理
    home-manager.enable = true;

    # direnv 配置（自动加载项目环境）
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    # Lazygit: 终端 Git UI
    lazygit = {
      enable = true;
      settings = {
        gui.theme = {
          lightTheme = false;
          activeBorderColor = [ "green" "bold" ];
          inactiveBorderColor = [ "white" ];
          selectedLineBgColor = [ "reverse" ];
        };
      };
    };

    # Zoxide: 智能目录跳转 (替代 cd)
    zoxide = {
      enable = true;
      enableFishIntegration = true;
      # options = [ "--cmd cd" ]; # 如果你想用 z 替代 cd，可以取消注释这行
    };

    # Tealdeer: tldr 的 Rust 实现 (更快的命令手册)
    tealdeer = {
      enable = true;
      settings = {
        display = {
          use_pager = true;
          compact = false;
        };
        updates = {
          auto_update = true;
        };
      };
    };

    # Git 基础配置（可以根据需要调整）
    git = {
      enable = true;
      signing.format = "openpgp";
      settings = {
        user.name = "cake";
        user.email = "zhaocake@foxmail.com";
        init.defaultBranch = "main"; # 设置默认分支为 main
        advice.defaultBranchName = false; # 禁用分支名警告
      };
    };

    # SSH 配置
    ssh = {
      enable = true;
      enableDefaultConfig = false; # 禁用默认配置，手动指定

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
  };
}

