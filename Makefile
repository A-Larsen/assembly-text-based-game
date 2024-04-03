textGame: textGame.o memalloc.o
	gcc -g -o textGame textGame.o memalloc.o -no-pie

textGame.o: textGame.nasm
	nasm -f elf64 -g -F dwarf textGame.nasm -l textGame.lst

memalloc.o: memalloc.nasm
	nasm -f elf64 -g -F dwarf memalloc.nasm -l memalloc.lst

clean:
	rm -rf *.o *.lst
	rm -rf $(shell  find . -maxdepth 1 -type f -executable)

.PHONY: clean	

