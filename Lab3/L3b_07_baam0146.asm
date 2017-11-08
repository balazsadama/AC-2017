; nev: Balazs Adam-Attila
; azonosito: baam0146
; csoport: 621
; labor: L3 B 07
; Feladat: Keszítsünk assembly programot, amely beolvas három előjel nélküli egész számot, 32 bites egészként, kiírja a felhasznált szabályt és
; a beolvasott értékeket bináris formában, majd előállítja és végül kiírja bináris formában a művelet eredményét.

%include 'mio.inc'

global main

section .text
main:

	mov		eax, str_beker
	call	mio_writestr
	call	mio_writeln
	
	; read A
	mov		eax, str_a
	call	mio_writestr
	call	read_hex
	mov		[num_a], eax
	
	; read B
	mov		eax, str_b
	call	mio_writestr
	call	read_hex
	mov		[num_b], eax
	
	; read C
	mov		eax, str_c
	call	mio_writestr
	call	read_hex
	mov		[num_c], eax
	
	; write expression and given input
	mov		eax, str_expr
	call	mio_writestr
	call	mio_writeln
	
	mov		eax, str_a
	call	mio_writestr
	mov		eax, [num_a]
	call	write_bin
	
	mov		eax, str_b
	call	mio_writestr
	mov		eax, [num_b]
	call	write_bin
	
	mov		eax, str_c
	call	mio_writestr
	mov		eax, [num_c]
	call	write_bin
	
	
	xor		edx, edx			; where we will build the result
	
	mov		eax, [num_c]
	shr		eax, 7
	and		eax, 11b			; EAX = C[8:7]
	and		eax, 10b			; EAX = C[8:7] and 10
	
	mov		edx, eax			; EDX = C[8:7] and 10
	
	
	mov		eax, [num_a]
	shr		eax, 5
	and		eax, 111b			; EAX = A[7:5]
	and		eax, 010b			; EAX = A[7:5] and 010
	
	shl		edx, 3
	add		edx, eax			; EDX = C[8:7] and 10, A[7:5] and 010
	
	
	shl		edx, 1				; EDX = C[8:7] and 10, A[7:5] and 010, 0
	
	
	mov		eax, [num_a]
	shr		eax, 23
	and		eax, 1b				; EAX = A[23:23]
	
	mov		ebx, [num_b]
	shr		ebx, 11
	and		ebx, 1b				; EBX = B[11:11]
	
	and		eax, ebx			; EAX = B[11:11] AND A[23:23]
	shl		edx, 1
	add		edx, eax			; EDX = C[8:7] and 10, A[7:5] and 010, 0, B[11:11] AND A[23:23]
	
	
	mov		eax, [num_a]
	shl		eax, 5
	shr		eax, 11				; EAX = A[26:6]
	shl		edx, 21
	add		edx, eax			; EDX = C[8:7] and 10, A[7:5] and 010, 0, B[11:11] AND A[23:23], A[26:6]
	
	
	mov		eax, [num_a]
	shr		eax, 28				; EAX = A[31:28]
	mov		ebx, [num_b]
	shr		ebx, 9
	and		ebx, 1111b			; EBX = B[12:9]
	add		eax, ebx
	and		eax, 1111b			; EAX = B[12:9] + A[31:28]
	
	shl		edx, 4
	add		edx, eax
	
	mov		eax, edx
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
	str_expr	db	'C[8:7] AND 10, A[7:5] AND 010, 0, B[11:11] AND A[23:23], A[26:6], B[12:9] + A[31:28]', 0
	str_beker	db	'Adjon meg 3 elojel nelkuli egesz szamot hexadecimalis alakban:', 0
	str_a		db	'A = ', 0
	str_b		db	'B = ', 0
	str_c		db	'C = ', 0

section .bss
	num_a		resd	1
	num_b		resd	1
	num_c		resd	1
