ARCHS = armv7 armv7s arm64

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = QuickLock
$(APPLICATION_NAME)_LIBRARIES = rocketbootstrap
$(APPLICATION_NAME)_FILES = main.m QLAppDelegate.mm RootViewController.mm
$(APPLICATION_NAME)_FRAMEWORKS = UIKit CoreGraphics AudioToolbox
$(APPLICATION_NAME)_PRIVATE_FRAMEWORKS = AppSupport

include $(THEOS_MAKE_PATH)/application.mk