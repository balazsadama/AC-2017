; nev: Balazs Adam-Attila
; azonosito: baam0146
; csoport: 621
; labor: L3 C 07 pascal
; Feladat: Készítsünk két assembly programot (NASM), amelyek beolvassák a szükséges karakterláncokat, kiírják a felhasznált szabályt (mint üzenetet) és a beolvasott karakterláncokat
; külön sorokba, majd előállítják és végül kiírják a művelet eredményét, ami szintén egy karakterlánc.
; A szabaly: "abcde" + [A-ból azok a karakterek, amelyek "" jelek között vannak (minden második " jel után az a szakasz befejeződik és egy újabb " kell ahhoz, hogy újabb szakasz
; nyíljon, valamint be is kell fejeződjön "-al, hogy érvényes legyen)] + "edcba" + [B, minden kisbetűt a rákövetkező betűvel helyettesítjük (kivéve a z-t, az marad)]

%include 'mio.inc'

global main

section .text
main:

	mov		edi, str_res
	mov		eax, [str_res_len]
	stosb
	mov		esi, str_res
	call	write_str_pascal
	call	mio_writeln
	
	mov		edi, str_res
	add		edi, 6
	xor		eax, eax
	mov		al, 'e'
	stosb
	mov		al, 'd'
	stosb
	mov		al, 'c'
	stosb
	mov		al, 'b'
	stosb
	mov		al, 'a'
	stosb
	
	mov		edi, str_res
	;add		byte [str_res_len], 5	; noveljuk az eredmeny karakterlanc hosszat
	;mov		eax, [str_res_len]
	mov		eax, 11
	stosb
	
	call	write_str_pascal
	call	mio_writeln
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	


	call	read_input
	call	write_given_input
	
	call	solve
	call	write_res
	
	ret

	
	

	
	
read_str_pascal:
	push	eax				; elmentjuk az eredeti ertekeket
	push	ebx
	push	ecx
	push	edx
	push	edi
	
	mov		ebx, edi		; elmentjuk a karakterlanc memoriabeli kezdocimet, hogy be tudjuk irni a hosszat
	inc		edi
	xor		ecx, ecx		; szamoljuk a beolvasott karaktereket
	
.loop_read:
	xor		eax, eax
	call	mio_readchar
	call	mio_writechar
	
	cmp		al, 13			; ha lenyomjak az 'enter' billentyut
	je		.stop_read
	stosb
	inc		ecx				; karakterek szamat noveljuk
	jmp		.loop_read
	
	
.stop_read:
	mov		eax, ecx		; a 0. karaktert beallitjuk a hosszra
	mov		edi, ebx		; az elso poziciora irjuk a hosszt
	stosb
	
	call	mio_writeln
	
	pop		edi
	pop		edx
	pop		ecx
	pop		ebx
	pop		eax
	ret
	
	
write_str_pascal:
	push	eax				; elmentjuk az eredeti ertekeket
	push	ebx
	push	ecx
	push	edx
	push	esi
	
	xor		eax, eax
	lodsb					; betoltjuk a hosszt
	mov		ecx, eax		; beallitjuk a loop counter-t
	jecxz	.end
.loop_write:
	lodsb
	call	mio_writechar
	loop	.loop_write
	
.end:
	call	mio_writeln
	pop		esi
	pop		edx
	pop		ecx
	pop		ebx
	pop		eax
	ret
	
	
solve:
	push	eax				; elmentjuk az eredeti ertekeket
	push	ebx
	push	ecx
	push	edx
	push	esi
	push	edi
	
	
	mov		edi, str_res
	add		edi, 6			; mert "0abcde" a str_res kezdeti erteke

	
	mov		esi, str_A		; beallitjuk a forras cimet
	
	xor		eax, eax		; a feldolgozando karakterlanc hosszat az ECX-be tesszuk
	lodsb
	mov		ecx, eax
	
	mov		ebx, 5			; eredmeny karakterlanc hossza
	xor		edx, edx		; szamoljuk az idezojelek kozti karaktereket
	
.loop_quote:
	jecxz	.end_A
	lodsb
	
	cmp		al, '"'
	je		.is_quote
	
	cmp		ebx, 0
	jne		.count_chars
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;loop	.loop_quote		; ha nincs idezojel nyitva, akkor vesszuk a kov. karaktert
	dec		ecx
	jmp		.loop_quote
	
.count_chars:
	inc		edx				; kulonben noveljuk az idezojelek kozti karakterek szamat
	dec		ecx
	jmp		.loop_quote
	
.is_quote:
	push	ebx				; quotes = 0 ha nincs zarojel nyitva, kulonben 1
	mov		ebx, [quotes]
	cmp		ebx, 0
	pop		ebx
	je		.start_quote	; ha 0 akkor idezojel nyitva
	
	; ha idezojel zarva, akkor kiirjuk a koztuk levo karaktereket
	mov		[qotes], 0		; jelezzuk, hogy vege az idezojelnek
	
	

	
	;jecxz	.loop_quote		; ha nincs karakter idezojelek kozott, akkor vizsgaljuk a kovetkezo karaktert
	cmp		edx, 0
	loop	.loop_quote
	
	
	
	
	
	
	
	sub		esi, edx		; visszalepunk a nyitott idezojel utani karakterre
	sub		esi, 1
	
	push	ecx
	mov		ecx, edx
.between_quotes:
	lodsb
	stosb
	;call	mio_writechar		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	inc		ebx				; noveljuk az eredmeny karakterlanc hosszat
	dec		ecx
	jmp		.loop_quote
	
	inc		esi				; lep a zaro idezojel utan kovetkezo beture
	pop		ecx				; helyreallitjuk ecx erteket
	xor		edx, edx		; az idezojelek kozti karakterek szamat lenullazzuk, hiszen kiirtuk oket
	dec		ecx
	jmp		.loop_quote
	
.start_quote:
	mov		[qotes], 1
	dec		ecx
	jmp		.loop_quote
	
.end_A:
	mov		al, 'e'
	stosb
	mov		al, 'd'
	stosb
	mov		al, 'c'
	stosb
	mov		al, 'b'
	stosb
	mov		al, 'a'
	stosb
	add		ebx, 5	; noveljuk az eredmeny karakterlanc hosszat

	; feldolgozzuk a B karakterlancot
	mov		esi, str_B
	xor		eax, eax		; a karakterlanc hosszat az ECX-be tesszuk
	lodsb
	mov		ecx, eax
.loop_B:
	jecxz	.end
	lodsb
	
	cmp		al, 'a'
	jb		.add_to_res
	
	cmp		al, 'z'
	jae		.add_to_res
	
	inc		al				; rakovetkezo beture helyettesitjuk
.add_to_res:
	stosb
	inc		ebx				; noveljuk az eredmeny karakterlanc hosszat
	dec		ecx
	dec		ecx
	jmp		.loop_quote
	
.end:
	mov		edi, str_res
	mov		eax, ebx
	stosb
	;call	mio_writeln
	pop		edi
	pop		esi
	pop		edx
	pop		ecx
	pop		ebx
	pop		eax
	ret
	
	
	
	
	
	
read_input:
	push	eax
	push	edi
	
	mov		eax, str_be
	call	mio_writestr
	
	mov		edi, str_A
	call	read_str_pascal

	mov		eax, str_be
	call	mio_writestr
	
	mov		edi, str_B
	call	read_str_pascal
	
	pop		edi
	pop		eax
	
	ret
	
	
write_given_input:
	push	eax
	push	esi

	mov		eax, str_szabaly
	call	mio_writestr
	call	mio_writeln
	
	mov		eax, 'A'
	call	mio_writechar
	mov		eax, '='
	call	mio_writechar
	mov		esi, str_A
	call	write_str_pascal
	
	mov		eax, 'B'
	call	mio_writechar
	mov		eax, '='
	call	mio_writechar
	mov		esi, str_B
	call	write_str_pascal
	
	pop		esi
	pop		eax
	ret
	
write_res:
	push	esi
	
	mov		esi, str_res
	call	write_str_pascal
	
	pop		esi
	ret
	
	
section .data
	str_be			db	'Adjon meg egy karakterlancot: ', 0
	str_szabaly		db	'"abcde" + [A-bol azok a karakterek, amelyek "" jelek kozott vannak (minden masodik " jel utan az a szakasz befejezodik es egy ujabb " kell ahhoz, hogy ujabb szakasz nyiljon, valamint be is kell fejezodjon "-al, hogy ervenyes legyen)] + "edcba" + [B, minden kisbetut a rakovetkezo betuvel helyettesitjuk (kiveve a z-t, az marad)]', 0
	str_res			db	'0abcde'	; az elso karakter folul lesz irva a hosszal
	;str_res_len		db	5			; az eredmeny karakterlanc hossza
	quotes			db	0
section .bss
	str_A		resb	256
	str_B		resb	256