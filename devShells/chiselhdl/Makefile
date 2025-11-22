# ==========================================
# Project Configuration
# ==========================================
BUILD_DIR = ./build
PRJ = playground
TOP_MODULE = TopModule
CPP_SRCS = csrc/sim_main.cpp

# ==========================================
# Chisel → Verilog Generation
# ==========================================
.PHONY: verilog
verilog:
	@echo "🔧 Generating Verilog from Chisel..."
	mkdir -p $(BUILD_DIR)
	mill -i $(PRJ).runMain example.Elaborate --target-dir $(BUILD_DIR)
	@echo "✅ Verilog generated in $(BUILD_DIR)/"

# ==========================================
# Verilator Compilation
# ==========================================
.PHONY: verilator
verilator: verilog
	@echo "🔨 Compiling Verilator model..."
	verilator --cc --exe --build -j 4 \
		--top-module $(TOP_MODULE) \
		-I$(BUILD_DIR) \
		$(BUILD_DIR)/*.sv \
		$(CPP_SRCS) \
		--Mdir $(BUILD_DIR)/obj_dir \
		-o sim
	@echo "✅ Simulation binary: $(BUILD_DIR)/obj_dir/sim"

# ==========================================
# Simulation with Waveform Tracing
# ==========================================
.PHONY: trace
trace: verilog
	@echo "🔨 Compiling Verilator model with waveform tracing..."
	verilator --cc --exe --build -j 4 \
		--trace \
		--top-module $(TOP_MODULE) \
		-I$(BUILD_DIR) \
		$(BUILD_DIR)/*.sv \
		$(CPP_SRCS) \
		-CFLAGS "-DTRACE" \
		--Mdir $(BUILD_DIR)/obj_dir \
		-o sim
	@echo "✅ Simulation binary with tracing: $(BUILD_DIR)/obj_dir/sim"

# ==========================================
# Run Simulation
# ==========================================
.PHONY: sim
sim: verilator
	@echo "🚀 Running simulation..."
	$(BUILD_DIR)/obj_dir/sim
	@echo "✅ Simulation completed"

.PHONY: sim-trace
sim-trace: trace
	@echo "🚀 Running simulation with waveform tracing..."
	$(BUILD_DIR)/obj_dir/sim
	@echo "✅ Waveform saved to waves.vcd"
	@echo "💡 View with: gtkwave waves.vcd"

# ==========================================
# Testing
# ==========================================
.PHONY: test
test:
	@echo "🧪 Running tests..."
	mill -i $(PRJ).test

# ==========================================
# IDE Integration
# ==========================================
.PHONY: bsp
bsp:
	@echo "🔧 Generating BSP configuration for Metals/VS Code..."
	mill -i mill.bsp.BSP/install

.PHONY: idea
idea:
	@echo "🔧 Generating IntelliJ IDEA project..."
	mill -i mill.idea.GenIdea/idea

# ==========================================
# Code Formatting
# ==========================================
.PHONY: reformat
reformat:
	@echo "📝 Reformatting Scala code..."
	mill -i __.reformat

.PHONY: checkformat
checkformat:
	@echo "🔍 Checking code format..."
	mill -i __.checkFormat

# ==========================================
# Cleanup
# ==========================================
.PHONY: clean
clean:
	@echo "🧹 Cleaning build artifacts..."
	-rm -rf $(BUILD_DIR)
	-rm -f waves.vcd
	@echo "✅ Clean completed"

.PHONY: distclean
distclean: clean
	@echo "🧹 Deep cleaning (including Mill cache)..."
	mill clean
	-rm -rf out/

# ==========================================
# Help
# ==========================================
.PHONY: help
help:
	@echo "📚 Available targets:"
	@echo ""
	@echo "  🔧 Verilog Generation:"
	@echo "    make verilog      - Generate Verilog from Chisel"
	@echo ""
	@echo "  🔨 Simulation:"
	@echo "    make verilator    - Compile Verilator model"
	@echo "    make sim          - Compile and run simulation"
	@echo "    make trace        - Compile with waveform tracing"
	@echo "    make sim-trace    - Run simulation and generate VCD"
	@echo ""
	@echo "  🧪 Testing:"
	@echo "    make test         - Run Chisel tests"
	@echo ""
	@echo "  🔧 IDE Support:"
	@echo "    make bsp          - Generate BSP for Metals/VS Code"
	@echo "    make idea         - Generate IntelliJ IDEA project"
	@echo ""
	@echo "  📝 Code Quality:"
	@echo "    make reformat     - Format Scala code"
	@echo "    make checkformat  - Check code formatting"
	@echo ""
	@echo "  🧹 Cleanup:"
	@echo "    make clean        - Remove build artifacts"
	@echo "    make distclean    - Deep clean including Mill cache"
	@echo ""

.DEFAULT_GOAL := help
