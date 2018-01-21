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

# This file is a general .xdc for the Nexys4 DDR Rev. C
# To use it in a project:
# - uncomment the lines corresponding to used pins
# - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

# Clock signal
set_property IOSTANDARD LVDS [get_ports chipset_clk_osc_p]
set_property PACKAGE_PIN E19 [get_ports chipset_clk_osc_p]
set_property PACKAGE_PIN E18 [get_ports chipset_clk_osc_n]
set_property IOSTANDARD LVDS [get_ports chipset_clk_osc_n]

set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets chipset/clk_mmcm/inst/clk_in1_clk_mmcm]

# Reset
set_property IOSTANDARD LVCMOS18 [get_ports sys_rst_n]
set_property PACKAGE_PIN AV40 [get_ports sys_rst_n]

# False paths
set_false_path -to [get_cells -hierarchical *afifo_ui_rst_r*]
set_false_path -to [get_cells -hierarchical *ui_clk_sync_rst_r*]
set_false_path -to [get_cells -hierarchical *ui_clk_syn_rst_delayed*]
set_false_path -to [get_cells -hierarchical *init_calib_complete_f*]
set_false_path -from [get_clocks chipset_clk_clk_mmcm] -to [get_clocks net_axi_clk_clk_mmcm]

set_clock_groups -name sync_gr1 -logically_exclusive -group chipset_clk_clk_mmcm -group [get_clocks -include_generated_clocks mc_sys_clk_clk_mmcm]

# UART
#IO_L11N_T1_SRCC_35 Sch=uart_rxd_out
set_property IOSTANDARD LVCMOS18 [get_ports uart_tx]
set_property PACKAGE_PIN AU36 [get_ports uart_tx]
set_property IOSTANDARD LVCMOS18 [get_ports uart_rx]
set_property PACKAGE_PIN AU33 [get_ports uart_rx]

# Switches
set_property PACKAGE_PIN AV30 [get_ports sw[0]]
set_property IOSTANDARD LVCMOS18 [get_ports sw[0]]
set_property PACKAGE_PIN AY33 [get_ports sw[1]]
set_property IOSTANDARD LVCMOS18 [get_ports sw[1]]
set_property PACKAGE_PIN BA31 [get_ports sw[2]]
set_property IOSTANDARD LVCMOS18 [get_ports sw[2]]
set_property PACKAGE_PIN BA32 [get_ports sw[3]]
set_property IOSTANDARD LVCMOS18 [get_ports sw[3]]
set_property PACKAGE_PIN AW30 [get_ports sw[4]]
set_property IOSTANDARD LVCMOS18 [get_ports sw[4]]
set_property PACKAGE_PIN AY30 [get_ports sw[5]]
set_property IOSTANDARD LVCMOS18 [get_ports sw[5]]
set_property PACKAGE_PIN BA30 [get_ports sw[6]]
set_property IOSTANDARD LVCMOS18 [get_ports sw[6]]
set_property PACKAGE_PIN BB31 [get_ports sw[7]]
set_property IOSTANDARD LVCMOS18 [get_ports sw[7]]

# SD
set_property IOSTANDARD LVCMOS18 [get_ports sd_clk_out]
set_property PACKAGE_PIN AN30 [get_ports sd_clk_out]
set_property IOSTANDARD LVCMOS18 [get_ports sd_cmd]
set_property PACKAGE_PIN AP30 [get_ports sd_cmd]
set_property IOSTANDARD LVCMOS18 [get_ports sd_dat[0]]
set_property PACKAGE_PIN AR30 [get_ports sd_dat[0]]
set_property IOSTANDARD LVCMOS18 [get_ports sd_dat[1]]
set_property PACKAGE_PIN AU31 [get_ports sd_dat[1]]
set_property IOSTANDARD LVCMOS18 [get_ports sd_dat[2]]
set_property PACKAGE_PIN AV31 [get_ports sd_dat[2]]
set_property IOSTANDARD LVCMOS18 [get_ports sd_dat[3]]
set_property PACKAGE_PIN AT30 [get_ports sd_dat[3]]
# set_property IOSTANDARD LVCMOS18 [get_ports sd_cd]
# set_property PACKAGE_PIN AP32 [get_ports sd_cd]

#set_property PACKAGE_PIN AV30 [get_ports uart_lb_sw]
#set_property IOSTANDARD LVCMOS18 [get_ports uart_lb_sw]

## LEDs

set_property PACKAGE_PIN AM39 [get_ports leds[0]]
set_property IOSTANDARD LVCMOS18 [get_ports leds[0]]
set_property PACKAGE_PIN AN39 [get_ports leds[1]]
set_property IOSTANDARD LVCMOS18 [get_ports leds[1]]
set_property PACKAGE_PIN AR37 [get_ports leds[2]]
set_property IOSTANDARD LVCMOS18 [get_ports leds[2]]
set_property PACKAGE_PIN AT37 [get_ports leds[3]]
set_property IOSTANDARD LVCMOS18 [get_ports leds[3]]
set_property PACKAGE_PIN AR35 [get_ports leds[4]]
set_property IOSTANDARD LVCMOS18 [get_ports leds[4]]
set_property PACKAGE_PIN AP41 [get_ports leds[5]]
set_property IOSTANDARD LVCMOS18 [get_ports leds[5]]
set_property PACKAGE_PIN AP42 [get_ports leds[6]]
set_property IOSTANDARD LVCMOS18 [get_ports leds[6]]
set_property PACKAGE_PIN AU39 [get_ports leds[7]]
set_property IOSTANDARD LVCMOS18 [get_ports leds[7]]

#############################################
# SD Card Constraints for 25MHz
#############################################
create_generated_clock -name sd_fast_clk -source [get_pins chipset/clk_mmcm/sd_sys_clk] -divide_by 2 [get_pins chipset/chipset_impl/io_ctrl_top/piton_sd_top/sdc_controller/clock_divider0/fast_clk_reg/Q]
create_generated_clock -name sd_slow_clk -source [get_pins chipset/clk_mmcm/sd_sys_clk] -divide_by 200 [get_pins chipset/chipset_impl/io_ctrl_top/piton_sd_top/sdc_controller/clock_divider0/slow_clk_reg/Q]
create_generated_clock -name sd_clk_out -source [get_pins chipset/sd_clk_oddr/C] -divide_by 1 -add -master_clock sd_fast_clk [get_ports sd_clk_out]
create_generated_clock -name sd_clk_out_1 -source [get_pins chipset/sd_clk_oddr/C] -divide_by 1 -add -master_clock sd_slow_clk [get_ports sd_clk_out]
create_clock -period 40.000 -name VIRTUAL_sd_fast_clk -waveform {0.000 20.000}
create_clock -period 4000.000 -name VIRTUAL_sd_slow_clk -waveform {0.000 2000.000}
set_output_delay -clock [get_clocks sd_clk_out] -min -add_delay 5.000 [get_ports {sd_dat[*]}]
set_output_delay -clock [get_clocks sd_clk_out] -max -add_delay 15.000 [get_ports {sd_dat[*]}]
set_output_delay -clock [get_clocks sd_clk_out_1] -min -add_delay 5.000 [get_ports {sd_dat[*]}]
set_output_delay -clock [get_clocks sd_clk_out_1] -max -add_delay 1500.000 [get_ports {sd_dat[*]}]
set_output_delay -clock [get_clocks sd_clk_out] -min -add_delay 5.000 [get_ports sd_cmd]
set_output_delay -clock [get_clocks sd_clk_out] -max -add_delay 15.000 [get_ports sd_cmd]
set_output_delay -clock [get_clocks sd_clk_out_1] -min -add_delay 5.000 [get_ports sd_cmd]
set_output_delay -clock [get_clocks sd_clk_out_1] -max -add_delay 1500.000 [get_ports sd_cmd]
set_input_delay -clock [get_clocks VIRTUAL_sd_fast_clk] -min -add_delay 20.000 [get_ports {sd_dat[*]}]
set_input_delay -clock [get_clocks VIRTUAL_sd_fast_clk] -max -add_delay 35.000 [get_ports {sd_dat[*]}]
set_input_delay -clock [get_clocks VIRTUAL_sd_slow_clk] -min -add_delay 2000.000 [get_ports {sd_dat[*]}]
set_input_delay -clock [get_clocks VIRTUAL_sd_slow_clk] -max -add_delay 3500.000 [get_ports {sd_dat[*]}]
set_input_delay -clock [get_clocks VIRTUAL_sd_fast_clk] -min -add_delay 20.000 [get_ports sd_cmd]
set_input_delay -clock [get_clocks VIRTUAL_sd_fast_clk] -max -add_delay 35.000 [get_ports sd_cmd]
set_input_delay -clock [get_clocks VIRTUAL_sd_slow_clk] -min -add_delay 2000.000 [get_ports sd_cmd]
set_input_delay -clock [get_clocks VIRTUAL_sd_slow_clk] -max -add_delay 3500.000 [get_ports sd_cmd]
set_clock_groups -physically_exclusive -group [get_clocks -include_generated_clocks sd_clk_out] -group [get_clocks -include_generated_clocks sd_clk_out_1]
set_clock_groups -logically_exclusive -group [get_clocks -include_generated_clocks {VIRTUAL_sd_fast_clk sd_fast_clk}] -group [get_clocks -include_generated_clocks {sd_slow_clk VIRTUAL_sd_slow_clk}]
set_clock_groups -asynchronous -group [get_clocks [list [get_clocks -of_objects [get_pins chipset/clk_mmcm/inst/mmcm_adv_inst/CLKOUT0]]]] -group [get_clocks -filter { NAME =~  "*sd*" }]
