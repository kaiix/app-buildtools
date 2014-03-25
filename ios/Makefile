BUILD_PATH=`pwd`/Build
APP_NAME=noname
WORKSPACE=Noname

build:
	export CODE_SIGN_IDENTITY=$(DEVELOPER)
	export CONFIGURATION_BUILD_DIR=$(BUILD_PATH)
	export ONLY_ACTIVE_ARCH=NO
	xcodebuild -sdk iphoneos \
               -workspace "$(WORKSPACE).xcworkspace" \
               -scheme BuildBot \
			   -configuration Release \
			   clean build \

archive:
	rm -f $(BUILD_PATH)/$(APP_NAME).ipa
	xcrun -sdk iphoneos PackageApplication \
	      -v $(BUILD_PATH)/Products/Release-iphoneos/$(APP_NAME).app \
		  -o $(BUILD_PATH)/$(APP_NAME)-release.ipa


release: build archive
