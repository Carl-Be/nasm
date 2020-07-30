section .data

section .text

	global _start

_start:
	nop
; Put your experiments between the two nops...

	mov eax, 5
DoMore: dec eax
	jnz DoMore

; Put your experiments between the two nops...
	nop

section .bss 
