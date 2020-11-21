[bits 16]
; A boot sector that enters 32-bit protected mode.
[org 0x7c00]
	mov bp, 0x9000			; set the stack
	mov sp, bp

	mov bx, MSG_REAL_MODE
	call print_string

	call switch_to_pm

	jmp $

%include "print_string.s"
%include "gdt.s"
%include "print_string_pm.s"
%include "switch_to_pm.s"

[bits 32]
; This is where we arrive after switching to and initialising protected mode.
BEGIN_PM:
	mov ebx, MSG_PROT_MODE
	call print_string_pm	; Use our 32-bit print routine.

	jmp $					; Hang.

; Global variables
MSG_REAL_MODE: 
	db "DuckOS bootloader...",0
MSG_PROT_MODE:
	db "DuckOS Successfully loaded in 32 mode.",0

; Bootsector padding
times 510-($-$$) db 0
dw 0xaa55