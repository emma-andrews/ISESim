#Update the module name for the DuT
MODULE=xc_aesmix


VMODULE=V$(MODULE)
DUTPATH=../../eut/xcrypto/rtl/$(MODULE)/$(MODULE).v
POWER_LIBS=../power_libs

SOC=scarv_soc
SOC_DIR=../$(SOC)

APP_NAME=aes
FIRMWARE=$(SOC_DIR)/firmware
APP_SRC=$(FIRMWARE)/aesmix.S
SOC_WORK = obj_dir


include $(POWER_LIBS)/tvla-soc.mk
include $(SOC_DIR)/firmware.mk
include $(SOC_DIR)/soc.mk


