#!/bin/bash

###################STEP 1: The compiler ########################################

sudo apt-get install subversion;
sudo apt-get install gcc;
sudo apt-get install g++;

echo Compiler;

pushd $HOME;
mkdir toolchain;
popd ;
cp * $HOME/toolchain;
cd $HOME/toolchain;

svn co http://llvm.org/svn/llvm-project/llvm/trunk llvm-svn;
cd llvm-svn/tools;
svn co http://llvm.org/svn/llvm-project/cfe/trunk clang;

cd ../projects;
svn co http://llvm.org/svn/llvm-project/compiler-rt/trunk compiler-rt;


cd ..;
./configure --prefix=$HOME/toolchain  --enable-optimized;
make;
sudo make install;

###################STEP 2: The assembler and linker ###########################

cd $HOME/toolchain;

echo Assembler and Linker;

wget http://ios-toolchain-based-on-clang-for-linux.googlecode.com/files/cctools-836-ld64-134.9-for-linux-1.0.tar.xz;

tar xvf cctools-836-ld64-134.9-for-linux-1.0.tar.xz;
cd cctools-836;

sudo apt-get install uuid-dev;
sudo apt-get install libssl-dev;

BITS=`uname -m`
if [ "$BITS" = "i686" ]; then
    TYPESH=`locate bits/types.h` &
    sudo chmod 777 $TYPESH &
    cd ${TYPESH%/*} & # répertoire où se trouve types.h
    #wget types.patch & # -> à récupérer
    cp $HOME/toolchain/types.patch . &
    sudo patch -p0 < types.patch
fi

cd $HOME/toolchain/cctools-836;

#wget configure.patch; # -> à récupérer
#patch -p0 < configure.patch;
echo PATH=$PATH:$HOME/toolchain/bin >> $HOME/.bashrc;

cd misc;
#wget libtool.path;  # -> à récupérer
cp $HOME/toolchain/libtool.patch . ;
patch -p0 < libtool.patch;
cd ..;

cd ld64/src/ld/;
#wget snapshot.patch; # -> à récupérer
cp $HOME/toolchain/snapshot.patch . ;
patch -p0 < snapshot.patch;
cd $HOME/toolchain/cctools-836;

#wget helper.patch;
cp $HOME/toolchain/helper.patch . ;
patch -p0 < helper.patch;

./configure --target=arm-apple-darwin11 --prefix=$HOME;

cd ld;
#wget makefile.patch; # -> à récupérer
cp $HOME/toolchain/makefile.patch . ;
patch -p0 < makefile.patch;
cd ..;

sed -i 's_<llvm-c/lto.h>_"'"$HOME/toolchain/llvm-svn/include/llvm-c/lto.h"'"_g' libstuff/lto.h;

sed -i 's_llvm-c/lto.h_'"$HOME/toolchain/llvm-svn/include/llvm-c/lto.h"'_g' ld64/src/ld/parsers/lto_file.cpp;

make;
sudo make install;

################################################################################

#wget dmg2img;
#sudo apt-get install libbz2-dev;
#cd dmg2img;
#make;
#sudo make install;

#cd ..;
#wget xar;
#sudo apt-get install libxml2-dev;
#cd xar-1.5.2;
#./configure && make && sudo make install;
#cd ..;

#wget xcode+ios_sdk.dmg;
#dmg2img -p 5 xcode+ios_sdk.dmg;
#sudo modprobe hfsplus;
#sudo mount -o loop -t hfsplus xcode+ios_sdk.dmg /mnt;
#cd /mnt/Packages; 

###################STEP 3: The iPhoneOS SDK ####################################

echo iPhoneOS SDK;

cd $HOME/toolchain;
wget http://ios-toolchain-based-on-clang-for-linux.googlecode.com/files/iPhoneOS4.2.sdk.tar.xz;
sudo tar xvf iPhoneOS4.2.sdk.tar.xz -C $HOME/toolchain/share;

wget http://ios-toolchain-based-on-clang-for-linux.googlecode.com/files/iPhoneOS5.0.sdk.tar.xz;
sudo tar xvf iPhoneOS5.0.sdk.tar.xz -C $HOME/toolchain/share;

wget http://ios-toolchain-based-on-clang-for-linux.googlecode.com/files/iPhoneOS6.0.sdk.tar.xz;
sudo tar xvf iPhoneOS6.0.sdk.tar.xz -C $HOME/toolchain/share;

###################STEP 4: The utilities #######################################

echo utilities;

wget http://ios-toolchain-based-on-clang-for-linux.googlecode.com/files/iphonesdk-utils-1.8.tar.bz2;
tar xvf iphonesdk-utils-1.8.tar.bz2;

sudo apt-get install pkg-config;
cd iphonesdk-utils-1.8.tar.bz2;

#wget genLoca.patch;
cp $HOME/toolchain/getLoca;patch . ;
patch -p1 < getLoca.patch;

./configure --prefix=$HOME/toolchain;
make;
sudo make install;

################################################################################