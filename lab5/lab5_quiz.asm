.include "atxmega128a1udef.inc"

.equ stackInit= 0x3FFF
.equ NULL = 0;
.equ IN_TABLE_ADDR = 0x300


.cseg
.org 0x00 
rjmp main

.org 0x100
main:
ldi r16, low(stackInit)
out CPU_SPL, r16
ldi r16, high(stackInit)
out CPU_SPH, r16

ldi r16, 0b00001000
sts PORTD_OUTSET, r16
sts PORTD_DIRSET, r16
ldi r16, 0b00000100
sts PORTD_DIRCLR, r16

ldi r16, 0xFF
sts PORTA_OUTSET, r16
sts PORTA_DIRCLR, r16
sts PORTC_DIRSET, r16

rcall USART_INIT

LOOP:
rcall QUIZ
rjmp loop


end:
rjmp end

;********************************************************************************************
OUT_CHAR:
push r17

TX_POLL:
lds r17, USARTD0_STATUS
sbrs r17, USART_DREIF_bp
rjmp TX_POLL
sts USARTD0_DATA, r16
pop r17
ret

;********************************************************************************************
IN_CHAR:

RX_POLL:
lds r16, USARTD0_STATUS
sbrs r16, USART_RXCIF_bp
rjmp RX_POLL

lds r16, USARTD0_DATA
ret

;********************************************************************************************
USART_INIT:
push r16
ldi r16, 0b00011000
sts USARTD0_CTRLB, r16

ldi r16, 0b00101011
sts USARTD0_CTRLC, r16

ldi r16, low(0)
sts USARTD0_BAUDCTRLA, r16

ldi r16, ((-7 <<4) | high(0))
sts USARTD0_BAUDCTRLB, r16
pop r16
ret
;********************************************************************************************
QUIZ:
rcall IN_CHAR
cpi r16, 0x37
breq DISPLAY_LED
rcall OUT_CHAR
ret

DISPLAY_LED:
push r16
lds r16, PORTA_IN
sts PORTC_OUT, r16

ldi r26, 0
com r16
add r26, r16
andi r16, 0b00001111

lsr r26
lsr r26
lsr r26
lsr r26
ldi r29, 0x30
add r16, r29
add r26, r29

sts USARTD0_DATA, r26
sts USARTD0_DATA, r16
pop r16
;rcall OUT_CHAR
ret
