[org 0x7c00]	; offset the starting address when direct addressing

mov ah, 0x0e	; tty BIOS routine

mov bp, 0x8000	; set stack base pointer a little above where BIOS
mov sp, bp		; loads this bootloader, so it won't overwrite it

mov bx, hello_world
mov al, [bx]
call print
mov bx, boot_msg
mov al, [bx]
call print

jmp $			; jump to current address = infinite loop

print:
	int 0x10
	add bx, 1
	mov al, [bx]
	test al, al
	jnz print
	mov al, [return]
	int 0x10
	ret

hello_world:
	db `hello world\n\0`
boot_msg:
	db `Booting DuckOS\n\0`
return:
	db `\r`

; padding and magic number
times 510 - ($-$$) db 0
dw 0xaa55
