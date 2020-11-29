[bits 16]
; Switch to pretected mode
switch_to_pm:
	; We must switch of interrupts until we have
	; set-up the protected mode interrupt vector
	; otherwise interrupts will crash
	cli
	; Load our global descriptor table, which defines
	; the protected mode segments
	lgdt [gdt_descriptor]
	; To make the switch to protected mode we set
	; the first bit CR0, a control register
	mov eax, cr0
	or eax, 0x1
	mov cr0, eax
	; Make a far jump to our 32 bit code.
	; This also force the CPU to flush its cache of
	; pre-fetched and real mode decoded instructions, which
	; can cause problems.
	jmp CODE_SEG:init_pm

[bits 32]
; Initialise registers and the stack once in PM.
init_pm:
	mov ax, DATA_SEG
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	mov ebp, 0x90000
	mov esp , ebp

	call BEGIN_PM
