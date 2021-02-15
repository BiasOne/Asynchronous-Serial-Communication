.include "atxmega128a1udef.inc"

.equ stackInit= 0x3FFF
.equ NULL = 0;
.equ IN_TABLE_ADDR = 0x2000

.org USARTD0_RXC_vect
rjmp ISR

.org 0x00 
rjmp main

.org 0x100
main:
ldi r16, low(stackInit)
out CPU_SPL, r16
ldi r16, high(stackInit)
out CPU_SPH, r16

ldi r16, 0b00101000
sts PORTD_DIRSET, r16

ldi r16, 0b00000100
sts PORTD_DIRCLR, r16

rcall USART_INIT

ldi r16, 0x01

sts PMIC_CTRL, r16
sei 

GREEN_LED:
ldi r20, 0b00100000
sts PORTD_OUTTGL, r20
rjmp GREEN_LED


end:
rjmp end

;********************************************************************************************


ISR:
push r17

;ldi r17, 0x80
;sts USARTD0_STATUS, r17
lds r16, USARTD0_DATA

;TX_POLL:
;lds r17, USARTD0_STATUS
;sbrs r17, USART_DREIF_bp
;rjmp TX_POLL

sts USARTD0_DATA, r16 

pop r17
reti


;********************************************************************************************
USART_INIT:
push r16

ldi r16, 0b00010000
sts USARTD0_CTRLA, r16

ldi r16, 0b00011000
sts USARTD0_CTRLB, r16

ldi r16, 0b00110011
sts USARTD0_CTRLC, r16

ldi r16, low(11)
sts USARTD0_BAUDCTRLA, r16

ldi r16, ((-7 <<4) | high(11))
sts USARTD0_BAUDCTRLB, r16

pop r16
ret
;********************************************************************************************