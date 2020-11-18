print_line:
int 0x10
add bx, 1
mov al, [bx]
test al, al
jnz print_line
mov al, `\n`
int 0x10
mov al, `\r`
int 0x10
ret