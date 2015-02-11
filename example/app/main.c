/**
 * \brief Simple application to toggle an AVR output for a LED.
 *
 * \file main.c
 * \author Matthias Kleemann
 */

#include <avr/io.h>
#include "mylib.h"

/**
 * \brief main loop
 * Within the main loop the LED port(s) are initialized and toggled, using mylib. The
 * main loop never ends until switching off the AVR itself.
 */
int main(void)
{
   /* test the GNU __extension__ with -pedantic settings */
   uint8_t someBinVar = __extension__ 0b01011010;

   DDRB |= someBinVar;

   initPort();

   while(1)
   {
      togglePin();
   }
}

