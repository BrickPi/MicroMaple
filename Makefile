OBJS = src/kmain.o

mload: src/load/mload.c
	gcc -fpic -ffreestanding -fno-stack-protector -fno-stack-check -fshort-wchar -mno-red-zone -I/usr/include/efi -maccumulate-outgoing-args -c src/load/mload.c -o main.o
	ld -shared -Bsymbolic -L/lib/gnuefi/x64 -T/lib/gnuefi/x64/efi.lds /lib/gnuefi/x64/crt0.o main.o -o main.so -lgnuefi -lefi
	objcopy -j .text -j .sdata -j .data -j .dynamic -j .dynsym  -j .rel -j .rela -j .rel.* -j .rela.* -j .reloc --target efi-app-x86_64 --subsystem=10 main.so mload.efi
	rm main.so

kernel: ${OBJS}
	x86_64-elf-gcc ${OBJS} -o kernel -T src/link.ld -ffreestanding -O2 -nostdlib -lgcc

%.o: %.c
	x86_64-elf-gcc $< -o $@ -c -ffreestanding -O2 -Wall -Wextra -mno-red-zone

%.o: %.S
	nasm -felf64 $< -o $@

.PHONY: run
run: kernel mload
	touch test.img
	dd if=/dev/zero of=./test.img bs=33554432 count=1
	mkfs.fat ./test.img
	sudo mount test.img test
	sudo mkdir test/EFI
	sudo mkdir test/EFI/boot
	sudo cp mload.efi test/EFI/boot/bootx64.efi
	sudo cp kernel test/kernel
	sudo umount test
	qemu-system-x86_64 -monitor stdio -hda ./test.img -bios /usr/share/edk2/ovmf/OVMF_CODE.fd

.PHONY: clean
clean:
	rm -rf ${OBJS} kernel mload.efi test.img