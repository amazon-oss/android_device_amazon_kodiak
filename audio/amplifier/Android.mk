#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := audio_amplifier.$(TARGET_BOARD_PLATFORM)
LOCAL_MODULE_RELATIVE_PATH := hw
LOCAL_VENDOR_MODULE := true

LOCAL_SRC_FILES := audio_amplifier.c

LOCAL_C_INCLUDES := \
    $(call project-path-for,qcom-audio)/hal \
    $(call project-path-for,qcom-audio)/hal/msm8974

LOCAL_HEADER_LIBRARIES := \
    generated_kernel_headers \
    libhardware_headers

LOCAL_SHARED_LIBRARIES := \
    libaudio-ExternalSpeakerAmps \
    libcutils \
    liblog

include $(BUILD_SHARED_LIBRARY)
