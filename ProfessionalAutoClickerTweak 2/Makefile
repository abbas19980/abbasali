export ARCHS = arm64 arm64e
export TARGET = iphone:clang:latest:15.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ProfessionalAutoClicker
ProfessionalAutoClicker_FILES = \
    Tweak.xm \
    Classes/ACPreferences.m \
    Classes/ACLogger.m \
    Classes/ACPointModel.m \
    Classes/ACPointView.m \
    Classes/ACFloatingButton.m \
    Classes/ACMenuView.m \
    Classes/ACOverlayController.m \
    Classes/ACClickerEngine.m

ProfessionalAutoClicker_CFLAGS = -fobjc-arc -Wno-deprecated-declarations -Wall
ProfessionalAutoClicker_FRAMEWORKS = UIKit Foundation CoreGraphics QuartzCore

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += Prefs
include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall -9 SpringBoard 2>/dev/null || true"
