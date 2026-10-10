/*
 * SPDX-FileCopyrightText: The LineageOS Project
 * SPDX-License-Identifier: Apache-2.0
 */

#include <dlfcn.h>
#include <stddef.h>

static void* af_algo_open_lib(const char* lib, const char* sym) {
    void* handle = dlopen(lib, RTLD_NOW);
    void* (*open_lib)(void);

    if (!handle) return NULL;

    open_lib = (void* (*)(void))dlsym(handle, sym);
    return open_lib ? open_lib() : NULL;
}

void* bu63164_camera_af_algo_open_lib(void) {
    return af_algo_open_lib("libactuator_rohm_bu64243gwz_camera.so",
                            "rohm_bu64243gwz_camera_af_algo_open_lib");
}

void* bu63164_camcorder_af_algo_open_lib(void) {
    return af_algo_open_lib("libactuator_rohm_bu64243gwz_camcorder.so",
                            "ROHM_BU64243GWZ_camcorder_af_algo_open_lib");
}
