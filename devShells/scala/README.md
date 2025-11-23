# Pure Scala Development Environment

基于 Nix 的纯 Scala 开发环境模板。

## 🌟 特性

- **Scala 3.3.4 (LTS)** - 现代编程语言
- **Mill 构建系统** - 快速、灵活的构建工具
- **Nix Flake** - 可复现的开发环境
- **Metals 支持** - 优秀的 IDE 体验

## 📁 项目结构

```
.
├── flake.nix              # Nix 开发环境配置
├── build.mill             # Mill 构建配置
├── Makefile               # 便捷命令
└── src/
    └── Main.scala         # 示例代码
```

## 🚀 快速开始

### 1. 进入开发环境

```bash
# 使用 direnv（推荐）
direnv allow

# 或手动进入
nix develop
```

### 2. 运行应用

```bash
make run
# 或
mill app.run
```

### 3. 运行测试

```bash
make test
# 或
mill app.test
```

## 🛠️ 常用命令

```bash
make run        # 运行应用
make test       # 运行测试
make reformat   # 格式化代码
make bsp        # 生成 IDE 配置
make clean      # 清理构建产物
```

## 📝 自定义

编辑 `build.mill` 添加依赖：

```scala
def ivyDeps = Agg(
  ivy"com.lihaoyi::os-lib:0.9.3",
  ivy"com.lihaoyi::upickle:3.1.4"
)
```
