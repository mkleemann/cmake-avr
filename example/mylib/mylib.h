/**
 * \brief Header for mylib.
 *
 * \file mylib.h
 * \author Matthias Kleemann
 */

/**
 * \brief initializes a port pin for a LED
 * In this case port pin 2 of the port D of an atmega8 is used.
 */
void initPort(void);

/**
 * \brief toggle the defined port pin for the LED
 */
void togglePin(void);

