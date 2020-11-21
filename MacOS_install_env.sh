Green="\e[32m"
Red="\e[31m"
Yellow="\n\e[33;1m"
Default="\e[0m\n"

printf "${Green}Environment and tools setup${Default}"
printf "${Yellow}Brew packages installation...${Default}"
brew install qemu nasm gmp mpfr libmpc gcc \
&& printf "${Green}Brew packages installation OK${Default}" \
|| { printf "${Red}Brew packages installation failed${Default}" && exit 1; }

printf "${Green}Environment variables export${Default}"
echo "export CC=/usr/local/bin/gcc-10" >> ~/.zshrc
echo "export LD=/usr/local/bin/gcc-10" >> ~/.zshrc
echo "export PREFIX=\"/usr/local/i386elfgcc\"" >> ~/.zshrc
echo "export TARGET=i386-elf" >> ~/.zshrc
echo "export PATH=\"\$PREFIX/bin:\$PATH\"" >> ~/.zshrc
source ~/.zshrc

printf "${Green}Binutils installation${Default}"
mkdir /tmp/src
cd /tmp/src
if [ ! -d ./gcc-10.2.0 ]; then
	printf "${Yellow}Binutils download...${Default}"
	curl -O http://ftp.gnu.org/gnu/binutils/binutils-2.35.tar.xz \
	&& printf "${Green}Binutils download OK${Default}" \
	|| { printf "${Red}Binutils download failed${Default}" && exit 1; }
	tar xf binutils-2.35.tar.xz
	mkdir binutils-build
fi
cd binutils-build
printf "${Yellow}Binutils configuration...${Default}"
../binutils-2.35/configure \
	--target=$TARGET \
	--enable-interwork \
	--enable-multilib \
	--disable-nls \
	--disable-werror \
	--prefix=$PREFIX 2>&1 \
&& printf "${Green}Binutils configuration OK${Default}" \
|| { printf "${Red}Binutils configuration failed${Default}" && exit 1; }
printf "${Yellow}Binutils compilation...${Default}"
sudo make all install 2>&1 \
&& printf "${Green}Binutils compilation OK${Default}" \
|| { printf "${Red}Binutils compilation failed${Default}" && exit 1; }

printf "${Green}Cross-gcc installation${Default}"
cd /tmp/src
if [ ! -d ./gcc-10.2.0 ]; then
	printf "${Yellow}Gcc download...${Default}"
	curl -O https://ftp.gnu.org/gnu/gcc/gcc-10.2.0/gcc-10.2.0.tar.gz \
	&& printf "${Green}Gcc download OK${Default}" \
	|| { printf "${Red}Gcc download failed${Default}" && exit 1; }
	tar xf gcc-10.2.0.tar.gz
	mkdir gcc-build
fi
cd gcc-build
# Library version can be different
# check with bew info "package_name"
printf "${Yellow}Gcc configuration...${Default}"
../gcc-10.2.0/configure \
	--target=$TARGET \
	--prefix="$PREFIX" \
	--disable-nls \
	--disable-libssp \
	--enable-languages=c \
	--without-headers \
	--with-gmp=/usr/local/Cellar/gmp/6.2.1 \
	--with-mpfr=/usr/local/Cellar/mpfr/4.1.0 \
	--with-mpc=/usr/local/Cellar/libmpc/1.2.1 2>&1 \
&& printf "${Green}Gcc configuration OK${Default}" \
|| { printf "${Red}Gcc configuration failed${Default}" && exit 1; }
printf "${Yellow}Gcc compilation...${Default}"
make all-gcc 2>&1 \
&& make all-target-libgcc 2>&1 \
&& sudo make install-gcc 2>&1 \
&& sudo make install-target-libgcc 2>&1 \
&& printf "${Green}Gcc compilation OK${Default}" \
|| { printf "${Red}Gcc compilation failed${Default}" && exit 1; }

printf "${green}Setup success${Default}"