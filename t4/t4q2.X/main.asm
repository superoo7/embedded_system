#include <P16F84A.INC>
; TODO INSERT CONFIG CODE HERE USING CONFIG BITS GENERATOR

RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    START                   ; go to beginning of program

; TODO ADD INTERRUPTS HERE IF USED

MAIN_PROG CODE                      ; let linker place main program

START
    MOVLW D'100'                    ; 1 once
    MOVWF MYREG                     ; 1 once
    HERE NOP                        ; 1
	 NOP                            ; 1
	 NOP                            ; 1
	 NOP                            ; 1
	 NOP                            ; 1
	 DECFSC MYREG, 1	            ; 1 (2)
	 GOTO HERE                      ; 2
    GOTO $			    ; infinit loop
    END
    
    ; NOP time = T * prescaling factor
    ; NOP time = 1/4Mhz * 4
    ; NOP time = 1 micro s

    ; Total instruction = 2 + 8*99 + 5 + 2 = 801 instructions

    ; Total time = 801 micro second