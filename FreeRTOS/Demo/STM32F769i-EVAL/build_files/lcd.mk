ifeq ($(DEMO), lcd)
FREERTOS_DIR_REL := ../../../FreeRTOS
FREERTOS_DIR := $(abspath $(FREERTOS_DIR_REL))
FRTOS=../../Source/
KERNEL = $(abspath $(FRTOS))
KERNEL_DIR = $(KERNEL)
INCLUDE_KERNEL=$(KERNEL)/include/
INCLUDE_PORT=$(KERNEL)/portable/GCC/ARM_CM7/r0p1
INCLUDE_COMMON=../Common/include/


FREERTOS_EXE_CFLAGS=-flto=thin --target=arm-none-eabi -mthumb -mcpu=cortex-m7 -mfloat-abi=hard -mfpu=fpv4-sp-d16 -g -DFREERTOSCONFIG#Currently only STM32


#Its OK to use the DEMO switch here , cuz later things will override
#${CFLAGS_${PROJECT}_${DEMO}}
CFLAGS_EC_${DEMO} = $(FREERTOS_EXE_CFLAGS)

#EC_RELATED_FLAGS
CFLAGS_CRTC_${DEMO} = $(FREERTOS_EXE_CFLAGS) -DCRTC

#KLEE Flags
CFLAGS_KLEE_${DEMO} = $(FREERTOS_KLEE_CFLAGS)

#TODO Fix it
SOURCE_FILES = $(LCD_INSTALL)/Src/main.c
SOURCE_FILES += $(CMSIS_PATH)Device/cmsis_device_f7/Source/Templates/system_stm32f7xx.c

#Drivers for stm32
SOURCE_FILES += $(BSP_INSTALL)/stm32f769i_eval.c
SOURCE_FILES += ./LCD_DSI_ImagesSlider/Src/stm32f7xx_it.c
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


#Files for LCD
INCLUDE_DIRS += -I$(LCD_INSTALL)/Inc/ -I./Components/Common/
SOURCE_FILES += $(HAL_INSTALL)/Src/stm32f7xx_hal_dsi.c
SOURCE_FILES += $(HAL_INSTALL)/Src/stm32f7xx_hal_sdram.c
SOURCE_FILES += $(BSP_INSTALL)/stm32f769i_eval_lcd.c
SOURCE_FILES += $(BSP_INSTALL)/stm32f769i_eval_ts.c
SOURCE_FILES += $(HAL_INSTALL)/Src/stm32f7xx_hal_ltdc.c
SOURCE_FILES += $(BSP_INSTALL)/stm32f769i_eval_sdram.c
SOURCE_FILES += $(BSP_INSTALL)/stm32f769i_eval_qspi.c
SOURCE_FILES += $(BSP_INSTALL)/stm32f769i_eval_io.c
SOURCE_FILES += $(HAL_INSTALL)/Src/stm32f7xx_hal_dma2d.c
SOURCE_FILES += $(HAL_INSTALL)/Src/stm32f7xx_ll_fmc.c
SOURCE_FILES += $(HAL_INSTALL)/Src/stm32f7xx_hal_qspi.c
SOURCE_FILES += ./Components/ft6x06/ft6x06.c
SOURCE_FILES += ./Components/otm8009a/otm8009a.c
SOURCE_FILES += ./Components/mfxstm32l152/mfxstm32l152.c

endif

