{
  description = "SystemVerilog development environment with Verilator";

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
          # Verilator - 高性能开源仿真器
          verilator
          
          # 波形查看器
          gtkwave
          
          # SystemVerilog 语法检查和格式化
          verible       # Google 的 SystemVerilog 工具套件
          
          # 构建工具
          gnumake
          gcc
        ];
        
        shellHook = ''
          echo "⚡ SystemVerilog development environment"
          echo "Tools: verilator, gtkwave, verible"
          echo "Run: make help"
        '';
      };
    };
}
