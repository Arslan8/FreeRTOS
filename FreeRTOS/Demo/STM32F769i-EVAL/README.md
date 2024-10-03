source ./setup.sh
make bc
make build/startup.o
make exec
gdb-multiarch ./build/RTOSDemo.axf 
