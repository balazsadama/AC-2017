; nev: Balazs Adam-Attila
; azonosito: baam0146
; csoport: 621
; labor: L6
; Feladat: E(a,b) = (b^3 - a) / (a + b) - (a - b^2 + 1) / 4

;%include 'mio.inc'

;;;;;;;;;;;;;;;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!
%include 'io.inc'
;;;;;;;;;;;;;;;;;;;;!!!!!!!!!!!!!!!!!!!!!!!!

global main


section .text

main:

.loop_n:
	call	io_readint
	mov		ecx, eax
	cdq
	mov		ebx, 4
	div		ebx
	cmp		edx, 0
	jne		.hiba_n
	
	mov		eax, ecx
	mov		[n], eax
	xor		ecx, ecx		; ecx = 0
.loop_a:
	call	io_readflt
	movss	[arr_A + 4 * ecx], xmm0
	inc		ecx
	cmp		ecx, eax
	jne		.loop_a
	xor		ecx, ecx
.loop_b:
	call	io_readflt
	movss	[arr_B + 4 * ecx], xmm0
	inc		ecx
	cmp		ecx, eax
	jne		.loop_b	
	xor		ecx, ecx
	
; .loop_ki_A:
	; movss	xmm0, [arr_A + 4 * ecx]
	; call	io_writeflt
	; call	io_writeln
	; inc		ecx
	; cmp		ecx, [n]
	; jne		.loop_ki_A
	; xor		ecx, ecx
; .loop_ki_B:
	; movss	xmm0, [arr_B + 4 * ecx]
	; call	io_writeflt
	; call	io_writeln
	; inc		ecx
	; cmp		ecx, [n]
	; jne		.loop_ki_B
	
	call	Calculate
		
.loop_res:
	movss	xmm0, [res + 4 * ecx]
	call	io_writeflt
	call	io_writeln
	inc		ecx
	cmp		ecx, [n]
	jne		.loop_res
	
	
	ret
	
	
.hiba_n:
	; kiir hibauzenet
	jmp		.loop_n




Calculate:
	pushad
	xor		ecx, ecx
	
.loop_calc:
	movaps	xmm0, [arr_A + 4 * ecx]
	movaps	xmm1, [arr_B + 4 * ecx]
	
	movaps	xmm2, xmm1				; xmm2 = b
	mulps	xmm1, xmm2
	mulps	xmm1, xmm2				; xmm1 = b^3
	
	subps	xmm1, xmm0				; xmm1 = b^3 - a
	addps	xmm0, xmm2				; xmm0 = a + b
	divps	xmm1, xmm0				; xmm1 = (b^3 - a) / (a + b)
	
	mulps	xmm2, xmm2				; xmm2 = b^2
	movaps	xmm0, [arr_A + 4 * ecx]		; xmm0 = a
	subps	xmm0, xmm2				; xmm0 = a - b^2
	addps	xmm0, [one]				; xmm0 = a - b^2 + 1
	divps	xmm0, [four]			; xmm0 = (a - b^2 + 1) / 4
	subps	xmm1, xmm0
	movaps	[res + 4 * ecx], xmm1
	
	add		ecx, 4
	cmp		ecx, [n]
	jge		.end
	jmp		.loop_calc
	
.end:
	popad
	ret





section .bss
	arr_A	resd	256
	arr_B	resd	256
	res		resd	256
	n		resd	1
	;arr_res		resd	256
	
section .data
	one		dd		1.0, 1.0, 1.0, 1.0
	four	dd		4.0, 4.0, 4.0, 4.0