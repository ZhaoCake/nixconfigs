# C/C++ 开发环境使用指南

## 🚀 快速开始 - 一键创建项目

```bash
# 创建新的 C++ 项目
new-cpp-project my-awesome-project
```

就这么简单！项目已自动配置好：
- ✅ Flake 开发环境（Clang + CMake + clangd）
- ✅ CMake 构建系统
- ✅ direnv 自动加载环境
- ✅ Git 仓库初始化
- ✅ clangd LSP 支持
- ✅ 示例代码

---

## 📝 开发流程

```bash
# 1. 创建项目
new-cpp-project my-project

# 2. 进入项目（环境自动加载）
cd my-project

# 3. 开始编码
nvim src/main.cpp

# 4. 构建项目
cmake -B build
cmake --build build

# 5. 运行
./build/main
```

---

## 📦 添加依赖库

编辑 `flake.nix`，在 `buildInputs` 中添加需要的库：

```nix
buildInputs = with pkgs; [
  clang
  clang-tools
  cmake
  
  # 添加你的依赖
  boost          # Boost 库
  fmt            # 格式化库
  spdlog         # 日志库
  catch2         # 测试框架
  nlohmann_json  # JSON 库
  openssl        # SSL/TLS
  sqlite         # 数据库
];
```

保存后，环境会自动重新加载（direnv），或手动运行 `nix develop`。

---

## 🔧 交叉编译配置

### ARM64 交叉编译

编辑 `flake.nix`，取消注释并修改：

```nix
# 在 let 块中添加
crossPkgs = import nixpkgs {
  inherit system;
  crossSystem = {
    config = "aarch64-unknown-linux-gnu";
  };
};
```

然后修改 `buildInputs` 和 `shellHook`：

```nix
buildInputs = with crossPkgs; [
  stdenv.cc  # 交叉编译工具链
  cmake
];

shellHook = ''
  export CC=${crossPkgs.stdenv.cc}/bin/${crossPkgs.stdenv.cc.targetPrefix}cc
  export CXX=${crossPkgs.stdenv.cc}/bin/${crossPkgs.stdenv.cc.targetPrefix}c++
  echo "Cross-compiling for ARM64"
'';
```

### 常见交叉编译目标

在 `crossSystem.config` 中使用：
- `aarch64-unknown-linux-gnu` - ARM64 Linux
- `armv7l-unknown-linux-gnueabihf` - ARM32 Linux (硬浮点)
- `x86_64-w64-mingw32` - Windows 64位
- `i686-w64-mingw32` - Windows 32位
- `riscv64-unknown-linux-gnu` - RISC-V 64位
- `mips64el-unknown-linux-gnu` - MIPS64

---

## ⌨️ Nixvim LSP 快捷键

- `gd` - 跳转到定义
- `gr` - 查看所有引用
- `K` - 显示文档
- `<leader>ca` - 代码操作
- `<leader>rn` - 重命名
- `<leader>f` - 格式化代码

---

## 📂 项目结构

```
my-project/
├── flake.nix           # Nix 开发环境和依赖
├── CMakeLists.txt      # CMake 构建配置
├── .envrc              # direnv 配置
├── src/
│   └── main.cpp        # 源代码
└── build/              # 构建输出
```
