{ config, pkgs, lib, ... }:

{
  imports = [
    # ./claudecode.nix
    # ./codex.nix
    ./opencode.nix
  ];

  home.packages = with pkgs; [
    bun
  ];

  # Keep secret material out of Git-tracked Nix files.
  home.file.".config/ai-secrets/README.md".text = ''
    # AI Secrets (local only)

    Put your Anthropic API key in:

    ~/.config/ai-secrets/anthropic_api_key

    Put your ChatAnywhere API key in:

    ~/.config/ai-secrets/chatanywhere_api_key

    Put your SiliconFlow API key in:

    ~/.config/ai-secrets/siliconflow_api_key

    Put your DeepSeek API key in:

    ~/.config/ai-secrets/deepseek_api_key

    Put your Ark (Volcengine) API key in:

    ~/.config/ai-secrets/ark_api_key

    Put your Tavily API key in:

    ~/.config/ai-secrets/tavily_api_key

    Suggested permissions:

    chmod 700 ~/.config/ai-secrets
    chmod 600 ~/.config/ai-secrets/anthropic_api_key
    chmod 600 ~/.config/ai-secrets/chatanywhere_api_key
    chmod 600 ~/.config/ai-secrets/siliconflow_api_key
    chmod 600 ~/.config/ai-secrets/deepseek_api_key
    chmod 600 ~/.config/ai-secrets/ark_api_key
    chmod 600 ~/.config/ai-secrets/tavily_api_key
  '';

  programs.fish.loginShellInit = lib.mkAfter ''
    if test -f "${config.home.homeDirectory}/.config/ai-secrets/anthropic_api_key"
      set -gx ANTHROPIC_AUTH_TOKEN (cat "${config.home.homeDirectory}/.config/ai-secrets/anthropic_api_key")
    end

    if test -f "${config.home.homeDirectory}/.config/ai-secrets/chatanywhere_api_key"
      set -gx CHATANYWHERE_API_KEY (cat "${config.home.homeDirectory}/.config/ai-secrets/chatanywhere_api_key")
    end

    if test -f "${config.home.homeDirectory}/.config/ai-secrets/siliconflow_api_key"
      set -gx SILICONFLOW_API_KEY (cat "${config.home.homeDirectory}/.config/ai-secrets/siliconflow_api_key")
    end

    if test -f "${config.home.homeDirectory}/.config/ai-secrets/deepseek_api_key"
      set -gx DEEPSEEK_API_KEY (cat "${config.home.homeDirectory}/.config/ai-secrets/deepseek_api_key")
    end

    if test -f "${config.home.homeDirectory}/.config/ai-secrets/ark_api_key"
      set -gx ARK_API_KEY (cat "${config.home.homeDirectory}/.config/ai-secrets/ark_api_key")
    end

    if test -f "${config.home.homeDirectory}/.config/ai-secrets/tavily_api_key"
      set -gx TAVILY_API_KEY (cat "${config.home.homeDirectory}/.config/ai-secrets/tavily_api_key")
    end
  '';
}
