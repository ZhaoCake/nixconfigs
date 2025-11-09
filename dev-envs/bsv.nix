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

      inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
      };

      outputs = { self, nixpkgs }:
        let
          system = "x86_64-linux";
          pkgs = nixpkgs.legacyPackages.''${system};
        in
        {
          devShells.''${system}.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              bluespec
              verilog
              verilator
              gtkwave
              gnumake
              gcc
              gdb
              cmake
              bear
              valgrind
            ];

            shellHook = '''
              echo "🚀 Bluespec SystemVerilog Development Environment"
              echo "📦 Available tools:"
              echo "   • bsc (Bluespec compiler): ''$(which bsc)"
              echo "   • iverilog (Verilog simulator): ''$(which iverilog)"
              echo "   • verilator (Advanced simulator): ''$(which verilator)"
              echo "   • gtkwave (Waveform viewer): ''$(which gtkwave)"
              echo ""
              echo "📁 Project structure:"
              echo "   • bsv_src/ - BSV source files"
              echo "   • verilator_src/ - Verilator C++ simulation files"
              echo "   • Use 'make help' to see available targets"
              echo ""
              
              # Set BSV library path
              export BLUESPECDIR="''${pkgs.bluespec}/lib"
              
              # Verilator flags for better performance
              export VERILATOR_FLAGS="-Wall -Wno-UNUSED -Wno-UNOPTFLAT --trace"
            ''';
          };
        };
    }
  '';

  home.file.".local/share/bsv-templates/Makefile".text = ''
    # Bluespec SystemVerilog Makefile

    # Project settings
    TOP_MODULE ?= Top
    BSV_SRC_DIR = bsv_src
    BUILD_DIR = build
    VERILOG_DIR = ''$(BUILD_DIR)/verilog
    VERILATOR_DIR = verilator_src

    # Bluespec compiler settings
    BSC = bsc
    BSC_FLAGS = -sim -show-schedule -aggressive-conditions
    BSC_VERILOG_FLAGS = -verilog -show-schedule -aggressive-conditions

    # Verilator settings
    VERILATOR = verilator
    VERILATOR_FLAGS = -Wall -Wno-UNUSED -Wno-UNOPTFLAT --trace --cc --exe

    # Source files
    BSV_FILES = ''$(wildcard ''$(BSV_SRC_DIR)/*.bsv)

    .PHONY: all clean sim verilog verilator help

    all: sim

    help:
    	@echo "Available targets:"
    	@echo "  make sim        - Compile and run Bluesim simulation"
    	@echo "  make verilog    - Generate Verilog"
    	@echo "  make verilator  - Build Verilator simulation"
    	@echo "  make clean      - Clean build artifacts"
    	@echo "  make help       - Show this help message"

    # Bluesim simulation
    sim: ''$(BSV_FILES)
    	@mkdir -p ''$(BUILD_DIR)
    	@echo "🔨 Compiling BSV files for Bluesim..."
    	''$(BSC) ''$(BSC_FLAGS) -bdir ''$(BUILD_DIR) -simdir ''$(BUILD_DIR) \
    		-info-dir ''$(BUILD_DIR) -p +:''$(BSV_SRC_DIR) \
    		-g mk''$(TOP_MODULE) ''$(BSV_SRC_DIR)/''$(TOP_MODULE).bsv
    	@echo "🔗 Linking Bluesim executable..."
    	''$(BSC) -sim -e mk''$(TOP_MODULE) -o ''$(BUILD_DIR)/sim \
    		-bdir ''$(BUILD_DIR) -simdir ''$(BUILD_DIR)
    	@echo "✅ Build complete! Run: ./''$(BUILD_DIR)/sim"

    # Verilog generation
    verilog: ''$(BSV_FILES)
    	@mkdir -p ''$(VERILOG_DIR)
    	@echo "🔨 Generating Verilog..."
    	''$(BSC) ''$(BSC_VERILOG_FLAGS) -vdir ''$(VERILOG_DIR) \
    		-bdir ''$(BUILD_DIR) -info-dir ''$(BUILD_DIR) \
    		-p +:''$(BSV_SRC_DIR) -g mk''$(TOP_MODULE) \
    		''$(BSV_SRC_DIR)/''$(TOP_MODULE).bsv
    	@echo "✅ Verilog generated in ''$(VERILOG_DIR)/"

    # Verilator simulation
    verilator: verilog
    	@echo "🔨 Building Verilator simulation..."
    	''$(VERILATOR) ''$(VERILATOR_FLAGS) ''$(VERILOG_DIR)/mk''$(TOP_MODULE).v \
    		''$(VERILATOR_DIR)/sim_main.cpp -o ''$(BUILD_DIR)/verilator_sim
    	@echo "✅ Verilator build complete! Run: ./''$(BUILD_DIR)/verilator_sim"

    clean:
    	@echo "🧹 Cleaning build artifacts..."
    	rm -rf ''$(BUILD_DIR)
    	rm -f *.bo *.ba
    	@echo "✅ Clean complete"
  '';

  home.file.".local/share/bsv-templates/Top.bsv".text = ''
    package Top;

    // Simple counter example module
    (* synthesize *)
    module mkTop (Empty);
      Reg#(UInt#(32)) counter <- mkReg(0);
      
      rule increment;
        counter <= counter + 1;
        $display("Counter: %d", counter);
        
        if (counter >= 10) begin
          $display("Done!");
          $finish(0);
        end
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
        VerilatedVcdC* tfp = new VerilatedVcdC;
        
        top->trace(tfp, 99);
        tfp->open("wave.vcd");
        
        vluint64_t sim_time = 0;
        const vluint64_t max_sim_time = 1000;
        
        while (sim_time < max_sim_time && !Verilated::gotFinish()) {
            top->CLK = (sim_time % 2) == 0;
            top->RST_N = sim_time > 10;
            
            top->eval();
            tfp->dump(sim_time);
            sim_time++;
        }
        
        tfp->close();
        delete top;
        delete tfp;
        
        return 0;
    }
  '';

  home.file.".local/share/bsv-templates/README.md".text = ''
    # Bluespec SystemVerilog Project

    ## 项目结构

    ```
    .
    ├── bsv_src/           # BSV 源代码
    │   └── Top.bsv        # 顶层模块
    ├── verilator_src/     # Verilator 仿真代码
    │   └── sim_main.cpp   # Verilator testbench
    ├── build/             # 构建输出目录
    ├── flake.nix          # Nix 开发环境配置
    └── Makefile           # 构建配置
    ```

    ## 快速开始

    ### 1. 进入开发环境

    ```bash
    nix develop
    ```

    ### 2. 构建和运行

    #### Bluesim 仿真（推荐用于快速测试）

    ```bash
    make sim              # 编译
    ./build/sim           # 运行仿真
    ```

    #### 生成 Verilog

    ```bash
    make verilog
    # Verilog 文件在 build/verilog/ 目录
    ```

    #### Verilator 仿真（生成波形）

    ```bash
    make verilator        # 编译
    ./build/verilator_sim # 运行仿真
    gtkwave wave.vcd      # 查看波形
    ```

    ### 3. 清理构建文件

    ```bash
    make clean
    ```

    ## BSV 编译器常用选项

    - `-sim` - 生成 Bluesim 仿真
    - `-verilog` - 生成 Verilog
    - `-show-schedule` - 显示调度信息
    - `-aggressive-conditions` - 启用激进优化
    - `-p +:dir` - 添加搜索路径

    ## 环境变量

    - `BLUESPECDIR` - BSV 库路径（已自动设置）
    - `VERILATOR_FLAGS` - Verilator 编译选项
    - `TOP_MODULE` - 顶层模块名（默认: Top）

    ## 学习资源

    - [BSV 官方文档](http://wiki.bluespec.com/)
    - [BSV 参考指南](https://github.com/B-Lang-org/bsc)
    - [Verilator 文档](https://verilator.org/guide/latest/)
  '';
}
