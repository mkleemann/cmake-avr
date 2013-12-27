cmake_minimum_required(VERSION 2.8)

# needs to be overwritten, if default is not wanted
set(AVR_UPLOADTOOL avrdude)
set(AVR_PROGRAMMER avrispmkII)
set(AVR_MCU atmega16)
set(CMAKE_BUILD_TYPE Release)

# needs to be defined for AVR toolchain
set(MCU_SPEED "4000000UL")

# include search paths
include_directories(mylib)

add_avr_executable(
   toggle-led
   main.c
)

# for building the library
add_subdirectory(mylib)

# library search path for linker
link_directories(${CMAKE_CURRENT_SOURCE_DIR}/mylib)

# link libraries
target_link_libraries(toggle-led mylib-${AVR_MCU})

