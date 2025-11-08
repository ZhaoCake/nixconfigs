# fastfetch 配置模块
{ config, pkgs, ... }:

{
  # fastfetch 配置文件
  home.file.".config/fastfetch/config.jsonc".text = ''
    {
      "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
      "logo": {
        "source": "nixos_small",
        "padding": {
          "top": 1,
          "left": 2
        }
      },
      "display": {
        "separator": " ➜ ",
        "color": {
          "keys": "cyan",
          "title": "blue"
        }
      },
      "modules": [
        {
          "type": "title",
          "format": "{#blue}{user-name-colored}{#}@{#green}{host-name-colored}{#}"
        },
        {
          "type": "separator",
          "string": "─────────────────────────────"
        },
        {
          "type": "os",
          "key": "OS",
          "keyColor": "cyan"
        },
        {
          "type": "kernel",
          "key": "Kernel",
          "keyColor": "cyan"
        },
        {
          "type": "packages",
          "key": "Packages",
          "keyColor": "cyan"
        },
        {
          "type": "shell",
          "key": "Shell",
          "keyColor": "cyan"
        },
        {
          "type": "terminal",
          "key": "Terminal",
          "keyColor": "cyan"
        },
        {
          "type": "de",
          "key": "DE",
          "keyColor": "cyan"
        },
        {
          "type": "wm",
          "key": "WM",
          "keyColor": "cyan"
        },
        {
          "type": "separator",
          "string": "─────────────────────────────"
        },
        {
          "type": "host",
          "key": "Host",
          "keyColor": "magenta"
        },
        {
          "type": "cpu",
          "key": "CPU",
          "keyColor": "magenta"
        },
        {
          "type": "gpu",
          "key": "GPU",
          "keyColor": "magenta"
        },
        {
          "type": "memory",
          "key": "Memory",
          "keyColor": "magenta"
        },
        {
          "type": "disk",
          "key": "Disk",
          "keyColor": "magenta"
        },
        {
          "type": "uptime",
          "key": "Uptime",
          "keyColor": "yellow"
        },
        {
          "type": "separator",
          "string": "─────────────────────────────"
        },
        {
          "type": "colors",
          "symbol": "circle"
        }
      ]
    }
  '';
  
  # 创建一个简洁版本的配置（可选）
  home.file.".config/fastfetch/config-minimal.jsonc".text = ''
    {
      "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
      "logo": {
        "source": "nixos_small",
        "padding": {
          "top": 1
        }
      },
      "display": {
        "separator": " → ",
        "color": {
          "keys": "blue"
        }
      },
      "modules": [
        "title",
        "separator",
        "os",
        "kernel",
        "shell",
        "terminal",
        "separator",
        "cpu",
        "memory",
        "uptime",
        "separator",
        "colors"
      ]
    }
  '';
}
