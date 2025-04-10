
tvla-soc: print-soc soc-model #firmcat compile

soc-model: clean-fu soc hexup


print-soc:
	@echo "\033[1m\033[34mEvaluating \033[31m$(SOC) SoC \033[34mwith  \033[31m$(MODULE) \033[34m Module  \033[0m"

hexup:
	g++ $(POWER_LIBS)/hexup.cpp -include inputs_$(SOC)_$(MODULE).h -o obj_dir/hexup
	make toggle
	cd  obj_dir && ./hexup V$(SOC) $(MODULE)
	$(POWER_LIBS)/plotter V$(SOC)-$(MODULE).csv 1

clean-fu:
	rm -rf obj_dir 
	mkdir obj_dir
	
