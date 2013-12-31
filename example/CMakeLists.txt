cmake_minimum_required(VERSION 2.8)

project(AVR-EXAMPLE)

# needs to be overwritten, if default is not wanted
set(AVR_UPLOADTOOL avrdude)
set(AVR_PROGRAMMER avrispmkII)
set(AVR_MCU atmega8)
set(AVR_UPLOADTOOL_PORT usb)
set(CMAKE_BUILD_TYPE Release)

# needs to be defined for AVR toolchain
set(MCU_SPEED "4000000UL")

# some cmake necessities
set(CMAKE_FIND_ROOT_PATH "/usr/avr")
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_SYSTEM_INCLUDE_PATH "${CMAKE_FIND_ROOT_PATH}/include")
set(CMAKE_SYSTEM_LIBRARY_PATH "${CMAKE_FIND_ROOT_PATH}/lib")
#set(CMAKE_VERBOSE_MAKEFILE TRUE)

message(STATUS "Set CMAKE_FIND_ROOT_PATH to ${CMAKE_FIND_ROOT_PATH}")
message(STATUS "Set CMAKE_SYSTEM_INCLUDE_PATH to ${CMAKE_SYSTEM_INCLUDE_PATH}")
message(STATUS "Set CMAKE_SYSTEM_LIBRARY_PATH to ${CMAKE_SYSTEM_LIBRARY_PATH}")

# common options for compiler and linker
set(AVR_COMMON_OPTIONS "-mmcu=${AVR_MCU} -DF_CPU=${MCU_SPEED} -fpack-struct -fshort-enums")

# compiler options
set(AVR_COMPILER_OPTIONS "${AVR_COMMON_OPTIONS} -Wall -Werror -pedantic -pedantic-errors -funsigned-char -funsigned-bitfields -ffunction-sections -c -std=gnu99")

# if not debug, assume release 
if(NOT CMAKE_BUILD_TYPE EQUAL Debug)

   set(CMAKE_C_FLAGS_RELEASE "-Os")
   set(CMAKE_CXX_FLAGS_RELEASE "-Os")

else(NOT CMAKE_BUILD_TYPE EQUAL Debug)

   set(CMAKE_C_FLAGS_DEBUG "-O0 -save-temps")
   set(CMAKE_CXX_FLAGS_DEBUG "-O0 -save-temps")

endif(NOT CMAKE_BUILD_TYPE EQUAL Debug)

# include search paths
include_directories(${AVR-EXAMPLE_SOURCE_DIR}/mylib)

# building library and application in their subdirectories
add_subdirectory(mylib)
add_subdirectory(app)

