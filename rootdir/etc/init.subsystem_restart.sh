#!/system/bin/sh

PATH=/sbin:/system/sbin:/system/bin:/system/xbin

BUILD_TYPE=`getprop ro.build.type`

if [ "$BUILD_TYPE" == "user" ]; then

# enable modem and wifi subsystem restart

echo related > /sys/bus/msm_subsys/devices/subsys1/restart_level
echo related > /sys/bus/msm_subsys/devices/subsys2/restart_level
fi

