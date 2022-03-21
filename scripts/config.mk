# DO NOT change this file
ifndef __CONFIG_MK__
__CONFIG_MK__ := 1
export BUILD_SYSTEM := $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))
export CLEAR_VARS := $(BUILD_SYSTEM)/clear_vars.mk
export DEFINE_STATIC_LIB := $(BUILD_SYSTEM)/build_static_library.mk
export DEFINE_EXECUTE := $(BUILD_SYSTEM)/build_exe.mk
export EANBLE_COMPILE_PROGRESS := $(BUILD_SYSTEM)/calc_total_obj_count.mk
export BASIC_RULE := $(BUILD_SYSTEM)/basic_rule.mk
export ENABLE_PRECOMPILE := $(BUILD_SYSTEM)/pre_compile.mk
export BUILD_ALL_MODULE := $(BUILD_SYSTEM)/build_all_modules.mk
export MAKE ?= make --no-print-directory
export CC  ?= $(CROSS_COMPILE)gcc
export CXX ?= $(CROSS_COMPILE)g++
export CPP ?= $(CROSS_COMPILE)gcc -E
export AR  ?= $(CROSS_COMPILE)ar
export MODULE_LIST :=

export CPPFLAGS :=
export CXXFLAGS :=
export CFLAGS :=
export LDFLAGS :=

PLATFORM := linux
CPUCOUNT := $(shell cat /proc/cpuinfo | grep -c processor)
#CPUCOUNT := 1
OUT_DIR := $(ROOT_DIR)/build/$(PLATFORM)/out
INC_DIR := $(ROOT_DIR)/inc
BIN_DIR := $(OUT_DIR)/bin
LIB_DIR := $(OUT_DIR)/lib

START_TIME := $(shell date +"%s.%N")
# Disable implicit rules so canonical targets will work.
.SUFFIXES:
# Disable VCS-based implicit rules.
% : %,v
# Disable VCS-based implicit rules.
% : RCS/%
# Disable VCS-based implicit rules.
% : RCS/%,v
# Disable VCS-based implicit rules.
% : SCCS/s.%
# Disable VCS-based implicit rules.
% : s.%
.PHONY: begin module_list
all: begin module_list
	@echo "\033[32m************************************************"
	@echo "* Compile complete $(shell date --rfc-3339=seconds)"
	@printf "* Build Time: %.2f seconds\n" $$(echo "$$(date +%s.%N) - $(START_TIME)" | bc)
	@echo "************************************************\033[0m"
begin:
	@echo "\033[32m************************************************"
	@echo "* Start compile $(shell date --rfc-3339=seconds)"
	@echo "************************************************\033[0m"

#if what the makefile show the build progress, include this
include $(EANBLE_COMPILE_PROGRESS)

endif
