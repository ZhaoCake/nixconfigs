{
  description = "Chisel + Verilator Development Environment Template";

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
            verilator
            python3
            mill
            coursier
            metals
            gnumake
          ];

          shellHook = ''
            echo "🚀 Chisel + Verilator Development Environment"
            echo ""
            echo "📦 Available tools:"
            echo "  - Verilator: $(verilator --version | head -n1)"
            echo "  - Python: $(python3 --version)"
            echo "  - Mill: $(mill --version 2>/dev/null || echo 'installed')"
            echo "  - GNU Make: $(make --version | head -n1)"
            echo ""
            echo "💡 Quick Start:"
            echo "  make verilog   # Generate Verilog from Chisel"
            echo "  make sim       # Compile and run simulation"
            echo "  make help      # Show all available commands"
            echo ""
          '';
        };
      }
    );
}
