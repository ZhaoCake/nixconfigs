{ config, self, ... }:

{
  age.identityPaths = [
    "${config.home.homeDirectory}/.config/sops/age/keys.txt"
  ];

  age.secrets = {
    anthropic_api_key = {
      file = "${self}/secrets/anthropic_api_key.age";
      path = "${config.home.homeDirectory}/.config/ai-secrets/anthropic_api_key";
    };
    chatanywhere_api_key = {
      file = "${self}/secrets/chatanywhere_api_key.age";
      path = "${config.home.homeDirectory}/.config/ai-secrets/chatanywhere_api_key";
    };
    siliconflow_api_key = {
      file = "${self}/secrets/siliconflow_api_key.age";
      path = "${config.home.homeDirectory}/.config/ai-secrets/siliconflow_api_key";
    };
    deepseek_api_key = {
      file = "${self}/secrets/deepseek_api_key.age";
      path = "${config.home.homeDirectory}/.config/ai-secrets/deepseek_api_key";
    };
    ark_api_key = {
      file = "${self}/secrets/ark_api_key.age";
      path = "${config.home.homeDirectory}/.config/ai-secrets/ark_api_key";
    };
    tavily_api_key = {
      file = "${self}/secrets/tavily_api_key.age";
      path = "${config.home.homeDirectory}/.config/ai-secrets/tavily_api_key";
    };
  };
}
