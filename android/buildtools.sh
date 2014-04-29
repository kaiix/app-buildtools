#!/bin/sh

APP_NAME=noname
APP_VER=$(grep -oE 'android:versionName="[0-9.]+"' AndroidManifest.xml|grep -oE "[0-9.]+")
GIT_VER=$(git rev-parse --short HEAD)
BUILD_PATH=build

archive()
{

    APK_NAME=${APP_NAME}-release-v${APP_VER}-r${GIT_VER}.apk

	echo [Archive] ${APK_NAME} ...

    cp bin/${APP_NAME}-release.apk build/${APK_NAME}
    cd ${BUILD_PATH}
    unlink ${APP_NAME}-release.apk 2>/dev/null
    rm -f $(readlink ${APP_NAME}-release.apk)
    ln -s ${APK_NAME} ${APP_NAME}-release.apk

	echo [Archive] done
}

tag()
{
	echo [TAG] version = $APP_VER

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
