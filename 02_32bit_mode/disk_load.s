; load DH sectors to ES:BX from drive DL
disk_load:
	push dx				; store how many sectors were requested on the stack

	mov ah, 0x02		; BIOS read sectors routine
	mov al, dh			; Read DH sector
	mov ch, 0x00		; Select cylinder 0
	mov dh, 0x00		; Select head 0
	mov cl, 0x02		; Start reading from second sector (after the boot sector)

	int 0x13			; BIOS Interrupt

	jc disk_error		; jump if error

	pop dx				; restore DX from the stack
	cmp dh, al			; check the number of readed sector
	jne disk_error		; jump if error
	ret

disk_error:
	mov bx, DISK_ERROR_MSG
	call print_line
	jmp $

; Variables
DISK_ERROR_MSG:
	db 'Disk read error!',0