/*********************
 * \file mylib.c
 * \author Matthias Kleemann
 *
 */

#include <avr/io.h>
#include <util/delay.h>

#include "mylib.h"

/**
 * initializes port pin for led
 */
void initPort(void)
{
   /* output pin 2 at port D */
   DDRD |= (1 << PIN2);
}

/**
 * toggle port pin for led
 */
void togglePin(void)
{
    // toggle pin
   PORTD ^= (1 << PIN2);
   // wait for 250ms
   _delay_ms(250);
}

