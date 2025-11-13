{
  description = "Chisel 7.0+ development environment";

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
          # Scala 工具链
          mill         # Mill Build Tool
          sbt          # Scala Build Tool (备用)
          scala_2_13   # Scala 2.13
          metals       # Scala LSP server
          
          # Java (Chisel 需要)
          jdk17        # Java 17 LTS
          
          # Verilog 工具
          verilator
          gtkwave
          gcc
          gnumake
        ];
        
        shellHook = ''
          echo "🔥 Chisel 7.0+ development environment"
          echo "Tools: mill, scala, verilator, gtkwave"
          echo "Run: make help"
        '';
      };
    };
}
