# Node.js 开发环境配置示例
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Node.js 运行时
    nodejs_20
    
    # 包管理器
    nodePackages.npm
    nodePackages.yarn
    nodePackages.pnpm
    
    # 开发工具
    nodePackages.typescript
    nodePackages.eslint
    nodePackages.prettier
    nodePackages.typescript-language-server
    
    # 其他工具
    # nodePackages.nodemon
    # nodePackages.pm2
  ];
  
  # Node.js 特定环境变量
  home.sessionVariables = {
    # NODE_ENV = "development";
  };
}
