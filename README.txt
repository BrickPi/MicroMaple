The µMaple Kernel and System Architecture
Joel Machens - 2022

Using µMaple
µMaple is nothing but a memory manager and scheduler, by no means a complete system and by even less a way of booting or operating a computer. µMaple is compliant with Multiboot (GRUB, Limine etc) and MLOAD, a tiny Maple-developed loader for UEFI-based systems.

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
1.1.6 The least significant 8-bits of the first dword of a Message MUST be an unsigned integer representing the number of following bytes.
1.1.7 A Message CAN be up to 256 bytes long including the header.
1.1.8 The data following a message header is unstandardised and may be anything, it MUST be ignored by the kernel and faithfully passed to its destination.

1.2 Message Delivery

1.2.1 A Kernel MUST implement SYSCALL where RAX = 0 to send messages, known henceforth as the POSTMSG system call.
1.2.2 Upon POSTMSG system call, the kernel MUST read RDI to find destination process ID.
1.2.3 The kernel MUST verify that the destination process exists.
1.2.4 The kernel SHOULD inform the caller (with a message) if the destination process does not exist and cannot be started.
1.2.5 The kernel MUST verify that the destination process supports and can receive the message.
1.2.6 The kernel SHOULD verify the message structure at memory location RSI.
1.2.7 The kernel MUST copy the message structure at RSI to the message queue of the destination process.
1.2.8 The kernel MUST add to the execution queue the "RECVMSG" function of the destination process.

1.3 Kernel Messages*

1.3.1 The kernel MUST implement MSG ID 17 as MSG_ALLOC which when received by the kernel allocates physical memory based on a number of flags. This message is 8 bytes in length, with the second dword containing a 24-bit number containing the number of pages requested, and an 8-bit number containing the flags, (ISADMA, LOWMEM, etc.)
1.3.2.1 The kernel MUST implement MSG ID 18 as MSG_ALLOCD.
1.3.2.2 When MSG_ALLOC_DONE is received by a program, it MUST be 8 or 12 bytes in length, which if successful, are 12 bytes containing an 64-bit memory address of the allocated memory, a 24-bit number containing the number of pages in this allocation, and 8 bits set to either 0x00 if there is no more chunks, or the number of further chunks coming as MSG_ALLOC_DONE messages.
1.3.2.3 If memory allocation is unsuccessful, it MUST be an 8 byte message with an error code in the lower dword of the message.
1.3.3 The kernel MUST implement MSG ID 19 as MSG_FREE which when received by the kernel deallocates physical memory at a provided address. This message is 12 bytes long, with the data being only the address. MSG_FREE MUST guarantee that the memory is freed.

* See Section 2 Kernel Routines and Function for more guidance on the function of these messages.
