# Chisel 7.0+ 开发环境
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Scala 工具链
    mill         # Mill Build Tool (推荐)
    sbt          # Scala Build Tool (备用)
    scala_2_13   # Scala 2.13
    metals       # Scala LSP server
    
    # Java (Chisel 需要)
    jdk17        # Java 17 LTS
    
    # Verilog 工具
    verilator
    gtkwave
    
    # 可选：形式验证工具
    # yosys
  ];

  # Chisel 项目模板（基于 Mill）
  home.file.".local/share/chisel-templates/build.mill".text = ''
    import mill._
    import mill.scalalib._
    import mill.scalalib.scalafmt.ScalafmtModule

    // Modify this to your package name
    object your_package_name extends ScalaModule with ScalafmtModule { m =>
      override def scalaVersion = "2.13.15"

      override def scalacOptions = Seq(
        "-language:reflectiveCalls",
        "-deprecation",
        "-feature",
        "-Xcheckinit"
      )

      val chiselVersion = "6.6.0"

      override def ivyDeps = Agg(
        ivy"org.chipsalliance::chisel:''${chiselVersion}"
      )
      
      override def scalacPluginIvyDeps = Agg(
        ivy"org.chipsalliance:::chisel-plugin:''${chiselVersion}"
      )

      object test extends ScalaTests with TestModule.ScalaTest with ScalafmtModule {
        override def ivyDeps = m.ivyDeps() ++ Agg(
          ivy"org.scalatest::scalatest:3.2.19",
          ivy"edu.berkeley.cs::chiseltest:6.0.0"
        )
      }

      def repositoriesTask = Task.Anon {
        Seq(
          coursier.MavenRepository("https://maven.aliyun.com/repository/public"),
          coursier.MavenRepository("https://repo.scala-sbt.org/scalasbt/maven-releases"),
          coursier.MavenRepository("https://oss.sonatype.org/content/repositories/releases"),
          coursier.MavenRepository("https://oss.sonatype.org/content/repositories/snapshots")
        ) ++ super.repositoriesTask()
      }
    }
  '';

  # Elaborate.scala - 用于生成 Verilog
  home.file.".local/share/chisel-templates/your_package_name/src/Elaborate.scala".text = ''
    package your_package_name

    import chisel3._
    import circt.stage.ChiselStage

    object Elaborate extends App {
      val usage = ""

      var firrtlOpts  = Array[String]()
      var firtoolOpts = Array[String]()

      type OptionMap = Map[Symbol, Any]
      def parseArgs(args: Array[String]) = {
        def nextOption(options: OptionMap, argList: List[String]): OptionMap = {
          argList match {
            case Nil                             => options
            case "--target-dir" :: value :: tail => nextOption(options ++ Map { Symbol("targetDir") -> value }, tail)
            case "--release" :: tail =>
              options ++ Map { Symbol("release") -> true }
              nextOption(options, tail)
            case option :: tail =>
              firrtlOpts :+= option
              nextOption(options, tail)
          }
        }
        nextOption(Map(), args.toList)
      }

      if (args.length == 0) println(usage)
      val options = parseArgs(args)
      def getArg(key: String) = options.getOrElse(Symbol(key), None)

      firrtlOpts = firrtlOpts ++ Array(
        "-td=" + getArg("targetDir"),
        "--split-verilog",
        "--preserve-aggregate=vec"
      )
      firtoolOpts = firtoolOpts ++ Array(
        "-O=" + (if (getArg("release") == true) "release" else "debug"),
        "--lowering-options=" + Seq(
          "locationInfoStyle=wrapInAtSquareBracket",
          "disallowLocalVariables",
          "mitigateVivadoArrayIndexConstPropBug"
        ).mkString(","),
        "--disable-all-randomization"
      )

      ChiselStage.emitSystemVerilogFile(
        new YourMain, // Main module matching TOPNAME in Makefile
        firrtlOpts,
        firtoolOpts
      )
    }
  '';

  # YourMain.scala - 示例模块
  home.file.".local/share/chisel-templates/your_package_name/src/YourMain.scala".text = ''
    package your_package_name

    import chisel3._

    class YourMain extends Module {
      val io = IO(new Bundle {
        val en = Input(Bool())
        val out = Output(UInt(8.W))
      })
      
      val count = RegInit(0.U(8.W))
      when (io.en) {
        count := count + 1.U
      }
      io.out := count
    }
  '';

  # 测试文件
  home.file.".local/share/chisel-templates/your_package_name/test/src/YourMainTest.scala".text = ''
    package your_package_name

    import chisel3._
    import chiseltest._
    import org.scalatest.flatspec.AnyFlatSpec

    class YourMainTest extends AnyFlatSpec with ChiselScalatestTester {
      "YourMain" should "increment" in {
        test(new YourMain) { dut =>
          dut.io.en.poke(true.B)
          dut.clock.step()
          dut.io.out.expect(1.U)
          dut.clock.step()
          dut.io.out.expect(2.U)
        }
      }
    }
  '';

  # Makefile
  home.file.".local/share/chisel-templates/Makefile".text = ''
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
  '';

  # Verilator C++ 仿真文件
  home.file.".local/share/chisel-templates/verilator_csrc/sim_main.cc".text = ''
    #include "VYourMain.h"
    #include "verilated.h"
    #include "verilated_vcd_c.h"
    #include <iostream>

    int main(int argc, char** argv) {
      Verilated::commandArgs(argc, argv);
      Verilated::traceEverOn(true);
      
      VYourMain* top = new VYourMain;
      VerilatedVcdC* tfp = new VerilatedVcdC;
      
      top->trace(tfp, 99);
      tfp->open("waveform.vcd");
      
      std::cout << "Starting simulation..." << std::endl;
      
      for (int i = 0; i < 200 && !Verilated::gotFinish(); ++i) {
        top->CLK = i & 1;
        top->RST_N = i > 5;
        top->io_en = (i > 10) ? 1 : 0;
        
        top->eval();
        tfp->dump(i);
        
        if ((i & 1) && (i > 10)) {
          std::cout << "Cycle " << i/2 << ": out = " << (int)top->io_out << std::endl;
        }
      }
      
      tfp->close();
      delete top;
      delete tfp;
      
      std::cout << "Simulation complete. Waveform saved to waveform.vcd" << std::endl;
      return 0;
    }
  '';

  # .mill-version (固定 Mill 版本)
  home.file.".local/share/chisel-templates/.mill-version".text = ''
    0.12.15
  '';

  # .envrc (direnv 自动加载 nix 环境)
  home.file.".local/share/chisel-templates/.envrc".text = ''
    use flake
  '';

  # flake.nix (项目环境描述)
  home.file.".local/share/chisel-templates/flake.nix".text = ''
    {
      description = "Chisel Mill Project";

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
              openjdk17
              mill
              scala_2_13
              verilator
              gtkwave
              gcc
              gnumake
            ];
            
            shellHook = '''
              echo "🔥 Chisel development environment"
              echo "Run: make help"
            ''';
          };
        };
    }
  '';

  # .gitignore
  home.file.".local/share/chisel-templates/.gitignore".text = ''
    # Build artifacts
    out/
    build/
    obj_dir/
    
    # Mill (不忽略 .mill-version)
    
    # IDE
    .bsp/
    .metals/
    .vscode/
    .idea/
    
    # Simulation
    waveform.vcd
    *.log
    
    # Scala
    *.class
    target/
    
    # direnv
    .direnv/
  '';

  # README
  home.file.".local/share/chisel-templates/README.md".text = ''
    # Chisel Project (Mill + Makefile)

    ## Quick Start

    ```bash
    make verilog      # Generate Verilog
    make vsim         # Run Verilator simulation
    make vsim-trace   # Run with VCD tracing
    make test         # Run tests
    make clean        # Clean build artifacts
    make help         # Show all targets
    ```

    ### Using Mill directly
    ```bash
    mill your_package_name.compile
    mill your_package_name.test
    mill your_package_name.runMain your_package_name.Elaborate --target-dir build
    ```

    ## Project Structure
    ```
    .
    ├── build.mill                    # Mill build definition
    ├── Makefile                      # Build commands
    ├── your_package_name/
    │   ├── src/
    │   │   ├── Elaborate.scala      # Verilog generator
    │   │   └── YourMain.scala       # Main module
    │   └── test/src/
    │       └── YourMainTest.scala   # Tests
    ├── verilator_csrc/
    │   └── sim_main.cc              # C++ testbench
    └── build/                        # Generated Verilog (gitignored)
    ```

    ## IDE Support
    ```bash
    make bsp          # Generate BSP for Metals/VSCode
    make idea         # Generate IntelliJ IDEA project
    ```

    ## Notes
    - Uses **Mill** as the build tool (faster than sbt)
    - **Makefile** provides convenient command shortcuts
    - Chinese mirrors (Aliyun) configured in build.mill for faster downloads
    - All dependencies managed by global Nix environment
  '';
}
