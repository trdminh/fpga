// Created with Corsair v1.0.4
#ifndef __GPIO_INPUT_REGS_H
#define __GPIO_INPUT_REGS_H

#define __I  volatile const // 'read only' permissions
#define __O  volatile       // 'write only' permissions
#define __IO volatile       // 'read / write' permissions


#ifdef __cplusplus
#include <cstdint>
extern "C" {
#else
#include <stdint.h>
#endif

#define GCSR_I_BASE_ADDR 0x40000000

// GPIO_1 - General Purpose Register for Output
#define GCSR_I_GPIO_1_ADDR 0x0
#define GCSR_I_GPIO_1_RESET 0x0
typedef struct {
    uint32_t : 16; // reserved
    uint32_t DATA_IN : 16; // Data from GPIO inputs (e.g., switches)
} gcsr_i_gpio_1_t;

// GPIO_1.DATA_IN - Data from GPIO inputs (e.g., switches)
#define GCSR_I_GPIO_1_DATA_IN_WIDTH 16
#define GCSR_I_GPIO_1_DATA_IN_LSB 16
#define GCSR_I_GPIO_1_DATA_IN_MASK 0xffff0000
#define GCSR_I_GPIO_1_DATA_IN_RESET 0x0


// Register map structure
typedef struct {
    union {
        __I uint32_t GPIO_1; // General Purpose Register for Output
        __I gcsr_i_gpio_1_t GPIO_1_bf; // Bit access for GPIO_1 register
    };
} gcsr_i_t;

#define GCSR_I ((gcsr_i_t*)(GCSR_I_BASE_ADDR))

#ifdef __cplusplus
}
#endif

#endif /* __GPIO_INPUT_REGS_H */