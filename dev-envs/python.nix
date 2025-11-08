# Python 开发环境配置示例
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Python 解释器
    python311
    python311Packages.pip
    python311Packages.virtualenv
    
    # Python 开发工具
    python311Packages.ipython
    python311Packages.black
    python311Packages.flake8
    python311Packages.pylint
    python311Packages.pytest
    
    # 常用库（可选）
    # python311Packages.numpy
    # python311Packages.pandas
    # python311Packages.requests
  ];
  
  # Python 特定的环境变量
  home.sessionVariables = {
    # PYTHONPATH = "$HOME/.local/lib/python3.11/site-packages";
  };
}
