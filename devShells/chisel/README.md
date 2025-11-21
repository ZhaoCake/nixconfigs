# Chisel Development Environment

A Nix-based Chisel 7.0 development environment template using Mill build tool.

## 🌟 Features

- **Chisel 7.0.0** - Latest Chisel hardware description language
- **Scala 2.13.16** - Modern Scala version
- **Mill 0.12.7** - Fast and simple build tool (no obscure SBT DSL)
- **Nix Flake** - Reproducible development environment
- **direnv support** - Auto-activate when entering directory

## 📁 Project Structure

```
.
├── flake.nix              # Nix development environment
├── build.mill             # Mill build configuration
├── .mill-jvm-opts         # JVM options for Chisel
├── .mill-version          # Mill version lock
├── Makefile               # Convenient make commands
├── playground/            # Example Chisel code
│   ├── src/
│   │   ├── GCD.scala
│   │   ├── DecoupledGCD.scala
│   │   └── Elaborate.scala
│   └── test/
│       └── src/
│           └── GCDSpec.scala
└── README.md              # This file
```

## 🚀 Quick Start

### Using with direnv (Recommended)

If you have direnv enabled in your main nixconfigs:

```bash
# Navigate to this directory
cd /path/to/devShells/chisel

# Allow direnv (first time only)
direnv allow

# Environment will auto-activate!
```

### Manual activation

```bash
# Enter Nix development shell
nix develop

# Or use direnv
echo "use flake" > .envrc
direnv allow
```

## 🛠️ Available Commands

### Building and Testing

```bash
# Run all tests (recommended for TDD)
make test

# Generate Verilog from Chisel code
make verilog

# Show help for Elaborate options
make help

# Clean build artifacts
make clean
```

### Development Tools

```bash
# Setup BSP for IDE integration (VSCode, IntelliJ)
make bsp

# Generate IntelliJ IDEA project
make idea

# Format Scala code
make reformat

# Check code formatting
make checkformat
```

### Direct Mill Commands

```bash
# Run tests
mill -i playground.test

# Compile the project
mill -i playground.compile

# Run main class
mill -i playground.runMain Elaborate

# Show all available tasks
mill resolve _
```

## 📝 Customizing for Your Project

### 1. Rename the module

Edit `build.mill` and change `playground` to your project name:

```scala
object myproject extends SbtModule { m =>
  // ... rest of configuration
}
```

### 2. Update Makefile

Change `PRJ = playground` to `PRJ = myproject` in `Makefile`.

### 3. Reorganize source files

The template uses SBT-style directory layout:
- `src/` - Main Scala/Chisel source files
- `test/src/` - Test files

Feel free to rename or restructure as needed.

### 4. Add dependencies

Edit `build.mill` to add more dependencies:

```scala
override def ivyDeps = Agg(
  ivy"org.chipsalliance::chisel:$chiselVersion",
  // Add your dependencies here
  ivy"edu.berkeley.cs::chiseltest:7.0.0",
)
```

## 🎓 Example: GCD Module

The template includes a GCD (Greatest Common Divisor) example:

```bash
# Run tests
make test

# Generate Verilog
make verilog

# Check the output in build/ directory
cat build/GCD.sv
```

## 🔧 IDE Setup

### VS Code with Metals

```bash
# Generate BSP configuration
make bsp

# Install Scala (Metals) extension in VS Code
# Metals will automatically detect the BSP configuration
```

### IntelliJ IDEA

```bash
# Generate IDEA project
make idea

# Open the project in IntelliJ IDEA
```

## 📚 Useful Resources

- [Chisel Documentation](https://www.chisel-lang.org/)
- [Chisel Bootcamp](https://github.com/freechipsproject/chisel-bootcamp)
- [Mill Documentation](https://mill-build.org/)
- [Scala Documentation](https://docs.scala-lang.org/)

## ⚙️ Technical Details

### Why SbtModule?

This template uses `SbtModule` instead of `ScalaModule` to follow the standard SBT directory layout (`src/`, `test/src/`), which is more familiar to Scala/Chisel developers.

### .mill-jvm-opts

The `.mill-jvm-opts` file contains:
```
-Dchisel.project.root=${PWD}
```

This is required for Chisel to correctly handle project paths and generate output files. See [mill#3840](https://github.com/com-lihaoyi/mill/issues/3840) for details.

### Chisel 7.0 Changes

Chisel 7.0 requires Scala 2.13.16 and includes several improvements. The template is configured with:
- `-Ymacro-annotations` for Chisel macros
- Updated plugin and library versions

## 🤝 Contributing

This is a template project. Feel free to:
- Copy and modify for your projects
- Report issues or suggest improvements
- Share your Chisel designs!

## 📄 License

MIT License - feel free to use for any purpose.
