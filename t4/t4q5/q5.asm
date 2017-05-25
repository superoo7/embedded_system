; an assembly language program to for toggling a specific pin RB0 of Port B with a time delay of 1 second

#include <P16F84A.INC>

RES_VECT  CODE    0x0000            ; processor reset vector
GOTO    START                   ; go to beginning of program


MAIN_PROG CODE                      ; let linker place main program

START

	BCF STATUS, RP0              ; SELECT BANK 0 (PORT B)
	CLRF PORTB									 ; Initialize PORT B 

	

MAINPROGRAM
	COMF PORTB, 1
	CALL DELAY
	GOTO MAINPROGRAM						


DELAY
    MOVLW D'6'
	  MOVWF COUNTERC
	  MOVLW D'24'
	  MOVWF COUNTERB
	  MOVLW D'168'
	  MOVWF COUNTERA
	 LOOP
	  DECFSZ COUNTERA,1
	  GOTO LOOP
	  DECFSZ COUNTERB,1
	  GOTO LOOP
	  DECFSZ COUNTERC,1
	  GOTO LOOP  
	 RETURN
	
END
