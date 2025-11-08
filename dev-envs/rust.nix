# Rust 开发环境配置示例
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
    # cmake
    # pkg-config
  ];
  
  # Rust 特定环境变量
  home.sessionVariables = {
    RUST_BACKTRACE = "1";
    # CARGO_HOME = "$HOME/.cargo";
  };
}
