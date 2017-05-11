; use 2 input switch, one can count from D'0 to D'9 the other one in reverse order


  #include "p16F84A.inc"
  ; CONFIG
  ; __config 0xFFF9
  __CONFIG _FOSC_XT & _WDTE_OFF & _PWRTE_OFF & _CP_OFF

  RES_VECT CODE 0x0000                                    ; processor reset vector

  GOTO START                                              ; go to beginning of program

  ; MAKE PORT
  CTR_01 EQU 0x20
  CTR_02 EQU 0x21
  CTR_03 EQU 0x22					  ; Counter for increment
  CTR_04 EQU 0x23					  ; Counter for decrement
  COUNT  EQU 0x24					  ; Counter to Port B
  
  MAIN_PROG CODE                                          ; let linker place main program

START

    BCF   STATUS, RP0           ; Select Bank 0 (PORT B)
    CLRF  PORTB                 ; Initialize PORT B by
                                ; clearing output
                                ; data latches
    BSF   STATUS, RP0           ; Select Bank 1 (TRIS B)
    MOVLW 0x0                   ; Value used to
                                ; initialize data direction
    MOVWF TRISB                 ; Set RB<7:0> as outputs
    BSF   TRISA,  2             ; Set RA2 as input
    BSF   TRISA,  3             ; Set RA3 as input
    BCF   STATUS, RP0           ; Select Bank 0 (PORT B)

    ; For CTR_03 (Increment)
    ; 246 -> 0
    ; 255 -> 9
    ; when 256 it will reset
    ; For CTR_04 (DECREMENT)
    ; 10  -> 9
    ; 1   -> 0
    
    ; start from 0
again1    
    ; When reset start from 0
    ; CTR_03 (Increment)
    MOVLW D'246'
    MOVWF CTR_03
    MOVLW D'1'
    MOVWF CTR_04
    
    ; Count start from 0
    CLRF  COUNT
    
    GOTO loop
    
    
    ; start from 9
again2
    ; when reset start from 9
    ; CTR_04 (Decrement)
    MOVLW D'255'
    MOVWF CTR_03
    MOVLW D'10'
    MOVWF CTR_04
    
    ; Count start from 9
    ClRF COUNT
    MOVLW D'9'
    MOVWF COUNT
    
    GOTO loop
    
loop
    MOVFW  COUNT
    MOVWF  PORTB
    CALL   Delay
    CALL   Delay
    CALL   Delay
    CALL   Delay
    CALL   RA_CHK
    GOTO   loop


; Subroutine Delay
; CTR_01=0x20; CTR_02=0x21; CTR_03=0x22;
; Meant to delay the microcontroller
; FUNCTION DELAY
Delay
    MOVLW   0xFF
    MOVWF   CTR_01
L1
    MOVLW   0xFF
    MOVWF   CTR_02
L2
    DECFSZ  CTR_02,F
    GOTO    L2
    DECFSZ  CTR_01,F
    GOTO    L1
    RETURN
; END OF SUBROUTINE Delay

; FUNCTION RA2_CHK
; Main Function
; RA2 input (increment), RA3 input (decrement), RB{0:A, 1:B, 2:C, 3:D} output
  RA_CHK
    CHK_PUSH
        CALL  CHK_RA2          ; Call function to check wether RA2 is 1 or 0
        BTFSS STATUS,     Z    ; Check RA2
        GOTO  RA2_FALSE        ; if RA2 is False
        GOTO  RA2_TRUE         ; if RA2 is True
      RA2_FALSE
        CALL  CHK_RA3          ; Call function to check wether RA3 is 1 or 0
        BTFSS STATUS,     Z    ; Check RA3
        GOTO  CHK_PUSH         ; RA2 is 0, RA3 is 0 => run again
        GOTO  DECREMENT1       ; RA2 is 0, RA3 is 1 => Decrement
      RA2_TRUE
        CALL  CHK_RA3          ; Call function to check wether RA3 is 1 or 0
        BTFSS STATUS,     Z    ; Check RA3
        GOTO  INCREMENT1       ; RA2 is 1, RA3 is 0 => Increment
        GOTO  CHK_PUSH         ; RA2 is 1, RA3 is 1 => run again
      INCREMENT1
        CALL   Delay           ; wait
        CALL   Delay           ; wait
        INCF   COUNT,     F    ; Increment
        INCFSZ CTR_03          ; Increment in CTR_03
        GOTO   INCREMENT2      ; if 246<=CTR_03<=255
	GOTO   again1	       ; When CTR_03 = 256 (>9)
	
      INCREMENT2
	INCFSZ CTR_04	       ; add 1 to CTR_04 (1<=CTR_04<=10)
	RETURN
	GOTO   again1	       ; if code went wrong, reset
	
      DECREMENT1
        CALL   Delay           ; wait
        CALL   Delay           ; wait
        DECF   COUNT,     F    ; Decrement
        DECFSZ CTR_04          ; Decrement in CTR_04
        GOTO   DECREMENT2      ; if 1<=CTR_04<=10
	GOTO   again2	       ; When CTR_04 = 0 (0<)
	
      DECREMENT2
	DECFSZ CTR_03	       ; minus 1 to CTR_03 (246<=CTR_03<=255)
	RETURN
	GOTO   again1	       ; if code went wrong, reset


; Check RA2
  CHK_RA2
    MOVFW PORTA
    ANDLW B'00000100'     ; Check RA2
    RETURN

; Check RA3
  CHK_RA3
    MOVFW PORTA
    ANDLW B'00001000'     ; Check RA3
    RETURN

  END
