section .data

	msg: db "7",10,37h,10 ; message to be displayed 
	len: equ $-msg        ; length of message to be displayed

section .bss 

section .text

	global _start

_start:
	nop
; Put your experiments between the two nops...

	mov eax, 4       ; specify sys_write syscall
	mov ebx, 1       ; specify file desctiptor 1: Standard Output
	mov ecx, msg     ; message to be displayed
	mov edx, len     ; length of message 
	int 80h	         ; Make syscall to  output the text to stdout

; Put your experiments between the two nops...
	nop

