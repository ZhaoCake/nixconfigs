# C/C++ 开发环境配置
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # 编译器和工具链
    clang
    clang-tools  # 包含 clangd
    # gcc  # 与 clang 冲突，如需要请使用项目级 flake
    gdb
    lldb
    
    # 构建工具
    cmake
    gnumake
    ninja
    pkg-config
    
    # 常用库
    # openssl
    # zlib
    # curl
  ];
  
  # C/C++ 特定环境变量
  home.sessionVariables = {
    # 让 clangd 能找到标准库
    CPATH = "${pkgs.clang}/resource-root/include";
  };
  
  home.file."Templates/cpp-project/flake.nix".text = ''
    {
      description = "C++ development environment";
      
      inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
      };
      
      outputs = { self, nixpkgs }:
        let
          # 原生编译系统
          system = "x86_64-linux";
          pkgs = nixpkgs.legacyPackages.${"$"}{system};
          
          # === 交叉编译配置示例 ===
          # 如需交叉编译，取消注释并修改以下部分：
          
          # # ARM64 交叉编译
          # crossPkgs = import nixpkgs {
          #   inherit system;
          #   crossSystem = {
          #     config = "aarch64-unknown-linux-gnu";
          #   };
          # };
          
          # # Windows 交叉编译 (mingw)
          # crossPkgs = import nixpkgs {
          #   inherit system;
          #   crossSystem = {
          #     config = "x86_64-w64-mingw32";
          #   };
          # };
          
          # # RISC-V 交叉编译
          # crossPkgs = import nixpkgs {
          #   inherit system;
          #   crossSystem = {
          #     config = "riscv64-unknown-linux-gnu";
          #   };
          # };
          
        in
        {
          # 开发环境
          devShells.${"$"}{system}.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              # 工具链
              clang
              clang-tools  # clangd, clang-format, clang-tidy
              cmake
              ninja
              gdb
              
              # 交叉编译时使用对应的工具链：
              # crossPkgs.stdenv.cc
              # crossPkgs.cmake
              
              # === 常用库（按需取消注释） ===
              # boost
              # fmt
              # spdlog
              # catch2
              # nlohmann_json
              # openssl
              # curl
              # sqlite
            ];
            
            shellHook = '''
              # 设置编译器
              export CC=clang
              export CXX=clang++
              
              # 交叉编译时修改为：
              # export CC=''${crossPkgs.stdenv.cc}/bin/''${crossPkgs.stdenv.cc.targetPrefix}cc
              # export CXX=''${crossPkgs.stdenv.cc}/bin/''${crossPkgs.stdenv.cc.targetPrefix}c++
              
              echo "🔧 C++ development environment ready"
              echo "Compiler: $(clang++ --version | head -1)"
            ''';
          };
          
          # 构建配置（可选）
          packages.${"$"}{system}.default = pkgs.stdenv.mkDerivation {
            pname = "my-cpp-project";
            version = "0.1.0";
            src = ./.;
            
            nativeBuildInputs = [ pkgs.cmake pkgs.ninja ];
            buildInputs = with pkgs; [
              # 项目依赖
            ];
            
            # 交叉编译时使用：
            # nativeBuildInputs = [ pkgs.cmake ];
            # buildInputs = with crossPkgs; [
            #   # 项目依赖
            # ];
          };
        };
    }
  '';
  
  # CMakeLists.txt 模板
  home.file."Templates/cpp-project/CMakeLists.txt".text = ''
    cmake_minimum_required(VERSION 3.20)
    project(MyProject VERSION 0.1.0 LANGUAGES CXX)
    
    # C++ 标准
    set(CMAKE_CXX_STANDARD 20)
    set(CMAKE_CXX_STANDARD_REQUIRED ON)
    set(CMAKE_CXX_EXTENSIONS OFF)
    
    # 导出 compile_commands.json (for clangd)
    set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
    
    # 编译选项
    add_compile_options(-Wall -Wextra -Wpedantic)
    
    # 可执行文件
    add_executable(main src/main.cpp)
    
    # 链接库示例
    # find_package(Boost REQUIRED)
    # target_link_libraries(main PRIVATE Boost::boost)
  '';
  
  # 示例源文件
  home.file."Templates/cpp-project/src/main.cpp".text = ''
    #include <iostream>
    #include <vector>
    #include <string>
    
    int main() {
        std::vector<std::string> messages = {
            "Hello from Nix C++ project!",
            "Configured with Flake",
            "Using Clang + clangd"
        };
        
        for (const auto& msg : messages) {
            std::cout << msg << std::endl;
        }
        
        return 0;
    }
  '';
  
  # .envrc 模板（direnv）
  home.file."Templates/cpp-project/.envrc".text = ''
    # 自动加载 Nix 开发环境
    use flake
  '';
  
  # .gitignore 模板
  home.file."Templates/cpp-project/.gitignore".text = ''
    # 构建输出
    build/
    *.o
    *.a
    *.so
    *.exe
    
    # CMake
    CMakeCache.txt
    CMakeFiles/
    cmake_install.cmake
    
    # clangd
    .cache/
    compile_commands.json
    
    # direnv
    .direnv/
    
    # 编辑器
    .vscode/
    .idea/
    *.swp
    *~
  '';
  
  # 项目 README 模板
  home.file."Templates/cpp-project/README.md".text = ''
    # C++ Project
    
    ## Quick Start
    
    ```bash
    # Enter development environment
    nix develop
    # or use direnv: direnv allow
    
    # Build
    cmake -B build
    cmake --build build
    
    # Run
    ./build/main
    ```
    
    ## Project Structure
    
    ```
    .
    ├── flake.nix          # Nix development environment
    ├── CMakeLists.txt     # CMake configuration
    ├── src/
    │   └── main.cpp       # Source files
    └── README.md
    ```
    
    ## Adding Dependencies
    
    Edit `flake.nix` and add packages to `buildInputs`:
    
    ```nix
    buildInputs = with pkgs; [
      boost
      fmt
      spdlog
    ];
    ```
  '';
  
  # 全局 clangd 配置（适用于简单项目）
  home.file.".config/clangd/config.yaml".text = ''
    CompileFlags:
      Add:
        # 添加标准库路径
        - "-I${pkgs.clang}/resource-root/include"
        - "-I${pkgs.stdenv.cc.libc}/include"
        # C++ 标准
        - "-std=c++20"
      Remove:
        # 移除可能导致问题的标志
        - "-W*"
    
    Diagnostics:
      UnusedIncludes: Strict
      MissingIncludes: Strict
    
    Index:
      Background: Build
  '';
}
