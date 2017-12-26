; nev: Balazs Adam-Attila
; azonosito: baam0146
; csoport: 621
; labor: L5
; Feladat: E(a,b,c,d) = (a^2 - b + c) / d + (a - b^3 + d) / c - 2.7

%include 'mio.inc'

;;;;;;;;;;;;;;;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!
%include 'io.inc'
;;;;;;;;;;;;;;;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!

global main

section .text

main:

	; call	io_readflt
	; call	io_writeflt
	; call	mio_writeln
	
	; call	ReadFloat
	; call	io_writeflt
	; call	mio_writeln

	; call	io_readflt
	; movss	[num_a], xmm0
	
	; call	io_readflt
	; movss	[num_b], xmm0
	
	; call	io_readflt
	; movss	[num_c], xmm0
	
	; call	io_readflt
	; movss	[num_d], xmm0
	
	; call	Calculate
	; movss	xmm0, [res]
	; call	io_writeflt
	
	
	
	call	ReadFloat
	movss	[num_a], xmm0
	
	call	ReadFloat
	movss	[num_b], xmm0
	
	call	ReadFloat
	movss	[num_c], xmm0
	
	call	ReadFloat
	movss	[num_d], xmm0
	
	call	Calculate
	movss	xmm0, [res]
	call	io_writeflt
	
	
	
	
	ret
	
	

	
Calculate:
	pushad
	
	movss	xmm0, [num_a]
	mulss	xmm0, xmm0						; xmm0 = a^2
	
	movss	xmm1, [num_b]					; xmm1 = b
	subss	xmm0, xmm1						; xmm0 = a^2 - b
	
	addss	xmm0, [num_c]					; xmm0 = a^2 - b + c
	divss	xmm0, [num_d]					; xmm0 = (a^2 - b + c) / d
	
	mulss	xmm1, xmm1						; xmm1 = b^2
	mulss	xmm1, [num_b]					; xmm1 = b^3
	
	movss	xmm2, [num_a]					; xmm2 = a
	subss	xmm2, xmm1						; xmm2 = a - b^3
	addss	xmm2, [num_d]					; xmm2 = a - b^3 + d
	divss	xmm2, [num_c]					; xmm2 = (a - b^3 + d) / c
	
	addss	xmm0, xmm2						; xmm0 = (a^2 - b + c) / d + (a - b^3 + d) / c
	subss	xmm0, [konst]					; xmm0 = (a^2 - b + c) / d + (a - b^3 + d) / c - 2.7
	
	movss	[res], xmm0
	
	popad
	ret

ReadFloat:
	push	ebx
	push	ecx
	push	edx
	
	xor		ecx, ecx			; szamoljuk, hogy hany karakter volt eddig beolvasva
	
	push	ebp					; a veremben "lokalisan memoriat foglalunk"
    mov		ebp, esp
	sub		esp, 50				; 50 karakternek hagyunk helyet
	
.loop_read:
	call	mio_readchar
	cmp		al, 13				; ha enter
	je		.end_read
	call	mio_writechar
	inc		ecx					; noveljuk a beolvasott karakterek szamat
	
	cmp		al, 0x08			; ha backspace
	je		.backspace
	
	cmp		ecx, 50
	jg		.loop_read			; ha mar tobb mint 11 karaktert olvastunk be, akkor azt nem taroljuk
	
	mov		BYTE [esp + ecx - 1], al
	jmp		.loop_read
	
.backspace:
	jecxz	.loop_read			; ha nincs karakter a kepernyon, akkor a backspace-nek nincs hatasa
	
	mov		al, 0x20			; space
	call	mio_writechar
	mov		al, 0x08			; backspace
	call	mio_writechar
	dec		ecx					; backspace miatt
	dec		ecx					; kitorolt karakter miatt
	jmp		.loop_read
	
.end_read:
	xor		ebx, ebx			; hogy kesobb osszeadasnal ne legyen szemet ertek benne
	xor		edx, edx			; szamoljuk a feldolgozott karaktereket
	xor		eax, eax			; epitjuk a szamot
	
	cmp		ecx, 50
	jg		.error				; ha tul hosszu a szam, akkor hiba
	
.loop_build:
	cmp		edx, ecx
	je		.end_no_point
	
	mov		BYTE bl, [esp + edx]; betoltjuk akaraktert
	
	cmp		bl, '.'
	je		.point
	
	cmp		bl, '-'
	jne		.skipNegative
	mov		BYTE [esp], bl		; hogy a vegen tudjuk, hogy kell-e negalni a szamot
	inc		edx
	jmp		.loop_build
	
.skipNegative:
	cmp		bl, '0'
	jb		.error
	
	cmp		bl, '9'
	ja		.error
	
	sub		bl, '0'
	imul	eax, 10
	jo		.error				; ha tulcsordulas tortent, akkor hiba
	add		eax, ebx
	
	inc		edx
	jmp		.loop_build
	
.error:
	stc
	jmp		.pop_return
	
	
	
	
	
.point:
	xorps	xmm0, xmm0			; itt taroljuk a szam egesz reszet
	xorps	xmm1, xmm1			; itt epitjuk a szam valos reszet
	cvtsi2ss xmm0, eax			; a szam egesz reszet konvertaljuk float-ba az xmm2 regiszterbe
	inc		edx
	
	
.loop_point:
	cmp		edx, ecx
	je		.end_point
	
	mov		BYTE bl, [esp + ecx - 1]; betoltjuk akaraktert
	
	cmp		bl, '0'
	jb		.error
	
	cmp		bl, '9'
	ja		.error
	
	sub		bl, '0'
	cvtsi2ss xmm2, ebx			; xmm2-be tesszuk az uj szamjegyet float-kent
	mulss	xmm1, [point_one]	; a szam eddigi valos reszet megszorozzuk 0.1-gyel
	mulss	xmm2, [point_one]	; az uj szamjegyet megszorozzuk 0.1-gyel
	addss	xmm1, xmm2			; hozzaadjuk az uj szamjegyet
	
	dec		ecx
	jmp		.loop_point
	
	
	
	
	
.end_no_point:
	cvtsi2ss xmm0, eax			; ha nem volt pont beolvasva, akkor itt tortenik a konverzio
	jmp		.sign
	
	
.end_point:
	addss	xmm0, xmm1			; hozzaadjuk a valos reszt az egesz reszhez
	
.sign:
	mov		BYTE bl, [esp]
	cmp		bl, '-'
	jne		.positive			; ha nem volt minusz jel megadva a szam elejen, akkor pozitivkent kezeljuk
	
	mulss	xmm0, [minus_one]	; megszorozzuk (-1)-gyel
	clc
	jmp		.pop_return
	
.positive:
	clc
	
.pop_return:
	mov		esp, ebp
    pop		ebp
	
	pop		edx
	pop		ecx
	pop		ebx
	
	call	mio_writeln
	ret


section .data
	konst		dd		2.7
	point_one	dd		0.1
	minus_one	dd		-1.0

section .bss
	num_a	resd	1
	num_b	resd	1
	num_c	resd	1
	num_d	resd	1
	res		resd	1