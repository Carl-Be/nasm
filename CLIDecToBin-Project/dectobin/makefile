dectobin:dectobin.o
	ld -o dectobin dectobin.o

dectobin.o:dectobin.asm 
	nasm -f elf64 -g -F stabs -o dectobin.o dectobin.asm
