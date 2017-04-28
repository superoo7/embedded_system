; created by LWH
; use 2 input switch, one can count from D'0 to D'9 the other one in reverse order
; TO DO
; - Create Tris C as a third input

  #include "p16F84A.inc"
  ; CONFIG
  ; __config 0xFFF9
  __CONFIG _FOSC_XT & _WDTE_OFF & _PWRTE_OFF & _CP_OFF

  RES_VECT CODE 0x0000                                    ; processor reset vector

  GOTO START                                              ; go to beginning of program

  ; MAKE PORT
  CTR_01 EQU 0x20
  CTR_02 EQU 0x21
  CTR_03 EQU 0x22
  COUNT  EQU 0x23
  ; TODO ADD INTERRUPTS HERE IF USED
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
    BSF   TRISA,  3
    BCF   STATUS, RP0           ; Select Bank 0 (PORT B)
again
    MOVLW D'246'
    MOVWF CTR_03
    CLRF  COUNT
loop
    MOVFW  COUNT
    MOVWF  PORTB
    CALL   Delay
    CALL   Delay
    CALL   Delay
    CALL   Delay
    CALL   RA_CHK

    GOTO   loop
    GOTO   again

; Function Delay
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
; END OF FUNCTION Delay

; FUNCTION RA2_CHK
; Main Function
; RA2 input (increment), RA3 input (decrement), RB{0:A, 1:B, 2:C, 3:D} output
  RA_CHK
    CHK_PUSH
        CALL  CHK_RA2         ; Call function to check wether RA2 is 1 or 0
        BTFSS STATUS,     Z   ; Check RA2
        GOTO  RA2_FALSE       ; if RA2 is False
        GOTO  RA2_TRUE        ; if RA2 is True
      RA2_FALSE
        CALL  CHK_RA3         ; Call function to check wether RA3 is 1 or 0
        BTFSS STATUS,     Z   ; Check RA3
        GOTO  CHK_PUSH        ; RA2 is 0, RA3 is 0 => run again
        GOTO  DECREMENT       ; RA2 is 0, RA3 is 1 => Decrement
      RA2_TRUE
        CALL  CHK_RA3         ; Call function to check wether RA3 is 1 or 0
        BTFSS STATUS,     Z   ; Check RA3
        GOTO  INCREMENT       ; RA2 is 1, RA3 is 0 => Increment
        GOTO  CHK_PUSH        ; RA2 is 1, RA3 is 1 => run again
      INCREMENT
        CALL  Delay           ; wait
        CALL  Delay           ; wait
        INCF   COUNT,F        ; Increment
        INCFSZ CTR_03         ; Increment
        RETURN
      DECREMENT
        CALL  Delay           ; wait
        CALL  Delay           ; wait
        DECF   COUNT,F        ; Decrement
        DECFSZ CTR_03         ; Decrement
        RETURN


;
  CHK_RA2
    MOVFW PORTA
    ANDLW B'00000100'     ; Check RA2
    RETURN

  CHK_RA3
    MOVFW PORTA
    ANDLW B'00001000'     ; Check RA3
    RETURN

  END
