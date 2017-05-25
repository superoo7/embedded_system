; Write an assembly language program that counts from 0 to 9 and starts incrementing from 0 for 10 times with a delay of one second for each count.


RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    START                   ; go to beginning of program


MAIN_PROG CODE                      ; let linker place main program

START

				; delay counter
				COUNTERA EQU 0x20
				COUNTERB EQU 0x21
				COUNTERC EQU 0x22
						
				; main counter
				COUNT EQU 0x23
				CTR_01 EQU 0x24          ; COUNTER FOR 0 - 9
				CTR_02 EQU 0x25					 ; COUNTER FOR running 10 loops
				
				; initialiased CTR_02
				MOVLW D'246'
				MOVWF CTR_02

				; initialised
			INIT
				CLRF COUNT                ; make COUNT 0
				MOVLW D'246'
				; (Increment)
				; 246 -> 0
				; 255 -> 9
				MOVWF CTR_01

			MAINPROGRAM
				CALL DELAY                ; Delay 1 second
				INCF COUNT                ; Increase COUNT
				INCFSZ CTR_01							; Increase CTR_01 that controls 0 -> 9
				GOTO MAINPROGRAM          ; If 0 <= COUNT <= 9
				INCFSZ CTR_02             ; Increase CTR_02 that ensure the program run 10 times
				GOTO INIT                 ; RESET COUNT TO 0
				NOP                       ; End of programme when loop > 10
			
			HERE GOTO HERE						  ; Programme ended


; Subroutine Delay that delay 1 second
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
