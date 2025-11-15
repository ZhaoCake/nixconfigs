# C++ Project

## Quick Start

```bash
# 复制模板或使用 nix-init
nix-init cpp my-cpp-project
cd my-cpp-project

# 构建
cmake -B build
cmake --build build

# 运行
./build/main
```

## Tools

- **clang/clang++**: C/C++ 编译器
- **clangd**: LSP 服务器
- **cmake**: 构建系统
- **gdb/lldb**: 调试器

## Adding Dependencies

在 `flake.nix` 的 `buildInputs` 中添加需要的库：

```nix
buildInputs = with pkgs; [
  # ... 现有的包
  boost
  fmt
  spdlog
];
```

然后在 `CMakeLists.txt` 中使用：

```cmake
find_package(Boost REQUIRED)
target_link_libraries(main PRIVATE Boost::boost)
```
