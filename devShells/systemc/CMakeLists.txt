cmake_minimum_required(VERSION 3.10)
project(HelloSystemC)

# Use C++17 standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find SystemC
find_package(SystemCLanguage CONFIG REQUIRED)

# Add executable
add_executable(hello_sc src/main.cpp)

# Link libraries
target_link_libraries(hello_sc SystemC::systemc)
