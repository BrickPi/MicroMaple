#!/bin/bash
nasm -f bin -o boot.bin loader/entry.S
i686-elf-gcc -T link.ld -s -o mdos.sys -ffreestanding -nostdlib -O2 -Wall -Wextra supervisor/supervisor.c -lgcc