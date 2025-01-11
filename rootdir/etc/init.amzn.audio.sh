#!/system/bin/sh

chown media:audio /dev/i2c-8

setprop amzn.audio.init complete
exit 0

