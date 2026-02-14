#include <systemc>
#include <iostream>

using namespace sc_core;

SC_MODULE(Hello) {
    SC_CTOR(Hello) {
        SC_THREAD(process);
    }

    void process() {
        std::cout << "Hello, SystemC World!" << std::endl;
        std::cout << "Time: " << sc_time_stamp() << std::endl;
        wait(10, SC_NS);
        std::cout << "Time: " << sc_time_stamp() << std::endl;
    }
};

int sc_main(int argc, char* argv[]) {
    Hello h("hello");
    sc_start();
    return 0;
}
