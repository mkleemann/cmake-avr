/**
 * \brief Implementation of some simple user functions.
 *
 * \file mylib.c
 * \author Matthias Kleemann
 */

#include <avr/io.h>
#include <util/delay.h>

#include "mylib.h"

/**
 * \brief initializes a port pin for a LED
 * In this case port pin 2 of the port D of an atmega8 is used.
 */
void initPort(void)
{
   /* output pin 2 at port D */
   DDRD |= (1 << PIN2);
}

/**
 * \brief toggle the defined port pin for the LED
 */
void togglePin(void)
{
    // toggle pin
   PORTD ^= (1 << PIN2);
   // wait for 250ms
   _delay_ms(250);
}

