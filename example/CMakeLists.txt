cmake_minimum_required(VERSION 2.6)

# needs to be overwritten, if default is not wanted
set(AVR_UPLOADTOOL avrdude)
set(AVR_PROGRAMMER avrispmkII)
set(AVR_MCU atmega8)
set(CMAKE_BUILD_TYPE Release)

# needs to be defined for AVR toolchain
set(MCU_SPEED "4000000UL")

add_avr_executable(
   toggle-led
   main.c
)

