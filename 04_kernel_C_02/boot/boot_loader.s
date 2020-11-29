[bits 16]
; A boot sector that enters 32-bit protected mode.
[org 0x7c00]
KERNEL_OFFSET equ 0x1000 ; This is the memory offset to which we will load our kernel

	mov [BOOT_DRIVE], dl	; BIOS store boot drive at in DL, save it
							; for later
	mov bp, 0x9000			; set the stack
	mov sp, bp

	mov bx, MSG_REAL_MODE
	call print_string

	call load_kernel

	call switch_to_pm

	jmp $

%include "boot/print/print_string.s"
%include "boot/disk/disk_load.s"
%include "boot/disk/load_kernel.s"
%include "boot/pm/gdt.s"
%include "boot/pm/print_string_pm.s"
%include "boot/pm/switch_to_pm.s"

[bits 32]
; This is where we arrive after switching to and initialising protected mode.
BEGIN_PM:
	mov ebx, MSG_PROT_MODE
	call print_string_pm	; Use our 32-bit print routine.

	call KERNEL_OFFSET

	jmp $					; Hang.

; Global variables
BOOT_DRIVE:
	db 0
MSG_REAL_MODE: 
	db "DuckOS bootloader...",0
MSG_PROT_MODE:
	db "Switch to 32-bit Protected mode. ",0
MSG_LOAD_KERNEL:
	db "Loading DuckOS Kernel into memory...",0

; Bootsector padding
times 510-($-$$) db 0
dw 0xaa55