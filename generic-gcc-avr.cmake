##########################################################################
# executables in use
##########################################################################
find_program(AVR_CC avr-gcc)
find_program(AVR_CXX avr-g++)
find_program(AVR_OBJCOPY avr-objcopy)
find_program(AVR_SIZE_TOOL avr-size)
find_program(AVR_OBJDUMP avr-objdump)

##########################################################################
# toolchain starts with defining mandatory variables
##########################################################################
set(CMAKE_SYSTEM_NAME generic)
set(CMAKE_SYSTEM_PROCESSOR avr)
set(CMAKE_C_COMPILER ${AVR_CC})
set(CMAKE_CXX_COMPILER ${AVR_CXX})

##########################################################################
# some necessary tools and variables for AVR builds, which may not 
# defined yet
# - AVR_UPLOADTOOL
# - AVR_UPLOADTOOL_PORT
# - AVR_PROGRAMMER
# - AVR_MCU
##########################################################################

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

# default programmer (hardware)
if(NOT AVR_PROGRAMMER)
   set(
      AVR_PROGRAMMER avrispmkII
      CACHE STRING "Set default programmer hardware model: avrispmkII"
   )
endif(NOT AVR_PROGRAMMER)

# default MCU (chip)
if(NOT AVR_MCU)
   set(
      AVR_MCU atmega8
      CACHE STRING "Set default MCU: atmega8 (see 'avr-gcc --target-help' for valid values)"
   )
endif(NOT AVR_MCU)

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
        (CMAKE_BUILD_TYPE MATCHES Debug)))
   set(
      CMAKE_BUILD_TYPE Release
      CACHE STRING "Choose cmake build type: Debug Release RelWithDebInfo"
      FORCE
   )
endif(NOT ((CMAKE_BUILD_TYPE MATCHES Release) OR
           (CMAKE_BUILD_TYPE MATCHES RelWithDebInfo) OR
           (CMAKE_BUILD_TYPE MATCHES Debug)))
 
##########################################################################

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

   # set file names
   set(elf_file ${EXECUTABLE_NAME}-${AVR_MCU}.elf)
   set(hex_file ${EXECUTABLE_NAME}-${AVR_MCU}.hex)
   set(map_file ${EXECUTABLE_NAME}-${AVR_MCU}.map)
   set(eeprom_image ${EXECUTABLE_NAME}-eeprom.hex)
  
   # elf file
   add_executable(${elf_file} EXCLUDE_FROM_ALL ${ARGN})
   
   set_target_properties(
      ${elf_file}
      PROPERTIES
         COMPILE_FLAGS "-mmcu=${AVR_MCU}"
         LINK_FLAGS "-mmcu=${AVR_MCU} -Wl,--gc-sections -mrelax -Wl,-Map,${map_file}"
   )
   
   add_custom_command(
      OUTPUT ${hex_file}
      COMMAND
         ${AVR_OBJCOPY} -j .text -j .data -O ihex ${elf_file} ${hex_file}
      COMMAND
         ${AVR_SIZE_TOOL} -C --mcu=${AVR_MCU} ${elf_file}
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

   add_custom_target(
      ${EXECUTABLE_NAME}
      ALL
      DEPENDS ${hex_file} ${eeprom_image}
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
         -U flash:w:${hex_file}
         -U eeprom:w:${eeprom_image}
         -P ${AVR_UPLOADTOOL_PORT} 
      DEPENDS ${hex_file} ${eeprom_image}
      COMMENT "Uploading ${hex_file} to ${AVR_MCU} using ${AVR_PROGRAMMER}"
   )

   # get status
   add_custom_target(
      get_status
      ${AVR_UPLOADTOOL} -p ${AVR_MCU} -c ${AVR_PROGRAMMER} -P ${AVR_UPLOADTOOL_PORT} -n -v
      COMMENT "Get status from ${AVR_MCU}"
   )

   # get fuses
   add_custom_target(
      get_fuses
      ${AVR_UPLOADTOOL} -p ${AVR_MCU} -c ${AVR_PROGRAMMER} -P ${AVR_UPLOADTOOL_PORT} -n
         -U lfuse:r:-:b 
         -U hfuse:r:-:b
      COMMENT "Get fuses from ${AVR_MCU}"
   )

   # set fuses
   add_custom_target(
      set_fuses
      ${AVR_UPLOADTOOL} -p ${AVR_MCU} -c ${AVR_PROGRAMMER} -P ${AVR_UPLOADTOOL_PORT}
         -U lfuse:w:${AVR_L_FUSE}:m 
         -U hfuse:w:${AVR_H_FUSE}:m
         COMMENT "Setup: High Fuse: ${AVR_H_FUSE} Low Fuse: ${AVR_L_FUSE}"
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
# Calls add_library with a concatenated name <LIBRARY_NAME>-${AVR_MCU}.
# This needs to be used for linking against the library, e.g. calling
# target_link_libraries(...).
##########################################################################
function(add_avr_library LIBRARY_NAME)
   
   set(lib_file ${LIBRARY_NAME}-${AVR_MCU})

   add_library(${lib_file} STATIC ${ARGN})

   set_target_properties(
      ${lib_file}
      PROPERTIES
         COMPILE_FLAGS "-mmcu=${AVR_MCU}"
   )

endfunction(add_avr_library)

