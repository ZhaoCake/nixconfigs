{ pkgs, ... }:

{
  # 安装 Verible (SystemVerilog LSP) 和 Ctags
  home.packages = with pkgs; [
    verible
    universal-ctags
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # 基础设置 (相当于 set ...)
    opts = {
      number = true;
      relativenumber = true;
      tabstop = 4;
      shiftwidth = 4;
      expandtab = true;
      ignorecase = true;
      smartcase = true;
      mouse = "a";
      clipboard = "unnamedplus";
      hlsearch = true;
      incsearch = true;
      showcmd = true;
      autoindent = true;
      smartindent = true;
      laststatus = 2;
      cursorline = true;
      cursorcolumn = true;
      encoding = "utf-8";
      fileencoding = "utf-8";
      termguicolors = true;
      wildmenu = true;
      wildmode = "longest:full,full";
      timeoutlen = 500;
    };

    # 全局变量 (相当于 let g:...)
    globals = {
      mapleader = " ";
      
      # Airline 扩展配置 (使用 # 符号的必须在 globals 中)
      "airline#extensions#tabline#enabled" = 1;
      "airline#extensions#tabline#formatter" = "unique_tail";
      "airline#extensions#tabline#buffer_nr_show" = 1;

      # Gutentags 配置
      gutentags_project_root = [".root" ".svn" ".git" ".hg" ".project"];
      gutentags_ctags_tagfile = ".tags";
      
      # NERDTree 配置
      NERDTreeQuitOnOpen = 1;
    };

    # Everforest 主题配置
    colorschemes.everforest = {
      enable = true;
      settings = {
        background = "hard";
        better_performance = 1;
      };
    };

    # 插件配置
    plugins = {
      # 状态栏
      airline = {
        enable = true;
        settings = {
          theme = "everforest";
          powerline_fonts = 1;
        };
      };
      
      # Nix 语言支持
      nix.enable = true;
      
      # 自动补全和 LSP (CoC)
      coc = {
        enable = true;
        settings = {
          "languageserver" = {
            "sv" = {
              "command" = "verible-verilog-ls";
              "filetypes" = ["systemverilog" "verilog"];
              "rootPatterns" = [".git" "verible.filelist"];
            };
            "rust" = {
              "command" = "rust-analyzer";
              "filetypes" = ["rust"];
              "rootPatterns" = ["Cargo.toml"];
            };
            "clangd" = {
              "command" = "clangd";
              "args" = ["--background-index"];
              "rootPatterns" = ["compile_commands.json" ".vim/" ".git/" ".hg/"];
              "filetypes" = ["c" "cpp" "objc" "objcpp"];
            };
          };
          "suggest.noselect" = true;
          "suggest.enablePreview" = true;
        };
      };

      # 模糊搜索 (FZF)
      fzf-vim.enable = true;
      
      # 代码大纲
      tagbar.enable = true;
      
      # 图标支持 (替代 vim-devicons)
      web-devicons.enable = true;
      
      # 记住上次编辑位置
      lastplace.enable = true;

      # 快捷键提示 (WhichKey)
      which-key = {
        enable = true;
        registrations = {
           "<leader>e" = "Explorer";
           "<leader>b" = "Buffers";
           "<leader>t" = "Tagbar";
           "<leader>f" = "Format";
           "<leader>r" = { name = "+refactor"; };
           "<leader>rn" = "Rename";
        };
      };
    };

    # 额外插件 (Nixvim 内置模块未覆盖的)
    extraPlugins = with pkgs.vimPlugins; [
      nerdtree          # 文件树
      vim-gutentags
      vim-airline-themes
    ];

    # 快捷键映射
    keymaps = [
      { mode = "n"; key = "<leader>t"; action = ":TagbarToggle<CR>"; }
      { mode = "n"; key = "<leader>e"; action = ":NERDTreeToggle<CR>"; }
      { mode = "n"; key = "<C-p>"; action = ":Files<CR>"; }
      { mode = "n"; key = "<leader>b"; action = ":Buffers<CR>"; }
      
      # CoC 快捷键
      { mode = "n"; key = "gd"; action = "<Plug>(coc-definition)"; options = { silent = true; }; }
      { mode = "n"; key = "gy"; action = "<Plug>(coc-type-definition)"; options = { silent = true; }; }
      { mode = "n"; key = "gi"; action = "<Plug>(coc-implementation)"; options = { silent = true; }; }
      { mode = "n"; key = "gr"; action = "<Plug>(coc-references)"; options = { silent = true; }; }
      { mode = "n"; key = "<leader>rn"; action = "<Plug>(coc-rename)"; }
      
      # 格式化
      { mode = "x"; key = "<leader>f"; action = "<Plug>(coc-format-selected)"; }
      { mode = "n"; key = "<leader>f"; action = "<Plug>(coc-format-selected)"; }
      
      # 查看文档
      { mode = "n"; key = "K"; action = ":call ShowDocumentation()<CR>"; options = { silent = true; }; }
    ];

    # 额外的 Vimscript 配置 (用于复杂逻辑)
    extraConfigVim = ''
      " --- Gutentags 缓存目录配置 ---
      let s:vim_tags = expand('~/.cache/tags')
      let g:gutentags_cache_dir = s:vim_tags
      if !isdirectory(s:vim_tags)
         silent! call mkdir(s:vim_tags, 'p')
      endif

      " --- CoC Tab 补全逻辑 ---
      inoremap <silent><expr> <TAB>
            \ coc#pum#visible() ? coc#pum#next(1) :
            \ CheckBackspace() ? "\<Tab>" :
            \ coc#refresh()
      inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

      function! CheckBackspace() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~# '\s'
      endfunction

      " 回车确认
      inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                                    \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

      " --- 文档查看函数 ---
      function! ShowDocumentation()
        if CocAction('hasProvider', 'hover')
          call CocActionAsync('doHover')
        else
          call feedkeys('K', 'in')
        endif
      endfunction
    '';
  };
}
