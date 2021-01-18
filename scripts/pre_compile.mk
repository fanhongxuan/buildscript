ifneq ($(LOCAL_PRECOMPILE_HEADER),)
CPPFLAGS += -Winvalid-pch -include $(LOCAL_PRECOMPILE_HEADER)
LOCAL_PRECOMPILE_HEADER_GCH := $(LOCAL_PRECOMPILE_HEADER).gch
LOCAL_PRECOMPILE_HEADER_DEP := $(LOCAL_PRECOMPILE_HEADER).d
EXT_TARGET_LIST += $(LOCAL_PRECOMPILE_HEADER_GCH) 
EXT_TARGET_LIST += $(LOCAL_PRECOMPILE_HEADER_DEP)

-include $(LOCAL_PRECOMPILE_HEADER).d
$(LOCAL_PRECOMPILE_HEADER_DEP):$(LOCAL_PRECOMPILE_HEADER)
	@mkdir -p $(shell dirname $@)
	@$(CPP) $(CPPFLAGS) -MF"$@" -MM -MP -MT"$(@:.d=.gch)" $<

$(LOCAL_PRECOMPILE_HEADER_GCH):$(LOCAL_PRECOMPILE_HEADER) $(LOCAL_PRECOMPILE_HEADER_DEP)
	@$(CXX) $(CPPFLAGS) $(CXXFLAGS) -o $@ $<
	@$(call AddObj," GEN","Generate Precompile header")
endif