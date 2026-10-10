/*
 * SPDX-FileCopyrightText: The LineageOS Project
 * SPDX-License-Identifier: Apache-2.0
 */

#include <stdint.h>

#define MAX_ACT_MOD_NAME_SIZE 32
#define MAX_ACT_NAME_SIZE 32
#define MAX_ACTUATOR_REG_TBL_SIZE 8
#define MAX_ACTUATOR_INIT_SET 12
#define MAX_ACTUATOR_SCENARIO 8
#define MAX_ACTUATOR_REGION 5
#define NUM_ACTUATOR_DIR 2

#define MSM_ACTUATOR_BYTE_ADDR 1
#define MSM_ACTUATOR_BYTE_DATA 1
#define MSM_ACTUATOR_WRITE_HW_DAMP 0
#define MSM_ACTUATOR_WRITE_DAC 1
#define MSM_ACT_WRITE 0
#define ACTUATOR_OIS 2

struct msm_actuator_reg_params_t {
    uint32_t reg_write_type;
    uint32_t hw_mask;
    uint16_t reg_addr;
    uint16_t hw_shift;
    uint16_t data_shift;
};

struct reg_settings_t {
    uint16_t reg_addr;
    uint32_t addr_type;
    uint16_t reg_data;
    uint32_t data_type;
    uint32_t i2c_operation;
    uint32_t delay;
};

struct region_params_t {
    uint16_t step_bound[2];
    uint16_t code_per_step;
};

struct damping_params_t {
    uint32_t damping_step;
    uint32_t damping_delay;
    uint32_t hw_params;
};

struct actuator_driver_params_t {
    char module_name[MAX_ACT_MOD_NAME_SIZE];
    char actuator_name[MAX_ACT_NAME_SIZE];
    uint32_t i2c_addr;
    uint32_t i2c_data_type;
    uint32_t i2c_addr_type;
    uint32_t act_type;
    uint16_t data_size;
    uint8_t reserved0;
    uint8_t reg_tbl_size;
    struct msm_actuator_reg_params_t reg_params[MAX_ACTUATOR_REG_TBL_SIZE];
    uint8_t reserved1[3];
    uint16_t init_setting_size;
    struct reg_settings_t init_settings[MAX_ACTUATOR_INIT_SET];
    uint8_t reserved2[3];
    uint16_t scenario_size[NUM_ACTUATOR_DIR];
    uint16_t ringing_scenario[NUM_ACTUATOR_DIR][MAX_ACTUATOR_SCENARIO];
    int16_t initial_code;
    uint16_t region_size;
    struct region_params_t region_params[MAX_ACTUATOR_REGION];
    struct damping_params_t damping[NUM_ACTUATOR_DIR][MAX_ACTUATOR_SCENARIO][MAX_ACTUATOR_REGION];
    uint8_t reserved3[2];
} __attribute__((packed));

_Static_assert(sizeof(struct actuator_driver_params_t) == 0x604, "actuator_driver_params_t size");

static struct actuator_driver_params_t actuator_lib_ptr = {
    .module_name = "Rohm",
    .actuator_name = "bu63164",
    .i2c_addr = 0x1c,
    .i2c_data_type = MSM_ACTUATOR_BYTE_DATA,
    .i2c_addr_type = MSM_ACTUATOR_BYTE_ADDR,
    .act_type = ACTUATOR_OIS,
    .data_size = 10,
    .reg_tbl_size = 3,
    .reg_params = {
        { .reg_write_type = MSM_ACTUATOR_WRITE_HW_DAMP, .hw_mask = 0xff, .reg_addr = 0xf0 },
        { .reg_write_type = MSM_ACTUATOR_WRITE_DAC, .reg_addr = 0xf3 },
        { .reg_write_type = MSM_ACTUATOR_WRITE_DAC, .reg_addr = 0xf2 },
    },
    .init_setting_size = 1,
    .init_settings = {
        { 0x8c, MSM_ACTUATOR_BYTE_ADDR, 0x01, MSM_ACTUATOR_BYTE_DATA, MSM_ACT_WRITE, 0 },
    },
    .scenario_size = { 1, 1 },
    .ringing_scenario = { { 423 }, { 423 } },
    .initial_code = 80,
    .region_size = 1,
    .region_params = {
        { .step_bound = { 423, 0 }, .code_per_step = 2 },
    },
    .damping = {
        { { { 1023, 7000, 0xb0 } } },
        { { { 1023, 7000, 0xb0 } } },
    },
};

void* actuator_driver_open_lib(void) {
    return &actuator_lib_ptr;
}
