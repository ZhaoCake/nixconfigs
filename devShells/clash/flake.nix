{
  description = "Clash Hello World Project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        hspkgs = pkgs.haskellPackages;
        
        # Create a GHC environment with Clash dependencies pre-installed
        ghcEnv = hspkgs.ghcWithPackages (p: with p; [
          clash-prelude
          clash-ghc
          ghc-typelits-natnormalise
          ghc-typelits-extra
          ghc-typelits-knownnat
        ]);
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            ghcEnv
            hspkgs.clash-ghc
            hspkgs.cabal-install
            hspkgs.haskell-language-server
          ];
        };
      }
    );
}
