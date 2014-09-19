# (Very) simple C example for AVR cmake toolchain

Using the example needs to point to a special case within the CMakeLists.txt.
Setting up the toolchain variables must be done prior calling the project(...)
function. See also issue #1 for details.

```cmake
[...]
### END TOOLCHAIN SETUP AREA #############################################

##########################################################################
# name your project
##########################################################################
project(AVR-CPP-EXAMPLE)

[...]
```

The call to create the build tree is now

```bash
cmake -DCMAKE_TOOLCHAIN_FILE=<path/to/toolchain>/generic-gcc-avr.cmake <path/to/repository>
```
Enjoy.

