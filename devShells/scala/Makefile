.PHONY: compile test run clean reformat bsp idea help

# Project name (change this to your module name)
PROJECT = myproject

# Default target
all: compile

# Compile the project
compile:
	mill $(PROJECT).compile

# Run tests
test:
	mill $(PROJECT).test

# Run the main class
run:
	mill $(PROJECT).run

# Run with arguments
run-args:
	mill $(PROJECT).run $(ARGS)

# Clean build artifacts
clean:
	mill clean

# Format code
reformat:
	mill mill.scalalib.scalafmt.ScalafmtModule/reformatAll __.sources

# Check formatting
checkformat:
	mill mill.scalalib.scalafmt.ScalafmtModule/checkFormatAll __.sources

# Setup BSP for IDE integration
bsp:
	mill mill.bsp.BSP/install

# Generate IntelliJ IDEA project
idea:
	mill mill.idea.GenIdea/idea

# Show all available tasks
tasks:
	mill resolve _

# Help
help:
	@echo "Available targets:"
	@echo "  make compile      - Compile the project"
	@echo "  make test         - Run tests"
	@echo "  make run          - Run the main class"
	@echo "  make run-args ARGS='arg1 arg2' - Run with arguments"
	@echo "  make clean        - Clean build artifacts"
	@echo "  make reformat     - Format code"
	@echo "  make checkformat  - Check code formatting"
	@echo "  make bsp          - Setup BSP for IDE"
	@echo "  make idea         - Generate IntelliJ IDEA project"
	@echo "  make tasks        - Show all Mill tasks"
