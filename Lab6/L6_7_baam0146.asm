; nev: Balazs Adam-Attila
; azonosito: baam0146
; csoport: 621
; labor: L6
; Feladat: E(a,b) = (b^3 - a) / (a + b) - (a - b^2 + 1) / 4


%include 'io.inc'

global main


section .text

main:
	mov		eax, feladat
	call	io_writestr
	call	io_writeln

.loop_n:
	mov		eax, strn
	call	io_writestr
	call	io_readint
	cmp		eax, 4
	jl		.hiba_n
	cmp		eax, 256
	jg		.hiba_n
	mov		ecx, eax
	cdq
	mov		ebx, 4
	div		ebx
	cmp		edx, 0
	jne		.hiba_n
	
	mov		[n], ecx
	xor		ecx, ecx		; ecx = 0
	mov		eax, be1
	call	io_writestr
	call	io_writeln
	
.loop_a:
	mov		eax, str1		; 'A['
	call	io_writestr
	mov		eax, ecx
	call	io_writeint		; index
	mov		eax, str3		; '] = '
	call	io_writestr
	call	io_readflt
	movss	[arr_A + 4 * ecx], xmm0
	inc		ecx
	cmp		ecx, [n]
	jne		.loop_a
	xor		ecx, ecx
	mov		eax, be2
	call	io_writestr
	call	io_writeln
.loop_b:
	mov		eax, str2		; 'B['
	call	io_writestr
	mov		eax, ecx
	call	io_writeint		; index
	mov		eax, str3		; '] = '
	call	io_writestr
	call	io_readflt
	movss	[arr_B + 4 * ecx], xmm0
	inc		ecx
	cmp		ecx, [n]
	jne		.loop_b	
	xor		ecx, ecx
	
	call	Calculate
	mov		eax, er
	call	io_writestr
	call	io_writeln
	
.loop_res:
	mov		eax, strE		; 'E['
	call	io_writestr
	mov		eax, ecx
	call	io_writeint		; index
	mov		eax, str3		; '] = '
	call	io_writestr
	movss	xmm0, [res + 4 * ecx]
	call	io_writeflt
	call	io_writeln
	inc		ecx
	cmp		ecx, [n]
	jne		.loop_res
	
	
	ret
	
	
.hiba_n:
	mov		eax, hiba
	call	io_writestr
	call	io_writeln
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
	
section .data
	one		dd		1.0, 1.0, 1.0, 1.0
	four	dd		4.0, 4.0, 4.0, 4.0
	hiba	db		'Hiba: a szam pozitiv es oszthato kell legyen 4-gyel', 0
	strn	db		'Adja meg a tombok hosszat(n integer, 4<=n<=256): ', 0
	strA	db		'Adja meg az A tomb elemeit:', 0
	strB	db		'Adja meg a B tomb elemeit:', 0
	strE	db		'E[', 0
	str1	db		'A[', 0
	str2	db		'B[', 0
	str3	db		'] = ', 0
	feladat	db		'E(a,b) = (b^3 - a) / (a + b) - (a - b^2 + 1) / 4', 0
	be1		db		'Adja meg az elso tomb elemeit:', 0
	be2		db		'Adja meg a masodik tomb elemeit:', 0
	er		db		'Az eredmeny:', 0