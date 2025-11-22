package example

import chisel3._

/**
 * 简单的计数器模块 - Chisel 模板示例
 * 
 * 这是一个基础的硬件模块，实现了：
 * - 32 位递增计数器
 * - 同步复位
 * - LED 输出（显示计数器高 8 位）
 */
class Counter extends Module {
  val io = IO(new Bundle {
    val led = Output(UInt(8.W))      // 8-bit LED 输出
    val reset_btn = Input(Bool())     // 复位按钮
  })
  
  // 32 位计数器寄存器
  val counter = RegInit(0.U(32.W))
  
  // 计数器逻辑
  when(io.reset_btn) {
    counter := 0.U
  }.otherwise {
    counter := counter + 1.U
  }
  
  // 将计数器的高 8 位输出到 LED
  // 这样可以用 LED 观察计数器的高速变化
  io.led := counter(31, 24)
}

/**
 * 顶层模块 - 用于测试
 */
class TopModule extends Module {
  val io = IO(new Bundle {
    val led = Output(UInt(8.W))
    val btn = Input(Bool())
  })
  
  // 实例化计数器
  val counter = Module(new Counter())
  
  // 连接 IO
  counter.io.reset_btn := io.btn
  io.led := counter.io.led
}
