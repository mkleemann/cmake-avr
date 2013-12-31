cmake-avr - a cmake toolchain for AVR projects
==============================================

### Testing the example provided

The toolchain was created and tested within the following environment:

* Arch Linux with kernel 3.12.5-1-ARCH
* cmake version 2.8.12.1
* GNU Make 4.0
* avr-gcc (GCC) 4.8.2
* avr-binutils 2.23.2-1
* git version 1.8.5.2

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

This just creates the example, but does not upload it. For all possible targets, you need to run

```
make help
```

after running the `cmake` command.

### ToDo

- [ ] export ELF target for target_link_libraries command
- [X] cleanup baudrate and other AVRDUDE settings
- [ ] test in Windows environment
- ~~[ ] set required variables as REQUIRED~~
- [X] use add_definition() instead of variables for compiler settings
- [ ] some more tests with upload and fuses
 
