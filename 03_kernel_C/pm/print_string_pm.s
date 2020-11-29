[bits 32]
; Define constants
VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f

; Print a null-terminated string pointed by EBX
print_string_pm:
	pusha
	mov edx, VIDEO_MEMORY	; Set EDX to the start of the video mem.

print_string_pm_loop:
	mov al, [ebx]			; Store the char at EBX in AL
	mov ah, WHITE_ON_BLACK	; Store the attibute in AH

	test al, al				; if end of the string
	jz print_string_pm_done

	mov [edx], ax			; Store char and attribute in video mem.
	add ebx, 1				; Next char in the string
	add edx, 2				; Next char in video mem.

	jmp print_string_pm_loop

print_string_pm_done:
	popa
	ret