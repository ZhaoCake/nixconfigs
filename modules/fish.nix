{ config, pkgs, ... }:

{
  programs.fish = {
    enable = true;
    
    # Fish shell 交互式配置
    interactiveShellInit = ''
      # 禁用欢迎消息
      set fish_greeting
      
      # 在交互式 shell 启动时显示 fastfetch（只在登录时显示一次）
      if status is-login
        fastfetch
      end
      
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
      
      hmupdate = ''
        nix flake update --flake ~/.nixconfigs
        and home-manager switch --flake ~/.nixconfigs#cake $argv
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
      
      # 创建硬件开发项目（SystemVerilog/BSV/Chisel）
      nix-init = ''
        set -l DEVSHELLS_DIR "$HOME/.nixconfigs/devShells"
        
        # 显示帮助信息
        function _nix_init_help
          echo "用法: nix-init <环境类型> [项目名]"
          echo ""
          echo "可用的环境类型:"
          echo "  通用开发:"
          echo "    cpp                - C++ 项目"
          echo ""
          echo "  硬件开发:"
          echo "    sv, systemverilog  - SystemVerilog + Verilator"
          echo "    bsv                - Bluespec SystemVerilog"
          echo "    chisel             - Chisel 硬件设计"
          echo ""
          echo "💡 提示: Rust/Python/Scala 已安装在主环境，无需模板"
          echo ""
          echo "示例:"
          echo "  nix-init cpp my-app           # 创建 C++ 项目"
          echo "  nix-init chisel               # 在当前目录初始化 Chisel"
          echo "  nix-init sv ~/hardware        # 在指定路径创建 SystemVerilog 项目"
        end
        
        # 检查参数
        if test (count $argv) -lt 1
          _nix_init_help
          return 1
        end
        
        set -l env_type $argv[1]
        set -l project_name $argv[2]
        
        # 环境名称别名映射
        switch $env_type
          case sv
            set env_type systemverilog
        end
        
        # 验证环境类型
        if not contains $env_type cpp systemverilog bsv chisel
          echo "❌ 未知的环境类型: '$env_type'"
          echo ""
          _nix_init_help
          return 1
        end
        
        # 确定源模板目录
        set -l template_dir "$DEVSHELLS_DIR/$env_type"
        
        if not test -d $template_dir
          echo "❌ 模板目录不存在: $template_dir"
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
        
        # 复制模板文件
        echo "📋 复制模板文件..."
        cp -r $template_dir/* $target_dir/ 2>/dev/null
        cp $template_dir/.envrc $target_dir/ 2>/dev/null
        cp $template_dir/.gitignore $target_dir/ 2>/dev/null
        cp $template_dir/.mill-version $target_dir/ 2>/dev/null
        
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
        echo ""
        echo "📍 项目位置: $target_dir"
        echo "🔧 环境类型: $env_type"
        echo ""
        echo "📝 下一步:"
        
        switch $env_type
          case cpp
            echo "   cmake -B build   - 配置构建"
            echo "   cmake --build build - 构建项目"
            echo "   ./build/main     - 运行"
          case systemverilog
            echo "   make sim     - 构建并运行仿真"
            echo "   make trace   - 生成波形文件"
            echo "   make lint    - 检查代码"
          case bsv
            echo "   make verilog   - 编译 BSV → Verilog"
            echo "   make verilator - 运行 Verilator 仿真"
          case chisel
            echo "   make verilog   - 生成 Verilog"
            echo "   make test      - 运行测试"
        end
        
        echo ""
        echo "查看 README.md 获取更多信息"
      '';
    };
  };
  
  # 设置 Fish 为默认 shell 的提示
  # 注意：需要手动运行: chsh -s $(which fish)
}
