#include <stdint.h>
#include <stdlib.h>
#include <gpio_regs.h>
#include <uart_regs.h>

void uart_send_char(uint8_t my_char);
void uart_send_str(uint8_t *my_str);
void delay_short();
void delay_long();
void delay(uint64_t time);

int main()
{

    uart_send_str("Start\n");

    GCSR->GPIO_0 = 0x00; 

    uint8_t mask = 0xff; 
    while (1)
    {
        
        GCSR->GPIO_0 = mask; 
        uart_send_str("Stand up!");
        delay(2);
        GCSR->GPIO_0 = ~mask;
        uart_send_str("Sit down!");
        delay(2);
    }
}

void uart_send_char(uint8_t my_char)
{
    while (UCSR->U_STAT_bf.READY == 0)
        ;
    UCSR->U_DATA = my_char;
    UCSR->U_CTRL_bf.START = 1;
}

void uart_send_str(uint8_t *my_str)
{

    for (uint8_t i = 0; my_str[i] != '\0'; i++)
    {
        uart_send_char(my_str[i]);
    }
}

// assume 5 cycles per empty loop iteration
// assume the clock is 12 MHz, 83.33 ns per clock period
// for 0.5 sec delay we need 6 million cycles
// this means we need 1.2 million iteration

void delay_long()
{

    for (uint64_t i = 0; i < 1000000 / 5; i++)
        ;
}

void delay_short()
{

    for (uint64_t i = 0; i < 1; i++)
        ;
}

void delay(uint64_t time)
{
    for (uint64_t i = 0; i < time; i++)
    {
        delay_long();
    }
        
}