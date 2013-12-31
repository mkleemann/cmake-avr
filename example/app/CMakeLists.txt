add_avr_executable(
   toggle-led
   main.c
)

#find_library(M_LIB m)
#message(STATUS "avr-libm: ${M_LIB}")

find_library(C_LIB c)
message(STATUS "avr-libc: ${C_LIB}")

# link libraries; NEEDS elf target as base!
target_link_libraries(toggle-led-${AVR_MCU}.elf mylib-${AVR_MCU} ${C_LIB}) 


