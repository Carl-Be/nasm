section .data

section .bss

section .text 
	; Making procedures callable out side of this source file 
	Global CharatersToInteger 

;--------------------------------------------------------------------------------------------------------------------------------
;       memic the modified dependancies
;	mov ebx, 1 ; pointer for edgeing
;	mov eax, 0 ; accumalater
;	mov edx, 0 ; to hold hexidecmial assci values 
;	mov ecx, buffer ; mov the buffer into ecx 
;	mov ebp, 0 ; buffer pointer 	
;--------------------------------------------------------------------------------------------------------------------------------
;CharatersToInteger: Takes user input and changes the hexidecmial ascii charaters to a interger that is usable by the machine to 
; 		     preform arthimatic operations on the user input 
;           UPDATED: 8/14/2020
; 		 IN: User Input Buffer 
;           RETURNS: Numeric Values of ASCII chr number
; 	  REGISTERS: EAX, EBP, Buffer, EDX, ECX, EBX 
;             CALLS: Nothing 
; 	DESCRIPTION: Most of the time useful programs have to take in user input and manipulate it somehow. This Procedure enables 
;        	     the reuse of the conversion algorithm that makes this possible. The algorithm is as follows:
; 		     Starting at the most significant byte work from left to right. (10*n1)+n2 (10)+n3 (10)+......+ LSB. 
; 		     Before the algorithm starts you must first convert the hexidecmial numbers into thier numric ascii values.
; 		     you do this by subtracting 30h from the ascii charaters. EDX/EBP/EAX must be set to zero ECX must have buffer 
;                    address.

; Turns ASCII charaters to Intergers 
CharatersToInteger:
	mov dl, byte [ecx + ebp] ; Starting at the Most significant byte moving left. Place the values into dl.
	sub dl, 30h ; turn the ascii hexidecmial value into a repersented decimal value (still in hex form tho).
	add eax, edx  ; add edx into the accumalater 	
	mov edx, eax ; mov eax current state into edx for later addition

	cmp byte [ecx + ebx], 0x0a ; check to see if the next loction in buffer is an EOL chr if so jmp to .localexit
	je .localExit ; jump short if equal [ZF = 1]

;Times the accumalater by ten 
	lea eax, [eax * 8 + eax] ; eax * 9 	
	add eax, edx ; eax * 10	

	inc ebx ; +1 to ebx
	inc ebp ; +1 to ebp 
	mov edx, 0 ; clear edx 
	jmp CharatersToInteger ; recursion 

; used to get out of loop when EOL chr is found 
.localExit:
	ret ; procedure is done exit to normal program execution
;------------------------------------------------------------------------------------------------------------------------------------
