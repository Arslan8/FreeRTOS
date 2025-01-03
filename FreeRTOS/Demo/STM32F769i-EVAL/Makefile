CC=clang
BIN := RTOSDemo.axf
CMSIS_PATH ?= ./CMSIS_5/
PIECES ?= /data/Pieces/
#Possible values KLEE, ETSAN, EC, CRTC, ECRTC
PROJECT ?= CRTC
#Possible values Flash, StreamBuffer, RECM, QSET, CR, INT
#Possible Baremetal demos include LwIP, Animation, SD, lcd
DEMO := lcd
BUILD_DIR := build

GCC_INSTALL ?= /data/arm-gnu-toolchain-13.3.rel1-x86_64-arm-none-eabi/
GCC_INSTALL_INCLUDE = $(GCC_INSTALL)arm-none-eabi/include/
CHECKED_C_INSTALL_INCLUDE ?=/data/checkedc/include
GCC_INSTALL_LIB ?= $(GCC_INSTALL)arm-none-eabi/lib/thumb/v7-m/nofp/
BSP_INSTALL ?= ./stm32f769i-eval-bsp/
BSP_COMMON_INSTALL ?= ./stm32-bsp-common/
HAL_INSTALL ?= ./stm32f7xx_hal_driver/
LCD_INSTALL ?= ./LCD_DSI_ImagesSlider/



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
CFLAGS = ${CFLAGS_${PROJECT}_${DEMO}} -O0 -nostdlib -DSTM32F769xx -DUSE_IOEXPANDER 
#LDFLAGS = ${LDFLAGS_${PROJECT}_${DEMO}} //Pretty much every configuration uses the same ld flags, can extend in future.
LDFLAGS = -v -T ./scripts/stm32_flash.ld  -specs=nano.specs --specs=rdimon.specs #-lc -lrdimon
LDFLAGS += -Xlinker -Map=${BUILD_DIR}/output.map

LDFLAGS += -L$(GCC_INSTALL_LIB) -L./ -v
#LDFLAGS +=  -L./ -v
SOURCE_FILES = ${SOURCE_FILES_${PROJECT}_${DEMO}}
INCLUDE_DIRS = ${INCLUDE_DIRS_${PROJECT}_${DEMO}} -I $(PIECES)/partitioner/monitor/include/ -I $(GCC_INSTALL_INCLUDE) -I $(CHECKED_C_INSTALL_INCLUDE)
#Device Path
INCLUDE_DIRS += -I$(CMSIS_PATH)/Device/cmsis_device_f7/Include/
INCLUDE_DIRS += -I$(CMSIS_PATH)/CMSIS/Core/Include/
INCLUDE_DIRS += -I$(BSP_INSTALL)/
INCLUDE_DIRS += -I$(HAL_INSTALL)/Inc/

SOURCE_FILES += $(CMSIS_PATH)Device/cmsis_device_f7/Source/Templates/system_stm32f7xx.c 

#Drivers for stm32
SOURCE_FILES += $(BSP_INSTALL)/stm32f769i_eval.c
SOURCE_FILES += $(HAL_INSTALL)/Src/stm32f7xx_hal_gpio.c
SOURCE_FILES += $(HAL_INSTALL)/Src/stm32f7xx_hal_cortex.c
SOURCE_FILES += $(HAL_INSTALL)/Src/stm32f7xx_hal_uart.c
SOURCE_FILES += $(HAL_INSTALL)/Src/stm32f7xx_hal_adc.c
SOURCE_FILES += $(HAL_INSTALL)/Src/stm32f7xx_hal.c
SOURCE_FILES += $(HAL_INSTALL)/Src/stm32f7xx_hal_dma.c
SOURCE_FILES += $(HAL_INSTALL)/Src/stm32f7xx_hal_rcc.c
SOURCE_FILES += $(HAL_INSTALL)/Src/stm32f7xx_hal_i2c.c
SOURCE_FILES += $(HAL_INSTALL)/Src/stm32f7xx_hal_adc_ex.c
SOURCE_FILES += $(HAL_INSTALL)/Src/stm32f7xx_hal_pwr_ex.c
SOURCE_FILES += $(HAL_INSTALL)/Src/stm32f7xx_hal_rcc_ex.c
SOURCE_FILES += $(BSP_INSTALL)/stm32f769i_eval_io.c
SOURCE_FILES += Components/mfxstm32l152/mfxstm32l152.c


#This file just del3tes are previous files.
include build_files/lcd.mk

#Prepare variables for build rules
OBJ_FILES := $(SOURCE_FILES:%.c=$(BUILD_DIR)/%.o)
CFLAGS += $(INCLUDE_DIRS)



.PHONY: clean

$(BUILD_DIR)/$(BIN) : $(OBJ_FILES) $(BUILD_DIR)/startup.o
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

$(BUILD_DIR)/startup.o : startup.s
	$(CC) -c -ffunction-sections -fdata-sections $(CFLAGS)  $+ -o $(@)

clean:
	-rm -rf build

bc: $(OBJ_FILES) 
	$(warning Files are $(OBJ_FILES))
	llvm-link  -v $+ -o $(BUILD_DIR)/$(BIN).bc
	llvm-dis $(BUILD_DIR)/$(BIN).bc
#	~/projects/Pieces/partitioner/run.py /home/arslan/projects/LBC/FreeRTOS/FreeRTOS/Demo/CORTEX_M4F_STM32F407ZG-SK/pRules.json

exec: build/RTOSDemo.axf.bc #$(CC) -c -ffunction-sections -fdata-sections $(CFLAGS)  $+ -o $(@)
	llc -filetype=obj build/RTOSDemo.axf.bc
	$(CC)  --target=arm-none-eabi -mthumb -mcpu=cortex-m4 $(LDFLAGS)  -Xlinker -Map=./rtmk.map build/RTOSDemo.axf.bc $(BUILD_DIR)/startup.o -o ./build/RTOSDemo.axf
	size -A -d ./build/RTOSDemo.axf  | tee ./sizeinfo

run:
	./build_files/qemu-system-arm -M stm32-p103 -semihosting -nographic -kernel $(BUILD_DIR)/RTOSDemo.axf -s -S 

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
