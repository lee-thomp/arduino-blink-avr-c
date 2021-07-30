#include <avr/io.h>
#include <avr/interrupt.h>

#define LED			PB5

ISR(TIMER1_COMPA_vect) {
	/* Toggle LED pin */	
	PORTB ^= (1 << LED);
}

int main(void) {
	
	/* Setup timer 1 registers, clear and then set up interrupts */
	cli();
	TCCR1A = 0x00;		// Disable PWM pins, CTC mode
	TCCR1B = 0x0c;		// Disable input capture, enable /256 prescaler
	OCR1A = 62499;		// Toggle LED and reset timer at 62499
	TIMSK1 = 0x02;		// Enable only timer 1 compare A ISR
	DDRB |= (1 << LED);	// Enable LED pin output (D13)
	sei();				// Resume interrupts

	/* nop main processor loop */
	while(1) {
		asm("nop");
	}
	
}
