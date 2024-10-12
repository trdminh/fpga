// Created with Corsair v1.0.4
#ifndef __GPIO_OUTPUT_REGS_H
#define __GPIO_OUTPUT_REGS_H

#define __I  volatile const // 'read only' permissions
#define __O  volatile       // 'write only' permissions
#define __IO volatile       // 'read / write' permissions


#ifdef __cplusplus
#include <cstdint>
extern "C" {
#else
#include <stdint.h>
#endif

#define GCSR_O_BASE_ADDR 0x40000000

// GPIO_0 - General Purpose Register for Output
#define GCSR_O_GPIO_0_ADDR 0x0
#define GCSR_O_GPIO_0_RESET 0x0
typedef struct {
    uint32_t DATA_OUT : 16; // Data to send to GPIO outputs (e.g., LEDs)
    uint32_t : 16; // reserved
} gcsr_o_gpio_0_t;

// GPIO_0.DATA_OUT - Data to send to GPIO outputs (e.g., LEDs)
#define GCSR_O_GPIO_0_DATA_OUT_WIDTH 16
#define GCSR_O_GPIO_0_DATA_OUT_LSB 0
#define GCSR_O_GPIO_0_DATA_OUT_MASK 0xffff
#define GCSR_O_GPIO_0_DATA_OUT_RESET 0x0


// Register map structure
typedef struct {
    union {
        __IO uint32_t GPIO_0; // General Purpose Register for Output
        __IO gcsr_o_gpio_0_t GPIO_0_bf; // Bit access for GPIO_0 register
    };
} gcsr_o_t;

#define GCSR_O ((gcsr_o_t*)(GCSR_O_BASE_ADDR))

#ifdef __cplusplus
}
#endif

#endif /* __GPIO_OUTPUT_REGS_H */