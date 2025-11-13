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
    top->clock = i & 1;
    top->reset = i > 5;
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
