; Print string loaded at BX address
print_string:
	mov ah, 0x0e			; tty BIOS routine
print_loop:
	mov al, [bx]
	test al, al
	jz print_end
	int 0x10
	add bx, 1
	jmp print_loop
print_end:
	mov al, `\n`
	int 0x10
	mov al, `\r`
	int 0x10
	ret