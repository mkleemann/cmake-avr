## TODO:

- remove fuses requirement
- if not fuses then no set_fuses
  - or set_fuses with fuses values as parameters
- maybe use CMAKE_CXX_FLAGS instead of add_definitions
- ~~add SET(CMAKE_SHARED_LIBRARY_LINK_C_FLAGS "") and SET(CMAKE_SHARED_LIBRARY_LINK_CXX_FLAGS "")~~
- better way to use WITH_MCU
- change upload_{project_name} to simply upload
- add macro definition for libs, e.g. `atmega8` &rarr; `__AVR_ATmega8__`
- https://forum.qt.io/topic/72414/qtcreator-doesn-t-open-the-cmake-wizard/4
