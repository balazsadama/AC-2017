; Compile:
; nasm -f win32 gfxdemo.asm
; nlink gfxdemo.obj -lio -lgfx -o gfxdemo.exe

; Use WASD and mouse (drag) to move the image

%include 'io.inc'
%include 'gfx.inc'

%include 'util.inc'

%define WIDTH  1024
%define HEIGHT 768

global main

section .text
main:
	; Create the graphics window
    mov		eax, WIDTH		; window width (X)
	mov		ebx, HEIGHT		; window hieght (Y)
	mov		ecx, 0			; window mode (NOT fullscreen!)
	mov		edx, caption	; window caption
	call	gfx_init
	
	test	eax, eax		; if the return value is 0, something went wrong
	jnz		.init
	; Print error message and exit
	mov		eax, errormsg
	call	io_writestr
	call	io_writeln
	ret
	
	
.init:
	mov		eax, infomsg	; print some usage info
	call	io_writestr
	call	io_writeln
	
	xor		esi, esi		; deltax (used for moving the image)
	xor		edi, edi		; deltay (used for moving the image)
	
	; Main loop
.mainloop:
	; Draw something
	call	gfx_map			; map the framebuffer -> EAX will contain the pointer
	
	
	
	

	
	
	
	; kiszamit deltax, deltay - ennyivel noveljuk a szamokat minden iteracional		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	movss	xmm0, [xmax]
	subss	xmm0, [xmin]				; xmm0 = xmax - xmin
	mov		eax, WIDTH
	cvtsi2ss xmm1, eax					; xmm1 = WIDTH
	divss	xmm0, xmm1					; xmm0 = (xmax - xmin) / WIDTH = deltax
	movss	[deltax], xmm0
	
	movss	xmm0, [ymax]
	subss	xmm0, [ymin]
	mov		eax, HEIGHT
	cvtsi2ss xmm1, eax																;ezt at kene rakni szerintem a mainloop utan
	divss	xmm0, xmm1					; xmm0 = (ymax - ymin) / HEIGHT = deltay	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	movss	[deltay], xmm0
	
	
	
	
	
	
	
	
	
	
	
	; Loop over the lines
	xor		ecx, ecx		; ECX - line (Y)
.yloop:
	cmp		ecx, HEIGHT
	jge		.yend	
	
	; Loop over the columns
	xor		edx, edx		; EDX - column (X)
.xloop:
	cmp		edx, WIDTH
	jge		.xend
	
	
	
	
	
	
	
	
	
	; Write the pixel
	pushad														;!!!!!!!!!!!!!!!!	 ez a sor kell, ezt ne torold ki veletlenul pls!!!!!!!!!!!!!!!!!!
	
	; kiszamit deltax, deltay - ennyivel noveljuk a szamokat minden iteracional		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; movss	xmm0, [xmax]
	; subss	xmm0, [xmin]				; xmm0 = xmax - xmin
	; mov		eax, WIDTH
	; cvtsi2ss xmm1, eax					; xmm1 = WIDTH
	; divss	xmm0, xmm1					; xmm0 = (xmax - xmin) / WIDTH = deltax
	; movss	[deltax], xmm0
	
	; movss	xmm0, [ymax]
	; subss	xmm0, [ymin]
	; mov		eax, HEIGHT
	; cvtsi2ss xmm1, eax
	; divss	xmm0, xmm1					; xmm0 = (ymax - ymin) / HEIGHT = deltay	;ezt at kene rakni szerintem a mainloop utan
	; movss	[deltay], xmm0															;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	
	; kiszamoljuk a kezdoertekeket
	cvtsi2ss xmm0, edx					; x koordinatat valossa alakitjuk
	mulss	xmm0, [deltax]				; kialakitjuk a kezdoerteket
	addss	xmm0, [xmin]				
	
	cvtsi2ss xmm1, ecx					; y koordinatat valossa alakitjuk
	mulss	xmm1, [deltay]				; kialakitjuk a kezdoerteket
	addss	xmm1, [ymin]
	
	xor		ebx, ebx					; iterator
.iterate_pixel:
	movss	xmm2, xmm0
	mulss	xmm2, xmm0					; xmm2 = x^2
	movss	xmm3, xmm1
	mulss	xmm3, xmm1					; xmm3 = y^2
	subss	xmm2, xmm3
	addss	xmm2, [x0]					; xmm2 = x^2 - y^2 + x0
	mulss	xmm1, xmm0
	mulss	xmm1, [two]
	addss	xmm1, [y0]					; xmm1 = 2*x*y + y0		 = y
	movss	xmm0, xmm3					; xmm0 = x^2 - y^2 + x0  = x
	
	movss	xmm2, xmm0
	mulss	xmm2, xmm1					; xmm2 = x^2 + y^2
	comiss	xmm2, [four] 
	jg		.escaped
	inc		ebx
	cmp		ebx, [max_iter]
	jge		.reached_max_it
	jmp		.iterate_pixel
	
.escaped:								; if it escaped, make it silver color
	mov		[eax], 192
	mov		[eax+1], 192
	mov		[eax+2], 192
	mov		[eax+3], 0
	jmp		.next_pixel
	
.reached_max_it:						; if it passed, make it black
	mov		[eax], 0
	mov		[eax+1], 0
	mov		[eax+2], 0
	mov		[eax+3], 0
	
	
	
	
	
	
	
	
	
	
	
;;	blue
	; mov		ebx, ecx
	; add		ebx, edx
	; add		ebx, [offsetx]
	; add		ebx, [offsety]
	; mov		[eax], bl
;;	green
	; mov		ebx, edx
	; add		ebx, [offsetx]
	; mov		[eax+1], bl
;;	red
	; mov		ebx, ecx
	; add		ebx, [offsety]
	; mov		[eax+2], bl
;;	zero
	; xor		ebx, ebx
	; mov		[eax+3], bl
	
.next_pixel:
popad
	add		eax, 4		    ; next pixel
	
	
	
	
	inc		edx
	jmp		.xloop
	
.xend:
	inc		ecx
	jmp		.yloop
	
.yend:
	call	gfx_unmap		; unmap the framebuffer
	call	gfx_draw		; draw the contents of the framebuffer (*must* be called once in each iteration!)
	
	
	; Query and handle the events (loop!)
	xor		ebx, ebx		; load some constants into registers: 0, -1, 1
	mov		ecx, -1
	mov		edx, 1
	
.eventloop:
	call	gfx_getevent
	
	; Handle movement: keyboard
	cmp		eax, 'w'	; w key pressed
	cmove	edi, ecx	; deltay = -1 (if equal)
	cmp		eax, -'w'	; w key released
	cmove	edi, ebx	; deltay = 0 (if equal)
	cmp		eax, 's'	; s key pressed
	cmove	edi, edx	; deltay = 1 (if equal)
	cmp		eax, -'s'	; s key released
	cmove	edi, ebx	; deltay = 0
	cmp		eax, 'a'
	cmove	esi, ecx
	cmp		eax, -'a'
	cmove	esi, ebx
	cmp		eax, 'd'
	cmove	esi, edx
	cmp		eax, -'d'
	cmove	esi, ebx
	
	; Handle movement: mouse
	cmp		eax, 1			; left button pressed
	jne		.eventloop1
	mov		dword [movemouse], 1
	call	gfx_getmouse
	mov		[prevmousex], eax
	mov		[prevmousey], ebx
	jmp		.eventloop
.eventloop1:
	cmp		eax, -1			; left button released
	jne		.eventloop2
	mov		dword [movemouse], 0
	jmp		.eventloop
.eventloop2:

	; Handle exit
	cmp		eax, 23			; the window close button was pressed: exit
	je		.end
	cmp		eax, 27			; ESC: exit
	je		.end
	test	eax, eax		; 0: no more events
	jnz		.eventloop
	
	
	; Query the mouse position if the left button is pressed, and update the offset
	cmp		dword [movemouse], 0
	je		.updateoffset
	call	gfx_getmouse	; EAX - x, EBX - y
	mov		ecx, eax
	mov		edx, ebx
	sub		eax, [prevmousex]
	sub		ebx, [prevmousey]
	sub		[offsetx], eax
	sub		[offsety], ebx
	mov		[prevmousex], ecx
	mov		[prevmousey], edx
	
.updateoffset:
	add		[offsetx], esi
	add		[offsety], edi
	jmp 	.mainloop
    
	; Exit
.end:
	call	gfx_destroy
    ret
    
	
section .data
    caption db "Assembly Graphics Demo", 0
	infomsg db "Use WASD and mouse (drag) to move the image!", 0
	errormsg db "ERROR: could not initialize graphics!", 0
	
	; These are used for moving the image
	offsetx dd 0
	offsety dd 0
	
	movemouse dd 0  ; bool (true while the left button is pressed)
	prevmousex dd 0
	prevmousey dd 0
	
	
	; mine:
	xmin		dd		-2.5
	xmax		dd		1.0
	ymin		dd		-1.0
	ymax		dd		1.0
	max_iter	dd		100
	x0			dd		-2.5
	y0			dd		-1.0
	two			dd		2.0
	four		dd		4.0
	
section .bss
	deltax		resd	1	; (xmax-xmin)/xres = (xmax - xmin) / 1024			ennyivel noveljuk pixelenkent az X koordinatat
	deltay		resd	1	; (ymax-ymin)/yres = (ymax - ymin) / 768			ennyivel noveljuk pixelenkent az Y koordinatat
	xtemp		resd	1
	iterator	resd	1