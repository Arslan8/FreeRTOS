CC                     =    clang-12
BIN                   :=    RTOSDemo.axf

BUILD_DIR             :=    build

DEBUG += 1

#Clang stuff
GCC_INSTALL ?= /opt/gcc-arm-none-eabi-10-2020-q4-major/
GCC_INSTALL_INCLUDE = $(GCC_INSTALL)arm-none-eabi/include/
GCC_INSTALL_LIB ?= $(GCC_INSTALL)arm-none-eabi/lib/thumb/v7-m/nofp/
LIBGCC_PATH ?= $(GCC_INSTALL)lib/gcc/arm-none-eabi/10.2.1/thumb/v7-m/nofp/

FREERTOS_DIR_REL      :=    ../../../FreeRTOS
FREERTOS_DIR          :=    $(abspath $(FREERTOS_DIR_REL))
KERNEL_DIR            :=    $(FREERTOS_DIR)/Source

# Startup sources
SOURCE_FILES          +=    init/startup.c  syscall.c main.c rtmk.c autogen/autogen_data.c

# platform portable source file
SOURCE_FILES          +=    $(KERNEL_DIR)/portable/clang/ARM_CM3_MPU/port.c
SOURCE_FILES          +=    $(KERNEL_DIR)/portable/clang/ARM_CM3_MPU/mpu_wrappers_v2_asm.c

# Kernel source files
SOURCE_FILES          +=    $(KERNEL_DIR)/portable/Common/mpu_wrappers.c
SOURCE_FILES          +=    $(KERNEL_DIR)/portable/Common/mpu_wrappers_v2.c
SOURCE_FILES          +=    $(KERNEL_DIR)/tasks.c
SOURCE_FILES          +=    $(KERNEL_DIR)/list.c
SOURCE_FILES          +=    $(KERNEL_DIR)/queue.c
SOURCE_FILES          +=    $(KERNEL_DIR)/timers.c
SOURCE_FILES          +=    $(KERNEL_DIR)/event_groups.c
SOURCE_FILES          +=    ${KERNEL_DIR}/portable/MemMang/heap_4.c
SOURCE_FILES          +=    $(KERNEL_DIR)/stream_buffer.c

# application source files
SOURCE_FILES          +=    app_main.c
SOURCE_FILES          +=    mpu_demo.c

INCLUDE_DIRS          +=    -I$(FREERTOS_DIR)/Demo/CORTEX_MPU_M3_MPS2_QEMU_CLANG
INCLUDE_DIRS          +=    -I$(FREERTOS_DIR)/Demo/CORTEX_MPU_M3_MPS2_QEMU_CLANG/CMSIS
INCLUDE_DIRS          +=    -I$(KERNEL_DIR)/include
INCLUDE_DIRS          +=    -I$(KERNEL_DIR)/portable/clang/ARM_CM3_MPU
INCLUDE_DIRS		  +=    -I $(GCC_INSTALL_INCLUDE)

DEFINES               :=    -DQEMU_SOC_MPS2
DEFINES               :=    -DHEAP4

CPPFLAGS              +=    $(DEFINES)

CFLAGS                +=    -mcpu=cortex-m3
CFLAGS                +=    -Wno-error=implicit-function-declaration
CFLAGS                +=    -Werror
CFLAGS                +=    -Wall
CFLAGS                +=    -Wextra
CFLAGS                +=    -fstrict-aliasing
CFLAGS                +=    -Wstrict-aliasing
CFLAGS                +=    -Wno-error=address-of-packed-member
CFLAGS                +=    -Wno-unused-parameter
CFLAGS                +=    $(INCLUDE_DIRS)

LDFLAGS               +=    -mthumb

LDFLAGS               +=    -Xlinker -Map=${BUILD_DIR}/output.map
LDFLAGS               +=    -nostartfiles -nostdlib -nolibc -nodefaultlibs 

LDFLAGS += -L$(GCC_INSTALL_LIB) -L./ -v

LDFLAGS                +=    -T ./scripts/mps2_m3.ld
CFLAGS += -emit-llvm -mthumb -mcpu=cortex-m3  --target=arm-none-eabi -g

ifeq ($(DEBUG), 1)
    CFLAGS                +=     -g -O0 -save-temps=obj
else
    CFLAGS                +=     -O3
endif

OBJ_FILES             :=    $(SOURCE_FILES:%.c=$(BUILD_DIR)/%.o)

.PHONY: clean

$(BUILD_DIR)/$(BIN) : $(OBJ_FILES)
	$(CC) -ffunction-sections -fdata-sections $(CFLAGS) $(LDFLAGS) $+ -o $(@)


%.d: %.c
	@set -e; rm -f $@; \
	$(CC) -M $(CPPFLAGS) $< > $@.$$$$; \
	sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
	rm -f $@.$$$$

INCLUDES              :=     $(SOURCE_FILES:%.c=$(BUILD_DIR)/%.d)
-include $(INCLUDES)

${BUILD_DIR}/%.o : %.c Makefile
	-mkdir -p $(@D)
	$(warning CFLAGS are $(CFLAGS))
	$(CC) $(CFLAGS) $(CPPFLAGS) -MMD -c $< -o $@

clean:
	-rm -rf build

bc: $(OBJ_FILES)
	$(warning Files are $(OBJ_FILES))
	llvm-link-12  -v $+ -o $(BUILD_DIR)/$(BIN).bc
	llvm-dis-12 $(BUILD_DIR)/$(BIN).bc

$(BUILD_DIR)/reset.o : reset.s
	$(CC) --target=arm-none-eabi -mthumb -c $(CFLAGS)  $+ -o $(@)

exec:
	llc-12 -filetype=obj build/RTOSDemo.axf.bc
	$(CC) -fuse-ld=/usr/bin/ld.lld-12 --target=arm-none-eabi -mthumb -mcpu=cortex-m3 $(LDFLAGS) -lc -L$(LIBGCC_PATH) -lgcc  -mfloat-abi=soft -Xlinker -Map=build/rtmk.map build/RTOSDemo.axf.bc -o ./build/RTOSDemo.axf
	size -A -d ./build/RTOSDemo.axf  | tee ./build/sizeinfo

rund:
	qemu-system-arm -d int,guest_errors -D qemu.log -machine mps2-an385 -monitor null -semihosting         --semihosting-config enable=on,target=native         -kernel ./build/RTOSDemo.axf         -serial stdio -nographic -gdb tcp::1235 -S
	stty sane
