; Desctiption: This is a binary to decimal convertor using shifts and one add 
;
;     Created: 8/18/2020
;     Updated: 8/18/2020 
;      Authur: Carl-Be
;     Version: 1 
;     
;      build:
; 	nasm -f elf64 -g -F stabs -l BinToDec.lst BinToDec.asm
; 	ld -o BinToDec BinToDec.o
;
;      run: 
;        ./BinToDec.asm or echo banary | ./BinToDec.asm or ./BinToDec.asm

;Initalized named data here
section .data 
	binary dd 00010100b ; 20 in decimal 

;Uninitalized named data here
section .bss 

;Program code here 
section .text 

	Global _start ; make the start label global	

; Program entry point 
_start: 
	nop ; keeps gdb happy
	
	xor ebx, ebx ; clear ebx 

	mov ecx, 1 ; start the index count at 1 
	mov ebx, 11010111b; copy the binary into ebx
	mov esi, 32 ; max bits 
	mov edi, 0 ; this is the sum 

;Since we are going to be using shl to get our decimal number the binary 0 index can be shifted out into the carry flag 
;for addition later on. 
getLowestBit: 
	
	shr ebx, 1 ; shift the 0 or 1 bit at index 0 into the carry flag 	

	jc storeOne ; store the one bit for safe keeping if carry flag is set from the shift
	jmp getDecimal ; if no carry go to getDecimal

;stores the carry flag 1 bit in edx manually 
storeOne: 
	mov edx, 1 ; mov 1 into edx because the shift right carried a bit  

	xor eax, eax ; clear eax 
	mov eax, 1

; this label gets the decimal value 
getDecimal:	
	
	shr ebx, 1 ; shift the binary out into the carry flag  
	jc shiftAccLeft ; if the ebx shfit right caused the CF=1 shfit the accumaltor left by the indexcount ammount  

	inc ecx 
	dec esi

	cmp esi, 0 ; if zero exit loop is not recurssion 
	jz addOne; if the length counter is zero jump to addOne
	jmp getDecimal ; jump to getDecemial

shiftAccLeft:

	shl eax, cl
	
 	add edi, eax ; add eax to the sum
	
	mov eax, 1 ; reset eax to 1  

	inc ecx 
	dec esi  

	cmp esi, 0 ; if zero exit loop is not recurssion 
	jz addOne; if the length counter is zero jump to addOne
	jmp getDecimal ; jump to getDecemial



;This adds one to the accumaltor if edx = 1 
addOne:
	cmp edx, 1 ; if edx is not 1 jump to exit else add one to the sum
	jnz exit ; jump to exit 

	add edi , 1 ; add one to the sum

; exit program here 
exit: 
	mov eax, 1 ; sys_exit System call
	mov ebx, 0 ; normal exit code 

	int 80h    ; system interupt to service dispatchor 
	
