GCC_PATH =  /opt/riscv-xcrypto/bin


CC              = $(GCC_PATH)/riscv32-unknown-elf-gcc
AS              = $(GCC_PATH)/riscv32-unknown-elf-as
AR              = $(GCC_PATH)/riscv32-unknown-elf-ar
OBJDUMP         = $(GCC_PATH)/riscv32-unknown-elf-objdump
OBJCOPY         = $(GCC_PATH)/riscv32-unknown-elf-objcopy

OBJCOPY_HEX_ARGS= --gap-fill 0 


LINKER    = $(SOC_HOME)/src/examples/share/link.ld
LINKER    = $(SOC_HOME)/src/fsbl/link.ld


# FW_SRC=$(SOC_WORK)/firmware.S
FW_OBJ    = $(SOC_WORK)/fw.elf
FW_OBJDUMP= $(SOC_WORK)/fw.objdump
# FW_HEX    = $(SOC_WORK)/ram.hex
FW_HEX    = $(SOC_WORK)/$(HEXNAME)


FW_CFLAGS = -nostartfiles -Os -O2 -Wall -fpic -fPIC \
              -T$(LINKER)
FW_CFLAGS += -march=rv32imacb_xcrypto -mabi=ilp32

compile: $(FW_HEX)

$(FW_SRC): $(SOC_WORK)/data.S $(FIRMWARE)/boot.S $(FIRMWARE)/main.S $(APP_SRC) 
	cat $^ > $@

$(FW_OBJ) : $(FW_SRC)
	@mkdir -p $(dir $@)
	$(CC) $(FW_CFLAGS) -o $@ $^

$(FW_OBJDUMP) : $(FW_OBJ)
	@mkdir -p $(dir $@)
	$(OBJDUMP) -z -D $< > $@

$(FW_HEX) : $(FW_OBJ)
	@mkdir -p $(dir $@)
	$(OBJCOPY) $(OBJCOPY_HEX_ARGS) --change-address=0xE0000000 -O verilog $< $@
	#$(POWER_LIBS)/vl-hex-align --scale 4 $@ 
	touch $(SOC_WORK)/rom.hex
# $(FW_VIVADO_HEX) : $(FW_OBJ)
# 	@mkdir -p $(dir $@)
# 	$(OBJCOPY) $(OBJCOPY_HEX_ARGS) \
#         --reverse-bytes=4 \
#         --remove-section=.riscv.attributes \
#         --change-address=0xF0000000 \
#         -O verilog $< $@
# 	python $(SOC_HOME)/bin/vl-hex-align.py --scale 4 $@