# Scala 开发环境

基于 Nix 的纯 Scala 开发环境，使用 Coursier 进行包管理，Mill 进行构建。

## 🌟 特性

- **Scala 3.3.4** - 现代化的 Scala 版本
- **Coursier** - Scala 标准的工件获取和安装工具
- **Mill 0.12.7** - 快速简洁的构建工具
- **Metals** - Scala 语言服务器，支持 IDE
- **Nix Flake** - 可复现的开发环境
- **direnv 支持** - 进入目录时自动激活环境

## 📁 项目结构

```
.
├── flake.nix              # Nix development environment
├── build.mill             # Mill build configuration
├── .mill-version          # Mill version lock
├── .scalafmt.conf         # Scalafmt configuration
├── Makefile               # Convenient make commands
├── src/
│   └── Main.scala         # Main application code
├── test/
│   └── src/
│       └── MainTest.scala # Test code
└── README.md              # This file
```

## 🚀 快速开始

### 使用 direnv（推荐）

如果你在主 nixconfigs 中启用了 direnv：

```bash
# 进入此目录
cd /path/to/devShells/scala

# 允许 direnv（首次需要）
direnv allow

# 环境将自动激活！
# Scala 会通过 Coursier 自动安装
```

### 手动激活

```bash
# 进入 Nix 开发 shell
nix develop

# 或使用 direnv
echo "use flake" > .envrc
direnv allow
```

## 🛠️ 可用命令

### 构建和测试

```bash
# 编译项目
make compile

# 运行测试
make test

# 运行主类
make run

# 带参数运行
make run-args ARGS="arg1 arg2"

# 清理构建产物
make clean
```

### 开发工具

```bash
# 格式化 Scala 代码
make reformat

# 检查代码格式
make checkformat

# 设置 BSP 用于 IDE 集成
make bsp

# 生成 IntelliJ IDEA 项目
make idea

# 显示所有可用的 Mill 任务
make tasks
```

### 直接使用 Mill 命令

```bash
# 编译
mill myproject.compile

# 运行
mill myproject.run

# 运行测试
mill myproject.test

# 显示依赖树
mill myproject.ivyDepsTree
```

### Coursier 命令

Coursier (cs) 可用于管理 Scala 应用程序：

```bash
# 安装 Scala 应用程序
cs install scala           # Scala REPL
cs install scalac          # Scala 编译器
cs install scala-cli       # Scala CLI
cs install sbt             # SBT 构建工具
cs install ammonite        # Ammonite REPL

# 无需安装直接启动应用
cs launch scala-cli

# 获取依赖
cs fetch org.typelevel::cats-core:2.10.0

# 设置完整的 Scala 环境
cs setup
```

## 📝 自定义项目

### 1. 重命名模块

编辑 `build.mill`，将 `myproject` 改为你的项目名：

```scala
object yourproject extends ScalaModule {
  def scalaVersion = "3.3.4"
  // ...
}
```

### 2. 更新 Makefile

在 `Makefile` 中将 `PROJECT = myproject` 改为 `PROJECT = yourproject`。

### 3. 更改 Scala 版本

编辑 `build.mill`：

```scala
def scalaVersion = "3.3.4"  // 或使用 "2.13.12" for Scala 2
```

### 4. 添加依赖

编辑 `build.mill` 添加依赖：

```scala
object myproject extends ScalaModule {
  def scalaVersion = "3.3.4"
  
  def ivyDeps = Agg(
    ivy"org.typelevel::cats-core::2.10.0",
    ivy"com.lihaoyi::upickle::3.1.3",
    // 在此添加更多依赖
  )
}
```

### 5. 添加更多模块

你可以在 `build.mill` 中定义多个模块：

```scala
object core extends ScalaModule {
  def scalaVersion = "3.3.4"
}

object api extends ScalaModule {
  def scalaVersion = "3.3.4"
  def moduleDeps = Seq(core)
}
```

## 🎓 示例：Hello World

模板包含一个简单的 Hello World 示例：

```bash
# 编译
make compile

# 运行
make run

# 带参数运行
make run-args ARGS="Alice Bob"

# 测试
make test
```

## 🔧 IDE 设置

### VS Code + Metals

1. 安装 "Scala (Metals)" 扩展
2. 生成 BSP 配置：
   ```bash
   make bsp
   ```
3. 在 VS Code 中打开项目
4. Metals 会自动导入项目

### IntelliJ IDEA

```bash
# 生成 IDEA 项目
make idea

# 或在 IntelliJ 中直接导入为 Mill 项目
```

### Vim/Neovim + Metals

1. 安装 [nvim-metals](https://github.com/scalameta/nvim-metals)
2. 生成 BSP 配置：
   ```bash
   make bsp
   ```
3. 打开任意 Scala 文件，Metals 会自动启动

## 📚 相关资源

- [Scala 文档](https://docs.scala-lang.org/)
- [Scala 3 教程](https://docs.scala-lang.org/scala3/book/introduction.html)
- [Mill 文档](https://mill-build.org/)
- [Coursier 文档](https://get-coursier.io/)
- [Metals 文档](https://scalameta.org/metals/)

## 🔍 Scala 版本

此模板默认使用 Scala 3，但你可以轻松切换：

### Scala 3（推荐用于新项目）
```scala
def scalaVersion = "3.3.4"
```

### Scala 2.13（为了兼容性）
```scala
def scalaVersion = "2.13.12"
```

### Scala 2.12（用于遗留项目）
```scala
def scalaVersion = "2.12.18"
```

## 💡 使用技巧

### 使用 Scala REPL

```bash
# 启动 Scala REPL
scala

# 或使用 Ammonite（功能更强大）
cs install ammonite
amm
```

### 使用 scala-cli 快速编写脚本

```bash
# 安装 scala-cli
cs install scala-cli

# 运行脚本
scala-cli run script.scala

# 打包为 JAR
scala-cli package myapp.scala -o myapp.jar
```

### 使用 Coursier 管理依赖

```bash
# 搜索包
cs search cats-core

# 显示依赖树
cs resolve org.typelevel::cats-core:2.10.0

# 获取特定版本
cs fetch org.typelevel::cats-core:2.10.0
```

## ⚙️ 技术细节

### 为什么使用 Coursier？

Coursier 是安装 Scala 应用程序和管理依赖的标准方式。它的优势：
- 快速可靠
- 正确处理依赖解析
- 提供一致的方式安装 Scala 工具
- 与所有构建工具良好集成

### Mill vs SBT

本模板使用 Mill 的原因：
- 更简单的语法（纯 Scala，无 DSL）
- 更快的构建速度
- 更好的缓存机制
- 更容易理解和调试

如果需要，你也可以轻松添加 SBT：`cs install sbt`

### Nix + Coursier

flake 提供：
- 通过 Nix 提供 JDK（可复现）
- 使用 Coursier 安装 Scala（标准方式）
- 通过 Nix 提供 Mill（版本锁定）
- Metals 用于 IDE 支持

这为你提供了两全其美的方案：Nix 的可复现性 + Scala 的标准工具链。

## 🤝 贡献

这是一个模板项目。欢迎：
- 复制并修改用于你的项目
- 报告问题或提出改进建议
- 分享你的 Scala 项目！

## 📄 许可证

MIT License - 可自由用于任何目的。
