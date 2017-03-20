#!/bin/bash 
 
# Make sure only root can run our script 
if [[ $EUID -ne 0 ]]; then 
   	echo "This script must be run as root" 1>&2 
   	exit 1 
fi 

if [ ! -d /usr/avr/cmake-* ]; then
	echo "Сmake is not installed" 1>&2 
	exit 1
fi

cp -f CMakeModule/FindGeneric-AVR-GCC.cmake /usr/share/cmake-*/Modules/ 
 
echo "Done"