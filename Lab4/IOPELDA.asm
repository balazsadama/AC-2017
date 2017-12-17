; nev: Balazs Adam-Attila
; azonosito: baam0146
; csoport: 621
; labor: L4 4a
; Feladat:
; beolvas egy előjeles 32 bites egész számot 10-es számrendszerben;
; kiírja a beolvasott értéket 10-es számrendszerben előjeles egészként, komplementer kódbeli ábrázolását 16-os és kettes számrendszerben;
; beolvas egy 32 bites hexa számot;
; kiírja a beolvasott értéket 10-es számrendszerben előjeles egészként, komplementer kódbeli ábrázolását 16-os és kettes számrendszerben;
; beolvas egy 32 bites bináris számot;
; kiírja a beolvasott értéket 10-es számrendszerben előjeles egészként, komplementer kódbeli ábrázolását 16-os és kettes számrendszerben;
; kiírja a három beolvasott érték összegét 10-es számrendszerben előjeles egészként, komplementer kódbeli ábrázolását 16-os és kettes számrendszerben;
; ez előző lépéseket elvégzi 64 bites értékekre is

%include 'IONUM.inc'
%include 'IOSTR.inc'

global main

section .text

main:

.loop_int32:
	mov		esi, tizes
	call	WriteStr
	call	ReadInt
	jc		.hiba_int32
	
	call	NewLine
	call	WriteStr
	call	WriteInt
	call	NewLine
	mov		esi, hexa
	call	WriteStr
	call	WriteHex
	call	NewLine
	mov		esi, kettes
	call	WriteStr
	call	WriteBin
	call	NewLine
	
	mov		ebx, eax
	
.loop_hex32:
	mov		esi, hexa
	call	WriteStr
	call	ReadHex
	jc		.hiba_hex32
	
	call	NewLine
	mov		esi, tizes
	call	WriteStr
	call	WriteInt
	call	NewLine
	mov		esi, hexa
	call	WriteStr
	call	WriteHex
	call	NewLine
	mov		esi, kettes
	call	WriteStr
	call	WriteBin
	call	NewLine
	
	mov		ecx, eax
	
.loop_bin32:
	mov		esi, kettes
	call	WriteStr
	call	ReadBin
	jc		.hiba_bin32
	
	call	NewLine
	mov		esi, tizes
	call	WriteStr
	call	WriteInt
	call	NewLine
	mov		esi, hexa
	call	WriteStr
	call	WriteHex
	call	NewLine
	mov		esi, kettes
	call	WriteStr
	call	WriteBin
	call	NewLine
	
	
	
	add		eax, ebx
	add		eax, ecx
	mov		esi, tizes
	call	WriteStr
	call	WriteInt
	call	NewLine
	mov		esi, hexa
	call	WriteStr
	call	WriteHex
	call	NewLine
	mov		esi, kettes
	call	WriteStr
	call	WriteBin
	call	NewLine
	
	
.loop_int64:
	mov		esi, tizes
	call	WriteStr
	call	ReadInt64
	jc		.hiba_int64
	
	call	NewLine
	call	WriteStr
	call	WriteInt64
	call	NewLine
	mov		esi, hexa
	call	WriteStr
	call	WriteHex64
	call	NewLine
	mov		esi, kettes
	call	WriteStr
	call	WriteBin64
	call	NewLine
	
	mov		ebx, edx
	mov		ecx, eax
	
.loop_hex64:
	mov		esi, hexa
	call	WriteStr
	call	ReadHex64
	jc		.hiba_hex64
	
	call	NewLine
	mov		esi, tizes
	call	WriteStr
	call	WriteInt64
	call	NewLine
	mov		esi, hexa
	call	WriteStr
	call	WriteHex64
	call	NewLine
	mov		esi, kettes
	call	WriteStr
	call	WriteBin64
	call	NewLine
	
	add		ecx, eax
	adc		ebx, edx
	
.loop_bin64:
	mov		esi, kettes
	call	WriteStr
	call	ReadBin64
	jc		.hiba_bin64
	
	call	NewLine
	mov		esi, tizes
	call	WriteStr
	call	WriteInt64
	call	NewLine
	mov		esi, hexa
	call	WriteStr
	call	WriteHex64
	call	NewLine
	mov		esi, kettes
	call	WriteStr
	call	WriteBin64
	call	NewLine
	
	
	
	add		eax, ecx
	adc		edx, ebx
	mov		esi, tizes
	call	WriteStr
	call	WriteInt64
	call	NewLine
	mov		esi, hexa
	call	WriteStr
	call	WriteHex64
	call	NewLine
	mov		esi, kettes
	call	WriteStr
	call	WriteBin64
	call	NewLine
	
	ret
	
.hiba_int32:
	call	NewLine
	mov		esi, hiba
	call	WriteLnStr
	jmp		.loop_int32
	
.hiba_hex32:
	call	NewLine
	mov		esi, hiba
	call	WriteLnStr
	jmp		.loop_hex32
	
.hiba_bin32:
	call	NewLine
	mov		esi, hiba
	call	WriteLnStr
	jmp		.loop_bin32
	
.hiba_int64:
	call	NewLine
	mov		esi, hiba
	call	WriteLnStr
	jmp		.loop_int64
	
.hiba_hex64:
	call	NewLine
	mov		esi, hiba
	call	WriteLnStr
	jmp		.loop_hex64
	
.hiba_bin64:
	call	NewLine
	mov		esi, hiba
	call	WriteLnStr
	jmp		.loop_bin64
	
section	.data:
	tizes		db	'10-es szamrendszer: ', 0
	hexa		db	'16-os szamrendszer: ', 0
	kettes		db	'kettes szamrendszer: ', 0
	hiba		db	'Hiba', 0
	