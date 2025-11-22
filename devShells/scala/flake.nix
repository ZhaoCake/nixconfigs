{
  description = "Pure Scala development environment with Coursier and Mill";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Java Development Kit (required for Scala)
            jdk17
            
            # Coursier - Scala artifact fetcher
            coursier
            
            # Mill build tool
            mill
            
            # Scala language server (for IDE support)
            metals
            
            # Utilities
            gnumake
            git
          ];

          shellHook = ''
            # Setup Coursier directory (Mill uses Coursier internally)
            export COURSIER_CACHE="$HOME/.cache/coursier"
            export COURSIER_DIR="$HOME/.local/share/coursier"
            
            # Ensure cs applications are in PATH (for optional tools)
            export PATH="$COURSIER_DIR/bin:$PATH"
            
            # Set JAVA_HOME
            export JAVA_HOME="${pkgs.jdk17}"
            
            # Display welcome message
            echo "🎯 Scala Development Environment"
            echo "=================================="
            echo "Java:      $(java -version 2>&1 | head -n 1)"
            echo "Mill:      $(mill --version 2>&1 || echo 'Mill available')"
            echo "Coursier:  $(cs version 2>&1 || echo 'available')"
            echo ""
            echo "📝 快速开始:"
            echo "  make compile     - 编译项目"
            echo "  make test        - 运行测试"
            echo "  make run         - 运行主类"
            echo "  make bsp         - 设置 IDE 集成"
            echo ""
            echo "💡 提示:"
            echo "  Mill 会自动管理 Scala 编译器和依赖"
            echo "  如需 REPL: cs install scala"
            echo "  如需 scala-cli: cs install scala-cli"
            echo ""
          '';
        };
      }
    );
}
