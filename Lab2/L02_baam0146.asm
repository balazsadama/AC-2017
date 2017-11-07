; nev: Balazs Adam-Attila
; azonosito: baam0146
; csoport: 621
; labor: L2
; Feladat: Írjunk meg egy-egy ASM alprogramot (függvényt, eljárást) 32 bites, előjeles egész (decimális), illetve 32 bites, pozitív hexa számok
; beolvasására és kiírására.

%include 'mio.inc'

global main

section .text
main:

.beker_int:
	mov		eax, str_beker_int	; ask for input
	call	mio_writestr
	call	read_dec_int
	jc		.hibakezeles_int

	call	write_int
	call	write_hex
	mov		ebx, eax
	
.beker_hex:
	mov		eax, str_beker_hex	; ask for input
	call	mio_writestr
	call	read_hex
	jc		.hibakezeles_hex
	
	call	write_int
	call	write_hex
	
	mov		ecx, eax
	mov		eax, str_ossz
	call	mio_writestr
	mov		eax, ecx
	
	add		eax, ebx
	call	write_int
	call	write_hex
	
	ret

.hibakezeles_int:
	call	mio_writeln
	mov		eax, str_hiba
	call	mio_writestr
	call	mio_writeln
	jmp		.beker_int
	
.hibakezeles_hex:
	call	mio_writeln
	mov		eax, str_hiba
	call	mio_writestr
	call	mio_writeln
	jmp		.beker_hex


	; read integer into EAX
read_dec_int:
	push	ebx				; save previous values
	push	ecx
	push	edx
	xor		ebx, ebx		; where we build the number

; check for negative sign
	xor		eax, eax
	call	mio_readchar
	call	mio_writechar	
	
	xor		ecx, ecx		; decide if negative or positive: 0 means positive, 1 means negative
	cmp		al, '-'
	jne		.check_numeric
	inc		ecx
	
	
.loop_read:
	xor		eax, eax
	call	mio_readchar
	call	mio_writechar
	cmp		al, 13			; if enter is pressed
	je		.stop_read

.check_numeric:
	cmp		al, '0'			; check if numeric
	jl		.hiba
	cmp		al, '9'
	jg		.hiba
	
	
	imul	ebx, 10
	sub		al, '0'
	add		ebx, eax		; add new digit
	jmp		.loop_read		; loop if enter not pressed yet
	
.stop_read:					; restore previous values, with result in EAX
	cmp		ecx, 0
	je		.positive
	neg		ebx
.positive:
	mov		eax, 10			; new line
	call	mio_writechar
	mov		eax, ebx
	pop		edx
	pop		ecx
	pop		ebx
	clc						; clear carry to signal succesful read
	ret
	
.hiba:
	pop		edx
	pop		ecx
	pop		ebx
	stc						; set carry to signal error
	ret
	
	
	; print integer, if number is in EAX
write_int:
	push	eax				; save previous values
	push	ebx
	push	ecx
	push	edx

	push	-1				; stopping condition
	cmp		eax, 0
	jge		to_stack		; if positive, skip printing '-'
	push	eax
	mov		eax, '-'
	call	mio_writechar
	pop		eax
	neg		eax
	
to_stack:
	xor		edx, edx		; set EDX to zero to get correct remainder
	mov		ebx, 10			; get last digit
	div		ebx
	add		edx, 48			; to get character
	push	edx
	cmp		eax, 0
	je		from_stack
	jmp		to_stack
	
from_stack:
	pop		eax
	cmp		eax, -1
	je		stop
	call	mio_writechar
	jmp		from_stack
	
stop:							; restore previous values
	mov		eax, 10
	call	mio_writechar		; new line
	pop		edx
	pop		ecx
	pop		ebx
	pop		eax
	ret
	
	
	;print HEX from EAX
write_hex:
	push	eax				; save previous values
	push	ebx
	push	ecx
	push	edx
	
	mov		ebx, eax		; save original input in EBX
	mov		ecx, 8			; loop count
	
	mov		eax, str_hex_prefix
	call	mio_writestr
	mov		eax, ebx
	
.loop_write:
	shr		eax, 28			; shift first word to last 4 bits
	cmp		eax, 9
	jg		.hex_letter
	add		eax, '0'		; if hex digit is numeric, push accordingly
	call	mio_writechar
	jmp		.write_hex_iterate

.hex_letter:
	sub		eax, 10			; convert to A-F hex digit
	add		eax, 'A'
	call	mio_writechar
	
.write_hex_iterate:
	shl		ebx, 4			; prepare next word
	mov		eax, ebx
	loop	.loop_write

	mov		eax, 10
	call	mio_writechar
	pop		edx
	pop		ecx
	pop		ebx
	pop		eax
	ret
	
	
	; read positive hexadecimal number
read_hex:
	push	ebx				; save previous values
	push	ecx
	push	edx
	xor		ebx, ebx		; where we build the number
	
.loop_read:
	xor		eax, eax
	call	mio_readchar
	call	mio_writechar
	
	cmp		al, 13			; if enter is pressed
	je		.stop_read
	
	cmp		al, '0'
	jl		.hiba
	cmp		al, '9'
	jg		.check_uppercase
	
	shl		ebx, 4			; shift left to add new digit
	sub		al, '0'
	add		ebx, eax
	jmp		.loop_read
	
.check_uppercase:
	cmp		al, 'A'
	jl		.hiba
	cmp		al, 'F'
	jg		.check_lowercase
	
	shl		ebx, 4			; shift left to add new digit
	sub		al, 'A'
	add		al, 10
	add		ebx, eax
	jmp		.loop_read
	
.check_lowercase:
	cmp		al, 'a'
	jl		.hiba
	cmp		al, 'f'
	jg		.hiba
	
	shl		ebx, 4			; shift left to add new digit
	sub		al, 'a'
	add		al, 10
	add		ebx, eax
	jmp		.loop_read
	
.stop_read:
	mov		eax, 10			; new line
	call	mio_writechar
	mov		eax, ebx
	pop		edx
	pop		ecx
	pop		ebx
	ret
	
	
.hiba:
	pop		edx
	pop		ecx
	pop		ebx
	stc						; set carry to signal error
	ret
	
	
section .data
	str_ossz		db	'Osszeg: ', 0
	str_hiba		db	'Hiba: Rossz bemenet', 0
	str_beker_int	db	'Adjon meg egy szamot egesz alakban: ', 0
	str_beker_hex	db	'Adjon meg egy szamot hexadecimalis alakban: ', 0
	str_hex_prefix	db	'0x', 0

section .bss