#include "VmkTop.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <iostream>

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Verilated::traceEverOn(true);
    
    VmkTop* top = new VmkTop;
    VerilatedVcdC* vcd = new VerilatedVcdC;
    top->trace(vcd, 99);
    vcd->open("wave.vcd");
    
    std::cout << "Starting Bluespec simulation..." << std::endl;
    
    for (int t = 0; t < 500 && !Verilated::gotFinish(); t++) {
        top->CLK = t & 1;
        top->RST_N = t > 10;
        top->eval();
        vcd->dump(t);
    }
    
    vcd->close();
    delete top;
    
    std::cout << "Simulation complete! Waveform: wave.vcd" << std::endl;
    return 0;
}
