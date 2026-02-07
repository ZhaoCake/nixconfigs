# Clash HDL Starter Template

这是一个基于 Nix Flakes 的 [Clash](https://clash-lang.org/) 硬件开发模板项目。

## 特性

- **环境隔离**: 使用 `nix` 和 `direnv` 自动管理 GHC、Clash 编译器和相关工具链，确保“在我机器上能跑”也能在你那里跑。
- **现代化配置**: `.cabal` 文件使用了 `common` 节来复用编译器参数，预配置了常用的 Clash 语言扩展和 GHC 插件（`ghc-typelits-*`）。
- **即用型**: 包含了一个简单的计数器示例和生成 HDL 的脚本命令。

## 快速开始

### 1. 环境准备

确保你已经安装了支持 Flakes 的 Nix 包管理器。

推荐安装 `direnv` 以自动加载开发环境：

```bash
# 首次进入目录时允许加载
direnv allow
```

或者手动进入 Nix 开发 Shell：

```bash
nix develop
```

### 2. 构建项目

编译 Haskell 库（用于类型检查和逻辑验证）：

```bash
cabal build
```

### 3. 生成硬件描述语言 (HDL)

本项目配置为可以直接调用 `clash` 也就是 GHC 的变体来生成 HDL 代码。

**生成 Verilog:**
生成的代码位于 `verilog/` 目录下。

```bash
clash --verilog src/Hello.hs
```

**生成 VHDL:**
生成的代码位于 `vhdl/` 目录下。

```bash
clash --vhdl src/Hello.hs
```

## 如何基于此模板创建新项目

如果你 Fork 或 Clone 了这个仓库作为新项目的起点，建议执行以下步骤：

1.  **重命名项目**:
    -   重命名 `clash-hello.cabal` 为 `your-project-name.cabal`。
    -   编辑 `.cabal` 文件内部的 `name:` 字段。
2.  **修改模块**:
    -   将 `src/Hello.hs` 重命名为你想要的模块名（例如 `src/MyCpu.hs`）。
    -   修改文件内的 `module Hello where` 为 `module MyCpu where`。
    -   更新 `.cabal` 文件中的 `exposed-modules` 列表。
3.  **添加依赖**:
    -   在 `.cabal` 文件的 `build-depends` 中添加你需要的其他 Haskell 库。

## 项目结构

```text
.
├── .envrc                # direnv 配置文件
├── .gitignore            # Git 忽略规则
├── clash-hello.cabal     # Cabal 项目描述 (依赖、构建选项)
├── flake.nix             # Nix Flake 定义 (依赖锁定、开发环境)
├── flake.lock            # Nix 依赖锁定文件
├── README.md             # 项目文档
└── src
    └── Hello.hs          # Clash 源代码示例
```

## 扩展性说明

此模板已经配置好了 Clash 开发中最核心的部分：
- **GHC 插件**:  `ghc-typelits-natnormalise` 等插件已启用，这是处理 Clash 中复杂的类型级自然数运算所必需的。
- **常用扩展**:  `DataKinds`, `TypeOperators` 等常用扩展已在 `common-options` 中预设，编写新模块时无需重复声明。

要扩展此项目，你只需在 `src/` 下创建新的 `.hs` 文件，并在 `.cabal` 中注册即可。对于大型项目，建议添加 `test-suite` 进行单元测试。
