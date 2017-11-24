; nev: Balazs Adam-Attila
; azonosito: baam0146
; csoport: 621
; labor: L3 B 07
; Feladat: Keszítsünk assembly programot, amely beolvas három előjel nélküli egész számot, 32 bites egészként, kiírja a felhasznált szabályt és
; a beolvasott értékeket bináris formában, majd előállítja és végül kiírja bináris formában a művelet eredményét.
; A szabály: C[8:7] AND 10, A[7:5] AND 010, 0, B[11:11] AND A[23:23], A[26:6], B[12:9] + A[31:28]

%include 'mio.inc'

global main

section .text
main:

	mov		eax, str_beker
	call	mio_writestr
	call	mio_writeln
	
	
	; beolvas A
	mov		eax, str_a
	call	mio_writestr
	call	read_hex
	mov		[num_a], eax
	
	; beolvas B
	mov		eax, str_b
	call	mio_writestr
	call	read_hex
	mov		[num_b], eax
	
	; beolvas C
	mov		eax, str_c
	call	mio_writestr
	call	read_hex
	mov		[num_c], eax
	
	; kiirja a kifejezest es a megadott bemenetet
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
	
	
	xor		edx, edx			; itt epitjuk az eredmenyt
	
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


; EAX tartalmat kiirja binaris alakban
write_bin:
	push	eax
	push	ebx
	push	ecx
	push	edx
	
	mov		ebx, eax	; eax-et hasznaljuk kiirasnal
	mov		ecx, 32		; beallitjuk loop counter-t

.bin_loop:
	shl		ebx, 1			; eltoljuk a bitet a Carry-be
	jc		.digit_one
	mov		al, '0'
	jmp		.write_digit
	
.digit_one:
	mov		al, '1'
	
.write_digit:
	call	mio_writechar
	
	; ellenorzi, hogy kell-e szokozt irjon
	mov		eax, ecx	; osztandot eax-be tesszuk
	add		eax, 3
	cdq
	push	ebx			; elmetnjuk az eredeti erteket, hogy osszunk 4-gyel
	mov		ebx, 4
	idiv	ebx
	pop		ebx			; helyreallitjuk az eredeti erteket
	
	cmp		edx, 0		; ha oszthato 4-gyel, akkor kiirunk egy szokozt
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
	
	


; beolvas pozitiv hexadecimalis szamot
read_hex:
	push	ebx				; elmentjuk az eredeti ertekeket
	push	ecx
	push	edx
	xor		ebx, ebx		; itt epitjuk a szamot
	
.loop_read:
	xor		eax, eax
	call	mio_readchar
	call	mio_writechar
	
	cmp		al, 13			; ha lenyomjak az 'enter' billentyut
	je		.stop_read
	
	cmp		al, '0'
	jb		.hiba
	cmp		al, '9'
	ja		.check_uppercase
	
	shl		ebx, 4			; balra tolunk, hogy az uj szamjegyet hozzaragasszuk
	sub		al, '0'
	add		ebx, eax
	jmp		.loop_read
	
.check_uppercase:
	cmp		al, 'A'
	jb		.hiba
	cmp		al, 'F'
	ja		.check_lowercase
	
	shl		ebx, 4			; balra tolunk, hogy az uj szamjegyet hozzaragasszuk
	sub		al, 'A'
	add		al, 10
	add		ebx, eax
	jmp		.loop_read
	
.check_lowercase:
	cmp		al, 'a'
	jb		.hiba
	cmp		al, 'f'
	ja		.hiba
	
	shl		ebx, 4			; balra tolunk, hogy az uj szamjegyet hozzaragasszuk
	sub		al, 'a'
	add		al, 10
	add		ebx, eax
	jmp		.loop_read
	
.stop_read:
	mov		eax, 10			; uj sor
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
	stc						; beallitjuk a carry-t, hogy hibat jelezzunk
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
