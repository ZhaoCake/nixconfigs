{ config, pkgs, ... }:

{
  programs.nixvim = {
    enable = true;
    
    # 默认为 Neovim 编辑器
    defaultEditor = true;
    
    # 全局选项
    opts = {
      # 行号
      number = true;
      relativenumber = true;
      
      # 缩进
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      autoindent = true;
      
      # 搜索
      ignorecase = true;
      smartcase = true;
      hlsearch = true;
      incsearch = true;
      
      # 界面
      termguicolors = true;
      cursorline = true;
      signcolumn = "yes";
      scrolloff = 8;
      
      # 其他
      mouse = "a";
      clipboard = "unnamedplus";
      wrap = false;
      swapfile = false;
      backup = false;
      undofile = true;
    };
    
    # 全局变量
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };
    
    # 主题配置
    colorschemes.tokyonight.enable = true;
    
    # 插件配置
    plugins = {
      # 图标支持
      web-devicons.enable = true;
      
      # 文件树
      neo-tree = {
        enable = true;
      };
      
      # 状态栏
      lualine = {
        enable = true;
      };
      
      # 模糊查找
      telescope = {
        enable = true;
        keymaps = {
          "<leader>ff" = "find_files";
          "<leader>fg" = "live_grep";
          "<leader>fb" = "buffers";
          "<leader>fh" = "help_tags";
        };
      };
      
      # 语法高亮
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };
      
      # LSP 配置
      lsp = {
        enable = true;
        servers = {
          # Nix
          nixd.enable = true;
          
          # Python
          pyright.enable = true;
          
          # Lua
          lua_ls.enable = true;
          
          # 可以根据需要添加更多 LSP
          # tsserver.enable = true;  # TypeScript/JavaScript
          # rust-analyzer.enable = true;  # Rust
        };
      };
      
      # 自动补全
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
          mapping = {
            __raw = ''
              cmp.mapping.preset.insert({
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-e>'] = cmp.mapping.close(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ['<Tab>'] = cmp.mapping.select_next_item(),
                ['<S-Tab>'] = cmp.mapping.select_prev_item(),
              })
            '';
          };
        };
      };
      
      # Git 集成
      gitsigns = {
        enable = true;
      };
      
      # 注释插件
      comment = {
        enable = true;
      };
      
      # 自动配对括号
      nvim-autopairs = {
        enable = true;
      };
      
      # 缩进线
      indent-blankline = {
        enable = true;
      };
      
      # Which-key (按键提示)
      which-key = {
        enable = true;
      };
    };
    
    # 键位映射
    keymaps = [
      # 保存文件
      {
        mode = "n";
        key = "<leader>w";
        action = "<cmd>w<CR>";
        options.desc = "Save file";
      }
      
      # 退出
      {
        mode = "n";
        key = "<leader>q";
        action = "<cmd>q<CR>";
        options.desc = "Quit";
      }
      
      # 分屏导航
      {
        mode = "n";
        key = "<C-h>";
        action = "<C-w>h";
        options.desc = "Move to left split";
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<C-w>j";
        options.desc = "Move to below split";
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<C-w>k";
        options.desc = "Move to above split";
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<C-w>l";
        options.desc = "Move to right split";
      }
      
      # 文件树切换
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>Neotree toggle<CR>";
        options.desc = "Toggle file explorer";
      }
      
      # 清除搜索高亮
      {
        mode = "n";
        key = "<leader>h";
        action = "<cmd>nohlsearch<CR>";
        options.desc = "Clear search highlight";
      }
    ];
  };
}
