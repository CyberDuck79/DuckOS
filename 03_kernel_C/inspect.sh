Green="\e[32m"
Default="\e[0m\n"
printf "${Green}Object dump${Default}"
i386-elf-objdump -d basic.o
printf "${Green}Object hexa - lot of debugging information and labels.${Default}"
xxd basic.o
printf "${Green}Binary hexa - only machine code.${Default}"
xxd basic.bin