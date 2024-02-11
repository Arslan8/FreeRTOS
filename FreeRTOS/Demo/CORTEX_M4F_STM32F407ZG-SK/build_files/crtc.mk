CRTC =./
CRTC_DIR =$(abspath $(CRTC))
#Files for CRT-C
CRTC_FILES += $(CRTC_DIR)/FreeRTOS_checked_compat.c
CRTC_CFLAGS = -DCRTC
