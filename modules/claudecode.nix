{ pkgs, ... }:

{
  home.packages = with pkgs; [
    claude-code
  ];

  # Claude Code defaults: use DeepSeek Anthropic-compatible API.
  home.file.".claude/settings.json".text = ''
    {
      "$schema": "https://json.schemastore.org/claude-code-settings.json",
      "model": "deepseek-v4-pro",
      "env": {
        "ANTHROPIC_BASE_URL": "https://api.deepseek.com/anthropic",
        "ANTHROPIC_MODEL": "deepseek-v4-pro",
        "ANTHROPIC_DEFAULT_OPUS_MODEL": "deepseek-v4-pro",
        "ANTHROPIC_DEFAULT_SONNET_MODEL": "deepseek-v4-pro",
        "ANTHROPIC_DEFAULT_HAIKU_MODEL": "deepseek-v4-flash",
        "CLAUDE_CODE_SUBAGENT_MODEL": "deepseek-v4-flash",
        "CLAUDE_CODE_EFFORT_LEVEL": "max",
        "CLAUDE_CODE_ATTRIBUTION_HEADER": "0",
        "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": "1",
        "CLAUDE_CODE_DISABLE_TERMINAL_TITLE": "1"
      }
    }
  '';

  programs.fish.functions = {
    claude-ca = ''
      set -l chatanywhere_key (cat ~/.config/ai-secrets/chatanywhere_api_key 2>/dev/null | string trim)
      if test -z "$chatanywhere_key"
        echo "Missing key: ~/.config/ai-secrets/chatanywhere_api_key"
        return 1
      end

      env \
        ANTHROPIC_BASE_URL="https://api.chatanywhere.tech" \
        ANTHROPIC_AUTH_TOKEN="$chatanywhere_key" \
        claude $argv
    '';
  };
}
