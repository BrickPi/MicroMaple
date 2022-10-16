OBJS32 = 
OBJS64 = src/kmain.o
GRUBOBJS = src/load/grub/grub.o

kernel: ${OBJS32} ${OBJS64}
	x86_64-elf-gcc ${OBJS32} ${OBJS64} -o kernel -T src/link.ld -ffreestanding -O2 -nostdlib -lgcc

grub: ${GRUBOBJS}
	i686-elf-gcc ${GRUBOBJS} -o grub.elf -T src/load/grub/link.ld -ffreestanding -O2 -nostdlib -lgcc

%.o: %.c
	x86_64-elf-gcc $< -o $@ -c -ffreestanding -O2 -Wall -Wextra -mno-red-zone

%.32.o: %.c
	i686-elf-gcc $< -o $@ -c -ffreestanding -O2 -Wall -Wextra

%.o: %.S
	nasm -f elf $< -o $@

.PHONY: clean
clean:
	rm -rf ${OBJS32} ${OBJS64} ${GRUBOBJS} kernel grub.elf