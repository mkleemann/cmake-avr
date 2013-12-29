/*********************
 * \file main.c
 * \author Matthias Kleemann
 *
 */

#include "mylib.h"

int main(void)
{
   initPort();

   while(1)
   {
      togglePin();
   }
}

