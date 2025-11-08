{ config, pkgs, ... }:

{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    
    settings = {
      # 主提示符格式
      format = "$all";
      
      # 在命令之间添加空行
      add_newline = true;
      
      # 字符配置
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
      
      # 目录配置
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        style = "bold cyan";
      };
      
      # Git 配置
      git_branch = {
        symbol = " ";
        style = "bold purple";
      };
      
      git_status = {
        conflicted = "🏳";
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        untracked = "🤷";
        stashed = "📦";
        modified = "📝";
        staged = "[++($count)](green)";
        renamed = "👅";
        deleted = "🗑";
      };
      
      # 编程语言图标配置
      python = {
        symbol = " ";
        style = "bold yellow";
      };
      
      nodejs = {
        symbol = " ";
        style = "bold green";
      };
      
      rust = {
        symbol = " ";
        style = "bold red";
      };
      
      golang = {
        symbol = " ";
        style = "bold cyan";
      };
      
      java = {
        symbol = " ";
        style = "bold red";
      };
      
      nix_shell = {
        symbol = " ";
        style = "bold blue";
        format = "via [$symbol$state( \\($name\\))]($style) ";
      };
      
      # 时间配置（可选）
      time = {
        disabled = false;
        format = "🕙[\\[ $time \\]]($style) ";
        time_format = "%T";
        style = "bold white";
      };
      
      # 命令执行时间
      cmd_duration = {
        min_time = 500;
        format = "underwent [$duration](bold yellow)";
      };
      
      # 用户名和主机名（可选）
      username = {
        show_always = false;
        format = "[$user]($style) in ";
      };
      
      hostname = {
        ssh_only = false;
        format = "on [$hostname](bold red) ";
        disabled = false;
      };
    };
  };
}
