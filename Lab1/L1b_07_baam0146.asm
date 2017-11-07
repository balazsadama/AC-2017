; nev: Balazs Adam-Attila
; azonosito: baam0146
; csoport: 621
; labor: L1, feladat: B. 7.
; bitenkénti logikai műveletek: a OR ((b XOR c) AND ((NOT a) XOR d))

%include 'io.inc'

global main

section .text
main:

	; write exercise
	mov		eax, str_ex
	call	io_writestr
	call	io_writeln
	
	; read num_a
	mov		eax, str_a
	call	io_writestr
	call	io_readint
	mov		[num_a], eax
	
	; read num_b
    mov     eax, str_b
    call    io_writestr
    call    io_readint
	mov		[num_b], eax
	
	; read num_c
	mov		eax, str_c
	call	io_writestr
	call	io_readint
	mov		[num_c], eax
	
	; read num_d
	mov		eax, str_d
	call	io_writestr
	call	io_readint
	mov		[num_d], eax
	
	
	; calculate (NOT a) XOR d
	mov		ebx, [num_a]
	not		ebx
	xor		eax, ebx			; EAX: (NOT a) XOR d
	
	; calculate (b XOR c)
	mov		ebx, [num_b]
	mov		ecx, [num_c]
	xor		ebx, ecx			; EBX: (b XOR c)
	
	; calculate (b XOR c) AND ((NOT a) XOR d)
	and		ebx, eax
	
	; calculate final result
	mov		eax, [num_a]
	or		ebx, eax
	
	
	; write result
	mov		eax, str_ex
	call	io_writestr
	mov		eax, str_eq
	call	io_writestr
	mov		eax, ebx
	call	io_writebin
	

	ret
	
section .data
	str_ex	db	'E(a,b,c,d) = a OR ((b XOR c) AND ((NOT a) XOR d))', 0
	str_eq	db	' = ', 0
	str_a	db	'A = ', 0
	str_b	db	'B = ', 0
	str_c	db	'C = ', 0
	str_d	db	'D = ', 0

section .bss
	num_a	resb	4
	num_b	resb	4
	num_c	resb	4
	num_d	resb	4