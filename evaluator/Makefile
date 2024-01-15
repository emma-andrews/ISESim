MAKEFLAGS += -s
export MAKEFLAGS

TOPTARGETS := all clean

# Filter out power_libs/ from the list of subdirectories
SUBDIRS := $(filter-out power_libs/., $(wildcard */.))
SUBDIRS := $(filter-out scarv_soc/., $(SUBDIRS))
# default:
# 	@echo $(SUBDIRS)

$(TOPTARGETS): $(SUBDIRS)
$(SUBDIRS):
		start_time=$$(date +%s); \
		$(MAKE) -s -C $@ $(MAKECMDGOALS); \
		end_time=$$(date +%s); \
		echo "Elapsed time: $$((end_time - start_time)) seconds."

.PHONY: $(TOPTARGETS) $(SUBDIRS)
