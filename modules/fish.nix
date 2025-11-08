{ config, pkgs, ... }:

{
  programs.fish = {
    enable = true;
    
    # Fish shell 交互式配置
    interactiveShellInit = ''
      # 禁用欢迎消息
      set fish_greeting
      
      # 启用 vi 模式（可选）
      # fish_vi_key_bindings
    '';
    
    # 登录 shell 初始化（加载 Nix 环境）
    loginShellInit = ''
      # 添加 Nix 相关路径
      if test -d "$HOME/.nix-profile/bin"
        fish_add_path --prepend "$HOME/.nix-profile/bin"
      end
      
      if test -d "/nix/var/nix/profiles/default/bin"
        fish_add_path --prepend "/nix/var/nix/profiles/default/bin"
      end
      
      # 设置 Nix 环境变量
      set -gx NIX_PROFILES "/nix/var/nix/profiles/default $HOME/.nix-profile"
      set -gx NIX_SSL_CERT_FILE "/etc/ssl/certs/ca-certificates.crt"
    '';
    
    # Shell 别名
    shellAliases = {
      # 基础命令增强
      ls = "eza --icons";
      ll = "eza -l --icons";
      la = "eza -la --icons";
      tree = "eza --tree --icons";
      
      # Git 别名
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git log --oneline --graph";
      
      # 其他工具
      cat = "bat";
      find = "fd";
      grep = "rg";
    };
    
    # Fish 插件配置
    plugins = [
      # 可以添加 Fish 插件
      # {
      #   name = "z";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "jethrokuan";
      #     repo = "z";
      #     rev = "e0e1b9dfdba362f8ab1ae8c1afc7ccf62b89f7eb";
      #     sha256 = "0dbnir6jbwjpjalz14snzd3cgdysgcs3raznsijd6savad3qhijc";
      #   };
      # }
    ];
    
    # Fish 函数
    functions = {
      # 快速创建并进入目录
      mkcd = ''
        mkdir -p $argv[1]
        cd $argv[1]
      '';
      
      # Nix 相关函数
      hmswitch = ''
        home-manager switch --flake ~/.nixconfigs#cake $argv
      '';
      
      hmupdate = ''
        nix flake update ~/.nixconfigs
        and home-manager switch --flake ~/.nixconfigs#cake $argv
      '';
    };
  };
  
  # 设置 Fish 为默认 shell 的提示
  # 注意：需要手动运行: chsh -s $(which fish)
}
