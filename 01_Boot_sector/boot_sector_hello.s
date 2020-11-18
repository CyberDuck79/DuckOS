[org 0x7c00]	; offset the starting address when direct addressing

mov ah, 0x0e	; tty BIOS routine

mov bp, 0x8000	; set stack base pointer a little above where BIOS
mov sp, bp		; loads this bootloader, so it won't overwrite it

mov al, `\n`
int 0x10
mov bx, boot_msg
mov al, [bx]
call print_line
mov bx, quak_quak
mov al, [bx]
call print_line

jmp $			; jump to current address = infinite loop

%include "print_line.s"

boot_msg:
	db 'Booting DuckOS',0
quak_quak:
	db 'Quak quak...',0

; padding and magic number
times 510 - ($-$$) db 0
dw 0xaa55
