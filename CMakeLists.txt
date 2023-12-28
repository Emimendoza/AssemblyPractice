cmake_minimum_required(VERSION 3.27.8)

set(CMAKE_ASM_NASM_LINK_EXECUTABLE "ld -dynamic-linker /lib64/ld-linux-x86-64.so.2 <LINK_FLAGS> <OBJECTS> -o <TARGET> <LINK_LIBRARIES>")
set(CMAKE_ASM_NASM_OBJECT_FORMAT elf64)
project(practice ASM_NASM)

add_executable(practice src/main.asm)

target_link_libraries(practice c)