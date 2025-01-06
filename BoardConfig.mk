#
# Copyright (C) 2025 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/amazon/kodiak

# Architecture
TARGET_ARCH := arm
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_CPU_VARIANT := krait

# Inherit the prebuilt kernel files
include device/amazon/kodiak-kernel/BoardConfigKernel.mk

# Inherit the proprietary files
-include vendor/amazon/kodiak/BoardConfigVendor.mk
