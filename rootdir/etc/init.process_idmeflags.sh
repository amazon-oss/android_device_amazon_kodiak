#!/system/bin/sh
PATH=/sbin:/system/sbin:/system/bin:/system/xbin

export IDME_FLAGS_ADB_ON=0x1
export IDME_FLAGS_CONSOLE_ON=0x4
export IDME_FLAGS_DISABLE_SECURE_ADB=0x20

idmeflagsfile="/proc/idme/flags"

if [ -f $idmeflagsfile ]; then
    export IDMEFLAGS=`cat $idmeflagsfile`
    log -t IDMEFLAGS Read IDME flags:$IDMEFLAGS

    # enable secure adb on user and userdebug builds
    export BUILD_TYPE=`getprop ro.build.type`
    if [ "$BUILD_TYPE" == "eng" ]; then
        log -t IDMEFLAGS "Disable secure ADB - ENG build"
        setprop ro.adb.secure 0
    else
        # enable only if disable secure adb flag is not set in idme
        if [ $(( $IDME_FLAGS_DISABLE_SECURE_ADB & 0x$IDMEFLAGS )) == 0 ]; then
            log -t IDMEFLAGS "Enable secure ADB"
            setprop ro.adb.secure 1
        else
            log -t IDMEFLAGS "Disable secure ADB - idme flags set"
            setprop ro.adb.secure 0
        fi
    fi

    if [ $(( $IDME_FLAGS_ADB_ON & 0x$IDMEFLAGS )) != 0 ]; then
        log -t IDMEFLAGS "Enabling adb from IDME flags"
        if ! `getprop persist.sys.usb.config | grep -q adb`; then
            setprop persist.sys.usb.config `getprop persist.sys.usb.config`,adb
        fi
    fi

    if [ $(( $IDME_FLAGS_CONSOLE_ON & 0x$IDMEFLAGS )) != 0 ]; then
        log -t IDMEFLAGS "Enabling console from IDME flags"
        start console
    fi
else
    log -t IDMEFLAGS "Enable secure ADB"
    setprop ro.adb.secure 1
fi
