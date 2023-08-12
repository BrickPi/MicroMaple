#!/bin/sh
nasm -f bin -o boot.bin loader/entry.S
i686-elf-gcc -c supervisor/supervisor.c -o supervisor.o -ffreestanding -nostdlib -O2 -Wall -Wextra
i686-elf-gcc -T link.ld -s -o mdos.sys -ffreestanding -nostdlib supervisor.o -lgcc