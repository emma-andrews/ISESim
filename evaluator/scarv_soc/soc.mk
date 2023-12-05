


#Update the module name for the DuT
# MODULE=scarv_soc

SOC_HOME=../../eut/scarv-soc
XCRYPTO_RTL=../../eut/xcrypto/rtl
SCARV_CPU=../../eut/scarv-soc/extern/scarv-cpu


VSOC=V$(SOC)
# Top module
SOCDUTPATH=$(SOC_HOME)/rtl/soc/$(SOC).v
SOCDUTPATH += $(SOC_HOME)/rtl/ic/ic_addr_decode.v
SOCDUTPATH += $(SOC_HOME)/rtl/ic/ic_cpu_bus_bram_bridge.v
SOCDUTPATH += $(SOC_HOME)/rtl/ic/ic_cpu_bus_axi_bridge.v
SOCDUTPATH += $(SOC_HOME)/rtl/ic/ic_rsp_tracker.v
SOCDUTPATH += $(SOC_HOME)/rtl/ic/ic_error_rsp_stub.v
SOCDUTPATH += $(SOC_HOME)/rtl/ic/ic_top.v

#  Random number generator sources
SOCDUTPATH += $(SOC_HOME)/rtl/rng/scarv_rng_lfsr.v
SOCDUTPATH += $(SOC_HOME)/rtl/rng/scarv_rng_top.v

#  Memories
SOCDUTPATH += $(SOC_HOME)/rtl/mem/scarv_soc_bram_dual_sim.v

# Core
SOCDUTPATH += $(XCRYPTO_RTL)/p_addsub/p_addsub.v 
SOCDUTPATH += $(XCRYPTO_RTL)/p_shfrot/p_shfrot.v
SOCDUTPATH += $(XCRYPTO_RTL)/xc_sha3/xc_sha3.v 
SOCDUTPATH += $(XCRYPTO_RTL)/xc_sha256/xc_sha256.v
SOCDUTPATH += $(XCRYPTO_RTL)/xc_aessub/xc_aessub.v
SOCDUTPATH += $(XCRYPTO_RTL)/xc_aessub/xc_aessub_sbox.v
SOCDUTPATH += $(XCRYPTO_RTL)/xc_aesmix/xc_aesmix.v
SOCDUTPATH += $(XCRYPTO_RTL)/xc_malu/xc_malu.v
SOCDUTPATH += $(XCRYPTO_RTL)/xc_malu/xc_malu_divrem.v
SOCDUTPATH += $(XCRYPTO_RTL)/xc_malu/xc_malu_long.v
SOCDUTPATH += $(XCRYPTO_RTL)/xc_malu/xc_malu_mul.v
SOCDUTPATH += $(XCRYPTO_RTL)/xc_malu/xc_malu_pmul.v
SOCDUTPATH += $(XCRYPTO_RTL)/xc_malu/xc_malu_muldivrem.v
SOCDUTPATH += $(XCRYPTO_RTL)/b_bop/b_bop.v
SOCDUTPATH += $(XCRYPTO_RTL)/b_lut/b_lut.v
SOCDUTPATH += $(SCARV_CPU)/rtl/core/frv_common.vh
SOCDUTPATH += $(SCARV_CPU)/rtl/core/frv_alu.v
SOCDUTPATH += $(SCARV_CPU)/rtl/core/frv_asi.v
SOCDUTPATH += $(SCARV_CPU)/rtl/core/frv_bitwise.v
SOCDUTPATH += $(SCARV_CPU)/rtl/core/frv_core_fetch_buffer.v
SOCDUTPATH += $(SCARV_CPU)/rtl/core/frv_core.v
SOCDUTPATH += $(SCARV_CPU)/rtl/core/frv_counters.v
SOCDUTPATH += $(SCARV_CPU)/rtl/core/frv_csrs.v
SOCDUTPATH += $(SCARV_CPU)/rtl/core/frv_gprs.v
SOCDUTPATH += $(SCARV_CPU)/rtl/core/frv_interrupts.v
SOCDUTPATH += $(SCARV_CPU)/rtl/core/frv_leak.v
SOCDUTPATH += $(SCARV_CPU)/rtl/core/frv_lsu.v
SOCDUTPATH += $(SCARV_CPU)/rtl/core/frv_pipeline_decode.v
SOCDUTPATH += $(SCARV_CPU)/rtl/core/frv_pipeline_execute.v
SOCDUTPATH += $(SCARV_CPU)/rtl/core/frv_pipeline_fetch.v
SOCDUTPATH += $(SCARV_CPU)/rtl/core/frv_pipeline_memory.v
SOCDUTPATH += $(SCARV_CPU)/rtl/core/frv_pipeline_register.v
SOCDUTPATH += $(SCARV_CPU)/rtl/core/frv_pipeline.v
SOCDUTPATH += $(SCARV_CPU)/rtl/core/frv_pipeline_writeback.v
SOCDUTPATH += $(SCARV_CPU)/rtl/core/frv_rngif.v

POWER_LIBS=../power_libs

TB= $(SOC_HOME)/verif/scarv-soc/memory_bus/memory_bus.cpp
TB += $(SOC_HOME)/verif/scarv-soc/memory_bus/memory_device.cpp
TB += $(SOC_HOME)/verif/scarv-soc/memory_bus/memory_device_ram.cpp
TB += $(SOC_HOME)/verif/scarv-soc/memory_bus/memory_device_uart.cpp
TB += $(SOC_HOME)/verif/scarv-soc/memory_bus/memory_device_gpio.cpp
TB += $(SOC_HOME)/verif/scarv-soc/axi4lite/a4l_slave_agent.cpp
TB += $(SOC_HOME)/verif/scarv-soc/dut_wrapper.cpp
TB += $(SOC_HOME)/verif/scarv-soc/testbench.cpp
TB += $(SOC_HOME)/verif/scarv-soc/main.cpp




soc: $(VSOC)
	@echo "\033[0;32mSoC model generated \033[0m"



$(VSOC): obj_dir/$(VSOC).mk
	make -C obj_dir -f $(VSOC).mk $(VSOC)

obj_dir/$(VSOC).mk:
	verilator -Wall --trace --public-flat-rw --cc  "-O2" -O3 -I$(SCARV_CPU)/rtl/core/ \
	 -Wno-lint -CFLAGS "-w -DMODULENAME=$(VSOC) -include $(VSOC).h " $(SOCDUTPATH)\
	  --top-module $(SOC) --exe $(TB)  -GBRAM_ROM_MEMH_FILE="\"rom.hex\"" \
        -GBRAM_RAM_MEMH_FILE="\"ram.hex\"" 


# define tgt_verilator_build

# ${1} : $(VL_CSRC)
# 	@mkdir -p ${2}
# 	$(VERILATOR) $(VL_FLAGS)  --Mdir ${2} -o ${1} \
#         -GBRAM_ROM_MEMH_FILE="\"$(strip ${3})\"" \
#         -GBRAM_RAM_MEMH_FILE="\"$(strip ${4})\"" \
#         -f $(VL_RTL_MANIFEST) \
#         -f $(VL_CPP_MANIFEST) \
#         -f $(SCARV_CPU_MANIFEST)
# 	$(MAKE) -C ${2} -f Vscarv_soc.mk

# endef

#$(eval $(call tgt_verilator_build,$(VL_OUT),$(VL_DIR),rom.hex,ram.hex))





