#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Display
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xhdpi

PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.composer@2.1-service \
    android.hardware.graphics.mapper@2.0-impl-2.1 \
    android.hardware.memtrack@1.0-impl \
    android.hardware.memtrack@1.0-service \
    gralloc.msm8974 \
    hwcomposer.msm8974 \
    liboverlay \
    libtinyxml \
    memtrack.msm8974

TARGET_SCREEN_HEIGHT := 1280
TARGET_SCREEN_WIDTH := 720

# Gatekeeper
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0-service.software

# HIDL
PRODUCT_ENFORCE_VINTF_MANIFEST_OVERRIDE := true

# Keylayout
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/keylayout/gpio-keys.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/gpio-keys.kl

# Keymaster
PRODUCT_PACKAGES += \
    android.hardware.keymaster@3.0-impl \
    android.hardware.keymaster@3.0-service

# Overlays
DEVICE_PACKAGE_OVERLAYS += \
    $(LOCAL_PATH)/overlay \
    $(LOCAL_PATH)/overlay-lineage

# Rootdir
PRODUCT_PACKAGES += \
    fstab.qcom \
    init.qcom.power.rc \
    init.qcom.rc \
    init.qcom.usb.rc \
    init.recovery.qcom.rc \
    ueventd.qcom.rc

# Inherit the proprietary files
$(call inherit-product, vendor/amazon/kodiak/kodiak-vendor.mk)
