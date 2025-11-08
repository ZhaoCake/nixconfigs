# Python 开发环境配置
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Python 解释器
    python312
    python312Packages.pip
    
    # uv - 现代 Python 包管理器
    uv
    
    # Python 开发工具
    python312Packages.ipython
    python312Packages.black
    python312Packages.ruff  # 更快的 linter，替代 flake8 和 pylint
    python312Packages.pytest
    python312Packages.mypy
    
    # 可选：全局安装的常用工具
    # python312Packages.poetry
    # python312Packages.pipx
  ];
  
  # 配置 pip 使用清华镜像源
  home.file.".pip/pip.conf".text = ''
    [global]
    index-url = https://pypi.tuna.tsinghua.edu.cn/simple
    
    [install]
    trusted-host = pypi.tuna.tsinghua.edu.cn
  '';
  
  # 配置 uv 使用清华镜像源
  home.file.".config/uv/uv.toml".text = ''
    [pip]
    index-url = "https://pypi.tuna.tsinghua.edu.cn/simple"
    
    # 或者使用中科大镜像
    # index-url = "https://mirrors.ustc.edu.cn/pypi/simple"
    
    # 或者使用阿里云镜像
    # index-url = "https://mirrors.aliyun.com/pypi/simple"
  '';
  
  # Python 特定的环境变量
  home.sessionVariables = {
    # uv 缓存目录
    UV_CACHE_DIR = "$HOME/.cache/uv";
    
    # Python 不创建 __pycache__ 目录（可选）
    # PYTHONDONTWRITEBYTECODE = "1";
  };
}
