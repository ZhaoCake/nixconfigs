{ config, pkgs, ... }:

{
  # Alacritty 终端配置
  # 注意：不安装 alacritty 包，仅管理配置文件（因为 Arch Linux 系统已安装）
  programs.alacritty = {
    enable = true;
    
    settings = {
      # 环境变量
      env = {
        TERM = "xterm-256color";
      };
      
      # 窗口配置
      window = {
        # 窗口尺寸
        dimensions = {
          columns = 120;
          lines = 30;
        };
        
        # 窗口内边距
        padding = {
          x = 10;
          y = 10;
        };
        
        # 装饰
        decorations = "full";  # full, none, transparent, buttonless
        
        # 启动模式
        # startup_mode = "Windowed";  # Windowed, Maximized, Fullscreen
        
        # 窗口标题
        title = "Alacritty";
        
        # 动态标题
        dynamic_title = true;
        
        # 窗口透明度（0.0 - 1.0）
        opacity = 0.95;
      };
      
      # 滚动配置
      scrolling = {
        history = 10000;
        multiplier = 3;
      };
      
      # 字体配置
      font = {
        # 字体大小
        size = 11.0;
        
        # 普通字体
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
        
        # 粗体字体
        bold = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold";
        };
        
        # 斜体字体
        italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Italic";
        };
        
        # 粗斜体字体
        bold_italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold Italic";
        };
      };
      
      # 颜色配置（Gruvbox Dark 主题）
      colors = {
        primary = {
          background = "#282828";
          foreground = "#ebdbb2";
        };
        
        normal = {
          black = "#282828";
          red = "#cc241d";
          green = "#98971a";
          yellow = "#d79921";
          blue = "#458588";
          magenta = "#b16286";
          cyan = "#689d6a";
          white = "#a89984";
        };
        
        bright = {
          black = "#928374";
          red = "#fb4934";
          green = "#b8bb26";
          yellow = "#fabd2f";
          blue = "#83a598";
          magenta = "#d3869b";
          cyan = "#8ec07c";
          white = "#ebdbb2";
        };
      };
      
      # 光标配置
      cursor = {
        style = {
          shape = "Block";  # Block, Underline, Beam
          blinking = "On";  # Never, Off, On, Always
        };
        
        # 光标闪烁间隔（毫秒）
        blink_interval = 750;
        
        # 光标在没有键盘输入时是否闪烁
        blink_timeout = 5;
      };
      
      # 选择配置
      selection = {
        semantic_escape_chars = ",│`|:\"' ()[]{}<>\t";
        save_to_clipboard = true;
      };
      
      # 鼠标配置
      mouse = {
        hide_when_typing = true;
      };
      
      # 键盘绑定
      keyboard.bindings = [
        # 复制/粘贴
        { key = "C"; mods = "Control|Shift"; action = "Copy"; }
        { key = "V"; mods = "Control|Shift"; action = "Paste"; }
        
        # 字体大小调整
        { key = "Plus"; mods = "Control"; action = "IncreaseFontSize"; }
        { key = "Minus"; mods = "Control"; action = "DecreaseFontSize"; }
        { key = "Key0"; mods = "Control"; action = "ResetFontSize"; }
        
        # 新建窗口
        { key = "N"; mods = "Control|Shift"; action = "CreateNewWindow"; }
        
        # 全屏
        { key = "Return"; mods = "Alt"; action = "ToggleFullscreen"; }
        
        # 清屏
        { key = "K"; mods = "Control|Shift"; action = "ClearHistory"; }
        { key = "L"; mods = "Control"; chars = "\\x0c"; }
      ];
      
      # Bell 配置
      bell = {
        animation = "EaseOutExpo";  # Ease, EaseOut, EaseOutSine, EaseOutQuad, EaseOutCubic, EaseOutQuart, EaseOutQuint, EaseOutExpo, EaseOutCirc, Linear
        duration = 0;  # 禁用视觉铃声
        color = "#ffffff";
      };
    };
  };
}
