# Bluespec SystemVerilog 开发环境
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Bluespec 编译器
    bluespec
    
    # Verilog 仿真工具
    iverilog          # Icarus Verilog (iverilog)
    verilator        # 高级仿真器
    
    # 波形查看器
    gtkwave
    
    # 构建工具
    gnumake
    cmake
    bear             # 生成 compile_commands.json
    
    # C++ 开发工具（Verilator 需要）
    # gcc 已在 cpp.nix 中配置
    gdb
    valgrind         # 内存调试
    
    # 基础工具
    which
    file
  ];

  # 创建 BSV 项目的函数模板
  home.file.".local/share/bsv-templates/flake.nix".text = ''
    {
      description = "Bluespec SystemVerilog project";

      inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

      outputs = { self, nixpkgs }:
        let
          system = "x86_64-linux";
          pkgs = nixpkgs.legacyPackages.''${system};
        in
        {
          devShells.''${system}.default = pkgs.mkShell {
            packages = with pkgs; [
              bluespec
              verilator
              gtkwave
              gnumake
              clang
            ];

            shellHook = '''
              export BLUESPECDIR="''${pkgs.bluespec}/lib"
              echo "🚀 BSV → Verilog + Verilator"
              echo "   bsc -verilog    # Compile BSV to Verilog"
              echo "   make verilator  # Build Verilator sim"
              echo "   make clean"
            ''';
          };
        };
    }
  '';

  home.file.".local/share/bsv-templates/Makefile".text = ''
    TOP_MODULE = Top
    BSV_SRC = bsv_src
    BUILD = build
    VDIR = ''$(BUILD)/verilog
    VSRC = verilator_src

    .PHONY: all verilog verilator clean

    all: verilator

    verilog:
    	@mkdir -p ''$(VDIR)
    	bsc -verilog -vdir ''$(VDIR) -bdir ''$(BUILD) -info-dir ''$(BUILD) \
    	    -p +:''$(BSV_SRC) -g mk''$(TOP_MODULE) ''$(BSV_SRC)/''$(TOP_MODULE).bsv
    	@echo "✅ Verilog: ''$(VDIR)/mk''$(TOP_MODULE).v"

    verilator: verilog
    	verilator -Wall -Wno-UNUSED --trace --cc --exe --build \
    	    ''$(VDIR)/mk''$(TOP_MODULE).v ''$(VSRC)/sim_main.cpp \
    	    -o ''$(BUILD)/sim
    	@echo "✅ Run: ./''$(BUILD)/sim"

    clean:
    	rm -rf ''$(BUILD) *.bo *.ba *.vcd
  '';

  home.file.".local/share/bsv-templates/Top.bsv".text = ''
    package Top;

    (* synthesize *)
    module mkTop (Empty);
      Reg#(UInt#(8)) count <- mkReg(0);
      
      rule tick;
        count <= count + 1;
        $display("tick: %d", count);
        if (count == 10) $finish(0);
      endrule
    endmodule

    endpackage
  '';

  home.file.".local/share/bsv-templates/sim_main.cpp".text = ''
    #include "VmkTop.h"
    #include "verilated.h"
    #include "verilated_vcd_c.h"

    int main(int argc, char** argv) {
        Verilated::commandArgs(argc, argv);
        Verilated::traceEverOn(true);
        
        VmkTop* top = new VmkTop;
        VerilatedVcdC* vcd = new VerilatedVcdC;
        top->trace(vcd, 99);
        vcd->open("wave.vcd");
        
        for (int t = 0; t < 200 && !Verilated::gotFinish(); t++) {
            top->CLK = t & 1;
            top->RST_N = t > 5;
            top->eval();
            vcd->dump(t);
        }
        
        vcd->close();
        delete top;
        return 0;
    }
  '';

  home.file.".local/share/bsv-templates/README.md".text = ''
    # BSV Project

    ```bash
    nix develop       # Enter dev shell
    make verilog      # BSV → Verilog
    make verilator    # Build Verilator sim
    ./build/sim       # Run simulation
    gtkwave wave.vcd  # View waveform
    make clean
    ```

    ## Structure
    - `bsv_src/Top.bsv` - BSV source
    - `verilator_src/sim_main.cpp` - C++ testbench
    - `build/verilog/` - Generated Verilog
  '';
}
