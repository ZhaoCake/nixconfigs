{
  description = "Bluespec SystemVerilog development environment";

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
          # Bluespec 编译器
          bluespec
          
          # Verilog 仿真工具
          iverilog      # Icarus Verilog
          verilator     # 高级仿真器
          
          # 波形查看器
          gtkwave
          
          # 构建工具
          gnumake
          gcc
          gdb
        ];
        
        shellHook = ''
          export BLUESPECDIR="${pkgs.bluespec}/lib"
          echo "🚀 Bluespec SystemVerilog environment"
          echo "Tools: bsc, verilator, iverilog, gtkwave"
          echo "Run: make help"
        '';
      };
    };
}
