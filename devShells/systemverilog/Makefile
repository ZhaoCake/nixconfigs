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
