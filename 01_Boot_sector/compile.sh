Green="\e[32m"
Red="\e[31m"
Default="\e[0m\n"
nasm -fbin boot_sector_hello.s -o boot_sector_hello.bin \
&& printf "${Green}Binary compilation OK${Default}" \
|| { printf "${Red}Binary compilation failed${Default}" && exit 1; }