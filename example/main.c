/*********************
 * \file main.c
 * \author Matthias Kleemann
 *
 */

#include <avr/io.h>
#include <util/delay.h>

#include "mylib.h"

int main(void)
{
   initPort();

   while(1)
   {
      togglePin();
   }
}

