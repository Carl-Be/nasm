; Executeable: fillter 
; Description: This program will take input from a file and convert its contents to the 
; 	       oppropiate numric value that that the user inputted 
;  
;  Created: 8/11/2020
;  Updated: 8/11/2020
;  Author: Carl Bechie
;  Version: 1
;
; build cmommands:
; 	    ld -o fillter filefillter.o
; 	    nasm -f elf64 -g -F stabs filefillter.asm -l filefillter.lst
;  
;      run:
;           echo n | ./filefillter 
;

; named initialized data here 
section .data
	DIVISOR equ 2 ; making a constant for the divisor

; uninitalized data here aka buffers 
section .bss
	BUFFERLEN equ 120 ; the buffers length is 120 bytes 
	ORDERBUFFLEN equ 400 ; enough room to make sure I dont collied 

	buffer: resb BUFFERLEN ; the actual input buffer 
	binbuffer: resb BUFFERLEN ; the conversion buffer to hold the calculations 
	orderdbuffer: resb ORDERBUFFLEN ; this buffer holds the bytes in the correct order 

; program code goes here 
section .text 

	Global _start ; make _start a global label 

; This is were the kernel enters the program code 
_start:
	nop ; keeps the debugger happy

; Reads the data in from the input file 
read: 
	mov eax, 3 ; sys_read system call 
	mov ebx, 0 ; file dicriptor Standard Input
	mov ecx, buffer ; the buffer to take input from file 
	mov edx, BUFFERLEN ; the length of the buffer 

	int 80h ; softerware interupt for the service dispatchor through the kernel service call gate 
	
	mov ebp, 0 ; place the buffer length into ebp for looping counter / buffer pointer  
	xor eax,eax ; clear eax the accumulator  
	mov ebx, 10 ; this is the multiplyer 
	mov edi, 1 ; checks the edge for 0a in the minus label

; Fillters the read buffer to make sure to it above or equal to 30h
fillterAbove:

	cmp byte [ecx + ebp], 29h ; compares 29h to byte 
	; TODO jbe erro message ; Jump short if below or equal (CF = 1 or ZF = 1) 
	ja fillterBelow ; jump short if above (CF = 0 and ZF = 0)

; Fillters to make sure the hex value is equal to or under 39h
fillterBelow:
	cmp byte [ecx + ebp], 40h ; compares 40h to byte  
	jb minus ; Jump short if below (CF = 1)
	;TODO jae add erro message label saying not a digit 

; Subtracts from the buffer index 
minus: 
	sub byte [ecx + ebp], 30h ; make the byte into a numric value and not ascii 
	
	cmp byte [ecx + edi], 0ah ; cmp to the eol chr  
	je addtoeax ; just add the next value into eax instead of times and add  

; Sums the decimal value in eax  
sumDec:	
	xor edx, edx ; clear edx 
	movzx edx, byte[ecx + ebp] ; add this memory addesses value into eax
	add eax, edx ; add the value into eax 
	mul ebx ; times eax by 10 
	
	inc ebp 
	inc edi

	jmp fillterAbove

; add to the accumulator the value of the least signiicant digit 
addtoeax:
	xor edx, edx ; clear edx 
	
	movzx edx, byte[ecx + ebp] ; add this memory addesses value into eax
	add eax, edx ; add the value into eax 
	
	xor ebx, ebx ; clear ebx 
	xor ebp, ebp ; clear ebp 
	mov ecx, binbuffer

; Converts to binary 
convert:

        mov edx, 0 ; clear the dividend
        mov ebx, DIVISOR ; copy two into ebx to be the divisor for the conversion
     
        ; before DIV executes eax = dividend | ebx = divisor 
        div ebx
        ; after DIV executes  eax = quotient | edx = remainder 
            
        add dl, 30h ; add 30h to dl to carry out all the one bits form the not operation to get the proper hex value 
        mov [ecx + ebp], dl; copy the remainder(ethier charater 0x30(zero) or 0x31(one) ASCII) into the binary buffer address incrementally by 1 add      ress each time
      
        inc ebp ; increment the (offset) buffer pointer by 1 so no buffer index gets overwriten           
      
        cmp eax, 0 ; if eax equals 0 binay conversion done else use recursion until done
	jz resetreg ; jump to conversion is done
	jmp convert ; use recursion until the dividend equals zero

; This resets the registers 
resetreg: 
	xor eax, eax
	xor ebp, ebp 
	xor edi, edi
	xor esi, esi
	xor ecx, ecx 
	xor ebx, ebx
	xor edx, edx 
	
	mov edx, binbuffer
	mov ecx, orderdbuffer
	mov ebp, 120 ; this is going to be used to reverse the order this is for binbuffer count downwards 
	mov edi, 0 ; this is for the orderdbuffer index

; This reverse the buffer to the correct order 
reverse: 
	dec ebp ; decrenment ebp by 1 

	mov al, byte [edx + ebp] ; starting at the least signicant byte place it into the correct order buffer 
	mov [ecx + edi], al ; starting at the most signicant byte start placing the correct order into the buffer 

	inc edi ; increment esi by 1 	

	cmp ebp, 0 ; once zero jmp to writeBuffer
	jnz reverse ; jmp if not zero back to reverse until zero 

; Displays the write buffer to the terminal 
writeBuffer: 
	
	mov byte [ecx + 350], 0ah; place the end of line charater bake into the buffer 

	mov eax, 4 ; System call sys_write
	mov ebx, 1 ; File dicriptor for standard output 
	mov edx, ORDERBUFFLEN; place the buffers length into edx for output 

	int 80h ; softerware interupt for the service dispatchor through the kernel service call gate 

; Exits the program normally 
exitProgram: 
	mov eax, 1 ; Place the sys_exit interput vector system call into eax 
	mov ebx, 0 ; Place the normal status exit code into ebx
	
	int 80h ; Call the kernel service call gate softerware interupt into the service dispatchor intuput vetor address in the interupt vetor tabel  

