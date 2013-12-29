cmake_minimum_required(VERSION 2.8)

project(AVR-EXAMPLE)

# needs to be overwritten, if default is not wanted
set(AVR_UPLOADTOOL avrdude)
set(AVR_PROGRAMMER avrispmkII)
set(AVR_MCU atmega16)
set(AVR_UPLOADTOOL_PORT usb)
set(CMAKE_BUILD_TYPE Release)

# needs to be defined for AVR toolchain
set(MCU_SPEED "4000000UL")

# common options for compiler and linker
set(AVR_COMMON_OPTIONS "-mmcu=${AVR_MCU} -fpack-struct -fshort-enums")

# compiler options
set(AVR_COMPILER_OPTIONS "${AVR_COMMON_OPTIONS} -Wall -Werror -pedantic -pedantic-errors -funsigned-char -funsigned-bitfields -ffunction-sections -c -std=gnu99 -DF_CPU=${MCU_SPEED}")

# if not debug, assume release 
if(NOT CMAKE_BUILD_TYPE EQUAL Debug)

   set(CMAKE_C_FLAGS_RELEASE "-Os")
   set(CMAKE_CXX_FLAGS_RELEASE "-Os")

else(NOT CMAKE_BUILD_TYPE EQUAL Debug)

   set(CMAKE_C_FLAGS_DEBUG "-O0 -save-temps")
   set(CMAKE_CXX_FLAGS_DEBUG "-O0 -save-temps")

endif(NOT CMAKE_BUILD_TYPE EQUAL Debug)

add_avr_executable(
   toggle-led
   main.c
)

# for building the library
add_subdirectory(mylib)

# include search paths
include_directories(${AVR-EXAMPLE_SOURCE_DIR}/mylib)

# find_library(MYLIB_LOCATION mylib-${AVR_MCU} ${AVR-EXAMPLE_BINARY_DIR}/mylib)
# message("+++ Library: ${MYLIB_LOCATION} +++")

# library search path for linker
# link_directories(${AVR-EXAMPLE_BINARY_DIR}/mylib)

#find_library(M_LIB m "/usr/avr/lib")
#find_library(C_LIB c "/usr/avr/lib")
#message("+++ ${M_LIB} + ${C_LIB} +++")

# link libraries
target_link_libraries(toggle-led mylib-${AVR_MCU}) 


