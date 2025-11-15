{
  description = "Python development environment";

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
          # Python 解释器
          python312
          python312Packages.pip
          
          # uv - 现代 Python 包管理器
          uv
          
          # Python 开发工具
          python312Packages.ipython
          python312Packages.black
          python312Packages.ruff
          python312Packages.pytest
          python312Packages.mypy
        ];
        
        shellHook = ''
          export UV_CACHE_DIR="$HOME/.cache/uv"
          
          echo "🐍 Python development environment"
          echo "Python: $(python --version)"
          echo ""
          echo "Commands:"
          echo "  uv init           - Initialize new project"
          echo "  uv venv           - Create virtual environment"
          echo "  uv pip install    - Install packages"
          echo "  uv run python     - Run with uv"
          echo ""
          echo "  python -m pytest  - Run tests"
          echo "  black .           - Format code"
          echo "  ruff check .      - Lint code"
        '';
      };
    };
}
