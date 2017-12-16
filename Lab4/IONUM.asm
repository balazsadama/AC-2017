; nev: Balazs Adam-Attila
; azonosito: baam0146
; csoport: 621
; labor: L4 1
; Feladat: Készítsük el a következő stringkezelő eljárásokat
; ReadInt():(EAX)                  – 32 bites előjeles egész beolvasása
; WriteInt(EAX):()                  – 32 bites előjeles egész kiírása
; ReadInt64():(EDX:EAX)      – 64 bites előjeles egész beolvasása
; WriteInt64(EDX:EAX):()      – 64 bites előjeles egész kiírása
; ReadBin():(EAX)                 – 32 bites bináris pozitív egész beolvasása
; WriteBin(EAX):()                 –                    - || -                   kiírása
; ReadBin64():(EDX:EAX)     – 64 bites bináris pozitív egész beolvasása
; WriteBin64(EDX:EAX):()     –                    - || -                   kiírása
; ReadHex():(EAX)                – 32 bites pozitív hexa beolvasása
; WriteHex(EAX):()                –                    - || -                   kiírása
; ReadHex64():(EDX:EAX)     – 64 bites pozitív hexa beolvasása
; WriteHex64(EDX:EAX):()     –                    - || -                   kiírása

%include 'mio.inc'

global main

global ReadInt
global WriteInt
global ReadInt64
global WriteInt64
global ReadBin
global WriteBin
global ReadBin64
global WriteBin64
global ReadHex
global WriteHex
global ReadHex64
global WriteHex64

section .text
main:

	clc
	call	ReadInt
	
	jc		.dunno
	mov		ecx, 0x696969
	
.dunno:
	mov		ebx, 0x12321

	ret
	
	
	
ReadInt:
	push	ebx
	push	ecx
	push	edx
	
	xor		ecx, ecx			; szamoljuk, hogy hany karakter volt eddig beolvasva
	
	push	ebp					; a veremben "lokalisan memoriat foglalunk"
    mov		ebp, esp
	sub		esp, 11				; max 10 szamjegyes lehet + elojel = 11 karakter = 11 byte
	
.loop_read:
	call	mio_readchar
	cmp		al, 13				; ha enter
	je		.end_read
	call	mio_writechar
	inc		ecx					; noveljuk a beolvasott karakterek szamat
	
	cmp		al, 0x08			; ha backspace
	je		.backspace
	
	cmp		ecx, 11
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
	
	cmp		ecx, 11
	jg		.error				; ha tul hosszu a szam, akkor hiba
	
.loop_build:
	cmp		edx, ecx
	je		.end
	
	mov		BYTE bl, [esp + edx]; betoltjuk az elso karaktert
	
	cmp		bl, '-'
	jne		.skipNegative
	mov		BYTE [esp], bl; hogy a vegen tudjuk, hogy kell-e negalni a szamot
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
	
.end:
	mov		BYTE bl, [esp]
	cmp		bl, '-'
	jne		.positive			; ha nem volt minusz jel megadva a szam elejen, akkor pozitivkent kezeljuk
	
	cmp		eax, 0x80000000
	ja		.error				; ha negativ iranyban tulcsordult, akkor hiba
	
	neg		eax
	clc
	jmp		.pop_return
	
.positive:
	clc
	
	cmp		eax, 0x80000000		; ha pozitiv iranyban tulcsordult, akkor hiba
	jae		.error
	clc
	
.pop_return:
	mov		esp, ebp
    pop		ebp
	
	pop		edx
	pop		ecx
	pop		ebx
	
	ret