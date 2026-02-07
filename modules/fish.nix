{ config, pkgs, ... }:

{
  programs.fish = {
    enable = true;
    

    # Fish 补全配置（为 nix-init 动态生成补全）
    interactiveShellInit = ''
      # 禁用欢迎消息
      set fish_greeting
      
      # 在交互式 shell 启动时显示 fastfetch（只在登录时显示一次）
      if status is-login
        fastfetch
      end
      
      # 为 nix-init 添加自动补全
      function __fish_nix_init_completer
        if test -d "$HOME/.nixconfigs/devShells"
          for d in "$HOME/.nixconfigs/devShells"/*
            if test -d "$d"
              basename "$d"
            end
          end
        end
      end
      
      complete -c nix-init -f -a "(__fish_nix_init_completer)" -d "Project Template"
      
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
      
      # 添加 Coursier bin 路径
      if test -d "$HOME/.local/share/coursier/bin"
        fish_add_path --append "$HOME/.local/share/coursier/bin"
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

      hmswitchb = ''
        home-manager switch -b backup --flake ~/.nixconfigs#cake $argv
      '';
      
      hmupdate = ''
        nix flake update --flake ~/.nixconfigs
        and home-manager switch --flake ~/.nixconfigs#cake $argv
      '';

      hmnews = ''
        home-manager news --flake ~/.nixconfigs#cake
      '';
      
      # fastfetch 相关函数
      ff = ''
        # 快捷方式运行 fastfetch
        fastfetch $argv
      '';
      
      ff-minimal = ''
        # 使用简洁配置
        fastfetch --config ~/.config/fastfetch/config-minimal.jsonc
      '';
      
      # 创建开发环境项目（支持所有 devShells 模板）
      nix-init = ''
        set -l DEVSHELLS_DIR "$HOME/.nixconfigs/devShells"
        
        # 获取所有可用的环境类型（即 devShells 子目录名）
        # 排除以 . 开头的隐藏文件和非目录
        set -l available_types
        for d in $DEVSHELLS_DIR/*
          if test -d $d
            set -l name (basename $d)
            if not string match -q '.*' $name
              set available_types $available_types $name
            end
          end
        end
        
        # 显示帮助信息
        function _nix_init_help --inherit-variable available_types
          echo "用法: nix-init <环境类型> [项目名]"
          echo ""
          echo "可用的环境类型:"
          for type in $available_types
            echo "    $type"
          end
          echo ""
          echo "💡 提示: Rust/Python 已安装在主环境，无需模板"
          echo ""
          echo "示例:"
          echo "  nix-init cpp my-app           # 创建 C++ 项目"
          echo "  nix-init chisel               # 在当前目录初始化 Chisel"
        end
        
        # 检查参数
        if test (count $argv) -lt 1
          _nix_init_help
          return 1
        end
        
        set -l env_type $argv[1]
        set -l project_name $argv[2]
        
        # 处理别名 (保留常用简写)
        if test "$env_type" = "sv"
          set env_type "systemverilog"
        end
        
        # 验证环境类型：动态检查目录是否存在
        set -l template_dir "$DEVSHELLS_DIR/$env_type"
        if not test -d $template_dir
          echo "❌ 未知的环境类型: '$env_type'"
          echo "请检查目录 $DEVSHELLS_DIR 下是否存在该模板"
          echo ""
          _nix_init_help
          return 1
        end
        
        # 确定目标目录
        set target_dir ""
        
        if test -n "$project_name"
          # 如果提供了项目名，创建新目录
          set target_dir $project_name
          
          # 处理绝对路径和相对路径
          if not string match -q '/*' $target_dir
            set target_dir "$PWD/$target_dir"
          end
          
          if test -e $target_dir
            echo "❌ 目标路径已存在: $target_dir"
            return 1
          end
          
          echo "📁 创建项目目录: $target_dir"
          mkdir -p $target_dir
        else
          # 如果没有提供项目名，在当前目录初始化
          set target_dir $PWD
          
          # 检查当前目录是否为空
          if test (count (ls -A $target_dir 2>/dev/null | grep -v '^\\.')) -gt 0
            echo "⚠️  当前目录不为空，是否继续? [y/N]"
            read -l confirm
            if test "$confirm" != "y" -a "$confirm" != "Y"
              echo "已取消"
              return 0
            end
          end
        end
        
        # 复制模板文件 (动态复制该模板目录下除 README 以外的所有文件，保留隐藏文件)
        echo "📋 复制模板文件..."
        
        # 使用 rsync 或 cp 复制，这里用 cp 通配符可以简单处理 hidden files
        # 注意：cp -r $template_dir/. $target_dir/ 可能会有些 shell 差异
        # 为保险起见，显式列出要复制的内容（排除 README，因为它是模板本身的说明）
        
        for item in $template_dir/* $template_dir/.*
          set -l name (basename $item)
          # 跳过 . 和 ..
          if test "$name" = "." -o "$name" = ".."
            continue
          end
          # 跳过 README.md (如果不想复制模板本身的 README)
          # if test "$name" = "README.md"; continue; end
          
          cp -r $item $target_dir/ 2>/dev/null
        end
        
        # 进入项目目录
        cd $target_dir
        
        # 初始化 git 仓库
        if not test -d .git
          if command -v git >/dev/null
            echo "🔧 初始化 Git 仓库..."
            git init
            git add .
            git commit -m "Initial commit: $env_type project template" -q
          end
        end
        
        # 激活 direnv
        if command -v direnv >/dev/null
          echo "✨ 授权 direnv..."
          direnv allow
        end
        
        echo ""
        echo "✅ 项目初始化完成!"
        echo "🔧 环境类型: $env_type"
        echo ""
        echo "📝 建议后续操作:"
        echo "   查看该模板的 README.md 或 Makefile 获取更具体的构建指令。"
        echo "   通常可以运行 'make' 或 'nix develop'。"
        echo ""
      '';
    };
  };
  
  # 设置 Fish 为默认 shell 的提示
  # 注意：需要手动运行: chsh -s $(which fish)
}
