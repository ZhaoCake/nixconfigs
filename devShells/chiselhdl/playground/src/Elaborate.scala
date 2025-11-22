package example

import circt.stage.ChiselStage

/**
 * Chisel 编译入口
 * 
 * 生成 SystemVerilog 代码
 * 配置选项确保生成的代码兼容 Verilator 和其他工具
 */
object Elaborate extends App {
  val firtoolOptions = Array(
    "--lowering-options=" + List(
      "disallowLocalVariables",      // 禁用局部变量（Yosys 兼容）
      "disallowPackedArrays",         // 禁用打包数组
      "locationInfoStyle=wrapInAtSquareBracket"  // 位置信息格式
    ).reduce(_ + "," + _)
  )
  
  // 生成 TopModule 的 SystemVerilog
  ChiselStage.emitSystemVerilogFile(
    new TopModule(),
    args,
    firtoolOptions
  )
}
