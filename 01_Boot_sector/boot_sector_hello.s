; Print some string and read some sectors from the boot disk
[bits 16]					; 16 bits mode
[org 0x7c00]				; offset the starting address when direct addressing

boot_hello:
	mov ah, 0x0e			; tty BIOS routine

	mov bp, 0x8000			; set stack base pointer a little above where BIOS
	mov sp, bp				; loads this bootloader, so it won't overwrite it

	mov al, `\n`
	int 0x10
	mov bx, BOOT_MSG
	call print_line
	mov bx, QUAK_MSG
	call print_line

	mov [BOOT_DRIVE], dl	; BIOS store boot drive at in DL, save it
	mov bx, 0x9000			; Load 5 sectors to 0x9000
	mov dh, 5				; from the boot disk
	mov	dl, [BOOT_DRIVE]
	call disk_load

	; TODO : load a string
	mov dx, [0x9000]		; Print the first loaded word at 0x90000
	call print_hex			; expect to be 0xdcdc

	mov dx, [0x9000 + 512]	; Print the first word of the second sector
	call print_hex			; expect to be 0xface

	jmp $					; jump to current address = infinite loop

%include "print_line.s"
%include "print_hex.s"
%include "disk_load.s"

; Variables
BOOT_MSG:
	db 'Booting DuckOS',0
QUAK_MSG:
	db 'Quaking the disk...',0
BOOT_DRIVE:
	db 0

; padding and magic number
times 510 - ($-$$) db 0
dw 0xaa55

; padding to test read
times 256 dw 0xdcdc
times 256 dw 0xface
