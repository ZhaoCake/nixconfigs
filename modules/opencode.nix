{ config, pkgs, ... }:

{
  home = {
    # packages = with pkgs; [
    #   opencode
    # ];

    # OpenCode default provider/model configuration with oh-my-openagent plugin.
    file.".config/opencode/opencode.jsonc".text = ''
    {
      "$schema": "https://opencode.ai/config.json",
      "plugin": ["oh-my-openagent"],
      "provider": {
        "newcli-anthropic": {
          "npm": "@ai-sdk/anthropic",
          "name": "NewCLI Anthropic",
          "options": {
            "baseURL": "https://code.newcli.com/claude/ultra",
            "apiKey": "{file:~/.config/ai-secrets/anthropic_api_key}"
          },
          "models": {
            "claude-sonnet-4-6": {
              "name": "Claude Sonnet 4.6 (NewCLI)"
            },
            "claude-opus-4-6": {
              "name": "Claude Opus 4.6 (NewCLI)"
            }
          }
        },
        "deepseek": {
          "npm": "@ai-sdk/openai-compatible",
          "name": "DeepSeek",
          "options": {
            "baseURL": "https://api.deepseek.com",
            "apiKey": "{file:~/.config/ai-secrets/deepseek_api_key}"
          },
          "models": {
            "deepseek-v4-pro": {
              "name": "DeepSeek V4 Pro"
            },
            "deepseek-v4-flash": {
              "name": "DeepSeek V4 Flash"
            }
          }
        },
        "chatanywhere": {
          "npm": "@ai-sdk/openai-compatible",
          "name": "ChatAnywhere",
          "options": {
            "baseURL": "https://api.chatanywhere.tech/v1",
          },
          "models": {
            "gpt-5.3-codex-ca": {
              "name": "GPT-5.3-Codex"
            }
          }
        },
        "siliconflow": {
          "npm": "@ai-sdk/openai-compatible",
          "name": "SiliconFlow",
          "options": {
            "baseURL": "https://api.siliconflow.cn/v1",
            "apiKey": "{file:~/.config/ai-secrets/siliconflow_api_key}"
          },
          "models": {
            "Pro/zai-org/GLM-5.1": {
              "name": "GLM-5.1 (SiliconFlow)"
            }
          }
        },
        "ark": {
          "npm": "@ai-sdk/openai-compatible",
          "name": "Ark (Volcengine)",
          "options": {
            "baseURL": "https://ark.cn-beijing.volces.com/api/coding/v3",
            "apiKey": "{file:~/.config/ai-secrets/ark_api_key}"
          },
          "models": {
            "glm-5.1": {
              "name": "GLM-5.1 (Ark)"
            }
          }
        }
      },
      "mcp": {
        "tavily_mcp": {
          "type": "local",
          "command": ["npx", "-y", "tavily-mcp"],
          "enabled": true,
          "environment": {
            "TAVILY_API_KEY": "{file:~/.config/ai-secrets/tavily_api_key}",
            "DEFAULT_PARAMETERS": "{\"max_results\": 10, \"search_depth\": \"advanced\"}"
          }
        }
        // "scholar_mcp": {
        //   "type": "local",
        //   "command": ["npx", "-y", "scholar-mcp", "--transport=stdio"],
        //   "enabled": true,
        //   "environment": {
        //     "SCHOLAR_MCP_TRANSPORT": "stdio",
        //     "SCHOLAR_REQUEST_DELAY_MS": "350",
        //     "RESEARCH_ALLOW_REMOTE_PDFS": "true",
        //     "RESEARCH_ALLOW_LOCAL_PDFS": "true"
        //   }
        // }
      },
      "model": "deepseek/deepseek-v4-pro",
      "small_model": "deepseek/deepseek-v4-flash"
    }
  '';

    file.".config/opencode/oh-my-openagent.json".text = ''
    {
      "agents": {
        "sisyphus": {
          "model": "deepseek/deepseek-v4-pro",
          "fallback_models": [
            "newcli-anthropic/claude-sonnet-4-6",
            "deepseek/deepseek-v4-pro",
            "ark/glm-5.1",
            "siliconflow/Pro/zai-org/GLM-5.1"
          ]
        },
        "metis": {
          "model": "deepseek/deepseek-v4-pro",
          "fallback_models": [
            "newcli-anthropic/claude-sonnet-4-6",
            "deepseek/deepseek-v4-pro"
          ]
        },
        "prometheus": {
          "model": "deepseek/deepseek-v4-pro",
          "fallback_models": [
            "newcli-anthropic/claude-sonnet-4-6",
            "deepseek/deepseek-v4-pro"
          ]
        },
        "atlas": {
          "model": "deepseek/deepseek-v4-pro",
          "fallback_models": [
            "newcli-anthropic/claude-sonnet-4-6",
            "deepseek/deepseek-v4-pro",
            "siliconflow/Pro/zai-org/GLM-5.1"
          ]
        },
        "oracle": {
          "model": "deepseek/deepseek-v4-pro",
          "fallback_models": [
            "newcli-anthropic/claude-opus-4-6",
            "newcli-anthropic/claude-sonnet-4-6",
            "chatanywhere/gpt-5.3-codex-ca"
          ]
        },
        "hephaestus": {
          "model": "deepseek/deepseek-v4-pro",
          "fallback_models": [
            "chatanywhere/gpt-5.3-codex-ca",
            "newcli-anthropic/claude-opus-4-6"
          ]
        },
        "momus": {
          "model": "deepseek/deepseek-v4-pro",
          "fallback_models": [
            "newcli-anthropic/claude-opus-4-6",
            "newcli-anthropic/claude-sonnet-4-6",
            "chatanywhere/gpt-5.3-codex-ca"
          ]
        },
        "explore": {
          "model": "deepseek/deepseek-v4-flash",
          "fallback_models": [
            "deepseek/deepseek-v4-pro"
          ]
        },
        "librarian": {
          "model": "deepseek/deepseek-v4-flash",
          "fallback_models": [
            "deepseek/deepseek-v4-pro"
          ]
        },
        "multimodal-looker": {
          "model": "ark/glm-5.1",
          "fallback_models": [
            "siliconflow/Pro/zai-org/GLM-5.1"
          ]
        }
      }
    }
  '';

  };
}
