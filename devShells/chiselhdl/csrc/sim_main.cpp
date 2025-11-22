#include <verilated.h>
#include "VTopModule.h"

#ifdef TRACE
#include <verilated_vcd_c.h>
#endif

#include <stdio.h>
#include <stdlib.h>

// Simulation parameters
#define SIM_CYCLES 100

VTopModule* top;
vluint64_t main_time = 0;

#ifdef TRACE
VerilatedVcdC* tfp;
#endif

double sc_time_stamp() {
    return main_time;
}

void tick() {
    // Falling edge
    top->clock = 0;
    top->eval();
    
#ifdef TRACE
    tfp->dump(main_time);
#endif
    
    main_time++;
    
    // Rising edge
    top->clock = 1;
    top->eval();
    
#ifdef TRACE
    tfp->dump(main_time);
#endif
    
    main_time++;
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    top = new VTopModule;
    
#ifdef TRACE
    Verilated::traceEverOn(true);
    tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("waves.vcd");
    printf("Waveform tracing enabled: waves.vcd\n");
#endif

    // Reset sequence
    printf("Starting simulation...\n");
    top->reset = 1;
    top->io_button = 0;
    
    for (int i = 0; i < 5; i++) {
        tick();
    }
    
    top->reset = 0;
    printf("Reset released\n");
    
    // Run simulation
    printf("Running %d cycles...\n", SIM_CYCLES);
    
    for (int cycle = 0; cycle < SIM_CYCLES; cycle++) {
        // Example: Toggle button every 20 cycles
        if (cycle == 20) {
            top->io_button = 1;
            printf("[Cycle %d] Button pressed\n", cycle);
        } else if (cycle == 25) {
            top->io_button = 0;
            printf("[Cycle %d] Button released\n", cycle);
        }
        
        tick();
        
        // Sample output every 10 cycles
        if (cycle % 10 == 0) {
            printf("[Cycle %d] LED output: 0x%02x\n", cycle, top->io_leds);
        }
    }
    
    printf("Simulation completed after %d cycles\n", SIM_CYCLES);
    
#ifdef TRACE
    tfp->close();
    delete tfp;
    printf("Waveform saved to waves.vcd\n");
#endif

    top->final();
    delete top;
    
    return 0;
}
