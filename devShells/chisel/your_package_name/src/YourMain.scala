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
