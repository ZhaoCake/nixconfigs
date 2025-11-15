{
  description = "C++ development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          # 编译器和工具链
          clang
          clang-tools  # clangd, clang-format, clang-tidy
          gcc
          gdb
          lldb
          
          # 构建工具
          cmake
          gnumake
          ninja
          pkg-config
          
          # 常用库（按需取消注释）
          # boost
          # fmt
          # spdlog
          # catch2
          # nlohmann_json
          # openssl
          # curl
        ];
        
        shellHook = ''
          export CC=clang
          export CXX=clang++
          
          echo "🔧 C++ development environment"
          echo "Compiler: $(clang++ --version | head -1)"
          echo ""
          echo "Commands:"
          echo "  cmake -B build        - Configure project"
          echo "  cmake --build build   - Build project"
          echo "  ctest --test-dir build - Run tests"
        '';
      };
    };
}
