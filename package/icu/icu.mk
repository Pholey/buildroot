################################################################################
#
# icu
#
################################################################################

ifeq ($(BR2_PACKAGE_RDK_VERSIONING),y)
ICU_VERSION = 57.1
else ifeq ($(BR2_PACKAGE_NETFLIX5),y)
ICU_VERSION = 58.2
else ifeq ($(BR2_PACKAGE_NETFLIX52),y)
ICU_VERSION = 58.2
else
ICU_VERSION = 57.1
endif

ICU_SOURCE = icu4c-$(subst .,_,$(ICU_VERSION))-src.tgz
ICU_SITE = http://download.icu-project.org/files/icu4c/$(ICU_VERSION)
ICU_LICENSE = ICU License
ICU_LICENSE_FILES = license.html

ICU_DEPENDENCIES = host-icu
ICU_INSTALL_STAGING = YES
ICU_CONFIG_SCRIPTS = icu-config
ICU_CONF_OPTS = \
	--with-cross-build=$(HOST_ICU_DIR)/source \
	--disable-samples \
	--disable-tests

# When available, icu prefers to use C++11 atomics, which rely on the
# __atomic builtins. On certain architectures, this requires linking
# with libatomic starting from gcc 4.8.
ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
ICU_CONF_ENV += LIBS="-latomic"
endif

# strtod_l() is not supported by musl; also xlocale.h is missing
ifeq ($(BR2_TOOLCHAIN_USES_MUSL),y)
ICU_CONF_ENV += ac_cv_func_strtod_l=no
endif

HOST_ICU_CONF_OPTS = \
	--disable-samples \
	--disable-tests \
	--disable-extras \
	--disable-icuio \
	--disable-layout \
	--disable-renaming
ICU_SUBDIR = source
HOST_ICU_SUBDIR = source

# FIXME: Disable ccache for host-icu to prevent a possible segmentation violation. 
HOST_ICU_CONF_ENV = CXX="$(HOSTCXX_NOCCACHE)" CC="$(HOSTCC_NOCCACHE)"

ifeq ($(BR2_PACKAGE_ICU_USE_ICUDATA),y)
ICU_DEPENDENCIES += icudata
ICU_POST_PATCH_HOOKS += ICUDATA_EXTRACT
endif

ICU_CUSTOM_DATA_PATH = $(call qstrip,$(BR2_PACKAGE_ICU_CUSTOM_DATA_PATH))

ifneq ($(ICU_CUSTOM_DATA_PATH),)
define ICU_COPY_CUSTOM_DATA
	cp $(ICU_CUSTOM_DATA_PATH) $(@D)/source/data/in/
endef
ICU_POST_PATCH_HOOKS += ICU_COPY_CUSTOM_DATA
endif

define ICU_REMOVE_DEV_FILES
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/,derb genbrk gencfu gencnval gendict genrb icuinfo makeconv uconv)
	rm -f $(addprefix $(TARGET_DIR)/usr/sbin/,genccode gencmn gennorm2 gensprep icupkg)
	rm -rf $(TARGET_DIR)/usr/share/icu
endef
ICU_POST_INSTALL_TARGET_HOOKS += ICU_REMOVE_DEV_FILES

$(eval $(autotools-package))
$(eval $(host-autotools-package))
