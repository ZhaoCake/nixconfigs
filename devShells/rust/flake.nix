{
  description = "Rust development environment";

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
          # Rust 工具链
          rustc
          cargo
          rustfmt
          clippy
          rust-analyzer
          
          # 构建依赖
          pkg-config
          openssl
        ];
        
        shellHook = ''
          export RUST_BACKTRACE=1
          export CARGO_HOME="$HOME/.cargo"
          
          echo "🦀 Rust development environment"
          echo "Tools: rustc $(rustc --version | cut -d' ' -f2), cargo, clippy, rust-analyzer"
          echo ""
          echo "Commands:"
          echo "  cargo new <name>   - Create new project"
          echo "  cargo build        - Build project"
          echo "  cargo run          - Run project"
          echo "  cargo test         - Run tests"
        '';
      };
    };
}
