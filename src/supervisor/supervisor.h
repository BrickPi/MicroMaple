#ifndef _H_SUPERVISOR
#define _H_SUPERVISOR
#include "defs.h"

struct __attribute__(packed) MMAP_ENT
{
    UINT64 base_addr;
    UINT64 region_len;
    UINT32 region_type; 
    /* REGION TYPE
    1: Usable
    2: Reserved
    3: ACPI reclaim
    4: ACPI reserved
    5: Reserved
    */
   UINT32 extended_attribs; /* bit zero: ignore entry if not set */
};
typedef struct MMAP_ENT MMAP_ENT;

#endif