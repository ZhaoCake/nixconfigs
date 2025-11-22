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
            # Setup Coursier directory
            export COURSIER_CACHE="$HOME/.cache/coursier"
            export COURSIER_DIR="$HOME/.local/share/coursier"
            
            # Ensure cs applications are in PATH
            export PATH="$COURSIER_DIR/bin:$PATH"
            
            # Set JAVA_HOME
            export JAVA_HOME="${pkgs.jdk17}"
            
            # Display welcome message
            echo "🎯 Scala Development Environment"
            echo "=================================="
            echo "Java:      $(java -version 2>&1 | head -n 1)"
            echo "Coursier:  $(cs version 2>&1 || echo 'installed')"
            echo "Mill:      $(mill --version 2>&1 || echo 'Mill available')"
            echo ""
            
            # Check if Scala is installed via cs
            if ! command -v scala &> /dev/null; then
              echo "📦 Installing Scala via Coursier..."
              echo ""
              cs install scala
              cs install scalac
              echo ""
            fi
            
            # Show installed Scala version if available
            if command -v scala &> /dev/null; then
              echo "Scala:     $(scala -version 2>&1 | grep -oP 'version \K[0-9.]+' || echo 'installed')"
            fi
            
            echo ""
            echo "📝 Quick Start:"
            echo "  cs install scala       - Install Scala (if not already)"
            echo "  cs install scalac      - Install Scala compiler"
            echo "  cs install scala-cli   - Install Scala CLI"
            echo "  mill _.compile         - Compile all modules"
            echo "  mill _.test            - Run all tests"
            echo "  mill _.run             - Run main class"
            echo ""
            echo "📚 Coursier commands:"
            echo "  cs install <app>       - Install Scala applications"
            echo "  cs launch <app>        - Launch Scala applications"
            echo "  cs fetch <dep>         - Fetch dependencies"
            echo "  cs setup               - Setup Scala environment"
            echo ""
          '';
        };
      }
    );
}
