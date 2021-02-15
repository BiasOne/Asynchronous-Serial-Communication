.include "atxmega128a1udef.inc"

.equ stackInit= 0x3FFF
.equ NULL = 0;
.equ IN_TABLE_ADDR = 0x2000


.org 0x00 
rjmp main

.org 0x100
main:
ldi r16, low(stackInit)
out CPU_SPL, r16
ldi r16, high(stackInit)
out CPU_SPH, r16

ldi YL, low(IN_TABLE_ADDR)
ldi YH, high(IN_TABLE_ADDR)

ldi r16, 0b00001000
sts PORTD_OUTSET, r16
sts PORTD_DIRSET, r16
ldi r16, 0b00000100
sts PORTD_DIRCLR, r16

rcall USART_INIT

REPEAT:
rcall RESET

LOOP:
rcall IN_STRING
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
IN_STRING:
rcall IN_CHAR

cpi r16, 0x08
breq BACKSPACE
;cpi r16, 0x20
;breq BACKSPACE ;delete
cpi r16, 0x0d
breq OUT_STRING
st Y+, r16
ret

;********************************************************************************************
OUT_STRING:
ldi r16, NULL
st Y, r16
rcall RESET

STRING_OUT:
ld r16, Y+
cpi r16, NULL
breq REPEAT
rcall OUT_CHAR
rjmp STRING_OUT

;********************************************************************************************
RESET:
ldi YL, low(IN_TABLE_ADDR)
ldi YH, high(IN_TABLE_ADDR)
ret
;********************************************************************************************
BACKSPACE:
push r16
ld r16, -Y
pop r16
ret


;********************************************************************************************
USART_INIT:
push r16
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