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
	$(OBJCOPY)  --change-address=0xF0000000 $(OBJCOPY_HEX_ARGS) -O verilog $${<} $${@}

$(call map_sw_bin,${1}) : $(call map_sw_elf,${1})
	@mkdir -p $(dir $(call map_sw_hex,${1}))
	$(OBJCOPY) -O binary $${<} $${@}

compile : firmcat \
			   $(call map_sw_elf,${1}) \
               $(call map_sw_dis,${1}) \
               $(call map_sw_hex,${1}) \
               $(call map_sw_bin,${1}) \
               $(VL_OUT)                       \
               $(FW_HEX)  
	mv  $(call map_sw_dir,${1})/ram.hex   $(SOC_WORK)/ram.hex              
	touch   $(SOC_WORK)/rom.hex
	@echo "\033[0;32mFirmware generated \033[0m"

endef

FW=$(SOC_WORK)/firmware.S
firmcat: $(SOC_WORK)/data.S $(FIRMWARE)/boot.S $(FIRMWARE)/main.S $(APP_SRC)
	cat $^ > $(FW) 

# include $(SOC_HOME)/src/examples/uart/Makefile.in

$(eval $(call add_sw_target,$(APP_NAME), $(FW)))

# run-example-% : example-%
# 	cd $(SOC_WORK); ./Vscarv_soc +TIMEOUT=1000 +WAVES=sim.vcd

# .PHONY: clean

# clean:
# 	rm -rf $(SW_EXAMPLES_DIR)

# FW_SRC    = $(SOC_HOME)/src/fsbl/boot.S \
#               $(SOC_HOME)/src/fsbl/fsbl.c

# FW_OBJ    = $(SOC_WORK)/fsbl/fsbl.elf
# FW_OBJDUMP= $(SOC_WORK)/fsbl/fsbl.objdump
# FW_HEX    = $(SOC_WORK)/fsbl/fsbl.hex
# FW_GTKWL  = $(SOC_WORK)/fsbl/fsbl.gtkwl

# FW_VIVADO_HEX = $(SOC_WORK)/fsbl/fsbl-vivado.hex

# FW_CFLAGS = -nostartfiles -Os -O2 -Wall -fpic -fPIC \
#               -T$(SOC_HOME)/src/fsbl/link.ld
# FW_CFLAGS += -march=rv32imc -mabi=ilp32

# $(FW_OBJ) : $(FW_SRC)
# 	@mkdir -p $(dir $@)
# 	$(CC) $(FW_CFLAGS) -o $@ $^

# $(FW_OBJDUMP) : $(FW_OBJ)
# 	@mkdir -p $(dir $@)
# 	$(OBJDUMP) -z -D $< > $@

# $(FW_HEX) : $(FW_OBJ)
# 	@mkdir -p $(dir $@)
# 	$(OBJCOPY) $(OBJCOPY_HEX_ARGS) --change-address=0xF0000000 -O verilog $< $@
# $(FW_VIVADO_HEX) : $(FW_OBJ)
# 	@mkdir -p $(dir $@)
# 	$(OBJCOPY) $(OBJCOPY_HEX_ARGS) \
#         --reverse-bytes=4 \
#         --remove-section=.riscv.attributes \
#         --change-address=0xF0000000 \
#         -O verilog $< $@
# 	python $(SOC_HOME)/bin/vl-hex-align.py --scale 4 $@