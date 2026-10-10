#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Rootdir
PRODUCT_PACKAGES += \
    fstab.qcom

# Inherit the proprietary files
$(call inherit-product, vendor/amazon/kodiak/kodiak-vendor.mk)
