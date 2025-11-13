# Chisel Mill Makefile
.PHONY: all verilog vsim vsim-trace test clean bsp idea help

PKG = your_package_name
TOP = YourMain
BUILD = build
VSRC = verilator_csrc

all: verilog

verilog:
	@mkdir -p $(BUILD)
	@rm -rf $(BUILD)/*
	@mill -i $(PKG).runMain $(PKG).Elaborate --target-dir $(BUILD)
	@echo "✅ Verilog generated in $(BUILD)/"

vsim: verilog
	@verilator --top-module $(TOP) --trace --exe --cc -j 0 --build \
		$$(find $(BUILD) -name "*.v" -o -name "*.sv") \
		$(VSRC)/sim_main.cc --CFLAGS "-g -I$$(pwd)/$(VSRC) -O2"
	@./obj_dir/V$(TOP)

vsim-trace: verilog
	@verilator --top-module $(TOP) --trace --exe --cc -j 0 --build -DMTRACE=1 \
		$$(find $(BUILD) -name "*.v" -o -name "*.sv") \
		$(VSRC)/sim_main.cc --CFLAGS "-g -I$$(pwd)/$(VSRC) -O2 -DMTRACE=1"
	@./obj_dir/V$(TOP)
	@echo "✅ Run: gtkwave waveform.vcd"

test:
	@mill __.test

clean:
	@rm -rf $(BUILD) obj_dir waveform.vcd *.log out

bsp:
	@mill mill.bsp.BSP/install

idea:
	@mill mill.idea.GenIdea/idea

help:
	@echo "Chisel Makefile targets:"
	@echo "  make verilog     - Generate Verilog"
	@echo "  make vsim        - Run Verilator simulation"
	@echo "  make vsim-trace  - Run Verilator with VCD trace"
	@echo "  make test        - Run Scala tests"
	@echo "  make clean       - Clean build artifacts"
	@echo "  make bsp         - Generate BSP for IDE"
	@echo "  make idea        - Generate IntelliJ project"
