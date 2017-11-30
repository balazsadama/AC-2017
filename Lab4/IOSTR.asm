; nev: Balazs Adam-Attila
; azonosito: baam0146
; csoport: 621
; labor: L4 2
; Feladat: Készítsünk el egy olyan stringbeolvasó eljárást, amely megfelelőképpen kezeli le a backspace billentyűt. <Enter>-ig olvas.
; Ebben a feladatban C stringekkel dolgozunk, itt a string végét a bináris 0 karakter jelenti.
; Készítsünk el egy olyan IOSTR.ASM / INC modult, amely a következő eljárásokat tartalmazza:
; ReadStr(EDI vagy ESI, ECX max. hossz):()   – C-s (bináris 0-ban végződő) stringbeolvasó eljárás, <Enter>-ig olvas
; WriteStr(ESI):()                                – stringkiíró eljárás
; ReadLnStr(EDI vagy ESI, ECX):()   – mint a ReadStr() csak újsorba is lép
; WriteLnStr(ESI):()                            – mint a WriteStr() csak újsorba is lép
; NewLine():()                                     – újsor elejére lépteti a kurzort

%include 'mio.inc'

global main

global ReadStr
global ReadLnStr
global WriteStr
global WriteLnStr
global NewLine

section .text
main:

	call	read_str1
	;call	read_strLn1
	ret
	
	
	
ReadStr:
	pushad					; elmentjuk az eredeti ertekeket
	mov		edx, ecx
	
.loop_read:
	cmp		ecx, 0
	jz		.out_of_bounds

	call	mio_readchar
	call	mio_writechar
	cmp		al, 0x08		; ha backspace
	je		.backspace
	
	cmp		al, 13			; ha lenyomjak az 'enter' billentyut
	je		.stop_read
	stosb					; beirt betut memoriaba mentjuk
	dec		ecx				; szamoljuk, hogy meg hany karakter fer
	jmp		.loop_read

.backspace:
	cmp		ecx, edx
	je		.loop_read

	mov		al, 0x20		; space
	call	mio_writechar
	mov		al, 0x08		; backspace
	call	mio_writechar
	inc		ecx				; toroltunk egy karaktert, megno a meg beolvashato karakterek szama
	
	cmp		ecx, 0
	jle		.loop_read		; ha ecx <= 0, akkor az out_of_bounds agon kell folytatni a beolvasast
	dec		edi				; kulonben kell csokkenteni EDI-t, mert toroltunk karaktert
	jmp		.loop_read
	
.out_of_bounds:
	call	mio_readchar
	call	mio_writechar
	cmp		al, 0x08		; ha backspace
	je		.backspace
	
	cmp		al, 13			; ha lenyomjak az 'enter' billentyut
	je		.stop_read
							; beirt betut nem mentjuk memoriaba, mert a megadott hosszt meghaladna es ez elronthatna mas adatokat
	dec		ecx				; szamoljuk, hogy meg hany karakter fer
	jmp		.out_of_bounds
	
.stop_read:
	xor		eax, eax		; null-terminalt string
	stosb
	
	clc						; hibajelzo kezdetben 0
	cmp		ecx, 0
	jge		.end			; ha a beolvasott karakterek szama nem haladta meg a megengedettet, nem allitjuk be a CF-et
	stc						; jelezzuk a hibat
	
.end:
	popad
	ret
	
	
ReadLnStr:
	call	ReadStr
	jc		.setCarry
	call	mio_writeln
	clc
	ret
	
.setCarry:
	call	mio_writeln
	stc
	ret

WriteStr:
	pushad					; elmentjuk az eredeti ertekeket
	
.loop_write:
	lodsb
	cmp		al, 0
	je		.end
	call	mio_writechar
	jmp		.loop_write
	
.end:
	popad
	ret
	
WriteLnStr:
	call	WriteStr
	call	mio_writeln
	ret

	
NewLine:
	call	mio_writeln
	ret
	
read_str1:
	pushad
	
.loop_read:
	mov		edi, str1
	mov		ecx, 9
	call	ReadStr
	jc		.hiba
	call	mio_writeln
	
	mov		esi, str1
	call	WriteStr
	call	mio_writeln
	
	popad
	ret
	
.hiba:
	call	mio_writeln
	push	esi
	mov		esi, str_hiba
	call	WriteStr
	call	mio_writeln
	pop		esi
	jmp		.loop_read
	

read_strLn1:
	pushad
	
.loop_read:
	mov		edi, str1
	mov		ecx, 9
	call	ReadLnStr
	jc		.hiba
	
	mov		esi, str1
	call	WriteLnStr
	
	popad
	ret
	
.hiba:
	push	esi
	mov		esi, str_hiba
	call	WriteLnStr
	pop		esi
	jmp		.loop_read
	
section .data
	str_hiba	db		'Hiba', 0

section .bss
	str1		resb	256
