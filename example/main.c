/*********************
 * \file main.c
 * \author Matthias Kleemann
 *
 */

#include <avr/io.h>
#include <util/delay.h>

int main(void)
{
   /* output pin 2 at port D */
   DDRD |= (1 << PIN2);

   while(1)
   {
      // toggle pin
      PORTD ^= (1 << PIN2);
      // wait for 250ms
      _delay_ms(250);
   }
}

