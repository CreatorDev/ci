J?=1
DIR__CI:=$(PWD)
DIR__OPENWRT:=$(DIR__CI)/openwrt
all: openwrt
	echo "All Done!"

openwrt: build_openwrt
	echo "OpenWrt Done!"

clean: clean_openwrt clean_feeds clean_binaries

# Building OpenWRT
$(DIR__CI)/patched:
	git submodule init openwrt;git submodule update --remote; \
	cd $(DIR__OPENWRT); \
	./scripts/feeds update -a; \
	./scripts/feeds install -a;
ifneq (_,_$(findstring all,$P))
	cd $(DIR__OPENWRT)/feeds/packages; patch -p1 < $(DIR__CI)/0001-glib2-make-libiconv-dependent-on-ICONV_FULL-variable.patch;\
	patch -p1 < $(DIR__CI)/0001-node-host-turn-off-verbose.patch;
	touch $(DIR__CI)/patched
endif

.PHONY: $(DIR__OPENWRT)/.config

$(DIR__OPENWRT)/.config: $(DIR__CI)/patched
	if test $(findstring P=,$(MAKEFLAGS)) && test -f $(DIR__OPENWRT)/target/linux/pistachio/$P; then \
		cat $(DIR__OPENWRT)/target/linux/pistachio/$P > $(DIR__OPENWRT)/.config; \
	fi
ifneq (_,_$(findstring all,$P))
	cp $(DIR__CI)/config-4.1-all $(DIR__OPENWRT)/target/linux/pistachio/config-4.1
endif
	cd $(DIR__OPENWRT);$(MAKE) defconfig

$(DIR__OPENWRT)/version:
	./getver.sh  $(DIR__OPENWRT) > $(DIR__OPENWRT)/version

.PHONY: build_openwrt
build_openwrt: $(DIR__OPENWRT)/.config $(DIR__OPENWRT)/version
ifneq (_,_$(findstring all,$P))
	$(MAKE) $(SUBMAKEFLAGS) -C $(DIR__OPENWRT) IGNORE_ERRORS=1 -j$(J)
else
	$(MAKE) $(SUBMAKEFLAGS) -C $(DIR__OPENWRT) -j$(J)
endif

# Clean OpenWRT
# Deletes contents of the directories /bin and /build_dir
.PHONY: clean_openwrt
clean_openwrt:
	$(MAKE) -C $(DIR__OPENWRT) clean

.PHONY: clean_patches
clean_patches:
	if [ -f $(DIR__CI)/patched ]; then \
		cd $(DIR__OPENWRT)/feeds/packages; patch -p1 -R < $(DIR__CI)/0001-glib2-make-libiconv-dependent-on-ICONV_FULL-variable.patch; \
		patch -p1 -R < $(DIR__CI)/0001-node-host-turn-off-verbose.patch;\
		rm $(DIR__CI)/patched;\
	else \
		echo "You don't have patched feeds";\
	fi

.PHONY: clean_feeds
clean_feeds: clean_patches
	cd $(DIR__OPENWRT); rm -rf .config feeds.conf tmp/ feeds;

.PHONY: clean_binaries
clean_binaries:
	rm -rf $(DIR__OPENWRT)/bin/pistachio/

