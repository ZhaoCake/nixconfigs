# Go 开发环境配置示例
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Go 工具链
    go
    gopls
    golangci-lint
    
    # 调试工具
    delve
  ];
  
  # Go 特定环境变量
  home.sessionVariables = {
    GOPATH = "$HOME/go";
    # GO111MODULE = "on";
  };
}
