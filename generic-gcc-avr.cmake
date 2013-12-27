# executables in use
find_program(AVR_CC avr-gcc)
find_program(AVR_CXX avr-g++)
find_program(AVR_OBJCOPY avr-objcopy)
find_program(AVR_SIZE_TOOL avr-size)
find_program(AVR_OBJDUMP avr-objdump)

# mandatory, but can be overwritten
if(NOT AVR_UPLOADTOOL)
   set(AVR_UPLOADTOOL avrdude
      CACHE STRING "Set default upload tool: avrdude"
      )
   find_program(AVR_UPLOADTOOL avrdude)
endif(NOT AVR_UPLOADTOOL)

if(NOT AVR_PROGRAMMER)
   set(AVR_PROGRAMMER avrispmkII
      CACHE STRING "Set default programmer hardware model: avrispmkII"
      )
endif(NOT AVR_PROGRAMMER)

if(NOT AVR_MCU)
   set(AVR_MCU atmega8
      CACHE STRING "Set default MCU: atmega8 (see 'avr-gcc --target-help' for valid values)"
      )
endif(NOT AVR_MCU)

if(NOT CMAKE_BUILD_TYPE)
   set(CMAKE_BUILD_TYPE Release
     CACHE STRING "Choose cmake build type: None Debug Release RelWithDebInfo MinSizeRel."
     FORCE
     )
endif(NOT CMAKE_BUILD_TYPE)


# options
set(AVR_UPLOADTOOL_OPTIONS
   CACHE STRING "Additional upload tool options"
   )



# toolchain starts with defining mandatories
set(CMAKE_SYSTEM_NAME generic)
set(CMAKE_C_COMPILER ${AVR_CC})
set(CMAKE_CXX_COMPILER ${AVR_CXX})

# compiler options
set(AVR_COMMON_OPTIONS -mmcu=${AVR_MCU}
                       -fpack-struct
                       -fshort-enums
   )

set(AVR_COMPILER_OPTIONS ${AVR_COMMON_OPTIONS}
                         -Wall
                         -Werror
                         -pedantic
                         -pedantic-errors
                         -funsigned-char
                         -funsigned-bitfields
                         -ffunction-sections
                         -c
                         -std=gnu99
                         -DF_CPU=${MCU_SPEED}
                         -save-temps
   )

# if not debug, assume release 
if(CMAKE_BUILD_TYPE NOT EQUAL Debug)

   set(AVR_COMPILER_BUILDTYPE_OPTIONS ${AVR_COMPILER_OPTIONS} 
                                      -Os 
      )

else(CMAKE_BUILD_TYPE NOT EQUAL Debug)

   set(AVR_COMPILER_BUILDTYPE_OPTIONS ${AVR_COMPILER_OPTIONS} 
                                      -O0
      )

endif(CMAKE_BUILD_TYPE NOT EQUAL Debug)

# function definitions
function(add_avr_executable EXECUTABLE_NAME)

   set(elf_file ${EXECUTABLE_NAME}-${AVR_MCU}.elf)
   set(hex_file ${EXECUTABLE_NAME}-${AVR_MCU}.hex)
   set(map_file ${EXECUTABLE_NAME}-${AVR_MCU}.map)
   set(eeprom_image ${EXECUTABLE_NAME}-eeprom.hex)

   # elf file
   add_executable(${elf_file} EXCLUDE_FROM_ALL ${ARGN})
   
   set_target_properties(
      ${elf_file}
      PROPERTIES
         COMPILE_FLAGS "${AVR_COMPILER_BUILDTYPE_OPTIONS}"
         LINK_FLAGS "${AVR_COMMON_OPTIONS} -Wl,-Map,${map_file}"
   )
   
   add_custom_command(
      OUTPUT ${hex_file}
      COMMAND
         ${AVR_OBJCOPY} -j .text -j .data -O ihex ${elf_file} ${hex_file}
      COMMAND
         ${AVR_SIZE_TOOL} ${elf_file}
      DEPENDS ${elf_file}
   )

   # eeprom
   add_custom_command(
      OUTPUT ${eeprom_image}
      COMMAND
         ${AVR_OBJCOPY} -j .eeprom --change-section-lma .eeprom=0 -O ihex ${elf_file} ${eeprom_image}
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

   # upload - TODO: make it more general; now it's avrdude
   add_custom_target(
      upload_${EXECUTABLE_NAME}
      ${AVR_UPLOADTOOL} -p ${AVR_MCU} -c ${AVR_PROGRAMMER} ${AVR_UPLOADTOOL_OPTIONS}
         -U flash:w:${hex_file}
         -U eeprom:w:${eeprom_image}
         -P usb -b 115200
      DEPENDS ${hex_file} ${eeprom_image}
      COMMENT "Uploading ${hex_file} to ${AVR_MCU} using ${AVR_PROGRAMMER}"
   )

   # disassemble
   add_custom_target(
      disassemble_${EXECUTABLE_NAME}
      ${AVR_OBJDUMP} -h -S ${elf_file} > ${EXECUTABLE_NAME}.lst
      DEPENDS ${elf_file}
   )

endfunction(add_avr_executable)

function(add_avr_library LIBRARY_NAME)
   
   set(lib_file ${LIBRARYNAME}-${AVR_MCU})

   add_library(${lib_file} STATIC ${ARGN})

   set_target_properties(
      ${lib_file}
      PROPERTIES
         COMPILE_FLAGS -mmcu=${AVR_MCU}
   )

endfunction(add_avr_library)

