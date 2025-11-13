{ config, pkgs, ... }:

{
  # SystemVerilog 开发环境
  home.packages = with pkgs; [
    # Verilator - 高性能开源仿真器
    verilator
    
    # 波形查看器
    gtkwave
    
    # SystemVerilog 语法检查和格式化
    verible       # Google 的 SystemVerilog 工具套件（linter、formatter、parser）
    
    # 构建工具
    gnumake
    
    # C++ 编译器（Verilator 需要）
    gcc
    
    # 可选：其他有用的工具
    # iverilog    # Icarus Verilog（另一个开源仿真器）
    # yosys       # 综合工具
    # symbiyosys  # 形式验证
  ];

  # SystemVerilog 项目模板
  home.file.".local/share/systemverilog-templates/Makefile".text = ''
    # SystemVerilog Verilator Makefile
    .PHONY: all sim trace clean help

    # 项目配置
    TOP_MODULE = top
    SRC_DIR = rtl
    TB_DIR = tb
    BUILD_DIR = build
    OBJ_DIR = obj_dir

    # 查找所有 SystemVerilog 源文件
    VSRCS = $(wildcard $(SRC_DIR)/*.sv $(SRC_DIR)/*.v)
    VHDRS = $(wildcard $(SRC_DIR)/*.svh $(SRC_DIR)/*.vh)
    TB_SRCS = $(wildcard $(TB_DIR)/*.cpp $(TB_DIR)/*.cc)

    # Verilator 参数
    VERILATOR_FLAGS = --cc --exe --build -j 0
    VERILATOR_FLAGS += --top-module $(TOP_MODULE)
    VERILATOR_FLAGS += -Wall -Wno-fatal
    VERILATOR_FLAGS += --trace

    # C++ 编译参数
    CFLAGS = -std=c++14 -O2 -I$(TB_DIR)

    all: sim

    sim: $(VSRCS) $(TB_SRCS)
    	@echo "🔨 Building simulation..."
    	@mkdir -p $(BUILD_DIR)
    	@verilator $(VERILATOR_FLAGS) $(VSRCS) $(TB_SRCS) \
    		--Mdir $(OBJ_DIR) \
    		--CFLAGS "$(CFLAGS)" \
    		-o ../$(BUILD_DIR)/sim
    	@echo "✅ Build complete: $(BUILD_DIR)/sim"
    	@$(BUILD_DIR)/sim

    trace: $(VSRCS) $(TB_SRCS)
    	@echo "🔨 Building simulation with trace..."
    	@mkdir -p $(BUILD_DIR)
    	@verilator $(VERILATOR_FLAGS) --trace-fst $(VSRCS) $(TB_SRCS) \
    		--Mdir $(OBJ_DIR) \
    		--CFLAGS "$(CFLAGS) -DTRACE" \
    		-o ../$(BUILD_DIR)/sim
    	@echo "✅ Build complete: $(BUILD_DIR)/sim"
    	@$(BUILD_DIR)/sim
    	@echo "📊 Waveform saved to: $(BUILD_DIR)/wave.vcd"
    	@echo "   View with: gtkwave $(BUILD_DIR)/wave.vcd"

    lint:
    	@echo "🔍 Running Verible linter..."
    	@verible-verilog-lint $(VSRCS)

    format:
    	@echo "✨ Formatting SystemVerilog files..."
    	@verible-verilog-format --inplace $(VSRCS)

    clean:
    	@echo "🧹 Cleaning build artifacts..."
    	@rm -rf $(BUILD_DIR) $(OBJ_DIR)

    help:
    	@echo "SystemVerilog Verilator Makefile"
    	@echo ""
    	@echo "Targets:"
    	@echo "  make sim     - Build and run simulation"
    	@echo "  make trace   - Build and run with VCD trace generation"
    	@echo "  make lint    - Run Verible linter"
    	@echo "  make format  - Format SystemVerilog code with Verible"
    	@echo "  make clean   - Remove build artifacts"
    	@echo "  make help    - Show this help message"
  '';

  # 示例 SystemVerilog 模块
  home.file.".local/share/systemverilog-templates/rtl/top.sv".text = ''
    // SystemVerilog 顶层模块示例
    module top (
        input  logic        clk,
        input  logic        rst_n,
        input  logic        en,
        output logic [7:0]  count
    );

        always_ff @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                count <= 8'h00;
            end else if (en) begin
                count <= count + 8'h01;
            end
        end

    endmodule
  '';

  # C++ Testbench
  home.file.".local/share/systemverilog-templates/tb/testbench.cpp".text = ''
    #include <cstdio>
    #include <cstdlib>
    #include "Vtop.h"
    #include "verilated.h"
    #include "verilated_vcd_c.h"

    int main(int argc, char** argv) {
        Verilated::commandArgs(argc, argv);
        Verilated::traceEverOn(true);

        // 实例化 DUT
        Vtop* dut = new Vtop;

        // VCD 追踪（可选）
        VerilatedVcdC* tfp = nullptr;
    #ifdef TRACE
        tfp = new VerilatedVcdC;
        dut->trace(tfp, 99);
        tfp->open("build/wave.vcd");
    #endif

        // 复位
        dut->rst_n = 0;
        dut->en = 0;
        dut->clk = 0;

        printf("Starting simulation...\n");

        // 运行仿真
        for (int cycle = 0; cycle < 100 && !Verilated::gotFinish(); cycle++) {
            // 时钟上升沿
            dut->clk = 1;
            dut->eval();
    #ifdef TRACE
            if (tfp) tfp->dump(cycle * 2);
    #endif

            // 时钟下降沿
            dut->clk = 0;
            
            // 释放复位
            if (cycle == 5) {
                dut->rst_n = 1;
            }
            
            // 使能计数器
            if (cycle == 10) {
                dut->en = 1;
            }
            
            dut->eval();
    #ifdef TRACE
            if (tfp) tfp->dump(cycle * 2 + 1);
    #endif

            // 打印结果
            if (cycle >= 10 && cycle % 5 == 0) {
                printf("Cycle %3d: count = 0x%02x (%d)\n", 
                       cycle, dut->count, dut->count);
            }
        }

        printf("Simulation complete!\n");

        // 清理
    #ifdef TRACE
        if (tfp) {
            tfp->close();
            delete tfp;
        }
    #endif
        delete dut;

        return 0;
    }
  '';

  # .gitignore
  home.file.".local/share/systemverilog-templates/.gitignore".text = ''
    # Build artifacts
    build/
    obj_dir/
    
    # Waveforms
    *.vcd
    *.fst
    
    # Logs
    *.log
    
    # IDE
    .vscode/
    .idea/
    
    # direnv
    .direnv/
  '';

  # README
  home.file.".local/share/systemverilog-templates/README.md".text = ''
    # SystemVerilog Project with Verilator

    ## Quick Start

    ```bash
    make sim       # Build and run simulation
    make trace     # Run with VCD trace generation
    make lint      # Lint SystemVerilog code
    make format    # Format SystemVerilog code
    make clean     # Clean build artifacts
    ```

    ## Project Structure

    ```
    .
    ├── Makefile                # Build configuration
    ├── rtl/
    │   └── top.sv             # SystemVerilog RTL
    ├── tb/
    │   └── testbench.cpp      # C++ testbench
    ├── build/                  # Build outputs (gitignored)
    │   ├── sim                # Compiled simulator
    │   └── wave.vcd           # Waveform dump
    └── obj_dir/               # Verilator objects (gitignored)
    ```

    ## Tools Included

    - **Verilator**: High-performance SystemVerilog simulator
    - **GTKWave**: Waveform viewer
    - **Verible**: SystemVerilog linter and formatter

    ## Viewing Waveforms

    After running `make trace`:
    ```bash
    gtkwave build/wave.vcd
    ```

    ## Tips

    - Verilator is cycle-accurate and very fast
    - Use `--trace-fst` for faster/smaller waveform files
    - Lint your code regularly with `make lint`
    - Format code with Verible for consistent style
  '';

  # direnv 配置
  home.file.".local/share/systemverilog-templates/.envrc".text = ''
    use flake
  '';

  # flake.nix
  home.file.".local/share/systemverilog-templates/flake.nix".text = ''
    {
      description = "SystemVerilog Development Environment";

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
              verilator
              gtkwave
              verible
              gnumake
              gcc
            ];
            
            shellHook = '''
              echo "⚡ SystemVerilog development environment"
              echo "Run: make help"
            ''';
          };
        };
    }
  '';
}
