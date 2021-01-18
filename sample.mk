ROOT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
PLATFORM := linux
CPUCOUNT := $(shell cat /proc/cpuinfo | grep -c processor)
#CPUCOUNT := 1

PLATFORM := linux
CROSS_COMPILE :=

# note:fanhongxuan@gmail.com
# define the dir which contain the temp file. this dir will be entie removed when make clean
OUT_DIR := $(ROOT_DIR)/build/$(PLATFORM)/out
INC_DIR := $(ROOT_DIR)/inc
BIN_DIR := $(OUT_DIR)/bin
LIB_DIR := $(OUT_DIR)/lib

WXWIN := /home/ubuntu/fanhongxuan/wxWidgets/linux
CPPFLAGS += -D__WXGTK__
CPPFLAGS += -I$(WXWIN)/lib/wx/include/gtk3-unicode-static-3.1 -I$(WXWIN)/include
CPPFLAGS +=  -fPIC -I$(INC_DIR)

CXXFLAGS += -std=c++11 
LDFLAGS += -L$(WXWIN)/lib
LDFLAGS += -pthread -lexpat   -lwx_gtk3u-3.1 -lwxscintilla-3.1 -lwxtiff-3.1 -lwxjpeg-3.1     -lwxregexu-3.1  -pthread    -lz -ldl -lm  -lexpat -lgtk-3 -lgdk-3 -lpangocairo-1.0 -lpango-1.0 -latk-1.0 -lcairo-gobject -lcairo -lgdk_pixbuf-2.0 -lgio-2.0 -lgobject-2.0 -lgthread-2.0 -pthread -lglib-2.0 -lX11 -lXxf86vm -lSM -lgtk-3 -lgdk-3 -lpangocairo-1.0 -lpango-1.0 -latk-1.0 -lcairo-gobject -lcairo -lgdk_pixbuf-2.0 -lgio-2.0 -lgobject-2.0 -lglib-2.0 -lXtst -lpangoft2-1.0 -lpango-1.0 -lgobject-2.0 -lglib-2.0 -lfontconfig -lfreetype -lpng -lz -llzma -lz -ldl -lm

#note:fanhongxuan@gmail.com
#include this at the beginning.
include $(ROOT_DIR)/scripts/config.mk

# compile all the file in src as a static library.
include $(CLEAR_VARS)
LOCAL_MODULE := srclib
LOCAL_PRECOMPILE_HEADER := $(INC_DIR)/precompile.h
LOCAL_SRC_DIR := src
include $(DEFINE_STATIC_LIB)

include $(CLEAR_VARS)
LOCAL_MODULE := test
LOCAL_SRC_DIR := test
include $(DEFINE_STATIC_LIB)

include $(CLEAR_VARS)
LOCAL_MODULE := lat
#LOCAL_PRECOMPILE_HEADER := $(INC_DIR)/precompile.h
#LOCAL_SRC_DIR := src
LOCAL_LIB := srclib test
LOCAL_LD_FLAGS :=
include $(DEFINE_EXECUTE)


#note fanhongxuan@gmail.com
#must include this file at the last.
include $(BUILD_ALL_MODULE)
