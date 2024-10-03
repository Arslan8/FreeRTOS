Make checkedC from their repo. 
https://github.com/checkedc/checkedc

You do need to install lld and perl:
sudo apt-get install lld perl

You also need GCC because clang sucks:
https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads

source ./setup.sh
make bc
make build/startup.o
make exec
gdb-multiarch ./build/RTOSDemo.axf 
