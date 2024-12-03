# Building an EXE for WindowsCE (ARM7)
This repository serves as a knowledge base on how to cross-compile
for WindowsCE (ARM7) using Clang, by showing how to build a simple EXE.

# Requirements
 * Clang 14
 * Visual Studio 9.0 with MFC installed
 * Host with common Unix utilities such as dd and bash

# Building
Set the VC_DIR environment variable to the VC dir of your Visual Studio 9.0
installation like this:

```bash
export VC_DIR="/media/user/c_drive/Program Files (x86)/Microsoft Visual Studio 9.0/VC"
```

Optionally, also set the SDK_DIR, only required if you want to link against libraries:
```bash
export SDK_DIR="/media/user/c_drive/Program Files (x86)/Windows CE Tools/SDKs/Toradex_CE700"
```

Now execute ./build.sh
```bash
./build.sh
```

This compiles and links the main.cpp file using the MFC imports (for demonstration)
Currently, it exports wWinMainCRTStartup, which circumvents intialization of
the C runtime.

In order to build using the C runtime startup code, linking towards corelibc
from the Windows CE SDK would be required, however as LLVM has no support for
the machine type nor the relocation type (0x8 and 0x3) within that archive,
it would be required to build corelibc from source.

An appropriate surrogate might be to use libcrt (and libmingw32) from the MinGW project.

In order to build for non-Unicode setups, remove the defines and the linker option
for setting the entry point.

# How does this work?
This works by patching the resulting EXE to the appropriate machine type,
as long as relocations are avoided (or only relocations that exist within that
machine type are used), resulting code should work fine to my knowledge.
As long as the used libraries are only "import libraries", the linker will generate
code and the symbols will be resolved at load time on the device.

Furthermore, the string in the main file "wazzup" needs to be put as the last
variable into the last compilation unit, to make the linker generate a PE file,
where IMAGE_IMPORT_DESCRIPTOR lands on multiples of 8.

# What is this good for?
Hard to tell. As MinGW headers will probably have to be used, it might be
of use to get newer compiler capabilities, while working on smaller projects,
or projects that need better optimization, than what the old Microsoft Compiler
offers.

# Feedback
Feel free to open issues when questions remain or create pull requests,
for improvements.

# Improvements
Following questions remain:
 * Could it be feasible to embed an ELF loader to handle relocations
   and just generate a custom PE header from that? (see U-Boot)
 * Is there a way to patch IMAGE_IMPORT_DESCRIPTOR otherwise?
   It should be possible to write a tool, to move it

Both could be achieved by generating the PE file, extracting the information,
create a custom linker script with the extracted information, then reassemble.
Other option would be to look into LLVM and "just" add support there.
