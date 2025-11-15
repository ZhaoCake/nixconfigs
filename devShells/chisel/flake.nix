{
  description = "Chisel 7.0+ development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        chiselPackage = "your_package_name";
        topModule = "YourMain";
        buildDir = "build";
        csrcDir = "verilator_csrc";

        # 生成Verilog
        verilogCmd = ''
          mkdir -p ${buildDir}
          rm -rf ${buildDir}/*
          mill -i ${chiselPackage}.runMain ${chiselPackage}.Elaborate --target-dir ${buildDir}
        '';

        # Scala测试
        testCmd = "mill -i __.test";

        # Verilator仿真
        vsimCmd = ''
          verilator --top-module ${topModule} --trace --exe --cc -j 0 --build \
            $(find ${buildDir} -name "*.v" -o -name "*.sv") \
            ${csrcDir}/sim_main.cc \
            --CFLAGS "-g -I$(pwd)/${csrcDir} -O2"
          ./obj_dir/V${topModule}
        '';

        # Verilator仿真（带VCD跟踪）
        vsimTraceCmd = ''
          verilator --top-module ${topModule} --trace --exe --cc -j 0 --build -DMTRACE=1 \
            $(find ${buildDir} -name "*.v" -o -name "*.sv") \
            ${csrcDir}/sim_main.cc \
            --CFLAGS "-g -I$(pwd)/${csrcDir} -O2 -DMTRACE=1"
          ./obj_dir/V${topModule}
        '';

        # 清理
        cleanCmd = ''
          rm -rf ${buildDir} obj_dir waveform.vcd *.log out
        '';

        # 波形查看
        waveCmd = ''
          if [ -f waveform.vcd ]; then
            gtkwave waveform.vcd
          else
            echo "❌ No waveform.vcd found. Run 'nix run .#vsim-trace' first."
          fi
        '';

        # BSP/IDE
        bspCmd = "mill mill.bsp.BSP/install";
        ideaCmd = "mill mill.idea.GenIdea/idea";

        # 帮助
        helpCmd = ''
          echo "🔥 Chisel项目可用命令:"
          echo ""
          echo "  nix run .#verilog     - 生成Verilog代码"
          echo "  nix run .#test        - 运行Scala测试"
          echo "  nix run .#vsim        - 编译并运行Verilator仿真"
          echo "  nix run .#vsim-trace  - 运行带VCD跟踪的仿真"
          echo "  nix run .#wave        - 使用GTKWave查看波形"
          echo "  nix run .#clean       - 清理所有生成文件"
          echo "  nix run .#bsp         - 生成BSP配置"
          echo "  nix run .#idea        - 生成IntelliJ IDEA项目"
          echo "  nix run .#help        - 显示此帮助信息"
          echo ""
          echo "或使用 Makefile:"
          echo "  make verilog / make test / make vsim / make clean"
        '';

      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Scala 工具链
            mill
            sbt
            scala_2_13
            
            # Java (Chisel 需要)
            jdk17
            
            # Verilog 工具
            verilator
            python3        # Verilator 需要
            gtkwave
            
            # 构建工具
            gcc
            gnumake
            cmake
            pkg-config
            
            # 系统库
            zlib
            ncurses
            stdenv.cc.cc.lib
          ];
          
          shellHook = ''
            export JAVA_HOME="${pkgs.jdk17}"
            export PATH="$JAVA_HOME/bin:$PATH"
            
            echo "🔥 Chisel 7.0+ development environment"
            echo "Tools: mill $(mill --version 2>&1 | head -1), scala, verilator, gtkwave"
            echo ""
            echo "Run: make help  或  nix run .#help"
          '';
        };

        apps = {
          verilog = flake-utils.lib.mkApp { drv = pkgs.writeShellScriptBin "verilog" verilogCmd; };
          test = flake-utils.lib.mkApp { drv = pkgs.writeShellScriptBin "test" testCmd; };
          vsim = flake-utils.lib.mkApp { drv = pkgs.writeShellScriptBin "vsim" vsimCmd; };
          vsim-trace = flake-utils.lib.mkApp { drv = pkgs.writeShellScriptBin "vsim-trace" vsimTraceCmd; };
          wave = flake-utils.lib.mkApp { drv = pkgs.writeShellScriptBin "wave" waveCmd; };
          clean = flake-utils.lib.mkApp { drv = pkgs.writeShellScriptBin "clean" cleanCmd; };
          bsp = flake-utils.lib.mkApp { drv = pkgs.writeShellScriptBin "bsp" bspCmd; };
          idea = flake-utils.lib.mkApp { drv = pkgs.writeShellScriptBin "idea" ideaCmd; };
          help = flake-utils.lib.mkApp { drv = pkgs.writeShellScriptBin "help" helpCmd; };
        };
      });
}
