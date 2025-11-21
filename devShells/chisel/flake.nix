{
  description = "Chisel development environment with Mill build tool";

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
            # Java Development Kit
            jdk17
            
            # Scala build tool
            mill
            
            # Scala language server (for IDE support)
            metals
            
            # Verilator for simulation (with required dependencies)
            verilator
            python3
            
            # C++ compiler and standard library
            gcc
            stdenv.cc.cc.lib
            
            # Utilities
            gnumake
            git
          ];

          shellHook = ''
            echo "🔧 Chisel Development Environment"
            echo "=================================="
            echo "Java:      $(java -version 2>&1 | head -n 1)"
            echo "Mill:      $(mill --version 2>&1 || echo 'Mill available')"
            echo "Verilator: $(verilator --version | head -n 1)"
            echo ""
            echo "📝 Quick Start:"
            echo "  make test       - Run all tests"
            echo "  make verilog    - Generate Verilog"
            echo "  make bsp        - Setup BSP for IDE"
            echo "  make idea       - Generate IntelliJ IDEA project"
            echo ""
            echo "📚 Project uses:"
            echo "  - Chisel 7.0.0"
            echo "  - Scala 2.13.16"
            echo "  - Mill $(cat .mill-version 2>/dev/null || echo 'build tool')"
            echo ""
          '';

          # Set JAVA_HOME for consistency
          JAVA_HOME = "${pkgs.jdk17}";
          
          # Mill configuration
          MILL_VERSION = "0.12.7";
        };
      }
    );
}
