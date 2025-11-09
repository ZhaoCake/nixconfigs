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
      
      # Python/uv 相关函数
      new-python-project = ''
        # 使用 uv 创建新的 Python 项目
        if test (count $argv) -eq 0
          echo "Usage: new-python-project <project-name>"
          return 1
        end
        
        set project_name $argv[1]
        
        if test -d $project_name
          echo "❌ Directory '$project_name' already exists"
          return 1
        end
        
        echo "🐍 Creating Python project with uv: $project_name"
        
        # 使用 uv 创建项目
        uv init $project_name
        cd $project_name
        
        # 初始化 git
        if command -v git >/dev/null
          git init
          echo "✅ Git repository initialized"
        end
        
        echo ""
        echo "✨ Project '$project_name' created!"
        echo ""
        echo "📝 Next steps:"
        echo "   cd $project_name"
        echo "   uv venv              # Create virtual environment"
        echo "   source .venv/bin/activate.fish"
        echo "   uv pip install <package>  # Install packages"
        echo "   uv run python main.py     # Run with uv"
      '';
      
      # 创建 BSV 项目
      new-bsv-project = ''
        # 检查参数
        if test (count $argv) -eq 0
          echo "Usage: new-bsv-project <project-name>"
          return 1
        end
        
        set project_name $argv[1]
        set template_dir "$HOME/.local/share/bsv-templates"
        
        # 检查项目是否已存在
        if test -d $project_name
          echo "❌ Directory '$project_name' already exists"
          return 1
        end
        
        # 创建项目结构
        echo "🚀 Creating Bluespec SystemVerilog project: $project_name"
        mkdir -p $project_name/bsv_src
        mkdir -p $project_name/verilator_src
        
        # 复制模板文件
        cp $template_dir/flake.nix $project_name/
        cp $template_dir/Makefile $project_name/
        cp $template_dir/Top.bsv $project_name/bsv_src/
        cp $template_dir/sim_main.cpp $project_name/verilator_src/
        cp $template_dir/README.md $project_name/
        
        # 创建 .gitignore
        echo "build/
*.bo
*.ba
*.so
*.o
wave.vcd
.direnv/
result
" > $project_name/.gitignore
        
        # 创建 .envrc for direnv
        echo "use flake" > $project_name/.envrc
        
        # 进入项目目录
        cd $project_name
        
        # 初始化 git
        if command -v git >/dev/null
          git init
          echo "✅ Git repository initialized"
        end
        
        # 允许 direnv
        if command -v direnv >/dev/null
          direnv allow
          echo "✅ direnv configured"
        end
        
        echo ""
        echo "✨ Project '$project_name' created successfully!"
        echo ""
        echo "📝 Next steps:"
        echo "   cd $project_name"
        echo "   nix develop          # Enter development environment"
        echo "   make help            # Show available targets"
        echo "   make sim             # Compile and run Bluesim"
        echo "   make verilator       # Build Verilator simulation"
        echo "   gtkwave wave.vcd     # View waveforms"
        echo ""
        echo "   Or just: nvim bsv_src/Top.bsv"
      '';
      
      # 创建 C++ 项目
      new-cpp-project = ''
        # 检查参数
        if test (count $argv) -eq 0
          echo "Usage: new-cpp-project <project-name>"
          return 1
        end
        
        set project_name $argv[1]
        set template_dir "$HOME/Templates/cpp-project"
        
        # 检查模板目录
        if not test -d $template_dir
          echo "❌ Template directory not found: $template_dir"
          echo "   Run 'hmswitch' to create templates"
          return 1
        end
        
        # 检查项目是否已存在
        if test -d $project_name
          echo "❌ Directory '$project_name' already exists"
          return 1
        end
        
        # 创建项目
        echo "🚀 Creating C++ project: $project_name"
        mkdir -p $project_name/src
        
        # 复制模板文件
        cp $template_dir/flake.nix $project_name/
        cp $template_dir/CMakeLists.txt $project_name/
        cp $template_dir/src/main.cpp $project_name/src/
        cp $template_dir/.envrc $project_name/
        cp $template_dir/.gitignore $project_name/
        cp $template_dir/README.md $project_name/
        
        # 替换项目名称
        sed -i "s/MyProject/$project_name/g" $project_name/CMakeLists.txt
        
        # 进入项目目录
        cd $project_name
        
        # 初始化 git（可选）
        if command -v git >/dev/null
          git init
          echo "✅ Git repository initialized"
        end
        
        # 允许 direnv
        if command -v direnv >/dev/null
          direnv allow
          echo "✅ direnv configured"
        end
        
        # 初始化 flake
        nix flake update
        
        echo ""
        echo "✨ Project '$project_name' created successfully!"
        echo ""
        echo "📝 Next steps:"
        echo "   cd $project_name"
        echo "   nix develop          # Enter development environment"
        echo "   cmake -B build       # Configure build"
        echo "   cmake --build build  # Build project"
        echo "   ./build/main         # Run"
        echo ""
        echo "   Or just: nvim src/main.cpp"
      '';
    };
  };
  
  # 设置 Fish 为默认 shell 的提示
  # 注意：需要手动运行: chsh -s $(which fish)
}
