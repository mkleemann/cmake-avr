##################################################################################
# Default setup for a "docu" target using doxygen.
##################################################################################

##################################################################################
# find doxygen
##################################################################################
find_package(Doxygen)

##################################################################################
# create docu target, if package was found
##################################################################################
if(DOXYGEN_FOUND)
   # find_file does not work as expected (WinXP, cmake 2.8.10-2.8.12)
   find_program(conf_file NAMES "doxygen.conf" PATHS ${CMAKE_CURRENT_SOURCE_DIR}) 
   
   if(NOT conf_file)
      message(WARNING "No doxygen configuration found. Please create 
                       '${CMAKE_CURRENT_SOURCE_DIR}/doxygen.conf'. 
                       No documentation target created.")
   else(NOT conf_file)
      # configuration input and output
      set(DOXYGEN_CONF_IN ${conf_file})
      set(DOXYGEN_CONF_OUT doxygen.conf)

      # set to override variable within configuration
      set(DOXYGEN_INPUT_PATH "\"${CMAKE_CURRENT_SOURCE_DIR}\"")
      set(DOXYGEN_OUTPUT_PATH "\"${CMAKE_CURRENT_BINARY_DIR}\"")
      set(DOXYGEN_IMAGE_PATH "\"${CMAKE_CURRENT_SOURCE_DIR}\"")
      set(DOXYGEN_DOTFILE_PATH "\"${CMAKE_CURRENT_SOURCE_DIR}\"")

      # cleanup properties from html output
      set_property(DIRECTORY APPEND PROPERTY ADDITIONAL_MAKE_CLEAN_FILES
                      "${CMAKE_CURRENT_BINARY_DIR}/html"
      )

      # copy configuration file and replace input path
      configure_file( ${DOXYGEN_CONF_IN}
                      ${DOXYGEN_CONF_OUT}
                      @ONLY
      )

      # add documentation target
      add_custom_target(
          docu
          COMMAND ${DOXYGEN_EXECUTABLE} ${DOXYGEN_CONF_OUT}
          COMMENT "Create HTML documentation."
      )
   endif(NOT conf_file)
else(DOXYGEN_FOUND)
   message(WARNING "Doxygen not found. Documentation target not created.")
endif(DOXYGEN_FOUND)


