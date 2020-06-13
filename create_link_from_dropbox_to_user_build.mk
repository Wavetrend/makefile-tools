# create_link_from_dropbox_to_user_build
#
# Designed to allow build product directories to be linked outside of the current project path, useful
# for when the working tree is in a Dropbox folder, and its hard to control through Dropbox selective sync
# whether build artefacts (obj,exe) need to be synced to Dropbox (creating transfer and storage overhead)
#
# The function will substitute the Dropbox path with the Builddir prefix, then create a link from the targetdir
# to the builddir.  Builddir has the same folder structure as the original Dropbox path, minus the Dropbox prefix
#
# params:
# $(3) dropbox folder, e.g. /Users/usersname/Dropbox
# $2 builddir folder, e.g. /Users/username/Builds
# $3 targetdir folder, e.g. /Users/username/Dropbox/Projects/Project-A/build
#
# Result: /Users/username/Dropbox/Projects/Project-A/build => /Users/username/Builds/Projects/Project-A/build
#
# IMPORTANT: All paths should be fully qualified and not include shortucts such as ~ for home directory
#
define create_link_from_dropbox_to_user_build
	@# Check the dropbox and build folders exist
	@(test -d "$(1)" || (echo "ERROR: DROPBOX folder \"$(1)\" MUST exist" && false))
	@(test -d "$(2)" || (echo "ERROR: BUILDDIR folder \"$(2)\" MUST exist" && false))
	@# if target exists but is not a symbolic link, remove it
	@(test -e "$(3)" && test ! -L "$(3)" && rm -rf "$(3)" && echo Deleted \"$(3)\" as not a link) || true
	@# if target is a link, remove it if it goes elsewhere
	@(readlink -n "$(3)" | { read link; test "$$link" = "$(subst $(1),$(2),$(3))" || (rm "$(3)" && echo Deleted \"$(3)\" as target was elsewhere); }) || true
	@# if target does not exist, create link
	@(test ! -d "$(3)" && mkdir -p "$(subst $(1),$(2),$(3))") || true
	@# if link to target does not exist, create
	@(test ! -L "$(3)" && ln -s "$(3)" "$(subst $(1),$(2),$(3))") || true
	@echo \"$(3)\" links to \"$(subst $(1),$(2),$(3))\"
endef

