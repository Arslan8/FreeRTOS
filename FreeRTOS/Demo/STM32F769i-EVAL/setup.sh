git clone https://github.com/ARM-software/CMSIS_5.git
cd CMSIS_5/Device
git clone https://github.com/STMicroelectronics/cmsis_device_f7
cd -
perl -pe 'BEGIN{undef $/;} s|/\*.*?\*/||gs; s|//.*||g' CMSIS_5//Device/cmsis_device_f7/Source/Templates/gcc/startup_stm32f769xx.s > startup.s
