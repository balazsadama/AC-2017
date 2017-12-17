; nev: Balazs Adam-Attila
; azonosito: baam0146
; csoport: 621
; labor: L4 4b
; Feladat:
; megfelelő üzenet kiíratása után beolvasunk egy stringet;
; kiírjuk a hosszát;
; kiírjuk a tömörített formáját;
; kiírjuk a tömörített formáját kisbetűkre alakítva;
; megfelelő üzenet kiíratása után beolvasunk egy második stringet;
; kiírjuk a hosszát;
; kiírjuk a tömörített formáját;
; kiírjuk a tömörített formáját nagybetűkre alakítva;
; létrehozunk a memóriában egy új stringet: az első string nagybetűs verziójához hozzáfűzzük a második string kisbetűs verzióját;
; kiírjuk a létrehozott stringet;
; kiírjuk a létrehozott string hosszát;
; befejezzük a programot.

%include 'IOSTR.inc'
%include 'STRINGS.inc'
%include 'IONUM.inc'

global main

section .text
	mov		esi, beker
	call	WriteStr
	mov		edi, str1
	mov		ecx, 255
	call	ReadStr
	mov		esi, str1
	call	StrLen
	call	WriteInt
	call	WriteLn
	mov		edi, str1c
	call	StrCompact
	mov		esi, str1c
	call	WriteLnStr
	call	StrLower
	call	WriteLnStr
	
	mov		esi, beker
	call	WriteStr
	mov		edi, str2
	call	ReadStr
	mov		esi, str2
	call	StrLen
	call	WriteInt
	call	WriteLn
	mov		edi, str2c
	call	StrCompact
	mov		esi, str1c
	call	WriteLnStr
	call	StrUpper
	call	WriteLnStr
	
	mov		esi, str1
	call	StrUpper
	mov		esi, str2
	call	StrLower
	mov		edi, str3
	mov		eax, 0
	stosb
	mov		edi, str3
	mov		esi, str1
	call	StrCat
	mov		esi, str2
	call	StrCat
	mov		esi, str3
	call	WriteLnStr
	
	ret
	

section .data
	beker	db	'Adjon meg egy karakterlancot: ', 0

section .bss
	str1	resb	256
	str1c	resb	256
	str2	resb	256
	str2c	resb	256
	str3	resb	512
	