; Test asm File to play with
; 
; Author: Carl Bechie
; Created: 8/03/2020
; Updated: 8/03/2020
;
; Will be inputed into sandbox.asm for building 

section .data ; where initialized data goes 
section .bss ; where unitialized data goes 
section .text ; program code goes beneath here 

	Global _start 	   		; Kerenel needs this global label to know where to start program execution 
		
_start: 	   		; start program code execution

	nop  			; gdb needs this to be happy 

	mov eax, 00010000b
	test eax, 4  		

	nop 			; gdb needs this to be happy 
