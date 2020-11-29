Green="\e[32m"
Red="\e[31m"
Default="\e[0m\n"
nasm -fbin boot_loader.s -o boot_loader.bin \
&& printf "${Green}Bootloader Binary compilation OK${Default}" \
|| { printf "${Red}Bootloader Binary compilation failed${Default}" && exit 1; }
i386-elf-gcc -ffreestanding -c kernel.c -o kernel.o \
&& printf "${Green}Kernel Object compilation OK${Default}" \
|| { printf "${Red}Kernel Object compilation failed${Default}" && exit 1; }
i386-elf-ld -o kernel.bin -Ttext 0x0 --oformat binary kernel.o \
&& printf "${Green}Kernel Binary compilation OK${Default}" \
|| { printf "${Red}Kernel Binary compilation failed${Default}" && exit 1; }
cat boot_loader.bin kernel.bin > os-image.bin \
&& printf "${Green}Bootable image creation OK${Default}" \
|| { printf "${Red}Bootable image creation failed${Default}" && exit 1; }