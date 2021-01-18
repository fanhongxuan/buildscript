ifndef __CALC_TOTAL_OBJ_COUNT_MK__
__CALC_TOTAL_OBJ_COUNT_MK__ :=1
ifeq ($(BUILD_SYSTEM),)
  $(error "Must include config.mk before include calc_total_obj_count.mk")
endif
OBJ_COUNT_FILE := $(BUILD_SYSTEM)/.obj_cout
export OBJ_COUNT_FILE
EXT_TARGET_LIST += $(OBJ_COUNT_FILE)
ifndef AddObj
#fixme:fanhongxuan@gmail.com
#must echo a x at the beginning
#otherwise the $(words $(shell cat $(OBJ_COUNT_FILE))) will return the wrong number
TOTAL_OBJ := $(shell mkdir -p $(dir $(OBJ_COUNT_FILE)) && echo "x"> $(OBJ_COUNT_FILE))
TOTAL_OBJ := $(shell $(MAKE) $(MAKECMDGOALS) --no-print-directory \
      -nrRf $(firstword $(MAKEFILE_LIST)) \
      AddObj="GenerateObject" | grep -c "GenerateObject")
export TOTAL_OBJ
endif
endif