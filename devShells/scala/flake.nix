{
  description = "Pure Scala Development Environment Template";

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
            mill
            coursier
            metals
            gnumake
          ];

          shellHook = ''
            echo "🚀 Pure Scala Development Environment"
            echo ""
            echo "📦 Available tools:"
            echo "  - Mill: $(mill --version 2>/dev/null || echo 'installed')"
            echo "  - Java: $(java -version 2>&1 | head -n1)"
            echo "  - GNU Make: $(make --version | head -n1)"
            echo ""
            echo "💡 Quick Start:"
            echo "  make run       # Run the application"
            echo "  make test      # Run tests"
            echo "  make help      # Show all available commands"
            echo ""
          '';
        };
      }
    );
}
