#!/bin/sh
nasm -f bin -o boot.bin loader/entry.S
/usr/bin/clang -target i686-none-elf -c supervisor.c -o supervisor.o -ffreestanding -O2 -Wall -Wextra
i686-elf-gcc -T link.ld -s -o mdos.sys -ffreestanding -nostdlib supervisor.o -lgcc