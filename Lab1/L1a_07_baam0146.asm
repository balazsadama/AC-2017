; nev: Balazs Adam-Attila
; azonosito: baam0146
; csoport: 621
; labor: L1, feladat: A. 7.
; aritmetikai kifejezés kiértékelése: ((a - (b * c)) div (a - b)) + ((b - e) div c) - ((f + g - 10) mod (g div 5)) - d

%include 'io.inc'

global main

section .text
main:

	; write exercise
	mov		eax, str_ex
	call	io_writestr
	call	io_writeln
	

	; read num_a
    mov     eax, str_a
    call    io_writestr
    call    io_readint
    mov     [num_a], eax
	
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
	
	; read num_e
	mov		eax, str_e
	call	io_writestr
	call	io_readint
	mov		[num_e], eax
	
	; read num_f
	mov		eax, str_f
	call	io_writestr
	call	io_readint
	mov		[num_f], eax
	
	; read num_g
	mov		eax, str_g
	call	io_writestr
	call	io_readint
	mov		[num_g], eax
	
	; calculate b*c
	mov		eax, [num_b]
	mov		ebx, [num_c]
	mul		ebx				; EAX: (b*c)
	
	; calculate a-(b*c)
	mov		ebx, [num_a]
	sub		ebx, eax
	mov		eax, ebx		; EAX: (a-(b*c))
	
	
	; calculate (a - b)
	mov		ebx, [num_a]
	mov		ecx, [num_b]
	sub		ebx, ecx		; EBX: (a-b)
		
	; calculate ((a-(b*c))div(a-b)) and store it in ECX
	cdq
	idiv	ebx
	mov		ecx, eax
	
	; calculate (b-e) in EAX
	mov		eax, [num_b]
	mov		ebx, [num_e]
	sub		eax, ebx
	
	; calculate ((b-e)div c)
	mov		ebx, [num_c]
	cdq
	idiv	ebx
	
	; calculate ((a-(b*c))div(a-b)) + (b-e)div c) and store it in ECX
	add		ecx, eax
	
	; calculate (g div 5) into EBX
	mov		eax, [num_g]
	mov		ebx, 5
	cdq
	idiv	ebx
	mov		ebx, eax
	
	; calculate (f+g-10) into EAX
	mov		eax, [num_f]
	mov		edx, [num_g]
	add		eax, edx
	sub		eax, 10
	
	; calculate (f+g-10) mod (g div 5)
	cdq
	idiv	ebx							; mod is in EDX
	
	; calculate final result
	sub		ecx, edx
	sub		ecx, [num_d]
	
	mov		eax, str_ex
	call	io_writestr
	mov		eax, str_eq
	call	io_writestr
	mov		eax, ecx
	call	io_writeint
	
	
    
    ret
	

section .data
	str_ex	db 'E(a,b,c,d,e,f,g) = ((a-(b*c))div(a-b))+((b-e)div c)-((f+g-10)mod(g div 5))-d', 0
	str_eq	db ' = ', 0
	str_a	db 'A = ', 0
    str_b	db 'B = ', 0
	str_c	db 'C = ', 0
    str_d	db 'D = ', 0
	str_e	db 'E = ', 0
    str_f	db 'F = ', 0
	str_g	db 'G = ', 0

section .bss
	num_a resd	1
	num_b resd	1
	num_c resd	1
	num_d resd	1
	num_e resd	1
	num_f resd	1
	num_g resd	1
	