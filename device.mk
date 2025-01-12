#
# Copyright (C) 2025 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Audio
PRODUCT_PACKAGES += \
    audio.a2dp.default \
    audio.primary.msm8974 \
    audio.r_submix.default \
    audio.usb.default \
    libaudio-resampler \
    libqcomvisualizer \
    libqcompostprocbundle \
    libqcomvoiceprocessing

PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/configs/audio/,$(TARGET_COPY_OUT_SYSTEM)/etc)

# Display
PRODUCT_PACKAGES += \
    copybit.msm8974 \
    gralloc.msm8974 \
    hwcomposer.msm8974 \
    memtrack.msm8974

PRODUCT_PACKAGES += \
    liboverlay \
    libqdutils \
    libqservice \
    libqdMetaData

# Keymaster
PRODUCT_PACKAGES += \
    keystore.msm8974

# Rootdir
PRODUCT_PACKAGES += \
    init.qcom.rc \
    ueventd.qcom.rc \
    init.amzn.audio.sh \
    init.class_main.sh \
    init.crda.sh \
    init.mdm.sh \
    init.process_idmeflags.sh \
    init.qcom.audio.sh \
    init.qcom.bt.sh \
    init.qcom.class_core.sh \
    init.qcom.coex.sh \
    init.qcom.early_boot.sh \
    init.qcom.efs.sync.sh \
    init.qcom.factory.sh \
    init.qcom.modem_links.sh \
    init.qcom.post_boot.sh \
    init.qcom.sdio.sh \
    init.qcom.sensor.sh \
    init.qcom.sh \
    init.qcom.ssr.sh \
    init.qcom.syspart_fixup.sh \
    init.qcom.usb.sh \
    init.qcom.wifi.sh \
    init.ramdump_setup.sh \
    init.subsystem_restart.sh

ifeq ($(TARGET_HAS_LOCKED_BOOTLOADER),true)
$(warning Will use prebuilt boot image since TARGET_HAS_LOCKED_BOOTLOADER is set to true)
PRODUCT_PACKAGES += \
    2ndinit
endif

ifneq ($(filter eng userdebug,$(TARGET_BUILD_VARIANT)),)
ADDITIONAL_DEFAULT_PROPERTIES += \
    ro.adb.secure=0 \
    ro.secure=0
endif

# Inherit the proprietary files
$(call inherit-product-if-exists, vendor/amazon/kodiak/kodiak-vendor.mk)

# Inherit the prebuilt kernel files
$(call inherit-product-if-exists, device/amazon/kodiak-kernel/kernel.mk)
