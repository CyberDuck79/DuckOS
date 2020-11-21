Green="\e[32m"
Red="\e[31m"
Default="\e[0m\n"
i386-elf-gcc -ffreestanding -c basic.c -o basic.o \
&& printf "${Green}Object compilation OK${Default}" \
|| { printf "${Red}Object compilation failed${Default}" && exit 1; }
i386-elf-ld -o basic.bin -Ttext 0x0 --oformat binary basic.o \
&& printf "${Green}Binary compilation OK${Default}" \
|| { printf "${Red}Binary compilation failed${Default}" && exit 1; }