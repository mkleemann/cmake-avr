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

##########################################################################
# The toolchain requires some variables set.
#
# AVR_MCU (default: atmega8)
#     the type of AVR the application is built for
# AVR_MCU_SPEED (default: 16000000UL)
#     clock frequency for the MCU used
# AVR_L_FUSE (NO DEFAULT)
#     the LOW fuse value for the MCU used
# AVR_H_FUSE (NO DEFAULT)
#     the HIGH fuse value for the MCU used
# AVR_E_FUSE (NO DEFAULT)
#     the EXTENDED fuse value for the MCU used
# AVR_UPLOADTOOL (default: avrdude)
#     the application used to upload to the MCU
#     NOTE: The toolchain is currently quite specific about
#           the commands used, so it needs tweaking.
# AVR_UPLOADTOOL_PORT (default: usb)
#     the port used for the upload tool, e.g. usb
# AVR_PROGRAMMER (default: avrispmkII)
#     the programmer hardware used, e.g. avrispmkII
# AVR_UPLOAD_BAUDRATE (default: 115200)
#     the upload speed fot the upload tool
# AVR_UPLOADTOOL_OPTIONS (default: "")
#     the additional parameters for AVR_UPLOADTOOL
##########################################################################

##########################################################################
# options
##########################################################################
option(WITH_MCU "Add the mCU type to the target file name." ON)
option(CXX_NO_THREAD_SAFE_STATICS "Don't use fread save statics in C++" ON)

##########################################################################
# executables in use
##########################################################################
find_program(AVR_CC avr-gcc)
find_program(AVR_CXX avr-g++)
find_program(AVR_OBJCOPY avr-objcopy)
find_program(AVR_SIZE_TOOL avr-size)
find_program(AVR_OBJDUMP avr-objdump)
find_program(AVR_ARCHIVER avr-ar)
find_program(AVR_LINKER avr-ld)
find_program(AVR_NM avr-nm)
find_program(AVR_RANLIB avr-ranlib)
find_program(AVR_STRIP avr-strip)
find_program(AVR_ASM avra)
find_program(AVR_AS avr-as)

##########################################################################
# toolchain starts with defining mandatory variables
##########################################################################
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR avr)
set(CMAKE_C_COMPILER ${AVR_CC})
set(CMAKE_CXX_COMPILER ${AVR_CXX})
set(CMAKE_OBJCOPY ${AVR_OBJCOPY})
set(CMAKE_SIZE_TOOL ${AVR_SIZE_TOOL})
set(CMAKE_OBJDUMP ${AVR_OBJDUMP})
set(CMAKE_AR ${AVR_ARCHIVER})
set(CMAKE_LINKER ${AVR_LINKER})
set(CMAKE_NM ${AVR_NM})
set(CMAKE_RANLIB ${AVR_RANLIB})
set(CMAKE_STRIP ${AVR_STRIP})
set(CMAKE_ASM_COMPILER ${AVR_AS})
#set(MCU_MAX_SIZE 28672) #TODO use this!


##################################################################################
# some cmake cross-compile necessities
##################################################################################
if(DEFINED ENV{AVR_FIND_ROOT_PATH})
    set(CMAKE_FIND_ROOT_PATH $ENV{AVR_FIND_ROOT_PATH})
else(DEFINED ENV{AVR_FIND_ROOT_PATH})
    if(EXISTS "/opt/local/avr")
      set(CMAKE_FIND_ROOT_PATH "/opt/local/avr")
    elseif(EXISTS "/usr/avr")
      set(CMAKE_FIND_ROOT_PATH "/usr/avr")
    elseif(EXISTS "/usr/lib/avr")
      set(CMAKE_FIND_ROOT_PATH "/usr/lib/avr")
    elseif(EXISTS "/usr/local/CrossPack-AVR")
      set(CMAKE_FIND_ROOT_PATH "/usr/local/CrossPack-AVR")
    else(EXISTS "/opt/local/avr")
      message(FATAL_ERROR "Please set AVR_FIND_ROOT_PATH in your environment.")
    endif(EXISTS "/opt/local/avr")
endif(DEFINED ENV{AVR_FIND_ROOT_PATH})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
# not added automatically, since CMAKE_SYSTEM_NAME is "generic"
set(CMAKE_SYSTEM_INCLUDE_PATH "${CMAKE_FIND_ROOT_PATH}/include")
set(CMAKE_SYSTEM_LIBRARY_PATH "${CMAKE_FIND_ROOT_PATH}/lib")

include_directories(${CMAKE_FIND_ROOT_PATH}/include)

##########################################################################
# some necessary tools and variables for AVR builds, which may not
# defined yet
# - AVR_MCU
# - AVR_MCU_SPEED
# - AVR_UPLOADTOOL
# - AVR_UPLOADTOOL_PORT
# - AVR_UPLOADTOOL_OPTIONS
# - AVR_PROGRAMMER
# - AVR_UPLOAD_BAUDRATE
# - AVR_SIZE_ARGS
# they have a default values
##########################################################################

# default MCU (chip)
if(NOT AVR_MCU)
   set(
      AVR_MCU atmega8
      CACHE STRING "Set default MCU: atmega8 (see 'avr-gcc --target-help' for valid values)"
   )
endif(NOT AVR_MCU)

# default MCU speed (frequency)
if(NOT AVR_MCU_SPEED)
	set(
		AVR_MCU_SPEED "16000000UL"
		CACHE STRING "Set default MCU SPEED: 16000000 MHz (see 'avr-gcc --help' for valid values)"
	)
	add_definitions("-DF_CPU=${AVR_MCU_SPEED}")
else(NOT AVR_MCU_SPEED)
	add_definitions("-DF_CPU=${AVR_MCU_SPEED}")
endif(NOT AVR_MCU_SPEED)

# default upload tool
if(NOT AVR_UPLOADTOOL)
   set(
      AVR_UPLOADTOOL avrdude
      CACHE STRING "Set default upload tool: avrdude"
   )
   find_program(AVR_UPLOADTOOL avrdude)
endif(NOT AVR_UPLOADTOOL)

# default upload tool port
if(NOT AVR_UPLOADTOOL_PORT)
   set(
      AVR_UPLOADTOOL_PORT usb
      CACHE STRING "Set default upload tool port: usb"
   )
endif(NOT AVR_UPLOADTOOL_PORT)

#default upload options
if(NOT AVR_UPLOADTOOL_OPTIONS)
	set(
		AVR_UPLOADTOOL_OPTIONS ""
		CACHE STRING "Set additional avrdude options (see 'avrdude --help')"
	)
endif(NOT AVR AVR_UPLOADTOOL_OPTIONS)

# default programmer (hardware)
if(NOT AVR_PROGRAMMER)
   set(
      AVR_PROGRAMMER avrispmkII
      CACHE STRING "Set default programmer hardware model: avrispmkII"
   )
endif(NOT AVR_PROGRAMMER)

# default upload baudrate
if(NOT AVR_UPLOAD_BAUDRATE)
   set(
      AVR_UPLOAD_BAUDRATE 115200
      CACHE STRING "Set default upload baudrate: 115200"
   )
endif(NOT AVR_UPLOAD_BAUDRATE)

#default avr-size args
if(NOT AVR_SIZE_ARGS)
   if(APPLE)
      set(AVR_SIZE_ARGS -B)
   else(APPLE)
      set(AVR_SIZE_ARGS -C;--mcu=${AVR_MCU})
   endif(APPLE)
endif(NOT AVR_SIZE_ARGS)

##########################################################################
# check build types:
# - Debug
# - Release
# - RelWithDebInfo
#
# Release is chosen, because of some optimized functions in the
# AVR toolchain, e.g. _delay_ms().
##########################################################################
if(NOT ((CMAKE_BUILD_TYPE MATCHES Release) OR
        (CMAKE_BUILD_TYPE MATCHES RelWithDebInfo) OR
        (CMAKE_BUILD_TYPE MATCHES Debug) OR
        (CMAKE_BUILD_TYPE MATCHES MinSizeRel)))
   set(
      CMAKE_BUILD_TYPE Release
      CACHE STRING "Choose cmake build type: Debug Release RelWithDebInfo MinSizeRel"
      FORCE
   )
endif(NOT ((CMAKE_BUILD_TYPE MATCHES Release) OR
           (CMAKE_BUILD_TYPE MATCHES RelWithDebInfo) OR
           (CMAKE_BUILD_TYPE MATCHES Debug) OR
           (CMAKE_BUILD_TYPE MATCHES MinSizeRel)))

##########################################################################
# delete linker flags for shared libs
##########################################################################
SET(CMAKE_SHARED_LIBRARY_LINK_C_FLAGS "")
SET(CMAKE_SHARED_LIBRARY_LINK_CXX_FLAGS "")

##########################################################################
# status messages
##########################################################################
message(STATUS "Current MCU is set to: ${AVR_MCU}")
message(STATUS "Current MCU speed is set to: ${AVR_MCU_SPEED}")
message(STATUS "Current H_FUSE is set to: ${AVR_H_FUSE}")
message(STATUS "Current L_FUSE is set to: ${AVR_L_FUSE}")
message(STATUS "Current E_FUSE is set to: ${AVR_E_FUSE}")
message(STATUS "Current uploadtool is: ${AVR_UPLOADTOOL}")
message(STATUS "Current upload port is: ${AVR_UPLOADTOOL_PORT}")
message(STATUS "Current programmer is: ${AVR_PROGRAMMER}")
message(STATUS "Current upload speed is: ${AVR_UPLOAD_BAUDRATE}")
message(STATUS "Current uploadtool options are: ${AVR_UPLOADTOOL_OPTIONS}")

##########################################################################
# status messages for generating
##########################################################################
message(STATUS "Set CMAKE_FIND_ROOT_PATH to ${CMAKE_FIND_ROOT_PATH}")
message(STATUS "Set CMAKE_SYSTEM_INCLUDE_PATH to ${CMAKE_SYSTEM_INCLUDE_PATH}")
message(STATUS "Set CMAKE_SYSTEM_LIBRARY_PATH to ${CMAKE_SYSTEM_LIBRARY_PATH}")

##########################################################################
# set compiler options for build types
##########################################################################
if(CMAKE_BUILD_TYPE MATCHES Release)
   set(CMAKE_C_FLAGS_RELEASE "-Os")
   set(CMAKE_CXX_FLAGS_RELEASE "-Os")
endif(CMAKE_BUILD_TYPE MATCHES Release)

if(CMAKE_BUILD_TYPE MATCHES RelWithDebInfo)
   set(CMAKE_C_FLAGS_RELWITHDEBINFO "-Os -save-temps -g -gdwarf-3 -gstrict-dwarf")
   set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-Os -save-temps -g -gdwarf-3 -gstrict-dwarf")
endif(CMAKE_BUILD_TYPE MATCHES RelWithDebInfo)

if(CMAKE_BUILD_TYPE MATCHES Debug)
   set(CMAKE_C_FLAGS_DEBUG "-O0 -save-temps -g -gdwarf-3 -gstrict-dwarf")
   set(CMAKE_CXX_FLAGS_DEBUG "-O0 -save-temps -g -gdwarf-3 -gstrict-dwarf")
endif(CMAKE_BUILD_TYPE MATCHES Debug)

##########################################################################
# thread safe option
##########################################################################
if(CXX_NO_THREAD_SAFE_STATICS)
   set(CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} -fno-threadsafe-statics)
endif(CXX_NO_THREAD_SAFE_STATICS)

##########################################################################
# target file name add-on option
##########################################################################
if(WITH_MCU)
   set(MCU_TYPE_FOR_FILENAME "-${AVR_MCU}")
else(WITH_MCU)
   set(MCU_TYPE_FOR_FILENAME "")
endif(WITH_MCU)

##########################################################################
# add_avr_executable
# - IN_VAR: EXECUTABLE_NAME
#
# Creates targets and dependencies for AVR toolchain, building an
# executable. Calls add_executable with ELF file as target name, so
# any link dependencies need to be using that target, e.g. for
# target_link_libraries(<EXECUTABLE_NAME>-${AVR_MCU}.elf ...).
##########################################################################
function(add_avr_executable EXECUTABLE_NAME)
   if(NOT ARGN)
      message(FATAL_ERROR "No source files given for ${EXECUTABLE_NAME}.")
   endif(NOT ARGN)

   # set file names
   set(elf_file ${EXECUTABLE_NAME}${MCU_TYPE_FOR_FILENAME}.elf)
   set(hex_file ${EXECUTABLE_NAME}${MCU_TYPE_FOR_FILENAME}.hex)
   set(bin_file ${EXECUTABLE_NAME}${MCU_TYPE_FOR_FILENAME}.bin)
   set(map_file ${EXECUTABLE_NAME}${MCU_TYPE_FOR_FILENAME}.map)
   set(eeprom_image ${EXECUTABLE_NAME}${MCU_TYPE_FOR_FILENAME}-eeprom.hex)

   # elf file
   add_executable(${elf_file} EXCLUDE_FROM_ALL ${ARGN})

   set_target_properties(
      ${elf_file}
      PROPERTIES
         COMPILE_FLAGS "-mmcu=${AVR_MCU}"
         LINK_FLAGS "-mmcu=${AVR_MCU} -Wl,--gc-sections -mrelax -Wl,-Map,${map_file}"
   )

   # hex file
   add_custom_command(
      OUTPUT ${hex_file}
      COMMAND
         ${AVR_OBJCOPY} -j .text -j .data -O ihex ${elf_file} ${hex_file}
      COMMAND
         ${AVR_SIZE_TOOL} ${AVR_SIZE_ARGS} ${elf_file}
      DEPENDS ${elf_file}
   )

   # bin file
   add_custom_command(
      OUTPUT ${bin_file}
      COMMAND
         ${AVR_OBJCOPY} -j .text -j .data -O binary ${elf_file} ${bin_file}
      COMMAND
         ${AVR_SIZE_TOOL} ${AVR_SIZE_ARGS} ${elf_file}
      DEPENDS ${elf_file}
   )

   # eeprom
   add_custom_command(
      OUTPUT ${eeprom_image}
      COMMAND
         ${AVR_OBJCOPY} -j .eeprom --set-section-flags=.eeprom=alloc,load
            --change-section-lma .eeprom=0 --no-change-warnings
            -O ihex ${elf_file} ${eeprom_image}
      DEPENDS ${elf_file}
   )

   #
   add_custom_target(
      ${EXECUTABLE_NAME}
      ALL
      DEPENDS ${hex_file} ${eeprom_image}
   )

   #
   set_target_properties(
      ${EXECUTABLE_NAME}
      PROPERTIES
         OUTPUT_NAME "${elf_file}"
   )

   # size
   add_custom_target(
      size
         ${CMAKE_SIZE_TOOL} ${AVR_SIZE_ARGS} ${elf_file}
      DEPENDS
         ${elf_file}
   )

   # clean
   get_directory_property(clean_files ADDITIONAL_MAKE_CLEAN_FILES)
   set_directory_properties(
      PROPERTIES
         ADDITIONAL_MAKE_CLEAN_FILES "${map_file}"
   )

   # upload - with avrdude
   add_custom_target(
      upload_${EXECUTABLE_NAME}
      ${AVR_UPLOADTOOL} -p ${AVR_MCU} -c ${AVR_PROGRAMMER} ${AVR_UPLOADTOOL_OPTIONS}
         -b ${AVR_UPLOAD_BAUDRATE}
         -U flash:w:${hex_file}
         -P ${AVR_UPLOADTOOL_PORT}
      DEPENDS ${hex_file}
      COMMENT "Uploading ${hex_file} to ${AVR_MCU} using ${AVR_PROGRAMMER}"
   )

   # upload eeprom only - with avrdude
   # see also bug http://savannah.nongnu.org/bugs/?40142
   add_custom_target(
      upload_eeprom
      ${AVR_UPLOADTOOL} -p ${AVR_MCU} -c ${AVR_PROGRAMMER} ${AVR_UPLOADTOOL_OPTIONS}
         -b ${AVR_UPLOAD_BAUDRATE}
         -U eeprom:w:${eeprom_image}
         -P ${AVR_UPLOADTOOL_PORT}
      DEPENDS ${eeprom_image}
      COMMENT "Uploading ${eeprom_image} to ${AVR_MCU} using ${AVR_PROGRAMMER}"
   )

   # get status
   add_custom_target(
      get_status
      ${AVR_UPLOADTOOL} -p ${AVR_MCU} -c ${AVR_PROGRAMMER} -P ${AVR_UPLOADTOOL_PORT}
         -n -v -b ${AVR_UPLOAD_BAUDRATE} ${AVR_UPLOADTOOL_OPTIONS}
      COMMENT "Get status from ${AVR_MCU}"
   )

   # get fuses
   add_custom_target(
      get_fuses
      ${AVR_UPLOADTOOL} -p ${AVR_MCU} -c ${AVR_PROGRAMMER} -P ${AVR_UPLOADTOOL_PORT} -n
         -U lfuse:r:-:b
         -U hfuse:r:-:b
         -U efuse:r:-:b
      COMMENT "Get fuses from ${AVR_MCU}"
   )

   # set fuses
   add_custom_target(
      set_fuses
      ${AVR_UPLOADTOOL} -p ${AVR_MCU} -c ${AVR_PROGRAMMER} -P ${AVR_UPLOADTOOL_PORT}
         -U lfuse:w:${AVR_L_FUSE}:m
         -U hfuse:w:${AVR_H_FUSE}:m
         -U efuse:w:${AVR_E_FUSE}:m
         COMMENT "Setup: High Fuse: ${AVR_H_FUSE} Low Fuse: ${AVR_L_FUSE} Extended Fuse ${AVR_E_FUSE}"
   )

   # get oscillator calibration
   add_custom_target(
      get_calibration
         ${AVR_UPLOADTOOL} -p ${AVR_MCU} -c ${AVR_PROGRAMMER} -P ${AVR_UPLOADTOOL_PORT}
         -U calibration:r:${AVR_MCU}_calib.tmp:r
         COMMENT "Write calibration status of internal oscillator to ${AVR_MCU}_calib.tmp."
   )

   # set oscillator calibration
   add_custom_target(
      set_calibration
      ${AVR_UPLOADTOOL} -p ${AVR_MCU} -c ${AVR_PROGRAMMER} -P ${AVR_UPLOADTOOL_PORT}
         -U calibration:w:${AVR_MCU}_calib.hex
         COMMENT "Program calibration status of internal oscillator from ${AVR_MCU}_calib.hex."
   )

   # disassemble
   add_custom_target(
      disassemble_${EXECUTABLE_NAME}
      ${AVR_OBJDUMP} -h -S ${elf_file} > ${EXECUTABLE_NAME}.lst
      DEPENDS ${elf_file}
   )

endfunction(add_avr_executable)

##########################################################################
# add_avr_library
# - IN_VAR: LIBRARY_NAME
#
# Calls add_library with an optionally concatenated name
# <LIBRARY_NAME>${MCU_TYPE_FOR_FILENAME}.
# This needs to be used for linking against the library, e.g. calling
# target_link_libraries(...).
##########################################################################
function(add_avr_library LIBRARY_NAME)
   if(NOT ARGN)
      message(FATAL_ERROR "No source files given for ${LIBRARY_NAME}.")
   endif(NOT ARGN)

   set(lib_file ${LIBRARY_NAME}${MCU_TYPE_FOR_FILENAME})

   add_library(${lib_file} STATIC ${ARGN})

   set_target_properties(
      ${lib_file}
      PROPERTIES
         COMPILE_FLAGS "-mmcu=${AVR_MCU}"
         OUTPUT_NAME "${lib_file}"
   )

   if(NOT TARGET ${LIBRARY_NAME})
      add_custom_target(
         ${LIBRARY_NAME}
         ALL
         DEPENDS ${lib_file}
      )

      set_target_properties(
         ${LIBRARY_NAME}
         PROPERTIES
            OUTPUT_NAME "${lib_file}"
      )
   endif(NOT TARGET ${LIBRARY_NAME})

endfunction(add_avr_library)

##########################################################################
# avr_target_link_libraries
# - IN_VAR: EXECUTABLE_TARGET
# - ARGN  : targets and files to link to
#
# Calls target_link_libraries with AVR target names (concatenation,
# extensions and so on.
##########################################################################
function(avr_target_link_libraries EXECUTABLE_TARGET)
   if(NOT ARGN)
      message(FATAL_ERROR "Nothing to link to ${EXECUTABLE_TARGET}.")
   endif(NOT ARGN)

   get_target_property(TARGET_LIST ${EXECUTABLE_TARGET} OUTPUT_NAME)

   foreach(TGT ${ARGN})
      if(TARGET ${TGT})
         get_target_property(ARG_NAME ${TGT} OUTPUT_NAME)
         list(APPEND TARGET_LIST ${ARG_NAME})
      else(TARGET ${TGT})
         list(APPEND NON_TARGET_LIST ${TGT})
      endif(TARGET ${TGT})
   endforeach(TGT ${ARGN})

   target_link_libraries(${TARGET_LIST} ${NON_TARGET_LIST})
endfunction(avr_target_link_libraries EXECUTABLE_TARGET)
