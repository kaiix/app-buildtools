#!/bin/sh

APP_NAME=noname
APP_VER=$(grep -oE '"CFBundleVersion" = "[0-9.]+"' ${APP_NAME}/en.lproj/InfoPlist.strings | grep -oE "[0-9.]+")
GIT_VER=$(git rev-parse --short HEAD)
BUILD_PATH=`pwd`/Build

archive()
{
    PKG_NAME=${APP_NAME}-release-v${APP_VER}-r${GIT_VER}.ipa

	echo [Archive] ${PKG_NAME} ...

	xcrun -sdk iphoneos PackageApplication \
	      -v ${BUILD_PATH}/Products/Release-iphoneos/${APP_NAME}.app \
          -o ${BUILD_PATH}/${PKG_NAME}

    cd ${BUILD_PATH}
    unlink ${APP_NAME}-release.ipa 2>/dev/null
    rm -f $(readlink ${APP_NAME}-release.ipa)
    ln -s ${PKG_NAME} ${APP_NAME}-release.ipa

	echo [Archive] done
}

tag()
{
	echo [TAG] version = ${APP_VER}

    echo [TAG] Does version correct? [y/n]
    read ok
    if [ $ok != "y" ]; then
        exit
    fi

    VER_TAG=${APP_NAME}-v${APP_VER}
    echo [TAG] tagging ${VER_TAG}

    git tag ${VER_TAG}
    echo Tagging Ok
    git tag -l

    echo "Pushing tags? [y/n]"
    read pushing
    if [ $pushing == "y" ]; then
        git push --tags
    fi

    echo [TAG] done
}

_prompt()
{
    while [ "$ok" != "y" ]; do
        echo "$1 [y/n]"
        read ok
    done
    ok=n
}

case "$1" in
    "")
        echo "usage [-a | -t]"
        ;;
    -a|--archive)
        archive
        ;;
    -t|--tag)
        tag
        ;;
esac
