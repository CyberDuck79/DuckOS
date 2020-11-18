[org 0x7c00] ; offset the starting address when direct addressing

mov ah, 0x0e ; tty mode
mov bx, hello_world
mov al, [bx]
print1:
	int 0x10
	add bx, 1
	mov al, [bx]
	test al, al
	jnz print1
mov al, [return]
int 0x10
mov bx, boot_msg
mov al, [bx]
print2:
	int 0x10
	add bx, 1
	mov al, [bx]
	test al, al
	jnz print2
mov al, [return]
int 0x10

jmp $ ; jump to current address = infinite loop

hello_world:
	db `hello world\n\0`
boot_msg:
	db `Booting DuckOS\n\0`
return:
	db `\r`

; padding and magic number
times 510 - ($-$$) db 0
dw 0xaa55
