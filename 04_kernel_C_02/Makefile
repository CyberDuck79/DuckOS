C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)

NAME = os-image.bin
OBJ = ${C_SOURCES:.c=.o}

all: $(NAME)

run: $(NAME)
	qemu-system-i386 -drive format=raw,file=$<,index=0,if=floppy

os-image.bin: boot/boot_loader.bin kernel.bin
	cat $^ > os-image.bin

kernel.bin: kernel/kernel_entry.o ${OBJ}
	i386-elf-ld -o $@ -Ttext 0x1000 $^ --oformat binary

%.o : %.c ${HEADERS}
	i386-elf-gcc -ffreestanding -c $< -o $@

%.o : %.s
	nasm $< -f elf -o $@

%.bin : %.s
	nasm $< -f bin -o $@

clean:
	rm -fr *.bin *.dis *.o
	rm -fr kernel/*.o boot/*.bin drivers/*.o

