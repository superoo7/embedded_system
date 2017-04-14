; TODO INSERT CONFIG CODE HERE USING CONFIG BITS GENERATOR

RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    START                   ; go to beginning of program

; TODO ADD INTERRUPTS HERE IF USED

MAIN_PROG CODE                      ; let linker place main program

START
    ; store number in locations 31H, 45H, and 47H 
    ; store 12 to locations 31h
    MOVLW 0x12
    MOVWF 0x31 
    ; store 4 to location 45h
    MOVLW 0x04
    MOVWF 0x45
    ; store 10 to location 47h
    MOVLW 0x10
    MOVWF 0x47
    ; current w register has 10 (from 47h)
    ; Addition
    ADDWF 0x31, 0
    ADDWF 0x45, 0
    ; move the sum of 3 locations to 22h
    MOVWF 0x22
 
    GOTO $                          ; loop forever

    END