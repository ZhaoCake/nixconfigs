{
  description = "Haskell Hello World Template";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        hspkgs = pkgs.haskellPackages;
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            hspkgs.ghc
            hspkgs.cabal-install
            hspkgs.haskell-language-server
            hspkgs.hlint
            hspkgs.ormolu
          ];

          shellHook = ''
            echo "🟣 Haskell development environment"
            echo "GHC: $(ghc --version)"
            echo "Cabal: $(cabal --version | head -n1)"
            echo ""
            echo "Commands:"
            echo "  make build   - Build the project"
            echo "  make run     - Run Hello World"
            echo "  make repl    - Start GHCi"
            echo "  make fmt     - Format with Ormolu"
            echo "  make lint    - Run HLint"
            echo ""
          '';
        };
      }
    );
}
