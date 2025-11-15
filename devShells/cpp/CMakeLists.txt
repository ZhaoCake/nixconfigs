cmake_minimum_required(VERSION 3.20)
project(MyProject VERSION 0.1.0 LANGUAGES CXX)

# C++ 标准
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# 导出 compile_commands.json (for clangd)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# 编译选项
add_compile_options(-Wall -Wextra -Wpedantic)

# 可执行文件
add_executable(main src/main.cpp)

# 链接库示例
# find_package(Boost REQUIRED)
# target_link_libraries(main PRIVATE Boost::boost)
