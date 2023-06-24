TARGET(binary)
INPUT(boot.bin)
OUTPUT_FORMAT(binary)
SECTIONS
{
    .boot : {
        boot.bin
    }
    .text : {
        *(.text)
    }
    .data : {
        *(.data)
        *(.bss)
    }
    .rodata : {
        *(.rodata)
    }
}