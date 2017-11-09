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
	mov		eax, str_beker_int	; beker egy szamot decimalis egesz alakban
	call	mio_writestr
	call	read_dec_int
	jc		.hibakezeles_int

	mov		ebx, eax
	mov		eax, str_int_alak	; kiirjuk a beolvasott szamot decimalis egesz alakban
	call	mio_writestr
	mov		eax, ebx
	call	write_int
	
	mov		eax, str_hex_alak	; kiirjuk a beolvasott szamot hexadecimalis alakban
	call	mio_writestr
	mov		eax, ebx
	call	write_hex
	
.beker_hex:
	mov		eax, str_beker_hex	; beker egy szamot hexadecimalis alakban
	call	mio_writestr
	call	read_hex
	jc		.hibakezeles_hex
	
	mov		ecx, eax
	mov		eax, str_int_alak	; kiirjuk a beolvasott szamot decimalis egesz alakban
	call	mio_writestr
	mov		eax, ecx
	call	write_int
	
	mov		eax, str_hex_alak	; kiirjuk a beolvasott szamot hexadecimalis alakban
	call	mio_writestr
	mov		eax, ecx
	call	write_hex
	
	mov		eax, str_ossz		; kiirjuk az osszeadasra vonatkozo szoveget
	call	mio_writestr
	call	mio_writeln
	mov		eax, ecx
	
	add		ecx, ebx
	
	mov		eax, str_int_alak	; kiirjuk az osszeget decimalis egesz alakban
	call	mio_writestr
	mov		eax, ecx
	call	write_int
	
	mov		eax, str_hex_alak	; kiirjuk az osszeget hexadecimalis alakban
	call	mio_writestr
	mov		eax, ecx
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


	; beolvas decimalis egeszt (integer) EAX regiszterbe
read_dec_int:
	push	ebx				; elmentjuk az eredeti ertekeket
	push	ecx
	push	edx
	xor		ebx, ebx		; itt epitjuk a szamot

; check for negative sign
	xor		eax, eax
	call	mio_readchar
	call	mio_writechar	
	
	xor		ecx, ecx		; eldonti, hogy negativ vagy pozitiv: 0 = pozitiv, 1 = negativ
	cmp		al, '-'
	jne		.check_numeric
	inc		ecx
	
	
.loop_read:
	xor		eax, eax
	call	mio_readchar
	call	mio_writechar
	cmp		al, 13			; ha 'enter' le van nyomva
	je		.stop_read

.check_numeric:
	cmp		al, '0'			; ellenorzi, hogy numerikus-e
	jl		.hiba
	cmp		al, '9'
	jg		.hiba
	
	
	imul	ebx, 10
	sub		al, '0'
	add		ebx, eax		; hozzaragasztja az uj szamjegyet
	jmp		.loop_read		; loop, ha meg nem nyomtak 'enter'-t
	
.stop_read:
	cmp		ecx, 0
	je		.positive
	neg		ebx
.positive:
	mov		eax, 10			; uj sor
	call	mio_writechar
	mov		eax, ebx
	pop		edx				; helyreallitja az eredeti ertekeket, az eredmeny EAX-ben
	pop		ecx
	pop		ebx
	clc						; carry-t nullara allitjuk, hogy sikeres beolvasast jelezzunk
	ret
	
.hiba:
	pop		edx
	pop		ecx
	pop		ebx
	stc						; beallitjuk a carry-t, hogy hibat jelezzunk
	ret
	
	
	; kiirja az EAX-ben levo erteket decimalis egeszkent (integer)
write_int:
	push	eax				; elmentjuk az eredeti ertekeket
	push	ebx
	push	ecx
	push	edx

	push	-1				; megallasi feltetel
	cmp		eax, 0
	jge		to_stack		; ha pozitiv, nem irjuk ki a '-' jelet
	push	eax
	mov		eax, '-'
	call	mio_writechar
	pop		eax
	neg		eax
	
to_stack:
	xor		edx, edx		; EDX-et nullara allitjuk, hogy jol osszon
	mov		ebx, 10			; tizzel osztunk, hogy az utolso szamjegyet kapjuk maradekkent
	div		ebx
	add		edx, 48			; karakterre alakitjuk szamjegybol
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
	
stop:							; helyreallitja az eredeti ertekeket
	mov		eax, 10
	call	mio_writechar		; uj sor
	pop		edx
	pop		ecx
	pop		ebx
	pop		eax
	ret
	
	
	;print HEX from EAX
write_hex:
	push	eax				; elmentjuk az eredeti ertekeket
	push	ebx
	push	ecx
	push	edx
	
	mov		ebx, eax		; eredeti bemenetet EBX-ben taroljuk
	mov		ecx, 8			; loop count
	
	mov		eax, str_hex_prefix
	call	mio_writestr
	mov		eax, ebx
	
.loop_write:
	rol		ebx, 4			; az elso szot a vegere forgatjuk
	mov		eax, ebx
	and		eax, 1111b		; csak utolso szot tartjuk meg
	cmp		eax, 9
	jg		.hex_letter
	add		eax, '0'		; ha numerikus, kiirjuk
	call	mio_writechar
	jmp		.write_hex_iterate

.hex_letter:
	sub		eax, 10			; atalakitjuk A-F alakba ha a szam nagyobb tiznel
	add		eax, 'A'
	call	mio_writechar
	
.write_hex_iterate:
	loop	.loop_write

	mov		eax, 10
	call	mio_writechar
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
	jl		.hiba
	cmp		al, '9'
	jg		.check_uppercase
	
	shl		ebx, 4			; balra tolunk, hogy az uj szamjegyet hozzaragasszuk
	sub		al, '0'
	add		ebx, eax
	jmp		.loop_read
	
.check_uppercase:
	cmp		al, 'A'
	jl		.hiba
	cmp		al, 'F'
	jg		.check_lowercase
	
	shl		ebx, 4			; balra tolunk, hogy az uj szamjegyet hozzaragasszuk
	sub		al, 'A'
	add		al, 10
	add		ebx, eax
	jmp		.loop_read
	
.check_lowercase:
	cmp		al, 'a'
	jl		.hiba
	cmp		al, 'f'
	jg		.hiba
	
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
	str_ossz		db	'A beolvasott szamok osszege: ', 0
	str_hiba		db	'Hiba: Rossz bemenet', 0
	str_beker_int	db	'Adjon meg egy szamot egesz alakban: ', 0
	str_beker_hex	db	'Adjon meg egy szamot hexadecimalis alakban: ', 0
	str_hex_prefix	db	'0x', 0
	str_int_alak	db	'A szam decimalis egesz alakban: ', 0
	str_hex_alak	db	'A szam hexadecimalis alakban: ', 0

section .bss