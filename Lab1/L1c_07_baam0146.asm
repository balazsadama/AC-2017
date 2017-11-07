; nev: Balazs Adam-Attila
; azonosito: baam0146
; csoport: 621
; labor: L1, feladat: C. 7.
; feltételes kifejezés:
; ha d mod 4 = 0 : (b - a) * 2
; ha d mod 4 = 1 : 13 - c
; ha d mod 4 = 2 : (9 - b) div a
; ha d mod 4 = 3 : c * (a - c)

%include 'io.inc'

global main

section .text
main:

	; write exercise
	mov		eax, str_ex1
	call	io_writestr
	call	io_writeln
	mov		eax, str_ex2
	call	io_writestr
	call	io_writeln
	mov		eax, str_ex3
	call	io_writestr
	call	io_writeln
	mov		eax, str_ex4
	call	io_writestr
	call	io_writeln
	mov		eax, str_ex5
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
	
	
	; calculate d mod 4
	mov		ebx, 4
	cdq
	idiv	ebx
	
	; comparisons and jumps
	cmp		edx, 0
	je		mod_equals_0
	
	cmp		edx, 1
	je		mod_equals_1
	
	cmp		edx, 2
	je		mod_equals_2
	
	jmp		mod_equals_3

	
		mod_equals_0:
		
	mov		ebx, [num_a]
	mov		eax, [num_b]
	sub		eax, ebx		; EAX = b-a
	mov		ebx, 2
	imul	eax, ebx		; EAX = (b-a)*2
	;call	io_writeint
	
	jmp		end
	
		mod_equals_1:
	mov		eax, 13
	sub		eax, [num_c]	; EAX = 13-c
	;call	io_writeint
	jmp		end
	
		mod_equals_2:
	mov		eax, 9
	sub		eax, [num_b]	; EAX = 9-b
	mov		ebx, [num_a]
	cdq
	idiv	ebx				; EAX = (9-b) div a
	;call	io_writeint
	jmp		end
	
		mod_equals_3:
	mov		eax, [num_c]
	mov		ebx, [num_a]
	sub		ebx, eax		; EBX = a-c
	imul	eax, ebx		; EAX = c * (a-c)
	;call	io_writeint
	
	
		end:
	mov		ebx, eax
	mov		eax, str_ex1
	call	io_writestr
	mov		eax, ebx
	call	io_writeint
	
	ret
	
section .data
	str_ex1	db	'E(a,b,c,d) = ', 0
	str_ex2	db	'ha d mod 4 = 0 : (b - a) * 2', 0
	str_ex3	db	'ha d mod 4 = 1 : 13 - c', 0
	str_ex4	db	'ha d mod 4 = 2 : (9 - b) div a', 0
	str_ex5	db	'ha d mod 4 = 3 : c * (a - c)', 0
	str_a	db	'A = ', 0
	str_b	db	'B = ', 0
	str_c	db	'C = ', 0
	str_d	db	'D = ', 0

section .bss
	num_a	resb	4
	num_b	resb	4
	num_c	resb	4
	num_d	resb	4