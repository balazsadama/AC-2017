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
	mov		ebx, 10				; tizzel osztunk, hogy az utolso szamjegyet kapjuk maradekkent
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

ReadBin:
	push	ebx
	push	ecx
	push	edx
	
	xor		eax, eax			; itt epitjuk a szamot
	xor		ecx, ecx			; szamoljuk, hogy hany karakter volt eddig beolvasva
	
	push	ebp					; a veremben "lokalisan memoriat foglalunk"
    mov		ebp, esp
	sub		esp, 32				; max 32 karaktert (0/1) adhat meg a felhasznalo
	
.loop_read:
	call	mio_readchar
	cmp		al, 13				; ha enter
	je		.end_read
	call	mio_writechar
	inc		ecx					; noveljuk a beolvasott karakterek szamat
	
	cmp		al, 0x08			; ha backspace
	je		.backspace
	
	cmp		ecx, 32
	jg		.loop_read			; ha mar tobb mint 32 karaktert olvastunk be, akkor azt nem taroljuk
	
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
	
	cmp		ecx, 32
	jg		.error				; ha tul hosszu a szam, akkor hiba
	
.loop_build:
	cmp		edx, ecx
	je		.end
	
	mov		BYTE bl, [esp + edx]; betoltjuk az elso karaktert
	cmp		bl, '0'
	jb		.error
	
	cmp		bl, '1'
	ja		.error
	
	sub		bl, '0'
	
	shl		eax, 1				; balra toljuk egy bittel
	or		eax, ebx			; hozzaadjuk a bitet
	
	inc		edx
	jmp		.loop_build
	
.error:
	stc
	jmp		.pop_return
	
.end:
	clc
	
.pop_return:
	mov		esp, ebp
    pop		ebp
	pop		edx
	pop		ecx
	pop		ebx
	ret

WriteBin:
	push	eax
	push	ebx
	push	ecx
	push	edx
	
	mov		ebx, eax			; eax-et hasznaljuk kiirasnal
	mov		ecx, 32				; beallitjuk loop counter-t

.bin_loop:
	shl		ebx, 1				; eltoljuk a bitet a Carry-be
	jc		.digit_one
	mov		al, '0'
	jmp		.write_digit
	
.digit_one:
	mov		al, '1'
	
.write_digit:
	call	mio_writechar
	
	; ellenorzi, hogy kell-e szokozt irjon
	mov		eax, ecx			; osztandot eax-be tesszuk
	add		eax, 3
	cdq
	push	ebx					; elmetnjuk az eredeti erteket, hogy osszunk 4-gyel
	mov		ebx, 4
	idiv	ebx
	pop		ebx					; helyreallitjuk az eredeti erteket
	
	cmp		edx, 0				; ha oszthato 4-gyel, akkor kiirunk egy szokozt
	jne		.loop_write
	mov		al, ' '
	call	mio_writechar
	
.loop_write:
	loop	.bin_loop
	
	pop		edx
	pop		ecx
	pop		ebx
	pop		eax
	ret
	
ReadHex:
	push	ebx
	push	ecx
	push	edx
	
	xor		eax, eax			; itt epitjuk a szamot
	xor		ecx, ecx			; szamoljuk, hogy hany karakter volt eddig beolvasva
	
	push	ebp					; a veremben "lokalisan memoriat foglalunk"
    mov		ebp, esp
	sub		esp, 8				; max 8 karaktert adhat meg a felhasznalo
	
.loop_read:
	call	mio_readchar
	cmp		al, 13				; ha enter
	je		.end_read
	call	mio_writechar
	inc		ecx					; noveljuk a beolvasott karakterek szamat
	
	cmp		al, 0x08			; ha backspace
	je		.backspace
	
	cmp		ecx, 8
	jg		.loop_read			; ha mar tobb mint 8 karaktert olvastunk be, akkor azt nem taroljuk
	
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
	cmp		ecx, 8
	jg		.error				; ha tul hosszu a szam, akkor hiba
	
.loop_build:
	cmp		edx, ecx
	je		.end
	mov		BYTE bl, [esp + edx]; betoltjuk az elso karaktert
	cmp		bl, '0'
	jb		.error
	cmp		bl, '9'
	ja		.check_uppercase
	sub		bl, '0'				; ha 0-9 kozti karakter
	jmp		.good_value
	
.check_uppercase:
	cmp		bl, 'A'
	jl		.error
	cmp		bl, 'F'
	jg		.check_lowercase
	
	sub		bl, 'A'
	add		bl, 10
	jmp		.good_value
	
.check_lowercase:
	cmp		bl, 'a'
	jl		.error
	cmp		bl, 'f'
	jg		.error
	
	sub		bl, 'a'
	add		bl, 10
	jmp		.good_value
	
.good_value:
	shl		eax, 4				; balra tolunk, hogy az uj szamjegyet hozzaragasszuk
	add		eax, ebx

	inc		edx
	jmp		.loop_build
	
.error:
	stc
	jmp		.pop_return
	
.end:
	clc
	
.pop_return:
	mov		esp, ebp
    pop		ebp
	pop		edx
	pop		ecx
	pop		ebx
	ret	
	
WriteHex:
	push	eax				; elmentjuk az eredeti ertekeket
	push	ebx
	push	ecx
	push	edx
	
	mov		ebx, eax		; eredeti bemenetet EBX-ben taroljuk
	mov		ecx, 8			; loop count
	
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

	pop		edx
	pop		ecx
	pop		ebx
	pop		eax
	ret

ReadInt64:
	push	ebx
	push	ecx
	push	edi
	push	esi
	
	xor		ecx, ecx			; szamoljuk, hogy hany karakter volt eddig beolvasva
	push	ebp					; a veremben "lokalisan memoriat foglalunk"
    mov		ebp, esp
	sub		esp, 20				; max 19 szamjegyes lehet + elojel = 20 karakter = 20 byte
	
.loop_read:
	call	mio_readchar
	cmp		al, 13				; ha enter
	je		.end_read
	call	mio_writechar
	inc		ecx					; noveljuk a beolvasott karakterek szamat
	cmp		al, 0x08			; ha backspace
	je		.backspace
	cmp		ecx, 20
	jg		.loop_read			; ha mar tobb mint 20 karaktert olvastunk be, akkor azt nem taroljuk
	
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
	cmp		ecx, 20
	jg		.error				; ha tul hosszu a szam, akkor hiba
	
	xor		ebx, ebx			; hogy kesobb osszeadasnal ne legyen szemet ertek benne
	xor		edx, edx			; epitjuk a szamot
	xor		eax, eax			; epitjuk a szamot
	xor		esi, esi			; szamoljuk a feldolgozott karaktereket
	
.loop_build:
	cmp		esi, ecx
	je		.end
	
	mov		BYTE bl, [esp + esi]; betoltjuk az elso karaktert
	cmp		bl, '-'
	jne		.skipNegative
	mov		BYTE [esp], bl		; hogy a vegen tudjuk, hogy kell-e negalni a szamot
	inc		esi
	jmp		.loop_build
	
.skipNegative:
	cmp		bl, '0'
	jb		.error
	cmp		bl, '9'
	ja		.error
	sub		bl, '0'
	
	push	eax
	mov		eax, edx
	mov		edx, 10
	mul		edx					; a szam felso reszet megszorozzuk 10-el
	mov		edi, eax			; elmentjuk a szam felso reszet
	pop		eax
	jo		.error
	
	xor		edx, edx
	push	ecx
	mov		ecx, 10
	mul		ecx					; EDX:EAX = EAX * 10
	pop		ecx
	
	add		eax, ebx			; hozzaadjuk az uj szamjegyet
	jnc		.dont_add
	add		edx, 1
.dont_add:
	add		edx, edi
	jc		.error
	
	inc		esi
	jmp		.loop_build
	
.error:
	stc
	jmp		.pop_return
	
.end:
	mov		BYTE bl, [esp]
	cmp		bl, '-'
	jne		.positive			; ha nem volt minusz jel megadva a szam elejen, akkor pozitivkent kezeljuk
	
	cmp		edx, 0x80000000
	ja		.error
	
	not		eax
	add		eax, 1
	not		edx
	jnc		.skip_add
	add		edx, 1
	
.skip_add:
	clc
	jmp		.pop_return
	
.positive:
	clc
	cmp		edx, 0x80000000		; ha pozitiv iranyban tulcsordult, akkor hiba
	jae		.error
	clc
	
.pop_return:
	mov		esp, ebp
    pop		ebp
	
	pop		esi
	pop		edi
	pop		ecx
	pop		ebx
	
	ret
	
WriteInt64:
	push	eax					; elmentjuk az eredeti ertekeket
	push	ebx
	push	ecx
	push	edx
	
	mov		ebx, 10				; tizzel osztunk, hogy az utolso szamjegyet kapjuk maradekkent

	push	-1					; megallasi feltetel
	cmp		edx, 0
	jge		.to_stack			; ha pozitiv, nem irjuk ki a '-' jelet
	push	eax
	mov		eax, '-'
	call	mio_writechar
	pop		eax
	
	not		eax					; ha negativ, akkor pizitivva alakitjuk
	add		eax, 1
	not		edx
	adc		edx, 0
	
.to_stack:
	cmp		eax, 0
	jne		.upper
	cmp		edx, 0
	jne		.upper
	jmp		.from_stack

.upper:
	push	eax					; elmentjuk az also reszt
	mov		eax, edx
	xor		edx, edx
	div		ebx					; elosztjuk a felso reszt 10-zel
	xchg	[esp], eax			; hanyadost verembe tesszuk, a szam also reszet is elosztjuk 10-zel
	div		ebx
	xchg	[esp], edx			; a maradekot (kiirando szamjegy) verembe tesszuk, az eredeti szam felso reszet helyere rakjuk
	jmp		.to_stack
	
.from_stack:
	pop		eax
	cmp		eax, -1
	je		.stop
	add		eax, '0'
	call	mio_writechar
	jmp		.from_stack
	
.stop:							; helyreallitja az eredeti ertekeket
	pop		edx
	pop		ecx
	pop		ebx
	pop		eax
	ret
	
ReadBin64:
	push	ebx
	push	ecx
	push	esi
	
	xor		eax, eax			; itt epitjuk a szamot
	xor		edx, edx
	xor		ecx, ecx			; szamoljuk, hogy hany karakter volt eddig beolvasva
	
	push	ebp					; a veremben "lokalisan memoriat foglalunk"
    mov		ebp, esp
	sub		esp, 64				; max 64 karaktert (0/1) adhat meg a felhasznalo
	
.loop_read:
	call	mio_readchar
	cmp		al, 13				; ha enter
	je		.end_read
	call	mio_writechar
	inc		ecx					; noveljuk a beolvasott karakterek szamat
	
	cmp		al, 0x08			; ha backspace
	je		.backspace
	
	cmp		ecx, 64
	jg		.loop_read			; ha mar tobb mint 32 karaktert olvastunk be, akkor azt nem taroljuk
	
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
	xor		edx, edx			; epitjuk a szamot
	xor		eax, eax
	xor		esi, esi			; szamoljuk a feldolgozott karaktereket
	
	cmp		ecx, 64
	jg		.error				; ha tul hosszu a szam, akkor hiba
	
.loop_build:
	cmp		esi, ecx
	je		.end
	
	mov		BYTE bl, [esp + esi]; betoltjuk az elso karaktert
	cmp		bl, '0'
	jb		.error
	cmp		bl, '1'
	ja		.error
	sub		bl, '0'
	shl		edx, 1
	shl		eax, 1				; balra toljuk egy bittel
	adc		edx, 0				; az EAX balra tolasabol tulcsordulo biteket EDX-be rajkuk
	or		eax, ebx			; hozzaadjuk EAX-hez a bitet
	
	inc		esi
	jmp		.loop_build
	
.error:
	stc
	jmp		.pop_return
	
.end:
	clc
	
.pop_return:
	mov		esp, ebp
    pop		ebp
	pop		esi
	pop		ecx
	pop		ebx
	ret
	
WriteBin64:
	push	eax
	mov		eax, edx
	call	WriteBin
	pop		eax
	call	WriteBin
	ret
	
ReadHex64:
	push	ebx
	push	ecx
	push	esi
	
	xor		ecx, ecx			; szamoljuk, hogy hany karakter volt eddig beolvasva
	push	ebp					; a veremben "lokalisan memoriat foglalunk"
    mov		ebp, esp
	sub		esp, 16				; max 16 karaktert adhat meg a felhasznalo
	
.loop_read:
	call	mio_readchar
	cmp		al, 13				; ha enter
	je		.end_read
	call	mio_writechar
	inc		ecx					; noveljuk a beolvasott karakterek szamat
	
	cmp		al, 0x08			; ha backspace
	je		.backspace
	
	cmp		ecx, 16
	jg		.loop_read			; ha mar tobb mint 8 karaktert olvastunk be, akkor azt nem taroljuk
	
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
	cmp		ecx, 16
	jg		.error				; ha tul hosszu a szam, akkor hiba
	
	xor		ebx, ebx			; hogy kesobb osszeadasnal ne legyen szemet ertek benne
	xor		edx, edx			; epitjuk a szamot
	xor		eax, eax			; epitjuk a szamot
	xor		esi, esi			; szamoljuk a feldolgozott karaktereket
	
.loop_build:
	cmp		esi, ecx
	je		.end
	
	mov		BYTE bl, [esp + esi]; betoltjuk az elso karaktert
	cmp		bl, '0'
	jb		.error
	
	cmp		bl, '9'
	ja		.check_uppercase
	
	sub		bl, '0'				; ha 0-9 kozti karakter
	jmp		.good_value
	
.check_uppercase:
	cmp		bl, 'A'
	jl		.error
	cmp		bl, 'F'
	jg		.check_lowercase
	
	sub		bl, 'A'
	add		bl, 10
	jmp		.good_value
	
.check_lowercase:
	cmp		bl, 'a'
	jl		.error
	cmp		bl, 'f'
	jg		.error
	
	sub		bl, 'a'
	add		bl, 10
	jmp		.good_value
	
	
.good_value:
	push	ecx
	mov		ecx, 4
.push_left:						; balra tolunk, hogy az uj szamjegyet hozzaragasszuk
	shl		edx, 1
	shl		eax, 1
	adc		edx, 0
	loop	.push_left
	
	pop		ecx
	add		eax, ebx
	
	inc		esi
	jmp		.loop_build
	
.error:
	stc
	jmp		.pop_return
	
.end:
	clc
	
.pop_return:
	mov		esp, ebp
    pop		ebp
	pop		esi
	pop		ecx
	pop		ebx
	ret	
	
WriteHex64:
	push	eax
	mov		eax, edx
	call	WriteHex
	pop		eax
	call	WriteHex
	ret
	
	
	
	
	