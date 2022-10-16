[BITS 32]
SECTION .multiboot ALIGN=32
multiboot:
%define MAGIC 0x1BADB002
%define ALIGNF 1<<0
%define MEMINF 1<<1
%define MB_FLAGS ALIGNF | MEMINF
%define CHECKSUM -(MAGIC + MB_FLAGS)

DD MAGIC    ; MAGIC
DD MB_FLAGS ; FLAGS
DD CHECKSUM ; CHECKSUM

SECTION .text
global _start
_start:
    CLI
    HLT