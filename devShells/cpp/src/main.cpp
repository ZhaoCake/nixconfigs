#include <iostream>
#include <vector>
#include <string>

int main() {
    std::vector<std::string> messages = {
        "Hello from C++ project!",
        "Using Nix + Clang",
        "Happy coding!"
    };
    
    for (const auto& msg : messages) {
        std::cout << msg << std::endl;
    }
    
    return 0;
}
