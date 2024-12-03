#!/bin/bash

set -x

name=main
file=$name.exe

# Currently the include directories aren't used,
# Because the old MFCs don't compile well with clang
# However the example should still help for cross-compiling MingW EXE or DLLs

if [ -z "${VC_DIR}" ]; then
	echo "VC_DIR environment variable isn't set!"
	echo "Please point to the path in Windows installation"
	echo "e.g. /media/user/c_drive/Program Files (x86)/Microsoft Visual Studio 9.0/VC"
	exit 1
fi

if [ -z "${SDK_DIR}" ]; then
	echo "SDK_DIR environment variable isn't set!"
	echo "Set the environment variable for the SDK dir in case it should be used"
	echo "e.g. /media/user/c_drive/Program Files (x86)/Windows CE Tools/SDKs/Toradex_CE700"
fi

clang-14 -DUNICODE -D_UNICODE -Wl,/entry:wWinMainCRTStartup -fuse-ld=lld --target=armv7-windows $name.cpp -L "$VC_DIR/ce/lib/armv4" -L "$VC_DIR/lib" -Wl,/SUBSYSTEM:WINDOWS -L"$SDK_DIR/Lib/ARMv4I" -L"$VC_DIR/ce/atlmfc/lib/armv4/" -lMFC90Ud -lcoredll -o $file

# Replace the machine type to allow the WinCE loader to load the EXE
out=$name.mod.exe
offset=0x7c

cp $file $out
# Interpreter needs to be bash so that printf will work as intended
printf '\xc2' | dd of="$out" conv=notrunc bs=1 seek=$(($offset))
