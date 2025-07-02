#!/usr/bin/env nix-shell
#! nix-shell -i bash --pure
#! nix-shell -p bash python310 flex bison perl538 gnused util-linux
#! nix-shell -p cmake git dosfstools qemu
#! nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/25.05.tar.gz

set -x

export GIT_SSL_CAINFO=/etc/ssl/certs/ca-certificates.crt
export NIX_HARDENING_ENABLE=""
export RTEMS_ROOT=$(pwd)/RTEMS/6

# NIX sets these variables and RTEMS builder picks them up incorrectly
# instead of those provided by the RTEMS cross-compiler
unset AR AS CC CXX LD

git submodule update --init --checkout --recursive

cd rsb/rtems
../source-builder/sb-set-builder --prefix=${RTEMS_ROOT} 6/rtems-i386
../source-builder/sb-set-builder --prefix=${RTEMS_ROOT} 6/rtems-arm
../source-builder/sb-set-builder \
	--prefix=${RTEMS_ROOT} --target=i386-rtems6 \
	--with-rtems-bsp=i386/pc386 --with-rtems-tests=yes 6/rtems-kernel
../source-builder/sb-set-builder \
	--prefix=${RTEMS_ROOT} --target=arm-rtems6 \
	--with-rtems-bsp=arm/beagleboneblack --with-rtems-tests=yes 6/rtems-kernel

cd ../../rtems-net-legacy
./waf configure --prefix=${RTEMS_ROOT} --rtems-bsps i386/pc386
./waf
./waf install

cd ../rtems-libbsd
./waf configure --prefix=${RTEMS_ROOT} --rtems-tools=${RTEMS_ROOT} \
    --rtems-bsps=arm/beagleboneblack --buildset=buildset/default.ini
./waf
./waf install

cd ../cFS
rm -f Makefile funky_defs
ln -s ../Makefile Makefile
ln -s ../funky_defs funky_defs
patch -b -p0 < ../osal001.patch
rm -rf build
make SIMULATION= prep
make -j20 install
exit 0
cd ..
rm -rf hda.img
dd if=/dev/zero of=./hda.img bs=1M count=64
fdisk hda.img < fdisk.script
mkfs.vfat --offset=2048 hda.img

qemu-system-i386 -m 128 -hda hda.img -netdev user,id=net0 \
	-device i82559er,netdev=net0 -no-reboot -nographic \
	-append "--video=off --console=/dev/com1 --batch-mode" \
	-kernel ./cFS/build/exe/cpu2/core-cpu2.exe
