[BITS 32]
[global _start]
[ORG 0x100000]
;If using '-f bin' we need to specify the
;origin point for our code with ORG directive
;multiboot loaders load us at physical 
;address 0x100000

MULTIBOOT_AOUT_KLUDGE    equ  1 << 16
;FLAGS[16] indicates to GRUB we are not
;an ELF executable and the fields
;header address, load address, load end address;
;bss end address and entry address will be available
;in Multiboot header
MULTIBOOT_ALIGN          equ  1<<0   
; align loaded modules on page boundaries
MULTIBOOT_MEMINFO        equ  1<<1   
; provide memory map

MULTIBOOT_VBE_MODE equ 1<<2

MULTIBOOT_HEADER_MAGIC   equ  0x1BADB002
;magic number GRUB searches for in the first 8k
;of the kernel file GRUB is told to load

MULTIBOOT_HEADER_FLAGS   equ  MULTIBOOT_AOUT_KLUDGE|MULTIBOOT_ALIGN|MULTIBOOT_MEMINFO;|MULTIBOOT_VBE_MODE
CHECKSUM                 equ  -(MULTIBOOT_HEADER_MAGIC + MULTIBOOT_HEADER_FLAGS)

_start:
        xor    eax, eax                ;Clear eax and ebx in the event
        xor    ebx, ebx                ;we are not loaded by GRUB.
        jmp    multiboot_entry         ;Jump over the multiboot header
        align  4                       ;Multiboot header must be 32
                                       ;bits aligned to avoid error 13
multiboot_header:
        dd   MULTIBOOT_HEADER_MAGIC    ;magic number
        dd   MULTIBOOT_HEADER_FLAGS    ;flags
        dd   CHECKSUM                  ;checksum
        dd   multiboot_header          ;header address
        dd   _start                    ;load address of code entry point
                                       ;in our case _start
        dd   00                        ;load end address : not necessary
        dd   00                        ;bss end address : not necessary
        dd   multiboot_entry           ;entry address GRUB will start at

        ; Uncomment this and "|MULTIBOOT_VBE_MODE" in MULTIBOOT_HEADER_FLAGS to enable VBE
        dd 00
        ; Safe resolution
        dd 1024
        dd 768
        dd 32

multiboot_entry:
        mov    esp, 0x100000       ;Setup the stack
        push   0                       ;Reset EFLAGS
        popf

        push   eax                     ;2nd argument is magic number
        push   ebx                     ;1st argument multiboot info pointer

        lea edi,[EXE+DOSHeader.e_lfanew]
        mov edi,[edi]
        add edi,EXE
        lea edi,[edi+NTHeader.AddressOfEntryPoint]
        mov edi,[edi]
        add edi,EXE
        call edi

        cli
        hlt
        jmp $

struc DOSHeader
        .e_magic: resb 2
        .e_cblp: resb 2
        .e_cp: resb 2
        .e_crlc: resb 2
        .e_cparhdr: resb 2
        .e_minalloc: resb 2
        .e_maxalloc: resb 2
        .e_ss: resb 2
        .e_sp: resb 2
        .e_csum: resb 2
        .e_ip: resb 2
        .e_cs: resb 2
        .e_lfarlc: resb 2
        .e_ovno: resb 2
        .e_res1: resb 8
        .e_oemid: resb 2
        .e_oeminfo: resb 2
        .e_res2: resb 20
        .e_lfanew: resb 4
endstruc

struc NTHeader
        .Signature: resb 4
        .Machine: resb 2
        .NumberOfSections: resb 2
        .TimeDateStamp: resb 4
        .PointerToSymbolTable: resb 4
        .NumberOfSymbols: resb 4
        .SizeOfOptionalHeader: resb 2
        .Characteristics: resb 2
        .Magic: resb 2
        .MajorLinkerVersion: resb 1
        .MinorLinkerVersion: resb 1
        .SizeOfCode: resb 4
        .SizeOfInitializedData: resb 4
        .SizeOfUninitializedData: resb 4
        .AddressOfEntryPoint: resb 4
        .BaseOfCode: resb 4
        .ImageBase: resb 8
        .SectionAlignment: resb 4
        .FileAlignment: resb 4
        .MajorOperatingSystemVersion: resb 2
        .MinorOperatingSystemVersion: resb 2
        .MajorImageVersion: resb 2
        .MinorImageVersion: resb 2
        .MajorSubsystemVersion: resb 2
        .MinorSubsystemVersion: resb 2
        .Win32VersionValue: resb 4
        .SizeOfImage: resb 4
        .SizeOfHeaders: resb 4
        .CheckSum: resb 4
        .Subsystem: resb 2
        .DllCharacteristics: resb 2
        .SizeOfStackReserve: resb 8
        .SizeOfStackCommit: resb 8
        .SizeOfHeapReserve: resb 8
        .SizeOfHeapCommit: resb 8
        .LoaderFlags: resb 4
        .NumberOfRvaAndSizes: resb 4
        .Tables: resb 128
endstruc

struc SectionHeader
        .Name: resb 8
        .PhysicalAddress_VirtualSize: resb 4
        .VirtualAddress: resb 4
        .SizeOfRawData: resb 4
        .PointerToRawData: resb 4
        .PointerToRelocations: resb 4
        .PointerToLineNumbers: resb 4
        .NumberOfRelocations: resb 2
        .NumberOfLineNumbers: resb 2
        .Characteristics: resb 4
endstruc

times 0x200000-($-$$) db 0
EXE:
    