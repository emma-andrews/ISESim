tvla-fu: print-fu $(VMODULE) toggle concat
	./obj_dir/$(VMODULE)
	cd obj_dir && ./toggle
	./obj_dir/concat $(MODULE).csv
	rm obj_dir/actual.csv
	rm obj_dir/toggle.csv
	$(POWER_LIBS)/plotter $(MODULE).csv 11

$(VMODULE): obj_dir/$(VMODULE).mk
	make -C obj_dir -f $(VMODULE).mk $(VMODULE)

obj_dir/$(VMODULE).mk:
	verilator -Wall --trace --public-flat-rw --cc  -Wno-lint -CFLAGS "-DMODULENAME=$(VMODULE) -include $(VMODULE).h -include ../inputs_$(MODULE).h" $(DUTPATH) --top-module $(MODULE) --exe $(POWER_LIBS)/tb.cpp


toggle:
	g++ $(POWER_LIBS)/toggle.cpp -o obj_dir/toggle

concat:
	g++ $(POWER_LIBS)/concat.cpp -o obj_dir/concat


print-fu:
	@echo "\033[1m\033[34mEvaluating the Functional Unit in \033[31m$(MODULE) \033[34mModule  \033[0m"


clean:
	rm -rf obj_dir 
	rm -f $(MODULE).csv
	rm -f $(MODULE).svg
	rm -f ../results.txt
	rm -f contingency_tables-fu.txt
