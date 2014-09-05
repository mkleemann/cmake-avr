##########################################################################
# "THE ANY BEVERAGE-WARE LICENSE" (Revision 42 - based on beer-ware
# license):
# <dev@layer128.net> wrote this file. As long as you retain this notice
# you can do whatever you want with this stuff. If we meet some day, and
# you think this stuff is worth it, you can buy me a be(ve)er(age) in
# return. (I don't like beer much.)
#
# Matthias Kleemann
##########################################################################

add_avr_executable(
   toggle-led
   main.c
)

# find_library(M_LIB m)
# message(STATUS "avr-libm: ${M_LIB}")

find_library(C_LIB c)
message(STATUS "avr-libc: ${C_LIB}")

# link libraries; NEEDS elf target as base!
target_link_libraries(toggle-led-${AVR_MCU}.elf mylib-${AVR_MCU} ${C_LIB})


