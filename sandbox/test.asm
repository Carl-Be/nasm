; Test asm File to play with
; 
; Author: Carl Bechie
; Created: 8/03/2020
; Updated: 8/03/2020
;
; Will be inputed into sandbox.asm for building 

section .data ; where initialized data goes 

	MyString: db "Hello this is my first written program from memory",10,'"This" will be a multiline string! :)',10 ; String labled MyString
	StringLen: equ $-MyString ; Calculate string lengeth during assembly-time calculations 

section .bss ; where unitialized data goes 


section .text ; program code goes beneath here 

	Global _start 	   		; Kerenel needs this global label to know where to start program execution 
		
_start: 	   		; start program code execution

	nop  			; gdb needs this to be happy 
	
	mov eax, 4 		; Put sys_call write into eax
	mov ebx, 1 		; output file discriptor arg
	mov ecx, MyString 	; buff argument of sys_call
	mov edx, StringLen ; String Size
		
	int 80H 		; Call System Interupt to write string to screen

	mov eax, 1 		; Put sys_call exit into eax
	mov ebx, 0 		; exit status code 0 - normal exit 

	int 80H 		; Call System Interupt to exit program code  

	nop 			; gdb needs this to be happy 
