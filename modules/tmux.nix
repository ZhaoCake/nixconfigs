{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    
    # 基础配置
    baseIndex = 1;  # 窗口编号从 1 开始
    clock24 = true;  # 使用 24 小时制
    escapeTime = 0;  # 减少 ESC 键延迟
    historyLimit = 10000;  # 历史记录行数
    
    # 终端配置
    terminal = "screen-256color";
    
    # 启用鼠标支持
    mouse = true;
    
    # 自定义前缀键（默认 Ctrl-b）
    # prefix = "C-a";  # 如果想改成 Ctrl-a，取消注释这行
    
    # 额外配置
    extraConfig = ''
      # 分屏快捷键
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      
      # 面板切换（Vim 风格）
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      
      # 面板大小调整
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5
      
      # 重新加载配置文件
      bind r source-file ~/.config/tmux/tmux.conf \; display "配置已重新加载"
      
      # 复制模式使用 vi 键绑定
      setw -g mode-keys vi
      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      
      # 状态栏配置
      set -g status-position bottom
      set -g status-justify left
      set -g status-style 'bg=colour234 fg=colour137 dim'
      set -g status-left ""
      set -g status-right '#[fg=colour233,bg=colour241,bold] %Y-%m-%d #[fg=colour233,bg=colour245,bold] %H:%M:%S '
      set -g status-right-length 50
      set -g status-left-length 20
      
      # 窗口状态栏配置
      setw -g window-status-current-style 'fg=colour1 bg=colour19 bold'
      setw -g window-status-current-format ' #I#[fg=colour249]:#[fg=colour255]#W#[fg=colour249]#F '
      setw -g window-status-style 'fg=colour9 bg=colour18'
      setw -g window-status-format ' #I#[fg=colour237]:#[fg=colour250]#W#[fg=colour244]#F '
      
      # 面板边框配置
      set -g pane-border-style 'fg=colour238'
      set -g pane-active-border-style 'fg=colour51'
      
      # 消息样式
      set -g message-style 'fg=colour232 bg=colour166 bold'
    '';
    
    # 插件配置（可选）
    plugins = with pkgs.tmuxPlugins; [
      # sensible  # 基础合理配置
      # yank      # 系统剪贴板集成
      # resurrect # 保存和恢复 tmux 会话
      # continuum # 自动保存 tmux 会话
    ];
  };
}
