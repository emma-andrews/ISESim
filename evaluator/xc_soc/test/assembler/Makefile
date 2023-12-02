
# BUILD_DIR   = ../work

# ALL_TARGETS = 

# include ../common.mk

# # $(eval $(call add_assembler_target,test_archstr.S))
# # $(eval $(call add_assembler_target,test_simple_assembly.S))
# # $(eval $(call add_assembler_target,test_masking_ise.S))


# #  $(eval $(call add_compiler_target,test_simple_assembly.S))

# # Specify source files here
# SOURCE_FILES := test_archstr.S test_simple_assembly.S

# # Generate targets for each source file
# $(foreach source,$(SOURCE_FILES),$(eval $(call add_assembler_target,$(source))))
# $(foreach source,$(SOURCE_FILES),$(eval $(call add_compiler_target,$(source))))
# $(foreach source,$(SOURCE_FILES),$(eval $(call add_elf_target,$(source))))
# $(foreach source,$(SOURCE_FILES),$(eval $(call add_spike_target,$(basename $(source)))))

# .PHONY: all
# # all: $(ALL_TARGETS)

# all: $(ALL_TARGETS)

# clean:
# 	rm -f $(ALL_TARGETS)



GCC_PATH = /opt/riscv-xcrypto/bin

AS      = $(GCC_PATH)/riscv32-unknown-elf-as
CC      = $(GCC_PATH)/riscv32-unknown-elf-gcc
OBJDUMP = $(GCC_PATH)/riscv32-unknown-elf-objdump

CFLAGS  += -O2 -Wall

ARCH_BASE = rv32imacb
ARCH      = $(ARCH_BASE)_xcrypto
ABI       = ilp32

SPIKE = $(RISCV)/bin/spike
PK    = $(RISCV)/riscv32-unknown-elf/bin/pk

BUILD_DIR = work

# Map source files to object files
define map_obj
$(BUILD_DIR)/$(basename ${1}).o
endef

# Map source files to disassembly files
define map_dis
$(BUILD_DIR)/$(basename ${1}).dis
endef

# Map source files to ELF files
define map_elf
$(BUILD_DIR)/$(basename ${1}).elf
endef

# Generate disassembly target for a given source file
define add_objdump_target
$(call map_dis,${1}) : ${2}
	$(OBJDUMP) -D $${^} > $${@}
endef

# Generate assembler target for a given source file
define add_assembler_target
$(call map_obj,${1}) : ${1}
	mkdir -p $(dir $(call map_obj,${1}))
	$(AS) -mabi=$(ABI) -march=$(ARCH) -o $${@} $${^}

$(call add_objdump_target,${1},$(call map_obj,${1}))

ALL_TARGETS +=$(call map_obj,${1})
ALL_TARGETS +=$(call map_dis,${1})
endef

# Generate compiler target for a given source file
define add_compiler_target
$(call map_obj,${1}) : ${1}
	mkdir -p $(dir $(call map_obj,${1}))
	$(CC) -c -mabi=$(ABI) -march=$(ARCH) -o $${@} $${^}

$(call add_objdump_target,${1},$(call map_obj,${1}))

ALL_TARGETS +=$(call map_obj,${1})
ALL_TARGETS +=$(call map_dis,${1})
endef

# Generate ELF target for a given source file
define add_elf_target
$(call map_elf,${1}) : ${1}
	mkdir -p $(dir $(call map_elf,${1}))
	$(CC) $(CFLAGS) -mabi=$(ABI) -march=$(ARCH) -o $${@} $${^}

$(call add_objdump_target,${1},$(call map_elf,${1}))

ALL_TARGETS +=$(call map_elf,${1})
ALL_TARGETS +=$(call map_dis,${1})
endef

# Generate target for running the program on Spike simulator
define add_spike_target
run_${1} : $(call map_elf,${1})
	$(SPIKE) --isa=${ARCH_BASE} $(PK) $(call map_elf,${1})
ALL_TARGETS += run_${1}
endef

# Specify source files here
SOURCE_FILES := test_archstr.S

# Generate targets for each source file
# $(foreach source,$(SOURCE_FILES),$(eval $(call add_assembler_target,$(source))))
# $(foreach source,$(SOURCE_FILES),$(eval $(call add_compiler_target,$(source))))
$(foreach source,$(SOURCE_FILES),$(eval $(call add_elf_target,$(source))))
# $(foreach source,$(SOURCE_FILES),$(eval $(call add_spike_target,$(basename $(source)))))

.PHONY: all
all: $(ALL_TARGETS)

clean:
	rm -f $(ALL_TARGETS)