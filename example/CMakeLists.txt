##################################################################################
# "THE ANY BEVERAGE-WARE LICENSE" (Revision 42 - based on beer-ware
# license):
# <dev@layer128.net> wrote this file. As long as you retain this notice
# you can do whatever you want with this stuff. If we meet some day, and
# you think this stuff is worth it, you can buy me a be(ve)er(age) in
# return. (I don't like beer much.)
#
# Matthias Kleemann
##################################################################################

cmake_minimum_required(VERSION 2.8)

### TOOLCHAIN SETUP AREA #########################################################
# Set any variables used in the toolchain prior project() call. In that
# case they are already set and used.
##################################################################################

##################################################################################
# tools to beused for programming the AVR
##################################################################################
set(AVR_UPLOADTOOL avrdude)
set(AVR_UPLOADTOOL_PORT usb)
set(AVR_PROGRAMMER avrispmkII)
set(AVR_UPLOAD_BAUDRATE 115200)
set(AVR_UPLOADTOOL_OPTIONS "")

set(WITH_MCU OFF)

##################################################################################
# AVR and fuses needs to be set
##################################################################################
set(AVR_MCU atmega16)
set(AVR_H_FUSE 0xd9)
set(AVR_L_FUSE 0xc3)

### END TOOLCHAIN SETUP AREA #####################################################

find_package(Generic-AVR-GCC)

##################################################################################
# name your project
##################################################################################
project(AVR-EXAMPLE)
set(CMAKE_BUILD_TYPE Release)

##################################################################################
# needs to be defined for AVR toolchain
##################################################################################
set(AVR_MCU_SPEED "4000000UL")

##################################################################################
# set command line arguments for compiler
##################################################################################
add_definitions("-fpack-struct")
add_definitions("-fshort-enums")
add_definitions("-Wall")
add_definitions("-Werror")
add_definitions("-pedantic")
add_definitions("-pedantic-errors")
add_definitions("-funsigned-char")
add_definitions("-funsigned-bitfields")
add_definitions("-ffunction-sections")
add_definitions("-c")
add_definitions("-std=gnu99")

##################################################################################
# include search paths
##################################################################################
include_directories(${AVR-EXAMPLE_SOURCE_DIR}/mylib)

##################################################################################
# building library and application in their subdirectories
##################################################################################
add_subdirectory(mylib)
add_subdirectory(app)

##################################################################################
# testing functions w/o source files - gets FATAL_ERROR
##################################################################################
# add_avr_executable(test_breaks_generation)
# add_avr_library(mytestlib_breaks_generation)

##################################################################################
# use default documentation target
##################################################################################
set(DOXYGEN_CONF_IN "doxygen.conf")
include("${PROJECT_SOURCE_DIR}/../Modules/defaultDocuTarget.cmake")
