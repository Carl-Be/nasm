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
	
	READBUFFLEN equ 10 ; Length of Decimal input buffer 10 bytes
	readinput: resb READBUFFLEN ; the decimal buffer itself 

	BINARBUFFLEN equ 20 ; Length of binary buffer 
	binBuff: resb BINARBUFFLEN ; the binary buffer itself 

; Progam code gose here 
section .text 


global _start ; lets the kernel know where to enter the program

; Start the program code
_start:   
	nop ; Keeps the debugger happy

;reading input from terminal 
read: 
	mov eax, 3 ; mov sys call sys_read into eax
	mov ebx, 0 ; file disriptor (input) arg for sys_read 
	mov ecx, readinput ; buffer for the input
	mov edx, READBUFFLEN ; length of readinput buffer

	int 80h ; software interrupt through the kernel service call gate towards the service dispatchor interrupt vector 

	mov eax, 240;ecx  copy the input into the eax register for calculations

	mov ecx, binBuff ; copy binBuff into ecx to write the remainder to the buffer for output 
	mov ebp, 0 ; copy 0 into ebp. each time convert is executed ebp will be incremented by 1 
	
; Coverting the decimal to binary 
convert:
	mov edx, 0 ; clear the dividend
	mov ebx, DIVISOR ; copy two into ebx to be the divisor for the conversion

	; before DIV executes eax = dividend | ebx = divisor 
	div ebx
	; after DIV executes  eax = quotient | edx = remainder 
	
	not dl ; reverse the bits to dl so display binary in correct order outcomes| 1111 1111 or 1111 1110 

	add dl, 32h ; add 32h to dl to carry out all the one bits form the not operation to get the proper hex value | 0001 1110 or 0001 1111 
	mov [binBuff + ebp], dl; copy the remainder(ethier charater 0x30(zero) or 0x31(one) ASCII) into the binary buffer address incrementally by 1 address each time

	inc ebp ; increment the (offset) buffer pointer by 1 so no buffer index gets overwriten           

	cmp eax, 0 ; if eax equals 0 binay conversion done else use recursion until done
    	jz write ; jump to conversion is done
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


