#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/product_launched_with_k.mk)

# Inherit from device makefile.
$(call inherit-product, device/amazon/kodiak/device.mk)

# Inherit some common LineageOS stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

PRODUCT_NAME := lineage_kodiak
PRODUCT_DEVICE := kodiak
PRODUCT_BRAND := google
PRODUCT_MANUFACTURER := Amazon
PRODUCT_MODEL := Fire Phone

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="juniper-user 4.4.4 KTU84P 35.4.6.6_user_466001420 release-keys" \
    PRODUCT_NAME=juniper

BUILD_FINGERPRINT := Amazon/juniper/kodiak:4.4.4/KTU84P/35.4.6.6_user_466001420:user/release-keys
