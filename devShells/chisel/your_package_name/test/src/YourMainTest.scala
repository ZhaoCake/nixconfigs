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
