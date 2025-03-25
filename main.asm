;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Assembly language file for Lab 2 in 55:035 (Embedded Systems)
; Spring 2025, The University of Iowa
; Created: 2/17/2025 1:48:18 PM
; Author : Thomas Tsilimigras and Joshua Abello
;
.include "m328pdef.inc"
.cseg
.org 0

;--------------------------------------------------------
; Configure I/O Ports
;--------------------------------------------------------
sbi DDRB, 2      ; PB2 - SER (output)
sbi DDRB, 1      ; PB1 - SRCLK (output)
sbi DDRB, 0      ; PB0 - RCLK (output)
cbi DDRD, 5      ; PD5 - Button input

;Constants and Definitions
.equ MIN_HOLD_TIME = 100  ; Used for the 1 second press  
.equ MAX_HOLD_TIME  = 200  ; Used for the 1-2 second press 
ldi R20, 0x10
ldi R18, 0
ldi r21, 1 ; 1 for increment 0 for dec

; Values for each digit (both increment and decrement)

.equ val0inc = 0x3f ; Value of 0 in Hex 
.equ val0dec = 0xBF 

.equ val1inc = 0x06 ; Value of 1 in Hex 
.equ val1dec = 0x86  

.equ val2inc = 0x5B ; Value of 2 in Hex 
.equ val2dec = 0xDB 

.equ val3inc = 0x4f ; Value of 3 in Hex 
.equ val3dec = 0xCF 

.equ val4inc = 0x66 ; Value of 4 in Hex 
.equ val4dec = 0xE6  

.equ val5inc = 0x6d ; Value of 5 in Hex 
.equ val5dec = 0xED  

.equ val6inc = 0x7d ; Value of 6 in Hex 
.equ val6dec = 0xFD  

.equ val7inc = 0x07 ; Value of 7 in Hex 
.equ val7dec = 0x87 

.equ val8inc = 0x7f ; Value of 8 in Hex 
.equ val8dec = 0xFF 

.equ val9inc = 0x6F ; Value of 9 in Hex 
.equ val9dec = 0xEF 

.equ valAinc = 0x77 ; Value of A in Hex 
.equ valAdec = 0xF7  

.equ valBinc = 0x7C ; Value of B in Hex 
.equ valBdec = 0xFC 

.equ valCinc = 0x39 ; Value of C in Hex 
.equ valCdec = 0xB9  

.equ valDinc = 0x5E ; Value of D in Hex 
.equ valDdec = 0xDE  

.equ valEinc = 0x79 ; Value of E in Hex 
.equ valEdec = 0xF9 

.equ valFinc = 0x71 ; Value of F in Hex 
.equ valFdec = 0xF1 



;--------------------------------------------------------
; Initialization
;--------------------------------------------------------

ldi R16, val0inc ; load pattern to display, sets the display to 0
rcall display    ; Display initial number

;--------------------------------------------------------
; Main Program Loop
;--------------------------------------------------------
loop1:
	ldi R18,0	 ; button press counter
    sbic PIND, 5     ; Skip if button is not pressed (active LOW)
    rjmp loop1       ; Keep looping if no button press
    rjmp button_pressed ; Jump if button pressed

;--------------------------------------------------------
; Button Pressed Subroutine
;--------------------------------------------------------
button_pressed:
	sbic PIND, 5 ;skip next instruction if button is released
	rjmp press_handler ; if button is pressed then go to handler
	call delay ; call delay to measure the hold time
	cpi R18, 250
	brlo incR18

	rjmp button_pressed ; repeat
	
incR18:
	inc r18
	rjmp button_pressed


press_handler:
	cpi R18, MIN_HOLD_TIME ; compares r18 to min hold time
	brlo mode_check ; if less than one second go to mode check and handle whether dec or inc
	cpi R18, MAX_HOLD_TIME
	brlo mode_switch ; if the hold time is less than max but more than min switch modes from inc to dec or visa versa
	;rjmp reset_button

;--------------------------------------------------------
; reset button handler
; resets display to 0
;--------------------------------------------------------
reset_button:
	ldi R16, val0inc ;load patter to display, sets the display to 0 with decimal
	ldi R21, 1 ; set R21 to increment mode again
	rcall display ; update display
	ldi R18, 0 ; changes the counter to 0
	rjmp loop1 ; re runs loop to start over
	
mode_switch:
	cpi R21, 1 ; check if R21 is in inc mode
	breq switch_to_zero ; branch if eqal to check_state
	ldi r21, 1
	;rcall display
	rjmp check_state
switch_to_zero:
	ldi r21, 0
check_state:
	cpi R21, 0 ; compare r21 to 0 and see if in dec mode
	breq dec_mode ; jump to dec mode (add decimal)
	andi R16, 0x7f ; get rid of decimal bit 
	ldi R21, 1
	rcall display
	rjmp continue ; returns to continue to update the desplay and reset counter
dec_mode:
	ori R16, 0x80 ;set bit 7 of register 16 (use and so it is one or the other)
	;rcall display
	rjmp continue ; continue with loop
	
mode_check: 
	cpi r21, 1 ; compare r21,1 (inc mode)
	breq increm_dig ; branch to increm if it is pos then jump to 0
	rjmp decF


continue:
	rcall display ; updates the display with the current in r16
	ldi R18, 0 ; resets counter to 0
	rjmp loop1 ; jumps back to loop1




increm_dig:
	cpi R16, val0inc ; compar0 current value to 0
	brne inc1
	ldi R16, val1inc ; load value 1 
	rcall display ; update display
	rjmp loop1 ; return to main loop
	
inc1:
	cpi R16, val1inc ; compare current value to 1
	brne inc2 ;if its not the same then check next
	ldi R16, val2inc ; load value 2
	rcall display ; update display
	rjmp loop1 ; return to main loop

inc2:
	cpi R16, val2inc ; compare current value to 2
	brne inc3 ;if its not the same then check next
	ldi R16, val3inc ; load value 3
	rcall display ; update display
	rjmp loop1 ; return to main loop

inc3:
	cpi R16, val3inc ; compare current value to 3
	brne inc4 ;if its not the same then check next
	ldi R16, val4inc ; load value 4
	rcall display ; update display
	rjmp loop1 ; return to main loop

inc4:
	cpi R16, val4inc ; compare current value to 3
	brne inc5 ;if its not the same then check next
	ldi R16, val5inc ; load value 4
	rcall display ; update display
	rjmp loop1 ; return to main loop

inc5:
	cpi R16, val5inc ; compare current value to 3
	brne inc6 ;if its not the same then check next
	ldi R16, val6inc ; load value 4
	rcall display ; update display
	rjmp loop1 ; return to main loop
inc6:
	cpi R16, val6inc ; compare current value to 3
	brne inc7 ;if its not the same then check next
	ldi R16, val7inc ; load value 4
	rcall display ; update display
	rjmp loop1 ; return to main loop


decF:
	cpi R16, valFdec ; compare current value to 3
	brne decE;if its not the same then check next
	ldi R16, valEdec ; load value 4
	rcall display ; update display
	rjmp loop1 ; return to main loop



inc7:
	cpi R16, val7inc ; compare current value to 3
	brne inc8 ;if its not the same then check next
	ldi R16, val8inc ; load value 4
	rcall display ; update display
	rjmp loop1 ; return to main loop
inc8:
	cpi R16, val8inc ; compare current value to 3
	brne inc9 ;if its not the same then check next
	ldi R16, val9inc ; load value 4
	rcall display ; update display
	rjmp loop1 ; return to main loop
inc9:
	cpi R16, val9inc ; compare current value to 3
	brne incA ;if its not the same then check next
	ldi R16, valAinc ; load value 4
	rcall display ; update display
	rjmp loop1 ; return to main loop
incA:
	cpi R16, valAinc ; compare current value to 3
	brne incB ;if its not the same then check next
	ldi R16, valBinc ; load value 4
	rcall display ; update display
	rjmp loop1 ; return to main loop
incB:
	cpi R16, valBinc ; compare current value to 3
	brne incC ;if its not the same then check next
	ldi R16, valCinc ; load value 4
	rcall display ; update display
	rjmp loop1 ; return to main loop
incC:
	cpi R16, valCinc ; compare current value to 3
	brne incD ;if its not the same then check next
	ldi R16, valDinc ; load value 4
	rcall display ; update display
	rjmp loop1 ; return to main loop
incD:
	cpi R16, valDinc ; compare current value to 3
	brne incE ;if its not the same then check next
	ldi R16, valEinc ; load value 4
	rcall display ; update display
	rjmp loop1 ; return to main loop
incE:
	cpi R16, valEinc ; compare current value to 3
	brne incF ;if its not the same then check next
	ldi R16, valFinc ; load value 4
	rcall display ; update display
	rjmp loop1 ; return to main loop
incF:
	ldi R16, val0inc ; load value 0
	rcall display ; update display
	rjmp loop1 ; return to main loop

decE:
	cpi R16, valEdec ; compare current value to 3
	brne decD ;if its not the same then check next
	ldi R16, valDdec ; load value 4
	rcall display ; update display
	rjmp loop1 ; return to main loop
decD:
	cpi R16, valDdec ; compare current value to 3
	brne decC ;if its not the same then check next
	ldi R16, valCdec ; load value 4
	rcall display ; update display
	rjmp loop1 ; return to main loop	
decC:
	cpi R16, valCdec ; compare current value to 3
	brne decB ;if its not the same then check next
	ldi R16, valBdec ; load value 4
	rcall display ; update display
	rjmp loop1 ; return to main loop
decB:
	cpi R16, valBdec ; compare current value to 3
	brne decA ;if its not the same then check next
	ldi R16, valAdec ; load value 4
	rcall display ; update display
	rjmp loop1 ; return to main loop
decA:
	cpi R16, valAdec ; compare current value to 3
	brne dec9 ;if its not the same then check next
	ldi R16, val9dec ; load value 4
	rcall display ; update display
	rjmp loop1 ; return to main loop
dec9:
	cpi R16, val9dec ; compare current value to 3
	brne dec8 ;if its not the same then check next
	ldi R16, val8dec ; load value 4
	rcall display ; update display
	rjmp loop1 ; return to main loop
dec8:
	cpi R16, val8dec ; compare current value to 3
	brne dec7 ;if its not the same then check next
	ldi R16, val7dec ; load value 4
	rcall display ; update display
	rjmp loop1 ; return to main loop
dec7:
	cpi R16, val7dec ; compare current value to 3
	brne dec6 ;if its not the same then check next
	ldi R16, val6dec ; load value 4
	rcall display ; update display
	rjmp loop1 ; return to main loop
dec6:
	cpi R16, val6dec ; compare current value to 3
	brne dec5 ;if its not the same then check next
	ldi R16, val5dec ; load value 4
	rcall display ; update display
	rjmp loop1 ; return to main loop
dec5:
	cpi R16, val5dec ; compare current value to 3
	brne dec4 ;if its not the same then check next
	ldi R16, val4dec ; load value 4
	rcall display ; update display
	rjmp loop1 ; return to main loop
dec4:
	cpi R16, val4dec ; compare current value to 3
	brne dec3 ;if its not the same then check next
	ldi R16, val3dec ; load value 4
	rcall display ; update display
	rjmp loop1 ; return to main loop
dec3:
	cpi R16, val3dec ; compare current value to 3
	brne dec2 ;if its not the same then check next
	ldi R16, val2dec ; load value 4
	rcall display ; update display
	rjmp loop1 ; return to main loop
dec2:
	cpi R16, val2dec ; compare current value to 2
	brne dec1 ;if its not the same then check next
	ldi R16, val1dec ; load value 3
	rcall display ; update display
	rjmp loop1 ; return to main loop
dec1:
	cpi R16, val1dec ; compare current value to 1
	brne dec_dig ;if its not the same then check next
	ldi R16, val0dec ; load value 2
	rcall display ; update display
	rjmp loop1 ; return to main loop
dec_dig:
	ldi R16, valFdec ; load value 0
	rcall display ; update display
	ldi R21, 0 ; keep R21 at 0
	rjmp loop1 ; return to main loop







;--------------------------------------------------------
; Display Subroutine: Shift bits into SN74HC595
;--------------------------------------------------------
display:
	; backup used registers on stack
	push R16
	push R17
	in R17, SREG
	push R17
	ldi R17, 8 ; loop --> test all 8 bits

loop_display:
    rol R16          ; Rotate left through Carry
    BRCS set_ser_in_1 ; Branch if Carry is set

    ; SER = 0
    cbi PORTB, 2
    rjmp end_display

set_ser_in_1:
    ; SER = 1
    sbi PORTB, 2

end_display:
    ; Generate SRCLK pulse
    sbi PORTB, 1
    cbi PORTB, 1

    dec R17
    brne loop_display

    ; Generate RCLK pulse
    sbi PORTB, 0
    cbi PORTB, 0

    ; Restore registers from stack
    pop R17
    out SREG, R17
    pop R17
    pop R16

    ret

; Delay sub routine
delay: ; with 
	ldi r31,0x4e
	ldi r30,0x20

d1:
	ldi r29, 0x01 ; r29 <-- load a 8-bit value into counter register for inner loop
d2:
	nop ; no operation
	dec r29 ; r29 <-- r29 - 1
	brne d2 ; branch to d2 if result is not "0"
	sbiw r31:r30, 1 ; r31:r30 <-- r31:r30 - 1     skips next line if 
	brne d1 ; branch to d1 if result is not "0"
	
	ret
