; nev: Balazs Adam-Attila
; azonosito: baam0146
; csoport: 621
; labor: L3 B 07
; Feladat: Készítsünk két assembly programot (NASM), amelyek beolvassák a szükséges karakterláncokat, kiírják a felhasznált szabályt (mint üzenetet) és a beolvasott karakterláncokat
; külön sorokba, majd előállítják és végül kiírják a művelet eredményét, ami szintén egy karakterlánc.
; A szabaly: "abcde" + [A-ból azok a karakterek, amelyek "" jelek között vannak (minden második " jel után az a szakasz befejeződik és egy újabb " kell ahhoz, hogy újabb szakasz
; nyíljon, valamint be is kell fejeződjön "-al, hogy érvényes legyen)] + "edcba" + [B, minden kisbetűt a rákövetkező betűvel helyettesítjük (kivéve a z-t, az marad)]

%include 'mio.inc'

global main

section .text
main:

	mov		eax, str_szabaly
	call	mio_writestr
	call	mio_writeln
	
	mov		eax, str_be
	call	mio_writestr
	
	mov		esi, str_A
	call	read_str_pascal
	
	mov		esi, str_A
	call	write_str_pascal
	
	ret

	
	
	
read_str_pascal:
	push	eax				; elmentjuk az eredeti ertekeket
	push	ebx
	push	ecx
	push	edx
	
	mov		ebx, esi		; elmentjuk a karakterlanc memoriabeli kezdocimet, hogy be tudjuk irni a hosszat
	xor		ecx, ecx		; szamoljuk a beolvasott karaktereket
	
.loop_read:
	xor		eax, eax
	call	mio_readchar
	call	mio_writechar
	
	cmp		al, 13			; ha lenyomjak az 'enter' billentyut
	je		.stop_read
	mov		[esi], al
	inc		si
	inc		ecx				; karakterek szamat noveljuk
	jmp		.loop_read
	
	
.stop_read:
	mov		[ebx], ecx		; a 0. karaktert beallitjuk a hosszra
	mov		eax, 10			; uj sor
	call	mio_writechar
	
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
	
	mov		ecx, [esi]		; a hosszt berakjuk ECX-be (loop)
	inc		esi
.loop_write:
	xor		eax, eax
	mov		eax, [esi]
	call	mio_writechar
	inc		esi
	loop	.loop_write
	
	pop		edx
	pop		ecx
	pop		ebx
	pop		eax
	ret
	

section .data
	str_be			db	'Adjon meg egy karakterlancot: ', 0
	str_szabaly		db	'"abcde" + [A-bol azok a karakterek, amelyek "" jelek kozott vannak (minden masodik " jel utan az a szakasz befejezodik es egy ujabb " kell ahhoz, hogy ujabb szakasz nyiljon, valamint be is kell fejezodjon "-al, hogy ervenyes legyen)] + "edcba" + [B, minden kisbetut a rakovetkezo betuvel helyettesitjuk (kiveve a z-t, az marad)]', 0

section .bss
	str_A		resb	256
	str_B		resb	256