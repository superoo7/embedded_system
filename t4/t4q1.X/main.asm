#include <P16F84A.INC>
; TODO INSERT CONFIG CODE HERE USING CONFIG BITS GENERATOR

RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    START                   ; go to beginning of program

; TODO ADD INTERRUPTS HERE IF USED

MAIN_PROG CODE                      ; let linker place main program

START
    STORAGE1 EQU 0x20
    STORAGE2 EQU 0x21
    COUNTER1 EQU d'10'
    COUNTER2 EQU d'50'
    
    ; Initialize Port B
    MOVLW 0x00
    MOVWF PORTB
 
    ; Move COUNTER1 to STORAGE1 (20)
    MOVLW COUNTER1
    MOVWF STORAGE1
    ; Move COUNTER2 to STORAGE2 (21)
    MOVLW COUNTER2
    MOVWF STORAGE2
    
    LOOP1 MOVLW COUNTER2
	  MOVWF STORAGE2
	  LOOP2 COMF PORTB, 1		    ; toggle Port B
		DECF STORAGE2, 1
		BNZ LOOP2
		DECF STORAGE1, 1
		BNZ LOOP1
    
	

    END