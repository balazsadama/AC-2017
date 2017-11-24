; nev: Balazs Adam-Attila
; azonosito: baam0146
; csoport: 621
; labor: L3 A
; Feladat: Írjunk assembly eljárást amely egy 32 bites, előjel nélküli egész számot ír ki a képernyőre bináris formában

%include 'mio.inc'

global main

section .text
main:

	mov		eax, str_beker_hex	; bekeri a bemenetet
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
	mov		eax, str_a				; ki A
	call	mio_writestr
	mov		eax, ebx
	call	write_bin
	
	mov		eax, str_b				; ki B
	call	mio_writestr
	mov		eax, ecx
	call	write_bin
	
	mov		eax, str_ab				; ki A + B
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
	
	
	
	; kiirja az EAX-ben levo erteket binaris alakban
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
	
	
	; beolvas egy hexadecimalis szamot
read_hex:
	push	ebx				; elmetnjuk az eredeti ertekeket
	push	ecx
	push	edx
	xor		ebx, ebx		; itt epitjuk a szamot
	
.loop_read:
	xor		eax, eax
	call	mio_readchar
	call	mio_writechar
	
	cmp		al, 13			; ha enter le van nyomva
	je		.stop_read
	
	cmp		al, '0'
	jb		.hiba
	cmp		al, '9'
	ja		.check_uppercase
	
	shl		ebx, 4			; balra toljuk hogy kovetkezo szamjegyet hozzaadhassuk
	sub		al, '0'
	add		ebx, eax
	jmp		.loop_read
	
.check_uppercase:
	cmp		al, 'A'
	jb		.hiba
	cmp		al, 'F'
	ja		.check_lowercase
	
	shl		ebx, 4			; balra toljuk hogy kovetkezo szamjegyet hozzaadhassuk
	sub		al, 'A'
	add		al, 10
	add		ebx, eax
	jmp		.loop_read
	
.check_lowercase:
	cmp		al, 'a'
	jb		.hiba
	cmp		al, 'f'
	ja		.hiba
	
	shl		ebx, 4			; balra toljuk hogy kovetkezo szamjegyet hozzaadhassuk
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
	str_a			db	'A = ', 0
	str_b			db	'B = ', 0
	str_ab			db	'A + B = ', 0
	str_beker_hex	db	'Adjon meg ket szamot hexadecimalis alakban: ', 0
	str_hiba		db	'Hiba: Rossz bemenet', 0

section .bss
