test:test.o
	ld -o test test.o

test.o:test.asm 
	nasm -f elf64 -g -F stabs -o test.o test.asm
