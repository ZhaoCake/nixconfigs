# Rust 开发环境配置
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Rust 工具链
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer
    
    # 构建工具
    pkg-config
    openssl
  ];
  
  # Rust 特定环境变量
  home.sessionVariables = {
    RUST_BACKTRACE = "1";
    CARGO_HOME = "$HOME/.cargo";
  };
  
  # Cargo 配置（使用国内镜像源）
  home.file.".cargo/config.toml".text = ''
    [source.crates-io]
    replace-with = 'ustc'
    
    # 中国科学技术大学镜像源
    [source.ustc]
    registry = "sparse+https://mirrors.ustc.edu.cn/crates.io-index/"
    
    # 或者使用字节跳动镜像源
    # [source.rsproxy]
    # registry = "https://rsproxy.cn/crates.io-index"
    
    # 或者使用清华大学镜像源
    # [source.tuna]
    # registry = "https://mirrors.tuna.tsinghua.edu.cn/git/crates.io-index.git"
    
    # rustup 镜像配置
    [install]
    # 使用中科大镜像
    # RUSTUP_DIST_SERVER = "https://mirrors.ustc.edu.cn/rust-static"
    # RUSTUP_UPDATE_ROOT = "https://mirrors.ustc.edu.cn/rust-static/rustup"
    
    # 编译优化
    [build]
    # 使用所有 CPU 核心
    jobs = 0
    
    # 网络配置
    [net]
    retry = 3
    git-fetch-with-cli = true
    
    # 注册表配置
    [registry]
    default = "crates-io"
  '';
}
