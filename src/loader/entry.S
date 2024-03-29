BITS 16
ORG 0x7C00
JMP 0:entry
entry:
XOR AX, AX
MOV DS, AX
MOV ES, AX
MOV SS, AX ; clear stack segment register
MOV SP, 0x7C00 ; stack grows down from here

; set the A20 line
%include "loader/util/A20.S"
after_A20:

; load rest of the bootloader
MOV AH, 0
INT 0x13
MOV AH, 0x2
MOV AL, 0x1
MOV CX, 0x2
MOV DH, 0x0
XOR BX, BX
MOV ES, BX
MOV BX, 0x7E00
INT 0x13

; kernel is the MX executable located in segment directly after bootloader
MOV AH, 0
INT 0x13
MOV AH, 0x2
MOV AL, 0x1 ; load first segment to read MX info
MOV CX, 0x3
MOV DH, 0x0
MOV BX, 0x1000
MOV ES, BX
XOR BX, BX
INT 0x13
; calculate needed sectors to load from MX header
MOV AX, 0x1000
MOV GS, AX
MOV AX, WORD [FS:0]
CALL c_mx

; detect memory
CALL do_e820
JC halt

; jump to second stage
JMP second

%include "loader/util/MMAP.S"

TIMES 510-($-$$) DB 0
DW 0xAA55

c_mx:
XOR EAX, EAX
MOV AX, WORD [FS:2]
ADD EAX, DWORD [FS:4]
ADD EAX, DWORD [FS:8]
XOR EDX,EDX
MOV ECX, 512d
DIV ECX
CMP EDX, 0
JE load_mx
INC EAX

load_mx:
MOV AH, 0
INT 0x13
MOV AH, 0x2
MOV CX, 0x3
MOV DH, 0x0
MOV BX, 0x1000
MOV ES, BX
XOR BX, BX
INT 0x13
RET

; second state bootloader entry
second:
; disable interrupts
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

; re-enable NMI, now that we're working with 32 bit code, we can't enable interrupts again until IDT is setup.
IN AL, 0x70
AND AL, 0x7F
OUT 0x70, AL
IN AL, 0x71

; jump to the kernel
PUSH 0x8004
PUSH 0x8000
CALL 0x10010
halt:
CLI
HLT

%include "loader/util/GDT.S"

TIMES 1024-($-$$) DB 0

; define MX header for supervisor
DB 'J'
DB 'M'
DW 16d
DD 0xAAAAAAAA ; code length - checksumtool'd
DD 0 ; kernel executable has no specific data segment
DD 0xCCCCCCCC ; sum checksum - checksumtool'd