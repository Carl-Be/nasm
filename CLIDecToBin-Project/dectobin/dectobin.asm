; Progam Name: dectobin
; Description:
; 	This program will take a decemial number from a file fillter and output it in binary. 
; 	Written only with 32-bit general purpose registers halves
;
; Created: 8/5/2020
; Updated: 8/6/2020
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

	DIVISOR equ 2 ; make a constant for the divisor 

; Uninitalized Named Data Items 
section .bss
	
	BINARBUFFLEN equ 1024 ; Length of binary buffer 
	binBuff: resb BINARBUFFLEN ; the binary buffer itself 

; Progam code gose here 
section .text 


global _start ; lets the kernel know where to enter the program

; Start the program code
_start:   
	nop ; Keeps the debugger happy

	mov ecx, binBuff ; copy binBuff into ecx to right the remainder to the buffer for output 
	mov ebp, 0 ; copy 0 into ebp. each time convert is executed ebp will be incremented by 1 
	mov eax, 255;

	
; Coverting the decimal to binary 
convert:
	mov edx, 0 ; clear the dividend
	mov ebx, DIVISOR ; copy two into ebx to be the divisor for the conversion

	; before DIV executes eax = dividend | ebx = divisor 
	div ebx
	; after DIV executes  eax = quotient | edx = remainder 
	
	add dl, 30h ; add 30h to the remainder to turn it into a number hex charater on the ASCII table instead of a null char or SOH (start of heading) char 
	mov [binBuff + ebp], dl; copy the remainder(ethier charater 0x30(zero) or 0x31(one) ASCII) into the binary buffer address incrementally by 1 address each time

	inc ebp ; increment the (offset) buffer pointer by 1 so no buffer index gets overwriten           

	cmp eax, 0 ; if eax equals 0 binay conversion done else use recursion until done
    	je write ; jump to conversion is done
	jmp convert ; use recursion until the dividend equals zero


; Write data out into a file 
write:	
	inc ebp ; increment the buffer pointer to add a eol char (newline) to the end of the output 
	mov dl, 0x0a ; mov the end of line (newline) char into dl 
	mov [binBuff + ebp], dl ; push end of line (newline) charater over one address  
	

	mov eax, 4 ; Systerm call sys_write 
	mov ebx, 1 ; Standard Output File Discriptor	
	; data buffer already in ecx 
	mov edx, BINARBUFFLEN ; copy binary buffer length into edx for sys_write call to execute

	int 80h ; Interupt Kernel Service Call Gate to Service Dispatcher Interupt Vector Tabel location 

; Exit the program
exit: 
	mov eax, 1 ; System call sys_exit 
	mov ebx, 0 ; Exit code 0 "Normal Execution"

 	int 80h   ; Call system interrupt


