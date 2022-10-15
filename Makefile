build:
	nasm -f bin src/main.S -o main.o

.PHONY: clean
clean:
	rm -rf *.o