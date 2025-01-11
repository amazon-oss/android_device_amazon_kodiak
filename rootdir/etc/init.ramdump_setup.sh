#!/system/bin/sh

PATH=/sbin:/system/sbin:/system/bin:/system/xbin
BUILD_TYPE=`grep ro.build.type /system/build.prop`

# enable ramdump if ramdump partition exists

if test -h /dev/block/platform/msm_sdcc.1/by-name/ramdump; then  
    mount -t vfat -rw -o umask=7003,uid=1000,gid=1000 /dev/block/platform/msm_sdcc.1/by-name/ramdump /mnt/ramdump

    # enable ramdump for non-user build (user-debug, eng)
    if [ "$BUILD_TYPE" != "ro.build.type=user" ]; then
        echo 1 > /sys/module/restart/parameters/download_mode
    else
        # enalbe ramdump for user build only if cookie exists in ramdump folder
        if test -f /mnt/ramdump/encookie.txt; then
            echo 1 > /sys/module/restart/parameters/download_mode
        fi
    fi
    # also execute ebi_extractor to extract kernel logs from existing ramdumps
    ebi_extractor
fi
