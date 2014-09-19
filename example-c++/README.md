# (Very) simple C++ example for AVR cmake toolchain

Instead of using the toolchain file during the command line call, it is simply included
into the main CMakeLists.txt. This works as well, it depends on you how to use it.

```cmake
[...]
### END TOOLCHAIN SETUP AREA #############################################

include(../generic-gcc-avr.cmake)

##########################################################################
# name your project
##########################################################################
project(AVR-CPP-EXAMPLE)

[...]
```

Currently it's quite hardcoded reflecting the file structure of this toolchain. You should
use a position within you source tree to be referenced too. This could be done using the
toolchain as a submodule, like 

```cmake
include(${CMAKE_SOURCE_DIR}/${PATH/TO/CMAKE-TOOLCHAIN/SUBMODULE}/generic-gcc-avr.cmake)
```

The simple call to create the build tree is now

```bash
cmake <path/to/repository>
```
Enjoy.

