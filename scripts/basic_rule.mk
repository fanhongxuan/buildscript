ifndef __BASIC_RULE_MK__
__BASIC_RULE_MK__ := 1
# $(1) is methord: C++/ASM/C/LINK
# $(2) is desc string
ifeq ($(OBJ_COUNT_FILE),)
define AddObj
	@printf "["$(1)"] \033[32m"$(2)"\033[0m\n"
endef
else
Number := $(shell cat $(OBJ_COUNT_FILE))
Count = $(words $(Number))
ifndef AddObj
define AddObj
	@mkdir -p $(dir $(OBJ_COUNT_FILE))
	@echo -n " x " >> $(OBJ_COUNT_FILE)
	@printf "[%3d%% %`expr length $(TOTAL_OBJ)`d/%d] ["$(1)"] \033[32m"$(2)"\033[0m\n" `expr $(Count) '*' 100 / $(TOTAL_OBJ)` $(Count) $(TOTAL_OBJ)  $(eval Number += x)
endef
endif
endif

# $(1) src file name
# $(2) output filename
define CompileC
	@mkdir -p $(dir $(2))
	@$(call AddObj,"  CC","Compile $(1) ")
	@$(CC) $(CPPFLAGS) $(CCFLAGS) -o $(2) -c $(1)
endef

define CompileCXX
	@mkdir -p $(dir $(2))
	@$(call AddObj," C++","Compile $(1) ...")
	@$(CXX) $(CPPFLAGS) $(CXXFLAGS) -o $(2) -c $(1)
endef

# $(1) target name
# $(2) input list
define GenerateStaticLib
	@mkdir -p $(dir $(1))
	@$(call AddObj,"  AR","Generate $(1) ...")
	@$(AR) crs $(1) $(2)
endef
endif