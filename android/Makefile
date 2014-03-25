ADB=$(SDK_ROOT)/platform-tools/adb
ANDROID=$(SDK_ROOT)/tools/android
NDK=$(NDK_ROOT)/ndk-build
APP_NAME=noname
PKG_NAME=com.example.app
MAIN_ACTIVITY=com.example.app.MainActivity

check_env:
ifeq ($(SDK_ROOT), )
	$(error SDK_ROOT NOT FOUND)
endif
ifeq ($(NDK_ROOT), )
	$(error NDK_ROOT NOT FOUND)
endif

setup: check_env
	$(ANDROID) -v update project -t android-14 -n $(APP_NAME) -p .
	test -d build || mkdir build

clean:
	ant clean
	rm -f build/$(APP_NAME)-release.apk

uninstall: check_env
	$(ADB) uninstall $(PKG_NAME)

install: check_env
	@echo [====== Install release version to device ======]
	$(ADB) install -r build/$(APP_NAME)-release.apk
	$(ADB) shell am start -n $(PKG_NAME)/$(MAIN_ACTIVITY)

build: check_env clean
	@echo [====== Build Release Version ======]
	ant clean
	ant release
	@./buildtools.sh --archive

