CC=clang
BIN := RTOSDemo.axf
#Possible values KLEE, ETSAN, EC, CRT-C, ECRT-C
PROJECT ?= EC
#Possible values Flash, StreamBuffer, RECM, QSET, CR, INT
#Possible Baremetal demos include LwIP, Animation, SD
DEMO := Flash
BUILD_DIR := build


#Include project level configurations
include build_files/ec.mk
include build_files/crtc.mk
include build_files/etsan.mk


#Include demo level configurations
include build_files/FreeRTOS.mk
include build_files/LwIP.mk
include build_files/Animation.mk
include build_files/SD.mk



#Finalize configuration variables based on project/demo
CFLAGS = ${CFLAGS_${PROJECT}_${DEMO}} 
#LDFLAGS = ${LDFLAGS_${PROJECT}_${DEMO}} //Pretty much every configuration uses the same ld flags, can extend in future.
LDFLAGS = -v -T ./scripts/stm32_flash.ld  -specs=nano.specs --specs=rdimon.specs #-lc -lrdimon
LDFLAGS += -Xlinker -Map=${BUILD_DIR}/output.map
LDFLAGS += -L/usr/lib/gcc/arm-none-eabi/9.2.1/../../../arm-none-eabi/lib/thumb/v7-m/nofp -L/usr/lib/gcc/arm-none-eabi/9.2.1 -L/usr/lib/gcc/arm-none-eabi/9.2.1/../../../arm-none-eabi/lib -L./ -v
SOURCE_FILES = ${SOURCE_FILES_${PROJECT}_${DEMO}}
INCLUDE_DIRS = ${INCLUDE_DIRS_${PROJECT}_${DEMO}}



#Prepare variables for build rules
OBJ_FILES := $(SOURCE_FILES:%.c=$(BUILD_DIR)/%.o)
CFLAGS += $(INCLUDE_DIRS)



.PHONY: clean

$(BUILD_DIR)/$(BIN) : $(OBJ_FILES) $(BUILD_DIR)/reg.o
	$(CC) -ffunction-sections -fdata-sections $(CFLAGS) $(LDFLAGS) $+ -o $(@)

%.d: %.c
	@set -e; rm -f $@; \
    $(CC) -M $(CPPFLAGS) $< > $@.$$$$; \
    sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
    rm -f $@.$$$$

INCLUDES := $(SOURCE_FILES:%.c=$(BUILD_DIR)/%.d)
-include $(INCLUDES)

${BUILD_DIR}/%.o : %.c Makefile
	-mkdir -p $(@D)
	$(CC) $(CFLAGS) $(CPPFLAGS) -MMD -c $< -o $@
	echo $(CFLAGS) > .cflags

$(BUILD_DIR)/reg.o : reg.S
	$(CC) -c -ffunction-sections -fdata-sections $(CFLAGS)  $+ -o $(@)

clean:
	-rm -rf build

bc: $(OBJ_FILES)  
	llvm-link  -v $+ -o $(BUILD_DIR)/$(BIN).bc
	llvm-dis $(BUILD_DIR)/$(BIN).bc
#	~/projects/Pieces/partitioner/run.py /home/arslan/projects/LBC/FreeRTOS/FreeRTOS/Demo/CORTEX_M4F_STM32F407ZG-SK/pRules.json

exec: build/RTOSDemo.axf.bc #$(CC) -c -ffunction-sections -fdata-sections $(CFLAGS)  $+ -o $(@)
	llc -filetype=obj build/RTOSDemo.axf.bc
	$(CC)  --target=arm-none-eabi -mthumb -mcpu=cortex-m4 $(LDFLAGS)  -Xlinker -Map=./rtmk.map build/RTOSDemo.axf.bc $(BUILD_DIR)/reg.o -o ./build/RTOSDemo.axf
	size -A -d ./build/RTOSDemo.axf  | tee ./sizeinfo

run:
	./build_files/qemu-system-arm -M stm32-p103 -semihosting -nographic -kernel ~/projects/LBC/FreeRTOS/FreeRTOS/Demo/CORTEX_M4F_STM32F407ZG-SK/build/RTOSDemo.axf -s -S 

rop:
	python3 ./genROPCount.py -b ./build/RTOSDemo.axf -i ./sizeinfo 

bcet: $(OBJ_FILES)
	llvm-link  -v $+ -o $(BUILD_DIR)/$(BIN).bc
	llvm-dis $(BUILD_DIR)/$(BIN).bc
	sed -i 's/optnone//g' $(BUILD_DIR)/$(BIN).ll
	opt -mem2reg -ipsccp -debug-pass=Arguments ./build/RTOSDemo.axf.ll -o $(BUILD_DIR)/$(BIN).bc
	llvm-dis $(BUILD_DIR)/$(BIN).bc

bc3: $(OBJ_FILES)
	llvm-link  -v $+ -o $(BUILD_DIR)/$(BIN).bc
	llvm-dis $(BUILD_DIR)/$(BIN).bc
	sed -i 's/optnone//g' $(BUILD_DIR)/$(BIN).ll
	opt -O3 ./build/RTOSDemo.axf.ll -o $(BUILD_DIR)/$(BIN).bc
	llvm-dis $(BUILD_DIR)/$(BIN).bc

itm:
	./extern/itm-tools/target/debug/itm-decode ~/etsan/itm.fifo
