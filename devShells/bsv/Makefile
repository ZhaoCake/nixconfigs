TOP_MODULE = Top
BSV_SRC = bsv_src
BUILD = build
VDIR = $(BUILD)/verilog
VSRC = verilator_src

.PHONY: all verilog verilator iverilog clean help

all: verilator

verilog:
	@mkdir -p $(VDIR)
	bsc -verilog -vdir $(VDIR) -bdir $(BUILD) -info-dir $(BUILD) \
	    -p +:$(BSV_SRC) -g mk$(TOP_MODULE) $(BSV_SRC)/$(TOP_MODULE).bsv
	@echo "✅ Verilog: $(VDIR)/mk$(TOP_MODULE).v"

verilator: verilog
	@verilator -Wall -Wno-UNUSED --no-timing --trace --cc --exe --build \
	    $(VDIR)/mk$(TOP_MODULE).v $(VSRC)/sim_main.cpp \
	    -o $(BUILD)/sim
	@echo "✅ Run: ./$(BUILD)/sim"
	@./$(BUILD)/sim

iverilog: verilog
	@iverilog -o $(BUILD)/sim.vvp $(VDIR)/mk$(TOP_MODULE).v $(VSRC)/tb_iverilog.v
	@vvp $(BUILD)/sim.vvp
	@echo "✅ Waveform: wave.vcd"

clean:
	@rm -rf $(BUILD) *.bo *.ba *.vcd obj_dir

help:
	@echo "Bluespec SystemVerilog Makefile"
	@echo ""
	@echo "Targets:"
	@echo "  make verilog   - Compile BSV to Verilog"
	@echo "  make verilator - Build and run Verilator simulation"
	@echo "  make iverilog  - Build and run Icarus Verilog simulation"
	@echo "  make clean     - Remove build artifacts"
