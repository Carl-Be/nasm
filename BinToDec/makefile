BinToDec:BinToDec.o
	ld -o BinToDec BinToDec.o
BinToDec.o:BinToDec.asm
	nasm -f elf64 -g -F stabs -l BinToDec.lst BinToDec.asm
