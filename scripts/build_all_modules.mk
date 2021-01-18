ifndef __BUILD_ALL_MODULES__
__BUILD_ALL_MODULES__ := 1
module_list: $(MODULE_LIST)

clean:
ifneq ($(EXT_TARGET_LIST),)
	@rm -rf $(EXT_TARGET_LIST)
endif
ifneq ($(OUT_DIR),)
	@rm -rf $(OUT_DIR)
endif

endif
