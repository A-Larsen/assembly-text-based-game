textGame: textGame.o memory.o string.o io.o
	gcc -g -o textGame textGame.o memory.o string.o io.o -no-pie

textGame.o: textGame.nasm
	nasm -f elf64 -g -F dwarf textGame.nasm -l textGame.lst

memory.o: memory.nasm
	nasm -f elf64 -g -F dwarf memory.nasm -l memory.lst

string.o: string.nasm
	nasm -f elf64 -g -F dwarf string.nasm -l string.lst

io.o: io.nasm
	nasm -f elf64 -g -F dwarf io.nasm -l io.lst

clean:
	rm -rf *.o *.lst
	rm -rf $(shell  find . -maxdepth 1 -type f -executable)

.PHONY: clean	

