/*
 * SPDX-FileCopyrightText: The LineageOS Project
 * SPDX-License-Identifier: Apache-2.0
 */

#define LOG_TAG "audio_amplifier"

#include <errno.h>
#include <pthread.h>
#include <stdlib.h>
#include <string.h>

#include <log/log.h>

#include <hardware/audio_amplifier.h>
#include <hardware/hardware.h>

#include <platform.h>

extern int ext_spkr_amps_init(void);
extern int ext_spkr_amps_enable(void);
extern int ext_spkr_amps_disable(void);
extern int ext_spkr_amps_set_use_case(const char *use_case);

typedef struct amp_device {
    amplifier_device_t amp_dev;
    pthread_mutex_t lock;
    pthread_t thread;
    bool thread_running;
    const char *use_case;
} amp_device_t;

static bool is_speaker(uint32_t snd_device)
{
    switch (snd_device) {
        case SND_DEVICE_OUT_SPEAKER:
        case SND_DEVICE_OUT_SPEAKER_REVERSE:
        case SND_DEVICE_OUT_SPEAKER_AND_HEADPHONES:
        case SND_DEVICE_OUT_SPEAKER_AND_LINE:
        case SND_DEVICE_OUT_VOICE_SPEAKER:
        case SND_DEVICE_OUT_SPEAKER_AND_HDMI:
        case SND_DEVICE_OUT_SPEAKER_AND_USB_HEADSET:
        case SND_DEVICE_OUT_SPEAKER_AND_ANC_HEADSET:
        case SND_DEVICE_OUT_SPEAKER_PROTECTED:
        case SND_DEVICE_OUT_VOIP_SPEAKER:
            return true;
        default:
            return false;
    }
}

static bool is_voice(uint32_t snd_device)
{
    return snd_device == SND_DEVICE_OUT_VOICE_SPEAKER ||
           snd_device == SND_DEVICE_OUT_VOIP_SPEAKER;
}

static void *amp_startup_thread(void *data)
{
    amp_device_t *amp = data;

    pthread_mutex_lock(&amp->lock);
    ext_spkr_amps_init();
    ext_spkr_amps_enable();
    ext_spkr_amps_set_use_case(amp->use_case);
    pthread_mutex_unlock(&amp->lock);

    return NULL;
}

static int amp_enable_output_devices(amplifier_device_t *device,
        uint32_t devices, bool enable)
{
    amp_device_t *amp = (amp_device_t *) device;

    if (!is_speaker(devices))
        return 0;

    if (amp->thread_running) {
        pthread_join(amp->thread, NULL);
        amp->thread_running = false;
    }

    if (enable) {
        amp->use_case = is_voice(devices) ? "voice" : "music";
        if (pthread_create(&amp->thread, NULL, amp_startup_thread, amp)) {
            ALOGE("%s: failed to start the amplifiers", __func__);
            return -ENOMEM;
        }
        amp->thread_running = true;
    } else {
        pthread_mutex_lock(&amp->lock);
        ext_spkr_amps_disable();
        pthread_mutex_unlock(&amp->lock);
    }

    return 0;
}

static int amp_dev_close(hw_device_t *device)
{
    amp_device_t *amp = (amp_device_t *) device;

    if (amp->thread_running)
        pthread_join(amp->thread, NULL);

    pthread_mutex_destroy(&amp->lock);
    free(amp);

    return 0;
}

static int amp_module_open(const hw_module_t *module, const char *name,
        hw_device_t **device)
{
    amp_device_t *amp;

    if (strcmp(name, AMPLIFIER_HARDWARE_INTERFACE)) {
        ALOGE("%s: %s does not match amplifier hardware interface name",
                __func__, name);
        return -ENODEV;
    }

    amp = calloc(1, sizeof(amp_device_t));
    if (!amp) {
        ALOGE("%s: unable to allocate memory for amplifier device", __func__);
        return -ENOMEM;
    }

    amp->amp_dev.common.tag = HARDWARE_DEVICE_TAG;
    amp->amp_dev.common.module = (hw_module_t *) module;
    amp->amp_dev.common.version = AMPLIFIER_DEVICE_API_VERSION_CURRENT;
    amp->amp_dev.common.close = amp_dev_close;
    amp->amp_dev.enable_output_devices = amp_enable_output_devices;

    pthread_mutex_init(&amp->lock, NULL);

    *device = (hw_device_t *) amp;

    return 0;
}

static struct hw_module_methods_t hal_module_methods = {
    .open = amp_module_open,
};

amplifier_module_t HAL_MODULE_INFO_SYM = {
    .common = {
        .tag = HARDWARE_MODULE_TAG,
        .module_api_version = AMPLIFIER_MODULE_API_VERSION_0_1,
        .hal_api_version = HARDWARE_HAL_API_VERSION,
        .id = AMPLIFIER_HARDWARE_MODULE_ID,
        .name = "Kodiak audio amplifier HAL",
        .author = "The LineageOS Project",
        .methods = &hal_module_methods,
    },
};
