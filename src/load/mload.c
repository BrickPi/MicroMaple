#include <efi/efi.h>
#include <efi/efilib.h>

EFI_STATUS
EFIAPI
efi_main (EFI_HANDLE ImageHandle, EFI_SYSTEM_TABLE* SystemTable)
{
    InitializeLib(ImageHandle, SystemTable);
    Print(L"MLOAD\n");

    // Get final memory map and exit UEFI
    UINTN MMS, MK, DS;
    UINT32 DV;
    EFI_MEMORY_DESCRIPTOR* MMAP;
    EFI_STATUS status;
    status = uefi_call_wrapper(SystemTable->BootServices->GetMemoryMap, 5, &MMS, MMAP, &MK, &DS, &DV);
    if (status = EFI_BUFFER_TOO_SMALL)
    {
        uefi_call_wrapper(SystemTable->BootServices->AllocatePages, 4, AllocateAnyPages, EfiLoaderData, (MMS/4096)+1, MMAP);
    }
    uefi_call_wrapper(SystemTable->BootServices->GetMemoryMap, 5, &MMS, MMAP, &MK, &DS, &DV);
    uefi_call_wrapper(SystemTable->BootServices->ExitBootServices, 2, ImageHandle, MK);
    while (1);
    return EFI_SUCCESS;
}