
tvla-soc: tvla-fu print-soc soc #firmcat compile

soc: hexup
	$(MAKE) -C  $(SOC_DIR)
	cp $(SOC_DIR)/obj_dir/V$(SOC) obj_dir/
	obj_dir/hexup V$(SOC)

	# -./obj_dir/V$(SOC) +WAVES=obj_dir/sim.vcd +TIMEOUT=10000

	
	#./obj_dir/toggle
	# ./obj_dir/concat $(MODULE).csv
	# rm actual.csv
	# rm toggle.csv
	# $(POWER_LIBS)/plotter $(MODULE).csv

print-soc:
	@echo "\033[1m\033[34mEvaluating \033[31m$(SOC) SoC \033[34mwith  \033[31m$(MODULE) \033[34m Module  \033[0m"

hexup:
	g++ $(POWER_LIBS)/hexup.cpp -o obj_dir/hexup