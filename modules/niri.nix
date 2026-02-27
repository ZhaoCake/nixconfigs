{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    noctalia-shell
    swww              # 动态壁纸守护进程
    fuzzel            # 极简应用启动器 (Wayland)
    grim              # 截图工具
    slurp             # 屏幕区域选择工具
    wl-clipboard      # 剪贴板工具
    libnotify         # 通知发送工具
  ];

  # 壁纸设置
  home.file.".config/niri/wallpaper.jpg".source = ../assets/wallpaper.jpg;

  # Noctalia Shell 配置
  home.file.".config/noctalia/settings.json".text = ''
    {
      "general": {
        "scaleRatio": 1.0,
        "animationSpeed": 1.0
      },
      "bar": {
        "position": "top",
        "floating": true,
        "backgroundOpacity": 0.8,
        "showWorkspaces": true,
        "showClock": true,
        "showSystemTray": true
      },
      "appearance": {
        "theme": "dark",
        "cornerRadius": 12,
        "blur": true
      }
    }
  '';

  # Foot 终端配置 (Catppuccin Mocha 配色)
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = "Maple Mono NF:size=10";
        pad = "10x10";
        dpi-aware = "yes";
      };
      
      mouse = {
        hide-when-typing = "yes";
      };

      colors = {
        alpha = "0.95";
        foreground = "cdd6f4"; # Text
        background = "1e1e2e"; # Base
        regular0 = "45475a";   # Surface 1
        regular1 = "f38ba8";   # Red
        regular2 = "a6e3a1";   # Green
        regular3 = "f9e2af";   # Yellow
        regular4 = "89b4fa";   # Blue
        regular5 = "f5c2e7";   # Pink
        regular6 = "94e2d5";   # Teal
        regular7 = "bac2de";   # Subtext 1
        bright0 = "585b70";    # Surface 2
        bright1 = "f38ba8";    # Red
        bright2 = "a6e3a1";    # Green
        bright3 = "f9e2af";    # Yellow
        bright4 = "89b4fa";    # Blue
        bright5 = "f5c2e7";    # Pink
        bright6 = "94e2d5";    # Teal
        bright7 = "a6adc8";    # Subtext 0
      };
    };
  };

  # Fuzzel 应用启动器配置
  home.file.".config/fuzzel/fuzzel.ini".text = ''
    [main]
    font=Maple Mono NF:size=14
    dpi-aware=yes
    icon-theme=hicolor
    width=40
    lines=10
    horizontal-pad=40
    vertical-pad=20
    inner-pad=10
    
    [colors]
    background=1e1e2eff
    text=cdd6f4ff
    match=f38ba8ff
    selection=585b70ff
    selection-text=cdd6f4ff
    border=89b4faff
    
    [border]
    width=2
    radius=10
  '';

  # Niri 窗口管理器完整配置
  home.file.".config/niri/config.kdl".text = ''
    // 基础输入设备配置
    input {
      keyboard {
        xkb {
          layout "us"
        }
        repeat-delay 600
        repeat-rate 25
      }

      touchpad {
        tap
        natural-scroll
        accel-speed 0.2
      }
    }

    // 窗口布局与外观
    layout {
      gaps 16
      center-focused-column "never"

      preset-column-widths {
        proportion 0.33333
        proportion 0.5
        proportion 0.66667
      }

      default-column-width { proportion 0.5; }

      focus-ring {
        width 2
        active-color "#89b4fa"
        inactive-color "#585b70"
      }
      
      border {
        off
      }
    }

    // 窗口外观规则
    window-rule {
      geometry-corner-radius 12
      clip-to-geometry true
    }

    // 动画设置
    animations {
      slowdown 1.0
    }

    // 快捷键绑定
    binds {
      // 核心操作
      Mod+Shift+Slash { show-hotkey-overlay; }
      Mod+Return { spawn "foot"; }
      Mod+D { spawn "fuzzel"; }
      Mod+Space { spawn "noctalia-shell"; } // Noctalia 启动器/菜单

      // 窗口管理
      Mod+Q { close-window; }

      // 焦点移动
      Mod+H { focus-column-left; }
      Mod+L { focus-column-right; }
      Mod+J { focus-window-down; }
      Mod+K { focus-window-up; }

      // 窗口移动
      Mod+Shift+H { move-column-left; }
      Mod+Shift+L { move-column-right; }
      Mod+Shift+J { move-window-down; }
      Mod+Shift+K { move-window-up; }

      // 窗口大小调整
      Mod+Minus { set-column-width "-10%"; }
      Mod+Equal { set-column-width "+10%"; }
      Mod+F { fullscreen-window; }
      
      // 布局操作
      Mod+C { center-column; }

      // 截图 (依赖 grim + slurp)
      Print { spawn "sh" "-c" "grim -g \"$(slurp)\" - | wl-copy"; }
      Ctrl+Print { spawn "sh" "-c" "grim - | wl-copy"; }

      // 退出 Niri
      Mod+Shift+E { quit; }
      
      // 媒体键支持
      XF86AudioRaiseVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+"; }
      XF86AudioLowerVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-"; }
      XF86AudioMute        allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
    }

    // 启动项

    // 启动 Noctalia Shell (作为状态栏/桌面环境)
    spawn-at-startup "noctalia-shell"

    // wallpaper
    spawn-at-startup "swww-daemon"
    spawn-at-startup "swww" "img" "${config.home.homeDirectory}/.config/niri/wallpaper.jpg"
    
    // 启动通知守护进程 (如果系统有 mako 或 dunst，这里暂不需要，niri 推荐 mako)
    // spawn-at-startup "mako"
  '';
}
