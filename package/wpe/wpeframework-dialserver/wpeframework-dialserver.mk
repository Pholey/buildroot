################################################################################
#
# wpeframework-dialserver
#
################################################################################

WPEFRAMEWORK_DIALSERVER_VERSION = 88fbbae258ca9ce0ad943d3891d8725aaf4e771f
WPEFRAMEWORK_DIALSERVER_SITE_METHOD = git
WPEFRAMEWORK_DIALSERVER_SITE = git@github.com:WebPlatformForEmbedded/WPEPluginDIAL.git
WPEFRAMEWORK_DIALSERVER_INSTALL_STAGING = YES
WPEFRAMEWORK_DIALSERVER_DEPENDENCIES = wpeframework

WPEFRAMEWORK_DIALSERVER_CONF_OPTS += -DBUILD_REFERENCE=${WPEFRAMEWORK_DIALSERVER_VERSION}

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_YOUTUBE),y)
	WPEFRAMEWORK_DIALSERVER_CONF_OPTS += -DENABLE_YOUTUBE=ON
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_NETFLIX),y)
	WPEFRAMEWORK_DIALSERVER_CONF_OPTS += -DENABLE_NETFLIX=ON
endif

$(eval $(cmake-package))

