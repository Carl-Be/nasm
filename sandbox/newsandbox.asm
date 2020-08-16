; Description: This is just an example program



; Named Initalized Data
section .data
	
	ClearTermES: db 27, "FF" ; this is the escape sequence for clearing the xterm terminal 
	;the length of the ClearTermES address bytes. Calculated with "Assembly Time Calculation"
	CLEARLEN: equ $-ClearTermES ; The escape sequence needs to be passed trough a Standard Output file stream with int 80h

; Uninitalized Data
section .bss
	
	BufferLength equ 1024 ; the constant lenth of the buffer 1024 bytes 
	InputBuffer: resb BufferLength ; this the buffer itself 


;Program code here 
section .text 

	Global _start ; declearing _start as a global label 

; get the the registers ready for system_read kernel command 
%macro Sysread 2 ; %1 buffer %2 buffer length 
	
	mov eax, 3 ; System call read 
	mov ebx, 0 ; File Discriptor Standard Input 
	mov ecx, %1 ; copy the buffer address into ecx 
	mov edx, %2 ; copy bufferlength into edx 

%endmacro  

; Clears the terminal from user input using escape sequences  
%macro ClearTerm 2 ; %1 = the escape sequence  2% = the escape sequence length 
	
	mov eax, 4 ; System call write
	mov ebx, 1; Standard Output File Discriptor 
	mov ecx, %1 ; copy the escape sequence address into ecx
	mov edx, %2 ; copy the escape sequence length into edx 
	
%endmacro

; Gets registers ready to write to the screen

%macro Syswrite 2 ; %1 buffer %2 bufferlength

	mov eax, 4 ; System call write 
	mov ebx, 1 ; File Discriptor Standard Output 
	mov ecx, %1 ; copy the buffer address into ecx 
	mov edx, %2 ; copy bufferlength into edx 

%endmacro
	
; Kernel enters program here 
_start: 
	nop ; keeps gdb happy 
	
	Sysread InputBuffer, BufferLength ; place the Sysread macro with its arguments
	
	int 80h ; call the system interupt to pass through the Kernel Service Call Gate to head towards the Service Dispathor

	ClearTerm ClearTermES, CLEARLEN ; place the ClearTerm macro with its required arguments

	int 80h ; call the system interupt to pass through the Kernel Service Call Gate to head towards the Service Dispathor

	Syswrite InputBuffer, BufferLength ; place the Syswrite macro with its arguments

	int 80h ; call the system interupt to pass through the Kernel Service Call Gate to head towards the Service Dispathor

	nop ; keeps gdb happy 










