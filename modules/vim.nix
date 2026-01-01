{ pkgs, ... }:

{
  # 安装 Verible (SystemVerilog LSP) 和 Ctags
  home.packages = with pkgs; [
    verible
    universal-ctags
  ];

  # CoC 配置文件
  home.file.".vim/coc-settings.json".text = builtins.toJSON {
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

  programs.vim = {
    enable = true;
    defaultEditor = true;
    
    # 基础插件
    plugins = with pkgs.vimPlugins; [
      vim-airline
      vim-nix
      vim-lastplace
      coc-nvim
      nerdtree
      fzf-vim
      
      # 主题
      everforest
      vim-airline-themes
      
      # 图标
      vim-devicons
      
      # Ctags 支持
      vim-gutentags
      tagbar
      
      # 快捷键提示
      vim-which-key
    ];

    # 基础设置
    settings = {
      number = true;
      relativenumber = true;
      tabstop = 4;
      shiftwidth = 4;
      expandtab = true;
      ignorecase = true;
      smartcase = true;
    };

    # Vimscript 配置
    extraConfig = ''
      " 设置 Leader 键为空格
      let mapleader = " "

      " 开启语法高亮
      syntax on
      
      " 鼠标支持
      set mouse=a
      
      " 剪贴板共享
      set clipboard=unnamedplus
      
      " 搜索高亮
      set hlsearch
      set incsearch
      
      " 状态栏显示命令
      set showcmd
      
      " 自动缩进
      set autoindent
      set smartindent
      
      " 总是显示状态栏
      set laststatus=2

      " 高亮当前行和列
      set cursorline
      set cursorcolumn
      
      " 编码设置
      set encoding=utf-8
      set fileencoding=utf-8
      
      " --- 主题配置 (Everforest) ---
      " 开启真彩色支持
      if (has("termguicolors"))
        set termguicolors
      endif
      
      " 设置背景为深色
      set background=dark
      
      " Everforest 配置 (Hard 模式对比度更高)
      let g:everforest_background = 'hard'
      let g:everforest_better_performance = 1
      
      colorscheme everforest
      
      " Airline 主题配置
      let g:airline_theme = 'everforest'
      let g:airline_powerline_fonts = 1
      
      " Airline Tabline 配置 (顶部 Buffer 栏)
      let g:airline#extensions#tabline#enabled = 1
      let g:airline#extensions#tabline#formatter = 'unique_tail'
      let g:airline#extensions#tabline#buffer_nr_show = 1

      " --- Tagbar 配置 ---
      " <leader>t 切换 Tagbar (代码大纲)
      nnoremap <leader>t :TagbarToggle<CR>
      
      " --- Gutentags 配置 ---
      " 自动管理 tags 文件
      let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']
      let g:gutentags_ctags_tagfile = '.tags'
      
      " 将 tags 文件放在统一的缓存目录，避免污染项目目录
      let s:vim_tags = expand('~/.cache/tags')
      let g:gutentags_cache_dir = s:vim_tags
      if !isdirectory(s:vim_tags)
         silent! call mkdir(s:vim_tags, 'p')
      endif

      " --- NERDTree 配置 ---
      " 使用 <leader>e 切换侧边栏
      nnoremap <leader>e :NERDTreeToggle<CR>
      " 打开文件时自动关闭 NERDTree
      let NERDTreeQuitOnOpen = 1

      " --- 命令行补全配置 (Wildmenu) ---
      " 启用命令行菜单
      set wildmenu
      " 补全模式：最长匹配 -> 完整列表
      set wildmode=longest:full,full
      " 使用垂直弹出菜单 (Vim 8.2+)
      if has("patch-8.2.1978")
        set wildoptions=pum
      endif

      " --- FZF 配置 ---
      " <C-p> 查找文件
      nnoremap <C-p> :Files<CR>
      " <leader>b 查找缓冲区
      nnoremap <leader>b :Buffers<CR>

      " --- CoC.nvim 配置 ---
      " 默认不自动选中第一个补全项
      set completeopt=menuone,noinsert,noselect
      
      " Tab 键补全
      inoremap <silent><expr> <TAB>
            \ coc#pum#visible() ? coc#pum#next(1) :
            \ CheckBackspace() ? "\<Tab>" :
            \ coc#refresh()
      inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

      function! CheckBackspace() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~# '\s'
      endfunction

      " 回车确认补全
      inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                                    \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

      " gd 跳转定义
      nmap <silent> gd <Plug>(coc-definition)
      " gy 跳转类型定义
      nmap <silent> gy <Plug>(coc-type-definition)
      " gi 跳转实现
      nmap <silent> gi <Plug>(coc-implementation)
      " gr 查找引用
      nmap <silent> gr <Plug>(coc-references)

      " K 显示文档
      nnoremap <silent> K :call ShowDocumentation()<CR>

      function! ShowDocumentation()
        if CocAction('hasProvider', 'hover')
          call CocActionAsync('doHover')
        else
          call feedkeys('K', 'in')
        endif
      endfunction

      " 重命名
      nmap <leader>rn <Plug>(coc-rename)
      
      " 格式化代码
      xmap <leader>f  <Plug>(coc-format-selected)
      nmap <leader>f  <Plug>(coc-format-selected)
      
      " --- WhichKey 配置 ---
      " 设置超时时间 (毫秒)
      set timeoutlen=500
      
      " 注册 Leader 键
      nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
      vnoremap <silent> <leader> :WhichKey '<Space>'<CR>
      
      " 定义菜单字典
      let g:which_key_map =  {}
      
      " 注册现有快捷键的描述
      let g:which_key_map.e = 'Explorer'
      let g:which_key_map.b = 'Buffers'
      let g:which_key_map.t = 'Tagbar'
      let g:which_key_map.f = 'Format'
      
      " 嵌套菜单
      let g:which_key_map.r = { 'name' : '+refactor' }
      let g:which_key_map.r.n = 'Rename'
      
      " 注册字典
      call which_key#register('<Space>', "g:which_key_map")
    '';
  };
}
