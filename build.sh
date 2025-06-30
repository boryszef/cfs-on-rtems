#!/usr/bin/env nix-shell
#! nix-shell -i bash --pure
#! nix-shell -p bash python310 flex bison perl538 gnused util-linux cmake
#! nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/25.05.tar.gz

set +x

export NIX_HARDENING_ENABLE=""
export RTEMS_ROOT=$(pwd)/RTEMS/quick-start/rtems/6
#cd rsb/rtems
#../source-builder/sb-set-builder --prefix=${RTEMS_ROOT} 6/rtems-i386
#../source-builder/sb-set-builder --prefix=${RTEMS_ROOT} --target=i386-rtems6 --with-rtems-bsp=i386/pc386 --with-rtems-tests=yes 6/rtems-kernel
#../source-builder/sb-set-builder --prefix=${RTEMS_ROOT} --with-rtems-bsp=i386/pc386 6/rtems-net-legacy
#cd ../../rtems-net-legasy
#./waf configure --prefix=${RTEMS_ROOT}
#./waf
#./waf install
cd cFS
patch -b -p0 < ../osal001.patch
#rm -rf build
#make SIMULATION= prep
make -j20 install
