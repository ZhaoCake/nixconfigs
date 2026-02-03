````markdown
# Haskell Hello World Template

基于 Nix Flakes 的 Haskell 开发环境模板（Hello World）。

## 🌟 特性

- **GHC** - Haskell 编译器
- **Cabal** - 标准构建工具
- **Haskell Language Server** - IDE/LSP 支持
- **Ormolu** - 代码格式化
- **HLint** - 静态检查

## 📁 项目结构

```
.
├── flake.nix              # Nix 开发环境配置
├── .envrc                 # direnv 配置
├── .gitignore             # Git 忽略规则
├── Makefile               # 便捷命令
├── haskell-hello.cabal    # Cabal 配置
└── src/
    └── Main.hs            # Hello World 示例
```

## 🚀 快速开始

### 1. 进入开发环境

```bash
# 使用 direnv（推荐）
direnv allow

# 或手动进入
nix develop
```

### 2. 运行示例

```bash
make run
```

## 🛠️ 常用命令

```bash
make build     # 构建项目
make run       # 运行程序
make repl      # 进入 GHCi
make fmt       # 格式化代码
make lint      # HLint 检查
make clean     # 清理构建产物
```

## 📝 添加依赖

在 `haskell-hello.cabal` 的 `build-depends` 中添加：

```cabal
build-depends:
  base >=4.14 && <5,
  text,
  containers
```

````
