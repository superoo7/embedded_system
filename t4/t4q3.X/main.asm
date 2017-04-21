#include <P16F84A.INC>
; TODO INSERT CONFIG CODE HERE USING CONFIG BITS GENERATOR

RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    START                   ; go to beginning of program

; TODO ADD INTERRUPTS HERE IF USED

MAIN_PROG CODE                      ; let linker place main program

START
    MOVLW D'100'
    MOVWF MYREG
    HERE 
	
	COUNT   EQU D'10'
	STORAGE EQU 0x20
	
	CLRF STORAGE
 
	MOVLW COUNTER
	MOVWF STORAGE	
 
	LOOP NOP
	     NOP
	     NOP
	     NOP
	     NOP
	     DECFSC MYREG, F	    
	     DECF STORAGE, 1
	     BNZ LOOP		; LOOP 10 TIMES
	
    GOTO HERE

    END
    
    ; NOP time = T * prescaling factor
    ; NOP time = 1/4Mhz * 4
    ; NOP time = 1 micro s
    ; Total NOP = 5 micro s