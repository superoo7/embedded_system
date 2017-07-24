# Comparison of Assembly and C in PIC16

ASM

	BSF    STATUS, RP0		; TRIS - BANK 1
	CLRF   TRISB			; RB AS OUTPUT
	BCF    STATUS, RP0		; PORT - BANK 0
	MOVLW  0X5B
	MOVWF  TRISB

C
	
	TRISB = 0X00;			; PORT B AS OUTPUT
	PORTB = 0X5B;			; DIRECT TRANSFER OF DATA


In C, require preprocessor

	#include <p16f84a.h>
	void main()
	{
	TRISB = 0;
	PORTB = 0b01010101;
	}

## LED Blink
	#include <p16f84a.h>
	#include <delay.c>

	void main() {
		TRISB = 0;  // TRISB as output

		for(;;) { // forever loop
			RB0 = 1; 		// lights ON
			MsDelay(250);   // from delay.c library, delay in ms
			RB0 = 0;		// lights OFF
			MsDelay(250);
		}
	}

### In delay.c
	void MsDelay(unsigned int itime) {
		unsingned int i, j;
		for (i=0, i<itime, i++) {
			for (j=0; j<1000; j++) // this loop create 1ms delay
		}
	}

## Send 00 -> FF to Port B

	#include <p16f84a.h>

	void main() {
		unsigned char i;
		TRISB = 0;
		for (i=0; i<255; i++) {
			PORTB = i;
		}

	}

## Send "Hello World!"
	#include <p16f84a.h>

	void main() {
		unsigned char text [] = "Hello World!"; // create a char array
		unsigned char z;

		TRISB = 0;

		for(z=0; z<12; z++) {
			PORTB = text [z];
		}



## Inline ASM
	#include <p16f84a.h>

	void main() {
		unsigned char i;
		TRISB = 0;
		asm {
			BCF    STATUS, RP0		; PORT - BANK 0
			MOVLW  0X5B
			MOVWF  TRISB
		}
	}
