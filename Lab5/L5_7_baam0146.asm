; nev: Balazs Adam-Attila
; azonosito: baam0146
; csoport: 621
; labor: L5
; Feladat: E(a,b,c,d) = (a^2 - b + c) / d + (a - b^3 + d) / c - 2.7

%include 'mio.inc'


global main

section .text

main:

	call	ReadFloat
	call	mio_writeln
	call	WriteFloat
	call	mio_writeln
	call	WriteFloatExp

	; mov		esi, str1
	; call	WriteStr
	; call	ReadFloat
	
	; call	WriteFloat
	; call	mio_writeln
	
	; call	mio_writeln
	; movss	[num_a], xmm0
	
	; mov		esi, str2
	; call	WriteStr
	; call	ReadFloat
	
	; call	WriteFloat
	; call	mio_writeln
	
	; call	mio_writeln
	; movss	[num_b], xmm0
	
	; mov		esi, str1
	; call	WriteStr
	; call	ReadFloat
	
	; call	WriteFloat
	; call	mio_writeln
	
	; call	mio_writeln
	; movss	[num_c], xmm0
	
	; mov		esi, str2
	; call	WriteStr
	; call	ReadFloat
	
	; call	WriteFloat
	; call	mio_writeln
	
	; call	mio_writeln
	; movss	[num_d], xmm0
	
	; call	Calculate
	; movss	xmm0, [res]
	; call	WriteFloat
	; call	mio_writeln
	; call	WriteFloatExp
	
	
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
	jg		.loop_read			; ha mar tobb mint 11 karaktert olvastunk be, amilor azt nem taroljuk
	
	mov		BYTE [esp + ecx - 1], al
	jmp		.loop_read
	
.backspace:
	jecxz	.loop_read			; ha nincs karakter a kepernyon, amilor a backspace-nek nincs hatasa
	
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
	jg		.error				; ha tul hosszu a szam, amilor hiba
	
.loop_build:
	cmp		edx, ecx
	je		.end_no_point
	
	mov		BYTE bl, [esp + edx]; betoltjuk akaraktert
	
	cmp		bl, '.'
	je		.point
	cmp		bl, 'e'
	je		.exponential
	cmp		bl, 'E'
	je		.exponential
	
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
	jo		.error				; ha tulcsordulas tortent, amilor hiba
	add		eax, ebx
	
	inc		edx
	jmp		.loop_build
	
.error:
	stc
	jmp		.pop_return
	
.exponential:					; fel kell dolgoznunk az 'e' utani karaktereket
	inc		edx
	xor		eax, eax			; itt epitjuk az 'e' utani szamot

.loop_after_e:
	cmp		edx, ecx
	je		.end_exp
	
	mov		BYTE bl, [esp + edx]; betoltjuk a karaktert
	cmp		bl, '-'
	je		.neg_after_e
	cmp		bl, '0'
	jb		.error
	cmp		bl, '9'
	ja		.error
	sub		bl, '0'
	imul	eax, 10
	jo		.error
	add		eax, ebx
	inc		edx
	jmp		.loop_after_e
	
.neg_after_e:
	inc		edx
	cmp		edx, ecx
	je		.end_exp
	
	mov		BYTE bl, [esp + edx]; betoltjuk a karaktert
	cmp		bl, '0'
	jb		.error
	cmp		bl, '9'
	ja		.error
	sub		bl, '0'
	imul	eax, 10
	jo		.error
	sub		eax, ebx
	jmp		.neg_after_e

.end_exp:
	cmp		eax, 0
	jl		.loop_div
	
.loop_mul:
	cmp		eax, 0
	je		.sign
	mulss	xmm0, [ten]
	jo		.error
	dec		eax
	jmp		.loop_mul
	
.loop_div:
	cmp		eax, 0
	je		.sign
	divss	xmm0, [ten]
	jo		.error
	add		eax, 1
	jmp		.loop_div
	
	
	

.point:
	xorps	xmm0, xmm0			; itt taroljuk a szam egesz reszet
	xorps	xmm1, xmm1			; itt epitjuk a szam valos reszet
	cvtsi2ss xmm0, eax			; a szam egesz reszet konvertaljuk float-ba az xmm2 regiszterbe
	inc		edx
	
	movss	xmm2, [point_one]	; szorozni eloszor 0.1-gyel, utana 0.01, 0.001 stb
	
.loop_point:
	cmp		edx, ecx
	je		.end_point
	
	mov		BYTE bl, [esp + edx]; betoltjuk akaraktert
	cmp		bl, 'e'
	je		.exponential
	cmp		bl, 'E'
	je		.exponential
	cmp		bl, '0'
	jb		.error
	cmp		bl, '9'
	ja		.error
	
	sub		bl, '0'
	cvtsi2ss xmm1, ebx			; xmm2-be tesszuk az uj szamjegyet float-kent
	;mulss	xmm1, [point_one]	; a szam eddigi valos reszet megszorozzuk 0.1-gyel
	mulss	xmm1, xmm2	; az uj szamjegyet megszorozzuk 10 megfelelo hatvanyaval
	mulss	xmm2, [point_one]
	addss	xmm0, xmm1			; hozzaadjuk az uj szamjegyet
	
	;dec		ecx
	inc		edx
	jmp		.loop_point

.end_no_point:
	cvtsi2ss xmm0, eax			; ha nem volt pont beolvasva, amikor itt tortenik a konverzio
	jmp		.sign
	
.end_point:
	addss	xmm0, xmm1			; hozzaadjuk a valos reszt az egesz reszhez
	
.sign:
	mov		BYTE bl, [esp]
	cmp		bl, '-'
	jne		.positive			; ha nem volt minusz jel megadva a szam elejen, amilor pozitivkent kezeljuk
	
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
	
	ret
	
WriteFloat:
	pushad
	push	ebp					; a veremben "lokalisan memoriat foglalunk"
    mov		ebp, esp
	sub		esp, 32				; 2*16 byte ket xmm_ regiszternek
	
	movdqu	[esp], xmm0
	movdqu	[esp + 16], xmm1
	
	comiss	xmm0, [zero]
	jae		.positive
	mov		eax, '-'
	call	mio_writechar
	mulss	xmm0, [minus_one]
	
.positive:
	cvttss2si eax, xmm0
	call	WriteInt			; kiirjuk az egesz reszet
	cvtsi2ss xmm1, eax
	mov		eax, '.'
	call	mio_writechar
	subss	xmm0, xmm1			; megtartjuk a tortreszt
	mulss	xmm0, [mil]			; 6 tizedes pontossaggal irjuk ki
	cvttss2si eax, xmm0
	call	WriteInt			; kiirjuk az egesz reszet
	
	
	movdqu xmm1, [esp + 16]
	movdqu xmm0, [esp]
	
	mov		esp, ebp
    pop		ebp
	popad
	ret
	
WriteFloatExp:
	pushad
	push	ebp					; a veremben "lokalisan memoriat foglalunk"
    mov		ebp, esp
	sub		esp, 32				; 2*16 byte ket xmm_ regiszternek
	xor		ebx, ebx			; szamoljuk az exponenset
	
	movdqu	[esp], xmm0
	movdqu	[esp + 16], xmm1
	
	comiss	xmm0, [zero]
	jae		.loop_div
	mov		eax, '-'
	call	mio_writechar
	mulss	xmm0, [minus_one]
	
.loop_div:
	comiss	xmm0, [ten]			; ha nagyobb, mint 10, amilor addig osztunk, amig csak egy szamjegy marad egesz resznek
	jb		.loop_mul
	divss	xmm0, [ten]
	inc		ebx
	jmp		.loop_div
	
.loop_mul:
	comiss	xmm0, [one]			; ha kisebb, mint 1, amilor addig szorzunk, amig csak egy szamjegy marad egesz resznek
	jae		.stop_mul
	mulss	xmm0, [ten]
	dec		ebx
	jmp		.loop_mul
	
.stop_mul:
	cvttss2si eax, xmm0
	cvtsi2ss xmm1, eax
	add		eax, '0'
	call	mio_writechar
	mov		eax, '.'
	call	mio_writechar
	
	mov		ecx, 6				; max 6 pontossaggal irjuk ki
.while_not_zero:
	jecxz	.stop
	subss	xmm0, xmm1
	comiss	xmm0, [zero]
	je		.stop
	mulss	xmm0, [ten]
	cvttss2si eax, xmm0
	cvtsi2ss xmm1, eax
	add		eax, '0'
	call	mio_writechar
	dec		ecx
	jmp		.while_not_zero
	
.stop:
	mov		eax, 'e'
	call	mio_writechar
	mov		eax, ebx
	call	WriteInt
	
	movdqu xmm1, [esp + 16]
	movdqu xmm0, [esp]
	mov		esp, ebp
    pop		ebp
	popad
	ret
	
WriteInt:
	push	eax				; elmentjuk az eredeti ertekeket
	push	ebx
	push	ecx
	push	edx

	push	-1				; megallasi feltetel
	cmp		eax, 0
	jge		.to_stack		; ha pozitiv, nem irjuk ki a '-' jelet
	push	eax
	mov		eax, '-'
	call	mio_writechar
	pop		eax
	neg		eax
	
.to_stack:
	xor		edx, edx			; EDX-et nullara allitjuk, hogy jol osszon
	mov		ebx, 10				; tizzel osztunk, hogy az utolso szamjegyet kapjuk marademilent
	div		ebx	
	add		edx, 48				; karakterre alakitjuk szamjegybol
	push	edx
	cmp		eax, 0
	je		.from_stack
	jmp		.to_stack
	
.from_stack:
	pop		eax
	cmp		eax, -1
	je		.stop
	call	mio_writechar
	jmp		.from_stack
	
.stop:							; helyreallitja az eredeti ertekeket
	pop		edx
	pop		ecx
	pop		ebx
	pop		eax
	ret
	
WriteStr:
	pushad						; elmentjuk az eredeti ertekeket
	
.loop_write:
	lodsb
	cmp		al, 0
	je		.end
	call	mio_writechar
	jmp		.loop_write
	
.end:
	call	mio_writeln
	popad
	ret


section .data
	str1		db		'Adjon meg egy egyszeres pontossagu lebegopontos erteket hagyomanyos formaban: ', 0
	str2		db		'Adjon meg egy egyszeres pontossagu lebegopontos erteket exponencialis formaban: ', 0
	konst		dd		2.7
	point_one	dd		0.1
	one			dd		1.0
	minus_one	dd		-1.0
	ten			dd		10.0
	zero		dd		0.0
	mil			dd		1000000.0
	var			dd		0.1

section .bss
	num_a	resd	1
	num_b	resd	1
	num_c	resd	1
	num_d	resd	1
	res		resd	1