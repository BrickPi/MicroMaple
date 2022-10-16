OBJS32 = src/load/grub/grub.o
OBJS64 = src/kmain.o

kernel: ${OBJS32} ${OBJS64}
	x86_64-elf-gcc ${OBJS32} ${OBJS64} -o kernel -T src/link.ld -ffreestanding -O2 -nostdlib -lgcc

%.o: %.c
	x86_64-elf-gcc $< -o $@ -c -ffreestanding -O2 -Wall -Wextra -mno-red-zone

%.32.o: %.c
	i686-elf-gcc $< -o $@ -c -ffreestanding -O2 -Wall -Wextra

%.o: %.S
	nasm -felf64 $< -o $@

.PHONY: clean
clean:
	rm -rf ${OBJS32} ${OBJS64} kernel grub.elf