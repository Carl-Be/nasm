; Progam Name: dectobin
; Description:
; 	This program will take a decemial number from a file fillter and output it in binary. 
; 	Written only with 32-bit general purpose registers halves
;
; Created: 8/5/2020
; Updated: 8/5/2020
; Version: 1.0
; Author: Carl Bechie
; 
; Makefile Commands:
; ld -o dectobin dictobin.o
; nasm -f elf64 -g -F stabs -o dectobin
;
; How to run: ./dectobin > output.txt < unsigned value ; cat output.txt 



; Initalized Named Data Items
section .data

	

; Uninitalized Named Data Items 
section .bss

	DECBUFFLEN equ 1024 ; Length of buffer * Play with this number you only need a byte * 
	decBuff: resb DECBUFFLEN ; the text buffer itself 

; Progam code gose here 
section .text 


global _start ; lets the kernel know where to enter the program

; Start the program code
_start:   
	nop ; Keeps the debugger happy

; Read data into the program 
read: 
	mov ax, 3 ; System call sys_read 
	mov bx, 0 ; Standard File Discriptor Input File 
	mov ecx, decBuff ; Get decBuff ready to recive input at its location 
	mov edx, DECBUFFLEN ; size of buffer

	int 80h ; Interupt Kernel Service Call Gate to Service Dispatcher Interupt Vector Tabel location 


; Coverting the decimal to binary 
convert:
	;TODO look at DIV in intels manual and Look up binay to dec using division for a quick refesher 


; Write data out into a file 
write:
	mov ax, 4 ; Systerm call sys_write 
	mov bx, 1 ; Standard Output File Discriptor	
	; data already in registers to write ie. cx and dx 

	int 80h ; Interupt Kernel Service Call Gate to Service Dispatcher Interupt Vector Tabel location 



; Exit the program
exit: 
	mov ax, 1 ; System call sys_exit 
	mov bx, 0 ; Exit code 0 "Normal Execution"

 	int 80h   ; Call system interrupt


