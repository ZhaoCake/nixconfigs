PRJ = app

run:
	mill -i $(PRJ).run

test:
	mill -i $(PRJ).test

reformat:
	mill -i __.reformat

checkformat:
	mill -i __.checkFormat

bsp:
	mill -i mill.bsp.BSP/install

idea:
	mill -i mill.idea.GenIdea/idea

clean:
	mill clean
	-rm -rf out/

help:
	@echo "📚 Available targets:"
	@echo "  make run          - Run the application"
	@echo "  make test         - Run tests"
	@echo "  make reformat     - Format Scala code"
	@echo "  make checkformat  - Check code formatting"
	@echo "  make bsp          - Generate BSP for Metals/VS Code"
	@echo "  make idea         - Generate IntelliJ IDEA project"
	@echo "  make clean        - Clean build artifacts"

.PHONY: run test reformat checkformat bsp idea clean help
.DEFAULT_GOAL := help
