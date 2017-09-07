# Copyright (c) 2016 Princeton University
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of Princeton University nor the
#       names of its contributors may be used to endorse or promote products
#       derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY PRINCETON UNIVERSITY "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL PRINCETON UNIVERSITY BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


# Allow unconstrained pins
set_property BITSTREAM.General.UnconstrainedPins {Allow} [current_design]

# Set DCI cascade
set_property slave_banks {34} [get_iobanks 33]

# False paths
set_false_path -to [get_cells -hierarchical *afifo_ui_rst_r*]
set_false_path -to [get_cells -hierarchical *ui_clk_sync_rst_r*]
set_false_path -to [get_cells -hierarchical *ui_clk_syn_rst_delayed*]
set_false_path -to [get_cells -hierarchical *init_calib_complete_f*]

set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets chipset/clk_mmcm/inst/clk_in1_clk_mmcm]
set_clock_groups -name sync_gr1 -logically_exclusive -group [get_clocks chipset_clk_clk_mmcm] -group [get_clocks -include_generated_clocks mc_sys_clk_clk_mmcm]

############################### PIN ARRANGEMENT ################################
#
# |---------------------------------------|
# |       SIGNAL       |      BOARD       |
# |---------------------------------------|
# | chipset_clk_osc_p  |  SYSCLK_P        |
# | chipset_clk_osc_p  |  SYSCLK_N        |
# |--------------------|------------------|
# | sys_rst_n          |  PL_CPU_RESET    |
# |--------------------|------------------|
# | sw[0]              |  NONE            |
# | sw[1]              |  NONE            |
# | sw[2]              |  NONE            |
# | sw[3]              |  NONE            |
# | sw[4]              |  NONE            |
# | sw[5]              |  NONE            |
# | sw[6]              |  GPIO_DIP_SW2    |
# | sw[7]              |  GPIO_DIP_SW3    |
# |--------------------|------------------|
# | leds[0]            |  GPIO_LED_LEFT   |
# | leds[1]            |  GPIO_LED_CENTER |
# | leds[2]            |  GPIO_LED_RIGHT  |
# | leds[3]            |  NONE            |
# | leds[4]            |  NONE            |
# | leds[5]            |  GPIO_LED_0      |
# | leds[6]            |  NONE            |
# | leds[7]            |  NONE            |
# |--------------------|------------------|
# | sd_spi_cs          |  PMOD1_0_LS      |
# | sd_spi_mosi        |  PMOD1_1_LS      |
# | sd_spi_sck         |  PMOD1_2_LS      |
# | sd_spi_miso        |  PMOD1_3_LS      |
# |--------------------|------------------|
# | uart_rx            |  PMOD1_6_LS      |
# | uart_tx            |  PMOD1_7_LS      |
# |---------------------------------------|
#
#
# Clock signals
set_property -dict {PACKAGE_PIN H9 IOSTANDARD LVDS} [get_ports {chipset_clk_osc_p}]
set_property -dict {PACKAGE_PIN G9 IOSTANDARD LVDS} [get_ports {chipset_clk_osc_n}]
# Reset
set_property -dict {PACKAGE_PIN A8 IOSTANDARD LVCMOS15} [get_ports {sys_rst_n}]
# Switches
set_property IO_BUFFER_TYPE none [get_ports sw[0]]
set_property IO_BUFFER_TYPE none [get_ports sw[1]]
set_property IO_BUFFER_TYPE none [get_ports sw[2]]
set_property IO_BUFFER_TYPE none [get_ports sw[3]]
set_property IO_BUFFER_TYPE none [get_ports sw[4]]
set_property IO_BUFFER_TYPE none [get_ports sw[5]]
set_property -dict {PACKAGE_PIN AC17 IOSTANDARD LVCMOS25} [get_ports {sw[6]}]
set_property -dict {PACKAGE_PIN AJ13 IOSTANDARD LVCMOS25} [get_ports {sw[7]}]
# LEDs
set_property -dict {PACKAGE_PIN Y21  IOSTANDARD LVCMOS25} [get_ports {leds[0]}]
set_property -dict {PACKAGE_PIN G2   IOSTANDARD LVCMOS15} [get_ports {leds[1]}]
set_property -dict {PACKAGE_PIN W21  IOSTANDARD LVCMOS25} [get_ports {leds[2]}]
set_property IO_BUFFER_TYPE none [get_ports leds[3]]
set_property IO_BUFFER_TYPE none [get_ports leds[4]]
set_property -dict {PACKAGE_PIN A17  IOSTANDARD LVCMOS15} [get_ports {leds[5]}]
set_property IO_BUFFER_TYPE none [get_ports leds[6]]
set_property IO_BUFFER_TYPE none [get_ports leds[7]]
# SD
set_property -dict {PACKAGE_PIN AJ21 IOSTANDARD LVCMOS25} [get_ports {spi_cs_n}]
set_property -dict {PACKAGE_PIN AK21 IOSTANDARD LVCMOS25} [get_ports {spi_data_out}]
set_property -dict {PACKAGE_PIN AB21 IOSTANDARD LVCMOS25} [get_ports {spi_clk_out}]
set_property -dict {PACKAGE_PIN AB16 IOSTANDARD LVCMOS25} [get_ports {spi_data_in}]
# UART
set_property -dict {PACKAGE_PIN AC18 IOSTANDARD LVCMOS25} [get_ports {uart_rx}]
set_property -dict {PACKAGE_PIN AC19 IOSTANDARD LVCMOS25} [get_ports {uart_tx}]
