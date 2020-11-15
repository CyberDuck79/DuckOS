nasm -f elf32 loader.s                          # Compile loader
ld -T link.ld -melf_i386 loader.o -o kernel.elf # Link to executable kernel
mkdir -p iso/boot/grub                          # create the folder structure
cp stage2_eltorito iso/boot/grub/               # copy the bootloader
cp kernel.elf iso/boot/                         # copy the kernel
cp menu.lst iso/boot/grub/                      # copy the bootloader menu entry
# Generate Iso image
genisoimage -R                              \
            -b boot/grub/stage2_eltorito    \
            -no-emul-boot                   \
            -boot-load-size 4               \
            -A os                           \
            -input-charset utf8             \
            -quiet                          \
            -boot-info-table                \
            -o os.iso                       \
            iso