
.include "atxmega128a1udef.inc"

.equ stackInit= 0x3FFF

.org 0x00 
rjmp main


.org 0x100
main:
ldi r16, low(stackInit)
out CPU_SPL, r16
ldi r16, high(stackInit)
out CPU_SPH, r16

ldi r16, 0b00001000
sts PORTC_OUTSET, r16
sts PORTC_DIRSET, r16
ldi r16, 0b00000100
sts PORTC_DIRCLR, r16

rcall USART_INIT

ldi r16, 'U'

loop:
rcall OUT_CHAR
rjmp loop

end:
rjmp end


OUT_CHAR:
push r17

TX_POLL:
lds r17, USARTC0_STATUS
sbrs r17, USART_DREIF_bp
rjmp TX_POLL

sts USARTC0_DATA, r16
pop r17
ret

USART_INIT:
push r16
ldi r16, 0b00011000
sts USARTC0_CTRLB, r16

ldi r16, 0b00110011
sts USARTC0_CTRLC, r16

ldi r16, low(11)
sts USARTC0_BAUDCTRLA, r16

ldi r16, ((-7 <<4) | high(11))
sts USARTC0_BAUDCTRLB, r16
pop r16
ret
