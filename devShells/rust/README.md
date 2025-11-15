# Rust Project

## Quick Start

```bash
# 复制模板
cp -r ~/.nixconfigs/devShells/rust ~/projects/my-rust-project
cd ~/projects/my-rust-project

# 激活环境
direnv allow

# 初始化项目
cargo init .
cargo build
cargo run
```

## Tools

- **rustc**: Rust 编译器
- **cargo**: Rust 包管理器
- **clippy**: Rust linter
- **rustfmt**: 代码格式化
- **rust-analyzer**: LSP 服务器

## Cargo 配置

Cargo 使用国内镜像源配置在 `~/.cargo/config.toml`。
