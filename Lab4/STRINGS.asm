; nev: Balazs Adam-Attila
; azonosito: baam0146
; csoport: 621
; labor: L4 3
; Feladat: Készítsük el a következő stringkezelő eljárásokat
; StrLen(ESI):(EAX)  			– EAX-ben visszatéríiti az ESI által jelölt string hosszát, kivéve a bináris 0-t
; StrCat(EDI, ESI):()        	– összefűzi az ESI és EDI által jelölt stringeket (azaz az ESI által jelöltet az EDI után másolja)
; StrUpper(ESI):()           	– nagybetűssé konvertálja az ESI stringet
; StrLower(ESI):()             	– kisbetűssé konvertálja az ESI stringet
; StrCompact(ESI):(EDI)      	– EDI-be másolja át az ESI stringet, kivéve a szóköz, tabulátor (9), kocsivissza (13) és soremelés (10) karaktereket

%include 'mio.inc'

global main

global StrLen
global StrCat
global StrUpper
global StrLower
global StrCompact

	
	
	
StrLen:
	push	ebx
	push	ecx
	push	edx
	push	esi
	
	xor		eax, eax
	xor		ebx, ebx
.loop_count:
	lodsb
	cmp		al, 0
	je		.end
	inc		ebx
	jmp		.loop_count
.end:
	mov		eax, ebx
	pop		esi
	pop		edx
	pop		ecx
	pop		ebx
	ret

	
StrCat:
	pushad
	
	push	esi
	mov		esi, edi		; el kell jutni EDI vegere
	
.iterate:
	lodsb
	cmp		al, 0
	jne		.iterate
	
	dec		esi				; most az esi a null karakterre mutat
	mov		edi, esi
	pop		esi

.loop_copy:
	lodsb
	cmp		al, 0
	je		.end
	stosb
	jmp		.loop_copy
	
.end:
	xor		eax, eax		; null-terminalast
	stosb
	popad
	ret
	
	
StrUpper:
	pushad
	mov		edi, esi
	
.loop_check:
	lodsb
	cmp		al, 0
	je		.end
	
	cmp		al, 'a'
	jb		.next
	
	cmp		al, 'z'
	ja		.next
	
	sub		al, 0x20			; atalakitjuk nagybetuve
	stosb
	jmp		.loop_check
	
.next:
	inc		edi
	jmp		.loop_check
	
.end:
	popad
	ret
	
	
	
StrLower:
	pushad
	mov		edi, esi
	
.loop_check:
	lodsb
	cmp		al, 0
	je		.end
	
	cmp		al, 'A'
	jb		.next
	
	cmp		al, 'Z'
	ja		.next
	
	add		al, 0x20			; atalakitjuk kisbetuve
	stosb
	jmp		.loop_check
	
.next:
	inc		edi
	jmp		.loop_check
	
.end:
	popad
	ret	
	
	
StrCompact:
	pushad
	
.iterate:
	lodsb
	
	cmp		al, 0
	je		.end
	
	cmp		al, 32
	je		.iterate
	
	cmp		al, 9
	je		.iterate
	
	cmp		al, 10
	je		.iterate
	
	cmp		al, 13
	je		.iterate
	
	stosb
	jmp		.iterate
	
.end:
	xor		eax, eax
	stosb
	popad
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
	