PRJ = haskell-hello

build:
	cabal build

run:
	cabal run $(PRJ)

repl:
	cabal repl $(PRJ)

fmt:
	ormolu -m inplace $(shell find src -name '*.hs')

lint:
	hlint src

clean:
	cabal clean

help:
	@echo "📚 Available targets:"
	@echo "  make build   - Build the project"
	@echo "  make run     - Run Hello World"
	@echo "  make repl    - Start GHCi"
	@echo "  make fmt     - Format code (ormolu)"
	@echo "  make lint    - Lint code (hlint)"
	@echo "  make clean   - Clean build artifacts"

.PHONY: build run repl fmt lint clean help
.DEFAULT_GOAL := help
