cmake-avr - a cmake toolchain for AVR projects
==============================================

### Testing the example provided

The toolchain was created and tested within the following environment:

Linux
* Arch Linux with kernel 3.12.5-1-ARCH
* cmake version 2.8.12.1
* GNU Make 4.0
* avr-gcc (GCC) 4.8.2
* avr-binutils 2.23.2-1
* avr-libc 1.8.0-5
* git version 1.8.5.2

Windows XP
* cmake version 2.8.10.2
* GNU Make 3.81
* avr-gcc (AVR_8_bit_GNU_Toolchain_3.4.1_798) 4.6.2 (Atmel Studio 6)
* avr-binutils AVR_8_bit_GNU_Toolchain_3.4.1_798 (Atmel Studio 6)
* avr-libc AVR_8_bit_GNU_Toolchain_3.4.1_798 (Atmel Studio 6)
* git version 1.7.11.msysgit.1

**Note:**
If building in a Windows environment, you need to extent the values of the 
environment variable `PATH` to the location of the binaries, especially to 
find `make`. To enable a more general appraoch to different Windows toolchains,
the variable `AVR_FIND_ROOT_PATH` needs to be defined. Tested was it with the 
following setup:

```
PATH=...;d:/Program Files/Atmel/Atmel Studio 6.0/extensions/Atmel/AVRGCC/3.4.1.81/AVRToolchain/bin;...
AVR_FIND_RROT_PATH="d:/Program Files/Atmel/Atmel Studio 6.0/extensions/Atmel/AVRGCC/3.4.1.81/AVRToolchain/avr"
```

After getting the project

```
git clone git@github.com:mkleemann/cmake-avr.git /path/to/clone/in
```

you just need to run the following commands

```
mkdir -p /path/to/some/build/dir
cd /path/to/some/build/dir
cmake -DCMAKE_TOOLCHAIN_FILE=/path/to/clone/in/generic-gcc-avr.cmake /path/to/clone/in/example
make
```

For Windows use:
```
cmake -G "Unix Makefiles" -DCMAKE_TOOLCHAIN_FILE=/path/to/clone/in/generic-gcc-avr.cmake /path/to/clone/in/example
```

This just creates the example, but does not upload it. For all possible targets, you need to run

```
make help
```

after running the `cmake` command.

### ToDo

- [ ] export ELF target for target_link_libraries command
- [X] cleanup baudrate and other AVRDUDE settings
- [X] test in Windows environment
- ~~[ ] set required variables as REQUIRED~~
- [X] use add_definition() instead of variables for compiler settings
- [ ] some more tests with upload and fuses

