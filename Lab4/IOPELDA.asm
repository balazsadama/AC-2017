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
	mov		esi, tizes
	call	WriteStr
	call	ReadInt
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
	
	mov		esi, hexa
	call	WriteStr
	call	ReadHex
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
	
	mov		esi, kettes
	call	WriteStr
	call	ReadBin
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
	
	
	
	mov		esi, tizes
	call	WriteStr
	call	ReadInt64
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
	
	mov		esi, hexa
	call	WriteStr
	call	ReadHex64
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
	
	mov		esi, kettes
	call	WriteStr
	call	ReadBin64
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

section	.data:
	tizes		db	'10-es szamrendszer: ', 0
	hexa		db	'16-os szamrendszer: ', 0
	kettes		db	'kettes szamrendszer: ', 0