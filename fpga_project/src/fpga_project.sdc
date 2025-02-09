//Copyright (C)2014-2024 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//Tool Version: V1.9.10 (64-bit) 
//Created Time: 2024-10-08 16:36:32
create_clock -name MAIN_CLK -period 37.037 -waveform {0 18.518} [get_ports {clk_in}]
create_clock -name PLL_CLK -period 33.333 -waveform {0 16.666} [get_nets {clk}]
