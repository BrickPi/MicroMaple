OBJS = src/kmain.o

kernel: ${OBJS}
	x86_64-elf-gcc ${OBJS} -o kernel -T src/link.ld -ffreestanding -O2 -nostdlib -lgcc

%.o: %.c
	x86_64-elf-gcc $< -o $@ -c -ffreestanding -O2 -Wall -Wextra -mno-red-zone

%.o: %.S
	nasm -felf64 $< -o $@

.PHONY: clean
clean:
	rm -rf ${OBJS} kernel grub.elf