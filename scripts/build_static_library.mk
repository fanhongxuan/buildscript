# note:fanhongxuan@gmail.com
# supporting the following param:
# LIB_NAME: the name of the static library, don't include lib, don't include .a, for example LIB_NAME is test will generate libtest.a
# LIB_SRCDIR: the src dir of the dir. default is source
# LIB_INCLUDE_SUB_DIR : if need include the file in sub-dir, default is y
include $(BASIC_RULE)
ifeq (,$(LOCAL_MODULE))
  $(error Please set the LOCAL_MODULE first)
endif
ifeq (,$(LOCAL_SRC_DIR))
  LOCAL_SRC_DIR := source
endif
ifeq (,$(LOCAL_INCLUDE_SUB_DIR))
   LOCAL_INCLUDE_SUB_DIR := y
endif

LOCAL_TARGET         := $(LIB_DIR)/lib$(LOCAL_MODULE).a
MODULE_LIST += $(LOCAL_TARGET)
LOCAL_TARGET_SRC_DIR := $(LOCAL_SRC_DIR)
LOCAL_TARGET_SRC_DIR_LIST := $(LOCAL_TARGET_SRC_DIR)
ifeq ($(LOCAL_INCLUDE_SUB_DIR), y)
  LOCAL_TARGET_SRC_DIR_LIST :=
  LOCAL_TARGET_SRC_DIR_LIST += $(shell find $(LOCAL_SRC_DIR) -maxdepth 5 -type d)
endif
LOCAL_TARGET_OBJ_DIR := $(OUT_DIR)/$(LOCAL_MODULE)

#target_cpp_src := $(wildcard $(target_src_dir)/*.cpp)
LOCAL_TARGET_CPP_SRC := $(foreach dir,$(LOCAL_TARGET_SRC_DIR_LIST),$(wildcard $(dir)/*.cpp))
LOCAL_TARGET_CPP_OBJ := $(patsubst $(LOCAL_TARGET_SRC_DIR)/%.cpp, $(LOCAL_TARGET_OBJ_DIR)/%.cpp.o, $(LOCAL_TARGET_CPP_SRC))
LOCAL_TARGET_CPP_DEP := $(patsubst $(LOCAL_TARGET_SRC_DIR)/%.cpp, $(LOCAL_TARGET_OBJ_DIR)/%.cpp.d, $(LOCAL_TARGET_CPP_SRC))

#target_c_src := $(wildcard $(target_src_dir)/*.c)
LOCAL_TARGET_C_SRC := $(foreach dir,$(LOCAL_TARGET_SRC_DIR_LIST),$(wildcard $(dir)/*.c))
LOCAL_TARGET_C_OBJ := $(patsubst $(LOCAL_TARGET_SRC_DIR)/%.c, $(LOCAL_TARGET_OBJ_DIR)/%.c.o, $(LOCAL_TARGET_C_SRC))
LOCAL_TARGET_C_DEP := $(patsubst $(LOCAL_TARGET_SRC_DIR)/%.c, $(LOCAL_TARGET_OBJ_DIR)/%.c.d, $(LOCAL_TARGET_C_SRC))

CPPFLAGS += $(foreach dir, $(LOCAL_TARGET_INC_DIR), -I$(SRC_ROOT)/$(dir))

LOCAL_TARGET_LIST :=

ifdef VERBOSE
LOCAL_TARGET_LIST := $(LOCAL_MODULE).start $(LOCAL_MODULE).debug
.PHONY: $(LOCAL_MODULE).start $(LOCAL_MODULE).debug
endif
LOCAL_OBJ_LIST_$(LOCAL_TARGET) := $(LOCAL_TARGET_C_OBJ) $(LOCAL_TARGET_CPP_OBJ)
LOCAL_TARGET_LIST += $(LOCAL_OBJ_LIST_$(LOCAL_TARGET))

$(LOCAL_TARGET): $(LOCAL_TARGET_LIST)
	@$(call GenerateStaticLib,$@, $(LOCAL_OBJ_LIST_$@))
ifdef VERBOSE
	@echo "\033[32m[Build] Build $(LOCAL_TARGET) OK\033[0m"
$(LOCAL_MODULE).start:
	@echo "\033[32m[Build] Starting build $(LOCAL_TARGET) ...\033[0m"
$(LOCAL_MODULE).debug:
	@echo "\033[32mLOCAL_TARGET_SRC_DIR      \033[0m:= $(LOCAL_TARGET_SRC_DIR)"
	@echo "\033[32mLOCAL_TARGET_SRC_DIR_LIST \033[0m:= $(LOCAL_TARGET_SRC_DIR_LIST)"
	@echo "\033[32mLOCAL_TARGET_OBJ_DIR      \033[0m:= $(LOCAL_TARGET_OBJ_DIR)"
	@echo "\033[32mLOCAL_TARGET_CPP_SRC      \033[0m:= $(LOCAL_TARGET_CPP_SRC)"
	@echo "\033[32mLOCAL_TARGET_CPP_OBJ      \033[0m:= $(LOCAL_TARGET_CPP_OBJ)"
	@echo "\033[32mLOCAL_TARGET_CPP_DEP      \033[0m:= $(LOCAL_TARGET_CPP_DEP)"
	@echo "\033[32mLOCAL_PRECOMPILE_HEADER   \033[0m:= $(LOCAL_PRECOMPILE_HEADER)"
	@echo "\033[32mCC                        \033[0m:= $(CC)"
	@echo "\033[32mCPPFLAGS                  \033[0m:= $(CPPFLAGS)"
	@echo "\033[32mLOCAL_SRC_DIR             \033[0m:= $(LOCAL_SRC_DIR)"
	@echo "\033[32mLOCAL_MODULE              \033[0m:= $(LOCAL_MODULE)"
endif

include $(ENABLE_PRECOMPILE)

.PHONY:lib$(LOCAL_MODULE).a
lib$(LOCAL_MODULE).a: $(LOCAL_TARGET)

$(LOCAL_TARGET_OBJ_DIR):
	@mkdir -p $@

$(LOCAL_TARGET_OBJ_DIR)/%.cpp.d:$(LOCAL_TARGET_SRC_DIR)/%.cpp
	@mkdir -p $(shell dirname $@)
	@$(CPP) $(CPPFLAGS) -MF"$@" -MM -MP -MT"$(@:.d=.o)" $<

-include $(LOCAL_TARGET_CPP_DEP)
$(LOCAL_TARGET_OBJ_DIR)/%.cpp.o:$(LOCAL_TARGET_SRC_DIR)/%.cpp $(LOCAL_TARGET_OBJ_DIR)/%.cpp.d $(LOCAL_PRECOMPILE_HEADER_GCH)
	@$(call CompileCXX,$<,$@)

$(LOCAL_TARGET_OBJ_DIR)/%.c.d:$(LOCAL_TARGET_SRC_DIR)/%.c
	@mkdir -p $(shell dirname $@)
	@$(CPP) $(CPPFLAGS) -MF"$@" -MM -MP -MT"$(@:.d=.o)" $<

-include $(LOCAL_TARGET_C_DEP)
$(LOCAL_TARGET_OBJ_DIR)/%.c.o:$(LOCAL_TARGET_SRC_DIR)/%.c $(LOCAL_TARGET_OBJ_DIR)/%.c.d $(LOCAL_PRECOMPILE_HEADER_GCH)
	@$(call CompileC,$<,$@)