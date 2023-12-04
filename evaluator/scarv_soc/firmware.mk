GCC_PATH =  /opt/riscv-xcrypto/bin


CC              = $(GCC_PATH)/riscv32-unknown-elf-gcc
AS              = $(GCC_PATH)/riscv32-unknown-elf-as
AR              = $(GCC_PATH)/riscv32-unknown-elf-ar
OBJDUMP         = $(GCC_PATH)/riscv32-unknown-elf-objdump
OBJCOPY         = $(GCC_PATH)/riscv32-unknown-elf-objcopy

OBJCOPY_HEX_ARGS= --gap-fill 0 


SOC_WORK = obj_dir

SW_EXAMPLES_LINK    = $(SOC_HOME)/src/examples/share/link.ld
SW_EXAMPLES_DIR     = $(SOC_WORK)

BSP_BUILD   = $(SOC_WORK)/bsp
BSP_INCLUDE = $(BSP_BUILD)/include

ARCH_BASE   = rv32imacb
ARCH        = $(ARCH_BASE)_xcrypto
ABI         = ilp32

SW_EXAMPLES_CFLAGS  = -march=$(ARCH) -mabi=$(ABI) -Wall -O2 -nostartfiles \
                      -I$(BSP_INCLUDE) \
                      -T$(SW_EXAMPLES_LINK)


map_sw_dir = $(SW_EXAMPLES_DIR)/$1
map_sw_elf = $(call map_sw_dir,$1)/$1.elf
map_sw_dis = $(call map_sw_dir,$1)/$1.dis
map_sw_hex = $(call map_sw_dir,$1)/ram.hex
map_sw_bin = $(call map_sw_dir,$1)/$1.bin

#
# Add a new example program to the build system
# 
# Arguments:
# 1 - Friendly experiment name
# 2 - Source files
#
define add_sw_target

$(call map_sw_elf,${1}) : ${2} $(BSP_LIB)
	@mkdir -p $(dir $(call map_sw_elf,${1}))
	$(CC) -c $(SW_EXAMPLES_CFLAGS) -o $${@} $${^}

$(call map_sw_dis,${1}) : $(call map_sw_elf,${1})
	@mkdir -p $(dir $(call map_sw_dis,${1}))
	$(OBJDUMP) -z -D $${<} > $${@}

$(call map_sw_hex,${1}) : $(call map_sw_elf,${1})
	@mkdir -p $(dir $(call map_sw_hex,${1}))
	$(OBJCOPY) --change-addresses=0xE0000000 $(OBJCOPY_HEX_ARGS) -O verilog $${<} $${@}

$(call map_sw_bin,${1}) : $(call map_sw_elf,${1})
	@mkdir -p $(dir $(call map_sw_hex,${1}))
	$(OBJCOPY) -O binary $${<} $${@}

compile : $(call map_sw_elf,${1}) \
               $(call map_sw_dis,${1}) \
               $(call map_sw_hex,${1}) \
               $(call map_sw_bin,${1}) \
               $(VL_OUT)                       \
               $(FSBL_HEX)  
	mv  $(call map_sw_dir,${1})/ram.hex   $(SOC_WORK)/ram.hex              
	#cp $(FSBL_HEX)  $(call map_sw_dir,${1})/rom.hex
	@echo "\033[0;32mFirmware generated \033[0m"

endef

FW=$(SOC_WORK)/firmware.S
firmcat: $(FIRMWARE)/boot.S $(FIRMWARE)/main.S $(APP_SRC)
	cat $^ > $(FW) 

# include $(SOC_HOME)/src/examples/uart/Makefile.in

$(eval $(call add_sw_target,$(APP_NAME), $(FW)))

# run-example-% : example-%
# 	cd $(SOC_WORK); ./Vscarv_soc +TIMEOUT=1000 +WAVES=sim.vcd

# .PHONY: clean

# clean:
# 	rm -rf $(SW_EXAMPLES_DIR)