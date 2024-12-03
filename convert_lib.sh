#!/bin/bash

# This file is provided, because it might be useful for tinkering with
# archives, that contain actual symbols.
# e.g. When creating an archive with an old version of the Microsoft Compiler
# NOTE: Relocations will most likely file

if [ -z $1 ]; then
	echo "convert_lib needs an argument to which file to convert"
	echo "Usage: ./convert_lib <library file>"
	echo " Replaces the machine type 0x1c2 with 0x1c4 for compatibility with LLVM"
	echo " in all objects of the library"
	exit 1
fi

if [ ! -x "$(command -v llvm-ar)" ]; then
	echo "llvm-ar not in PATH"
	exit 1
fi

if [ ! -f $1.bak ]; then
	echo "Creating backup of library"
	cp $1 $1.bak
fi

llvm-ar x $1

# Change the first byte of all object files to the machine type,
# that clang won't refuse to work with

echo "Patching files and adding them to archive"
for file in *.obj; do
	# Interpreter needs to be bash so that printf will work as intended
	printf '\xc4' | dd of="$file" conv=notrunc bs=1 seek=0
	llvm-ar r $1 $file
done
