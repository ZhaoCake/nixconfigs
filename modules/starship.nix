{ config, pkgs, ... }:

{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    
    settings = {
      # 简洁的提示符格式
      format = "$username$hostname$directory$git_branch$git_status$python$nodejs$rust$golang$nix_shell$character";
      
      # 在命令之间添加空行
      add_newline = true;
      
      # 字符配置
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };
      
      # 目录配置
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        style = "bold cyan";
        format = "[$path]($style) ";
      };
      
      # Git 配置
      git_branch = {
        symbol = "";
        style = "bold purple";
        format = "on [$symbol$branch]($style) ";
      };
      
      git_status = {
        style = "bold yellow";
        format = "([$all_status$ahead_behind]($style) )";
        conflicted = "=";
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕\${ahead_count}\${behind_count}";
        untracked = "?";
        stashed = "$";
        modified = "!";
        staged = "+";
        renamed = "»";
        deleted = "✘";
      };
      
      # 编程语言配置（简洁版）
      python = {
        symbol = "py ";
        style = "bold yellow";
        format = "via [$symbol$version]($style) ";
      };
      
      nodejs = {
        symbol = "node ";
        style = "bold green";
        format = "via [$symbol$version]($style) ";
      };
      
      rust = {
        symbol = "rs ";
        style = "bold red";
        format = "via [$symbol$version]($style) ";
      };
      
      golang = {
        symbol = "go ";
        style = "bold cyan";
        format = "via [$symbol$version]($style) ";
      };
      
      nix_shell = {
        symbol = "nix ";
        style = "bold blue";
        format = "via [$symbol$state]($style) ";
      };
      
      # 命令执行时间（仅显示较长时间）
      cmd_duration = {
        min_time = 2000;
        format = "took [$duration]($style) ";
        style = "bold yellow";
      };
      
      # 用户名和主机名（仅在 SSH 时显示）
      username = {
        show_always = false;
        format = "[$user]($style)@";
        style_user = "bold blue";
      };
      
      hostname = {
        ssh_only = true;
        format = "[$hostname]($style) in ";
        style = "bold blue";
      };
    };
  };
}
