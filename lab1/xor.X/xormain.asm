    #include "p16F84A.inc"
     ; CONFIG
     ; __config 0xFFF9
     __CONFIG _FOSC_XT & _WDTE_OFF & _PWRTE_OFF & _CP_OFF

     RES_VECT CODE 0x0000                                    ; processor reset vector

     GOTO START                                              ; go to beginning of program


    ; Initialised
    CTR_01	  EQU 0x20	    ;Counter for delay
    CTR_02	  EQU 0x21	    ;Counter for delay
    CTR_03	  EQU 0x22	    ;Store data for ()
    ;CTR_04	  EQU 0x23	    ;Store data for ()
    COUNT  EQU 0x24	    ;Real Counter + 2
    ;COUNT_02  EQU 0x25	    ;Output to BCD (REAL COUNTER)
  

  
MAIN_PROG CODE ; let linker place main program
    START
	BCF STATUS, RP0 ; Select Bank 0 (PORT B)
	CLRF PORTB ; Initialize PORT B by clearing output data latches
	BSF STATUS, RP0 ; Select Bank 1 (TRIS B)
	MOVLW 0x0 ; Value used to initialize data direction
	MOVWF TRISB ; Set RB<7:0> as outputs
	BSF TRISA,2 ; Set RA2 as input
	BCF STATUS, RP0 ; Select Bank 0 (PORT B)
    again
	MOVLW D'246'
	MOVWF CTR_03
	CLRF COUNT
    loop
	MOVFW COUNT
	MOVWF PORTB
	CALL Delay
	CALL Delay
	CALL Delay
	CALL Delay
	CALL RA2_CHK
	INCF COUNT,F
	INCFSZ CTR_03
	GOTO loop
	GOTO again

	
    Delay
	MOVLW 0xFF
	MOVWF CTR_01
	L1
	    MOVLW 0xFF
	    MOVWF CTR_02
	L2
	    DECFSZ CTR_02,F
	    GOTO L2
	    DECFSZ CTR_01,F
	    GOTO L1
	RETURN

    RA2_CHK
	CHK_PUSH
	    MOVFW PORTA
	    ANDLW B'00000100'
	    BTFSS STATUS, Z
	    GOTO CHK_PUSH ; if push button is not pressed
	    CALL Delay ; wait until the bouncing
	    CALL Delay ; of the push button finishes
	    MOVFW PORTA ; check RA2 again
	    ANDLW B'00000100'
	    BTFSS STATUS,Z
	    GOTO CHK_PUSH
	    RETURN
END