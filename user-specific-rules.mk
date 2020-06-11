# ========================================================================
#
# Allow for option machine/user specific build customisations
#
# 1. Construct a filename that looks like Makefile-{HOSTNAME}-{USERNAME}.mk
# 2. Include it if it exists
# 3. or define .user-clean-pre, .user-clean-post, .user-build-pre etc
#    targets, which the option file should include if it does exist.
#
# ========================================================================

# only do this on first pass
ifeq ($(MAKECMDGOALS),)

# make a list of words
USER_MAKEFILE := Makefile

# append computer name depending on platform
ifeq ($(MAKE_HOST),Windows32)
USER_MAKEFILE += $(COMPUTERNAME)
else
USER_MAKEFILE += $(shell uname -n)
endif

# append a user name
ifneq ($(USER),)
USER_MAKEFILE += $(USER)
else ifneq ($(LOGNAME),)
USER_MAKEFILE += $(LOGNAME)
else
USER_MAKEFILE += anon
endif

# define a literal space
SPACE = $(subst ,, )

# replace spaces with hypens to make filename
USER_MAKEFILE := $(subst $(SPACE),-,$(USER_MAKEFILE)).mk
	
# resolve it (blank if non-existent)
USER_MAKEFILE:=$(wildcard $(USER_MAKEFILE))
ifneq ($(strip $(USER_MAKEFILE)),)
    $(info Including >> $(USER_MAKEFILE))
    include $(USER_MAKEFILE)
else
    $(info NOT FOUND: $(USER_MAKEFILE) >> Skipping)
    # define dummy targets to satisfy the earlier 
.user-clean-pre:
.user-clean-post:
.user-build-pre:
.user-build-post:
endif

endif


