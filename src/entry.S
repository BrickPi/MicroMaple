BITS 16
ORG 0x7C00
JMP 0:entry
entry:
XOR AX, AX
MOV DS, AX
MOV ES, AX
MOV SS, AX ; clear stack segment register
MOV SP, 0x7C00 ; stack grows down from here

MOV AH, 0xE
MOV AL, 'J'
INT 0x10
MOV AL, 'M'
INT 0x10 ; startup display

; set the A20 line
%include "src/util/A20.S"
after_A20:

; load rest of the bootloader (TODO: load kernel and relocate to 0xA000, then handoff)
MOV AH, 0
INT 0x13
MOV AH, 0x2
MOV AL, 0x1 ; SECTORS TO READ
MOV CX, 0x2
MOV DH, 0x0
XOR BX, BX
MOV ES, BX
MOV BX, 0x7E00
INT 0x13

; detect memory
CALL do_e820
JC halt

; jump to second stage
JMP 0x7E00

%include "src/util/MMAP.S"

TIMES 510-($-$$) DB 0
DW 0xAA55

; disable NMI
CLI
IN AL, 0x70
OR AL, 0x80
OUT 0x70, AL
IN AL, 0x71

LGDT [gdtr_def]
MOV EAX, CR0
OR AL, 1 ; SET PE BIT
MOV CR0, EAX
JMP 8:pm_init ; far jump to PM
pm_init: ; init all of our segment registers
BITS 32 ; ALL CODE AFTER THIS IS 32 BIT
MOV EAX, 16d
MOV DS, EAX
MOV SS, EAX
MOV ES, EAX
MOV ESP, 0x7C00

; enable NMI
IN AL, 0x70
AND AL, 0x7F
OUT 0x70, AL
IN AL, 0x71
STI

JMP halt
%include "src/util/GDT.S"

halt:
CLI
HLT