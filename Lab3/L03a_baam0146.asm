; nev: Balazs Adam-Attila
; azonosito: baam0146
; csoport: 621
; labor: L3 A
; Feladat: Írjunk assembly eljárást amely egy 32 bites, előjel nélküli egész számot ír ki a képernyőre bináris formában

%include 'mio.inc'

global main

section .text
main:

	; KERDES: szamok osszeadasakor elofordulo tulcsordulas eseten ki kell irni a carry bit-et is?

	mov		eax, str_beker_hex	; ask for input
	call	mio_writestr
	call	mio_writeln
	
.be_hex1:
	mov		eax, str_a
	call	mio_writestr
	call	read_hex
	jc		.hibakezeles_hex1
	
	mov		ebx, eax
.be_hex2:
	mov		eax, str_b
	call	mio_writestr
	call	read_hex
	jc		.hibakezeles_hex1
	
	mov		ecx, eax
	mov		eax, str_a				; print A
	call	mio_writestr
	mov		eax, ebx
	call	write_bin
	
	mov		eax, str_b				; print B
	call	mio_writestr
	mov		eax, ecx
	call	write_bin
	
	mov		eax, str_ab				; print A + B
	call	mio_writestr
	mov		eax, ebx
	add		eax, ecx
	call	write_bin
	
	ret
	
	
	
.hibakezeles_hex1:
	call	mio_writeln
	mov		eax, str_hiba
	call	mio_writestr
	call	mio_writeln
	jmp		.be_hex1
	
.hibakezeles_hex2:
	call	mio_writeln
	mov		eax, str_hiba
	call	mio_writestr
	call	mio_writeln
	jmp		.be_hex2
	
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
	shl		ebx, 1			; shift digit into carry
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
	str_a			db	'A = ', 0
	str_b			db	'B = ', 0
	str_ab			db	'A + B = ', 0
	str_beker_hex	db	'Adjon meg ket szamot hexadecimalis alakban: ', 0
	str_hiba		db	'Hiba: Rossz bemenet', 0

section .bss
