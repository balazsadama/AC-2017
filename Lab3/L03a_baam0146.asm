; nev: Balazs Adam-Attila
; azonosito: baam0146
; csoport: 621
; labor: L3 A
; Feladat: Írjunk assembly eljárást amely egy 32 bites, előjel nélküli egész számot ír ki a képernyőre bináris formában

%include 'mio.inc'

global main

section .text
main:
	
	call	read_hex
	call	write_bin
	ret
	
	
	
	; write in binary form from EAX
write_bin:
	push	eax
	push	ebx
	push	ecx
	push	edx
	
	mov		ebx, eax	; eax needed to write characters
	mov		ecx, 32		; set loop counter

.bin_loop:
	shl		ebx			; shift digit into carry
	jc		.digit_one
	mov		al, '0'
	jmp		.write_digit
	
.digit_one:
	mov		al, '1'
	
.write_digit:
	call	mio_writechar
	
	; check if space needs to be printed for grouping digits by 4
	mov		eax, ecx	; move dividend(loop count) to EAX
	add		eax, 3
	cdq
	push	ebx			; save value to use for division by 4
	mov		ebx, 4
	idiv	ebx
	pop		ebx			; restore original value
	
	cmp		edx, 0		; if dividable by 4, then space needs to be printed
	jne		.loop_write
	mov		al, ' '
	call	mio_writechar
	
.loop_write:
	loop	.bin_loop
	
	call	mio_writeln
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


section .bss
