# executables in use
find_program(AVR_CC avr-gcc)
find_program(AVR_CXX avr-g++)
find_program(AVR_OBJCOPY avr-objcopy)
find_program(AVR_SIZE_TOOL avr-size)

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
      CACHE STRING "Set default MCU: atmega8"
      )
endif(NOT AVR_MCU)

if(NOT CMAKE_BUILD_TYPE)
   set(CMAKE_BUILD_TYPE Release)
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

add_definitions( -Wall
                 -Werror
                 -pedantic
                 -pedantic-errors
                 -mmcu=${AVR_MCU}
                 -funsigned-char
                 -funsigned-bitfields
                 -ffunction-sections
                 -fpack-struct
                 -fshort-enums
                 -c
                 -std=gnu99
                 -DF_CPU=${MCU_SPEED}
               )

# if not Debug, assume Release 
if(CMAKE_BUILD_TYPE NOT EQUAL Debug)

   add_definitions( -Os 
                  )

else(CMAKE_BUILD_TYPE NOT EQUAL Debug)

   add_definitions( -O0 
                    -save-temps
                  )

endif(CMAKE_BUILD_TYPE NOT EQUAL Debug)

