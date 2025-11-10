# Chisel 3.7 开发环境
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Scala 工具链
    sbt          # Scala Build Tool
    scala_3      # Scala 3
    metals       # Scala LSP server
    
    # Java (Chisel 需要)
    jdk17        # Java 17 LTS
    
    # Verilog 工具
    verilator
    gtkwave
    
    # 可选：形式验证工具
    # yosys
  ];

  # Chisel 项目模板
  home.file.".local/share/chisel-templates/build.sbt".text = ''
    scalaVersion := "2.13.12"

    libraryDependencies ++= Seq(
      "org.chipsalliance" %% "chisel" % "3.7.0",
      "edu.berkeley.cs" %% "chiseltest" % "5.0.2" % "test"
    )

    scalacOptions ++= Seq(
      "-deprecation",
      "-feature",
      "-unchecked",
      "-language:reflectiveCalls",
    )
  '';

  home.file.".local/share/chisel-templates/project/build.properties".text = ''
    sbt.version=1.9.7
  '';

  home.file.".local/share/chisel-templates/project/plugins.sbt".text = ''
    // 可选插件
  '';

  home.file.".local/share/chisel-templates/src/main/scala/Top.scala".text = ''
    import chisel3._

    class Counter(width: Int) extends Module {
      val io = IO(new Bundle {
        val en = Input(Bool())
        val out = Output(UInt(width.W))
      })
      
      val count = RegInit(0.U(width.W))
      when (io.en) {
        count := count + 1.U
      }
      io.out := count
    }

    object Main extends App {
      emitVerilog(
        new Counter(8),
        Array("--target-dir", "generated", "--split-verilog")
      )
    }
  '';

  home.file.".local/share/chisel-templates/src/test/scala/CounterTest.scala".text = ''
    import chisel3._
    import chiseltest._
    import org.scalatest.flatspec.AnyFlatSpec

    class CounterTest extends AnyFlatSpec with ChiselScalatestTester {
      "Counter" should "increment" in {
        test(new Counter(8)) { dut =>
          dut.io.en.poke(true.B)
          dut.clock.step()
          dut.io.out.expect(1.U)
          dut.clock.step()
          dut.io.out.expect(2.U)
        }
      }
    }
  '';

  home.file.".local/share/chisel-templates/Makefile".text = ''
    .PHONY: all compile test verilog clean

    all: verilog

    compile:
    	sbt compile

    test:
    	sbt test

    verilog:
    	sbt "runMain Main"
    	@echo "✅ Verilog: generated/Counter.v"

    clean:
    	rm -rf target generated project/target
  '';

  home.file.".local/share/chisel-templates/.gitignore".text = ''
    target/
    generated/
    project/target/
    project/project/
    .bsp/
    .metals/
    .vscode/
    *.class
    *.log
  '';

  home.file.".local/share/chisel-templates/README.md".text = ''
    # Chisel 3.7 Project

    ```bash
    sbt compile         # Compile Scala
    sbt test            # Run tests
    sbt "runMain Main"  # Generate Verilog
    # or: make verilog
    ```

    Generated Verilog: `generated/Counter.v`
  '';
}
