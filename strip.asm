section .bss
	inBuffer		resb 64
	outBuffer		resb 64

section .data
	msg				db "Lutfen Bir Yazi Giriniz: ", 0
	msglen			equ $ - msg

section .text
	global _start

_start:
	; write message to stdout
	mov		rax, 1				; syscall: write
	mov		rdi, 1				; stdout
	mov		rsi, msg			; message address
	mov		rdx, msglen			; message length
	syscall

	; read input from stdin
	mov		rax, 0				; syscall: read
	mov		rdi, 0				; stdin
	mov		rsi, inBuffer		; input buffer
	mov		rdx, 64				; number of bytes to read
	syscall

	; Strip function
	mov		rax, 4				; start index
	mov		rbx, 10				; stop index
	mov		rdi, inBuffer		; input buffer address
	mov		rsi, outBuffer		; output buffer address
  call	strip_text

	; write stripped text
	mov		rax, 1				; syscall: write
	mov		rdi, 1				; stdout
	mov		rsi, outBuffer		; output buffer
	mov		rdx, 64				; max write size
	syscall

	; exit
	mov		rax, 60				; syscall: exit
	xor		rdi, rdi			; exit code 0
	syscall

strip_text:
	lea		rdi, [rdi + rax]	; move input pointer to start index
.loop:
	cmp		rax, rbx
	je		.finish

	mov		cl, [rdi]			; get current char
	mov		byte [rsi], cl		; write to output buffer

	inc		rdi
	inc		rsi
	inc		rax
	jmp		.loop

.finish:
	ret
