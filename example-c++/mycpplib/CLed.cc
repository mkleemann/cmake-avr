/**
 * \brief simple class for port access for LEDs
 *
 * \file CLed.cc
 * \author Matthias Kleemann
 */

#include <avr/io.h>

#include "CLed.hh"

/**
 * \brief constructor of LED access class
 * \param PORT to access the LED
 * \param DDR  to set the LED port pin to output
 * \param PIN  to access the LED
 */
CLed::CLed(volatile uint8_t *PORT, volatile uint8_t *DDR, uint8_t PIN)
: m_Port(PORT)
, m_Ddr(DDR)
, m_Pin(PIN)
{
   *(m_Ddr) |= (1 << m_Pin);
}

//! destructor
CLed::~CLed()
{
}

//! switches the LED on
void CLed::on(void)
{
   *(m_Port) |= (1 << m_Pin);
}

//! switches the LED off
void CLed::off(void)
{
   *(m_Port) &= ~(1 << m_Pin);
}

//! toggles the LED
void CLed::toggle(void)
{
   *(m_Port) ^= (1 << m_Pin);
}

