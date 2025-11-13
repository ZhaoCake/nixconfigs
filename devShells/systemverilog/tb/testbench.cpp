#include <cstdio>
#include <cstdlib>
#include "Vtop.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Verilated::traceEverOn(true);

    // 实例化 DUT
    Vtop* dut = new Vtop;

    // VCD 追踪（可选）
    VerilatedVcdC* tfp = nullptr;
#ifdef TRACE
    tfp = new VerilatedVcdC;
    dut->trace(tfp, 99);
    tfp->open("build/wave.vcd");
#endif

    // 复位
    dut->rst_n = 0;
    dut->en = 0;
    dut->clk = 0;

    printf("Starting simulation...\n");

    // 运行仿真
    for (int cycle = 0; cycle < 100 && !Verilated::gotFinish(); cycle++) {
        // 时钟上升沿
        dut->clk = 1;
        dut->eval();
#ifdef TRACE
        if (tfp) tfp->dump(cycle * 2);
#endif

        // 时钟下降沿
        dut->clk = 0;
        
        // 释放复位
        if (cycle == 5) {
            dut->rst_n = 1;
        }
        
        // 使能计数器
        if (cycle == 10) {
            dut->en = 1;
        }
        
        dut->eval();
#ifdef TRACE
        if (tfp) tfp->dump(cycle * 2 + 1);
#endif

        // 打印结果
        if (cycle >= 10 && cycle % 5 == 0) {
            printf("Cycle %3d: count = 0x%02x (%d)\n", 
                   cycle, dut->count, dut->count);
        }
    }

    printf("Simulation complete!\n");

    // 清理
#ifdef TRACE
    if (tfp) {
        tfp->close();
        delete tfp;
    }
#endif
    delete dut;

    return 0;
}
