dectobin : filefillter.o
	ld -o dectobin filefillter.o

filefillter.o : filefillter.asm
	nasm -f elf64 -g -F stabs filefillter.asm -l filefillter.lst
