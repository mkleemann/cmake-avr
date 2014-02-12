/**
 * \brief simple class for port access for LEDs
 *
 * \file CLed.hh
 * \author Matthias Kleemann
 */

/**
 * \brief simple access class for LEDs
 */
class CLed
{
   public:
      /**
       * \brief constructor of LED access class
       * \param PORT to access the LED
       * \param DDR  to set the LED port pin to output
       * \param PIN  to access the LED
       */
      CLed(volatile uint8_t *PORT, volatile uint8_t *DDR, uint8_t PIN);
      //! destructor
      ~CLed();

      //! switches the LED on
      void on(void);
      //! switches the LED off
      void off(void);
      //! toggles the LED
      void toggle(void);

   private:
      CLed();
      CLed( CLed const &src );
      CLed& operator=(const CLed &src );

      //! pointer to the LED port
      volatile uint8_t *m_Port;
      //! pointer to the LED port's data direction register
      volatile uint8_t *m_Ddr;
      //! pin the LED is connected to
      uint8_t m_Pin;
};

