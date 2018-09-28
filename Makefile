ARCHS = armv7 armv7s arm64
TARGET = iphone:11.2:7.0

SUBPROJECTS = Apps Helper

include $(THEOS)/makefiles/common.mk
include $(THEOS)/makefiles/aggregate.mk

after-install::
	install.exec "killall \"SpringBoard\"" || true
