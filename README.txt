The µMaple Kernel and System Architecture
Joel Machens - 2022

Using µMaple
µMaple is nothing but a memory manager and scheduler, by no means a complete system and by even less a way of booting or operating a computer. µMaple is compliant with Multiboot, STIVALE2, and MLOAD, a tiny Maple-developed loader for x86 BIOS systems.

Specification

Language:
MUST is not optional, and needs to be implemented for a complete µMaple Kernel.
SHOULD is technically optional, but should be implemented wherever possible.
CAN is optional, and the specification makes no regard as to if it is or isn't implemented

1 - Messaging

1.1 Message Structure

1.1.1 A Message MUST be at least 4 bytes in length.
1.1.2 A Message SHOULD be 4 byte aligned
1.1.3 A Message MUST have at least a 24-bit ID, used to identify the message to the system and programs
1.1.5 A Message ID MUST be an unsigned integer, with 0-16384 reserved.
1.1.6 The least significant 8-bits of the first word of a Message MUST be an unsigned integer representing the number of following bytes.
1.1.7 A Message CAN be up to 256 bytes long including the header.
1.1.8 The data following a message header is unstandardised and may be anything, it MUST be ignored by the kernel and faithfully passed to its destination.

1.2 Message Posting

1.2.1 A Kernel MUST implement SYSCALL where RAX = 0 to send messages
1.2.2 Upon POSTMSG system call, the kernel MUST read RDI to find destination process ID.
1.2.3 The kernel MUST verify that the destination process exists.
1.2.4 The kernel MUST verify that the destination process supports and can recieve the message.
1.2.5 The kernel SHOULD verify the message structure at memory location RSI.
1.2.6 The kernel MUST copy the message structure at RSI to the message queue of the destination process.
1.2.7 The kernel MUST add to the execution queue the "RECVMSG" function of the destination process.