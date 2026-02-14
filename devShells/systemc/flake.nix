{
  description = "A SystemC project environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            cmake
            ninja
            pkg-config
          ];
          
          buildInputs = with pkgs; [
            systemc
            clang
            clang-tools # For LSP and linting
          ];

          shellHook = ''
            export CC=clang
            export CXX=clang++
            echo "SystemC development environment loaded!"
            echo "SystemC located at: ${pkgs.systemc}"
          '';
        };
      }
    );
}
