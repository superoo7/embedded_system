    #include "p16F84A.inc"
     ; CONFIG
     ; __config 0xFFF9
     __CONFIG _FOSC_XT & _WDTE_OFF & _PWRTE_OFF & _CP_OFF

     RES_VECT CODE 0x0000                                    ; processor reset vector

     GOTO START                                              ; go to beginning of program


    ; Initialised
    CTR_01	  EQU 0x20	    ;Counter for delay
    CTR_02	  EQU 0x21	    ;Counter for delay
    
    COUNT	  EQU 0x24	    ;DISPLAY + 2   (2<=range<=11)
    DISPLAY	  EQU 0x25	    ;Output to BCD (0<=range<=9)	  

  
MAIN_PROG CODE ; let linker place main program
    START
	BCF STATUS, RP0 ; Select Bank 0 (PORT B)
	CLRF PORTB ; Initialize PORT B by clearing output data latches
	BSF STATUS, RP0 ; Select Bank 1 (TRIS B)
	MOVLW 0x0 ; Value used to initialize data direction
	MOVWF TRISB ; Set RB<7:0> as outputs
	BSF TRISA,2 ; Set RA2 as input
	BSF TRISA,3 ; Set RA3 as input
	BCF STATUS, RP0 ; Select Bank 0 (PORT B)
	
	; Start with 0
	again1
	
	    CLRF    COUNT
	    CLRF    DISPLAY
	    MOVLW   D'0'
	    MOVWF   DISPLAY
	    ADDLW   D'2'
	    MOVWF   COUNT
	    GOTO    loop
	
	; Start with 9
	again2
	    CLRF    COUNT
	    CLRF    DISPLAY
	    MOVLW   D'9'
	    MOVWF   DISPLAY
	    ADDLW   D'2'
	    MOVLW   COUNT
	    GOTO    loop
	    
	loop
	    
	    MOVFW DISPLAY
	    MOVWF PORTB		;OUTPUT COUNT TO BCD
	    ; Delay 1 second
	    CALL Delay
	    CALL Delay
	    CALL Delay
	    CALL Delay
	    ; End Delay
	    
	; XOR
	; | 0 | 0 | = 0 
	; | 0 | 1 | = 1 
	; | 1 | 0 | = 1
	; | 1 | 1 | = 0 
	
	CHK_PUSH
	    MOVFW PORTA
	    ANDLW B'00000100'		
	    MOVFW PORTA
	    BTFSS STATUS, Z
	    GOTO  RA2_FALSE			; 0 | ?
	    GOTO  RA2_TRUE			; 1 | ?

	    RA2_TRUE		    		; 1 | ?
		MOVFW PORTA
		ANDLW B'00001000'		; Check RA3
		BTFSS STATUS, Z
		GOTO  INCREMENT1    	        ; 1 | 0 => Increment
		GOTO  CHK_PUSH			; 1 | 1 => Restart
		
	    RA2_FALSE				; 0 | 1
		MOVFW PORTA
		ANDLW B'00001000'		; Check RA3
		BTFSS STATUS, Z
		GOTO  CHK_PUSH    	        ; 0 | 0 => Restart
		GOTO  DECREMENT1		; 0 | 1 => Decrement 
		
	    INCREMENT1	    
		CALL Delay			 ; wait until the bouncing
		CALL Delay			 ; of the push button finishes
		MOVFW PORTA
		ANDLW B'00000100'
		BTFSS STATUS, Z
		GOTO  CHK_PUSH			 ; if false, restart
		INCF  COUNTER			 ; +1 Counter
		MOVLW D'12'
		XORWF COUNTER, 0		 ; check wether counter = 12 (disp = 10)
		GOTO INCREMENT2
		GOTO again1			 ; counter = 12, reset to 0
		
	    INCREMENT2				 ; counter added, need to add display
		INCF DISPLAY
		GOTO loop			 ; Start again
		
	    DECREMENT1
		CALL Delay			 ; wait until the bouncing
		CALL Delay			 ; of the push button finishes
		MOVFW PORTA
		ANDLW B'00001000'
		BTFSS STATUS, Z
		GOTO  CHK_PUSH			 ; if false, restart
		DECF  COUNTER			 ; -1 Counter
		MOVLW D'1'
		XORWF COUNTER, 0		 ; check wether counter = 1  (disp = -1)
		GOTO DECREMENT2
		GOTO again2			 ; counter = 1, set to 9
	
	    DECREMENT2
		DECF DISPLAY
		GOTO loop
	    
	    
	    
	    
	    
	    
	
	
	
;    again
;	MOVLW D'246'
;	MOVWF CTR_03
;	CLRF COUNT
;    loop
;	MOVFW COUNT
;	MOVWF PORTB
;	CALL Delay
;	CALL Delay
;	CALL Delay
;	CALL Delay
;	CALL RA2_CHK
;	INCF COUNT,F
;	INCFSZ CTR_03
;	GOTO loop
;	GOTO again

	
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


END