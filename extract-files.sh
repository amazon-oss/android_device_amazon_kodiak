#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

DEVICE=kodiak
VENDOR=amazon

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

KANG=
SECTION=

while [ "${#}" -gt 0 ]; do
    case "${1}" in
        -n | --no-cleanup )
                CLEAN_VENDOR=false
                ;;
        -k | --kang )
                KANG="--kang"
                ;;
        -s | --section )
                SECTION="${2}"; shift
                CLEAN_VENDOR=false
                ;;
        * )
                SRC="${1}"
                ;;
    esac
    shift
done

if [ -z "${SRC}" ]; then
    SRC="adb"
fi

function blob_fixup() {
    case "${1}" in
        vendor/lib/libacdbloader.so|vendor/lib/libacdbrtac.so|vendor/lib/libadiertac.so|vendor/lib/libaudcal.so|vendor/lib/libdiag.so)
            "${PATCHELF}" --add-needed "libamazonlog.so" "${2}"
            ;;
        vendor/lib/libaudio-ExternalSpeakerAmps.so)
            sed -i "s|/etc/audio/speakers|/vendor/etc/speaker|g" "${2}"
            "${PATCHELF}" --add-needed "libamazonlog.so" "${2}"
            ;;
        vendor/lib/libmmcamera_imx132.so)
            sed -i "s/\x20\x43\x07\x01\x00\x00\x02/\x20\x43\x07\x01\x00\x00\x01/" "${2}"
            ;;
        vendor/lib/libmmcamera_imx135.so)
            sed -i "s/\x20\x43\x1f\x01/\x30\x42\x1f\x01/; s/dw9714\x00v/bu63164\x00/" "${2}"
            ;;
        vendor/lib/libmmcamera2_sensor_modules.so)
            sed -i "s/ov8865_q8v18a/imx135\x00\x00\x00\x00\x00\x00\x00/; s/ov2685/imx132/" "${2}"
            ;;
    esac
}

# Initialize the helper
setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}" false "${CLEAN_VENDOR}"

extract "${MY_DIR}/proprietary-files.txt" "${SRC}" "${KANG}" --section "${SECTION}"

"${MY_DIR}/setup-makefiles.sh"
