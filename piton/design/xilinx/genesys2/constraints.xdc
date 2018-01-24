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

# Clock signals
set_property IOSTANDARD LVDS [get_ports chipset_clk_osc_p]
set_property PACKAGE_PIN AD12 [get_ports chipset_clk_osc_p]
set_property PACKAGE_PIN AD11 [get_ports chipset_clk_osc_n]
set_property IOSTANDARD LVDS [get_ports chipset_clk_osc_n]

set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets chipset/clk_mmcm/inst/clk_in1_clk_mmcm]



# Reset
set_property IOSTANDARD LVCMOS33 [get_ports sys_rst_n]
set_property PACKAGE_PIN R19 [get_ports sys_rst_n]

# False paths
set_false_path -to [get_cells -hierarchical *afifo_ui_rst_r*]
set_false_path -to [get_cells -hierarchical *ui_clk_sync_rst_r*]
set_false_path -to [get_cells -hierarchical *ui_clk_syn_rst_delayed*]
set_false_path -to [get_cells -hierarchical *init_calib_complete_f*]
set_false_path -from [get_clocks chipset_clk_clk_mmcm] -to [get_clocks net_axi_clk_clk_mmcm]


#### UART
#IO_L11N_T1_SRCC_35 Sch=uart_rxd_out
set_property IOSTANDARD LVCMOS33 [get_ports uart_rx]
set_property PACKAGE_PIN Y20 [get_ports uart_rx]
set_property IOSTANDARD LVCMOS33 [get_ports uart_tx]
set_property PACKAGE_PIN Y23 [get_ports uart_tx]

# Switches
set_property IOSTANDARD LVCMOS33 [get_ports {sw[7]}]
set_property PACKAGE_PIN P27 [get_ports {sw[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[6]}]
set_property PACKAGE_PIN P26 [get_ports {sw[6]}]
set_property IOSTANDARD LVCMOS12 [get_ports {sw[5]}]
set_property PACKAGE_PIN P19 [get_ports {sw[5]}]
set_property IOSTANDARD LVCMOS12 [get_ports {sw[4]}]
set_property PACKAGE_PIN N19 [get_ports {sw[4]}]
set_property IOSTANDARD LVCMOS12 [get_ports {sw[3]}]
set_property PACKAGE_PIN K19 [get_ports {sw[3]}]
set_property IOSTANDARD LVCMOS12 [get_ports {sw[2]}]
set_property PACKAGE_PIN H24 [get_ports {sw[2]}]
set_property IOSTANDARD LVCMOS12 [get_ports {sw[1]}]
set_property PACKAGE_PIN G25 [get_ports {sw[1]}]
set_property IOSTANDARD LVCMOS12 [get_ports {sw[0]}]
set_property PACKAGE_PIN G19 [get_ports {sw[0]}]

# Loopback control for UART
#set_property IOSTANDARD LVCMOS12 [get_ports uart_lb_sw]
#set_property PACKAGE_PIN G19 [get_ports uart_lb_sw]

# Soft reset
#set_property IOSTANDARD LVCMOS12 [get_ports pin_soft_rst]
#set_property PACKAGE_PIN E18 [get_ports pin_soft_rst]

# SD
set_property IOSTANDARD LVCMOS33 [get_ports sd_clk_out]
set_property PACKAGE_PIN R28 [get_ports sd_clk_out]
set_property IOSTANDARD LVCMOS33 [get_ports sd_cmd]
set_property PACKAGE_PIN R29 [get_ports sd_cmd]
set_property IOSTANDARD LVCMOS33 [get_ports {sd_dat[0]}]
set_property PACKAGE_PIN R26 [get_ports {sd_dat[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sd_dat[1]}]
set_property PACKAGE_PIN R30 [get_ports {sd_dat[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sd_dat[2]}]
set_property PACKAGE_PIN P29 [get_ports {sd_dat[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sd_dat[3]}]
set_property PACKAGE_PIN T30 [get_ports {sd_dat[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports sd_reset]
set_property PACKAGE_PIN AE24 [get_ports sd_reset]
set_property IOSTANDARD LVCMOS33 [get_ports sd_cd]
set_property PACKAGE_PIN P28 [get_ports sd_cd]


## LEDs

set_property PACKAGE_PIN T28 [get_ports {leds[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[0]}]
set_property PACKAGE_PIN V19 [get_ports {leds[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[1]}]
set_property PACKAGE_PIN U30 [get_ports {leds[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[2]}]
set_property PACKAGE_PIN U29 [get_ports {leds[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[3]}]
set_property PACKAGE_PIN V20 [get_ports {leds[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[4]}]
set_property PACKAGE_PIN V26 [get_ports {leds[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[5]}]
set_property PACKAGE_PIN W24 [get_ports {leds[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[6]}]
set_property PACKAGE_PIN W23 [get_ports {leds[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[7]}]


## OLED
set_property -dict {PACKAGE_PIN AC17 IOSTANDARD LVCMOS18} [get_ports oled_dc]
set_property -dict {PACKAGE_PIN AB17 IOSTANDARD LVCMOS18} [get_ports oled_rst_n]
set_property -dict {PACKAGE_PIN AF17 IOSTANDARD LVCMOS18} [get_ports oled_sclk]
set_property -dict {PACKAGE_PIN Y15 IOSTANDARD LVCMOS18} [get_ports oled_data]
set_property -dict {PACKAGE_PIN AB22 IOSTANDARD LVCMOS33} [get_ports oled_vbat_n]
set_property -dict {PACKAGE_PIN AG17 IOSTANDARD LVCMOS18} [get_ports oled_vdd_n]

## Buttons
set_property PACKAGE_PIN M20 [get_ports btnl]
set_property IOSTANDARD LVCMOS12 [get_ports btnl]
set_property PACKAGE_PIN C19 [get_ports btnr]
set_property IOSTANDARD LVCMOS12 [get_ports btnr]
set_property PACKAGE_PIN M19 [get_ports btnd]
set_property IOSTANDARD LVCMOS12 [get_ports btnd]
set_property PACKAGE_PIN B19 [get_ports btnu]
set_property IOSTANDARD LVCMOS12 [get_ports btnu]

## Ethernet

# NOTUSED? set_property PACKAGE_PIN AK16 [get_ports net_ip2intc_irpt]
# NOTUSED? set_property IOSTANDARD LVCMOS18 [get_ports net_ip2intc_irpt]
# NOTUSED? set_property PULLUP true [get_ports net_ip2intc_irpt]
set_property PACKAGE_PIN AF12 [get_ports net_phy_mdc]
set_property IOSTANDARD LVCMOS15 [get_ports net_phy_mdc]
set_property PACKAGE_PIN AG12 [get_ports net_phy_mdio_io]
set_property IOSTANDARD LVCMOS15 [get_ports net_phy_mdio_io]
set_property PACKAGE_PIN AH24 [get_ports net_phy_rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports net_phy_rst_n]
#set_property -dict { PACKAGE_PIN AK15  IOSTANDARD LVCMOS18 } [get_ports { ETH_PMEB }]; #IO_L1N_T0_32 Sch=eth_pmeb
set_property PACKAGE_PIN AG10 [get_ports net_phy_rxc]
set_property IOSTANDARD LVCMOS15 [get_ports net_phy_rxc]
set_property PACKAGE_PIN AH11 [get_ports net_phy_rxctl]
set_property IOSTANDARD LVCMOS15 [get_ports net_phy_rxctl]
set_property PACKAGE_PIN AJ14 [get_ports {net_phy_rxd[0]}]
set_property IOSTANDARD LVCMOS15 [get_ports {net_phy_rxd[0]}]
set_property PACKAGE_PIN AH14 [get_ports {net_phy_rxd[1]}]
set_property IOSTANDARD LVCMOS15 [get_ports {net_phy_rxd[1]}]
set_property PACKAGE_PIN AK13 [get_ports {net_phy_rxd[2]}]
set_property IOSTANDARD LVCMOS15 [get_ports {net_phy_rxd[2]}]
set_property PACKAGE_PIN AJ13 [get_ports {net_phy_rxd[3]}]
set_property IOSTANDARD LVCMOS15 [get_ports {net_phy_rxd[3]}]
set_property PACKAGE_PIN AE10 [get_ports net_phy_txc]
set_property IOSTANDARD LVCMOS15 [get_ports net_phy_txc]
set_property PACKAGE_PIN AJ12 [get_ports {net_phy_txd[0]}]
set_property IOSTANDARD LVCMOS15 [get_ports {net_phy_txd[0]}]
set_property PACKAGE_PIN AK11 [get_ports {net_phy_txd[1]}]
set_property IOSTANDARD LVCMOS15 [get_ports {net_phy_txd[1]}]
set_property PACKAGE_PIN AJ11 [get_ports {net_phy_txd[2]}]
set_property IOSTANDARD LVCMOS15 [get_ports {net_phy_txd[2]}]
set_property PACKAGE_PIN AK10 [get_ports {net_phy_txd[3]}]
set_property IOSTANDARD LVCMOS15 [get_ports {net_phy_txd[3]}]
set_property PACKAGE_PIN AK14 [get_ports net_phy_txctl]
set_property IOSTANDARD LVCMOS15 [get_ports net_phy_txctl]

### False paths
set_clock_groups -name sync_gr1 -logically_exclusive -group [get_clocks chipset_clk_clk_mmcm] -group [get_clocks -include_generated_clocks mc_sys_clk_clk_mmcm]


###############################################################

set_property LOC ILOGIC_X1Y119 [get_cells {chipset/chipset_impl/mc_top/mig_7series_0/u_mig_7series_0_mig/u_memc_ui_top_std/mem_intfc0/ddr_phy_top0/u_ddr_mc_phy_wrapper/gen_dqs_iobuf_HP.gen_dqs_iobuf[2].gen_dqs_diff.u_iddr_edge_det/u_phase_detector}]
set_property PACKAGE_PIN AG2 [get_ports {ddr_dqs_p[2]}]
set_property PACKAGE_PIN AH1 [get_ports {ddr_dqs_n[2]}]

set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]

#############################################
# Ethernet Constraints for 100 Mb/s
#############################################

######### Input constraints
# hint from here: https://forums.xilinx.com/t5/Timing-Analysis/XDC-constraints-Source-Synchronous-ADC-DDR/td-p/292807
create_clock -period 40.000 -name net_phy_rxc_virt
# conservatively assuming +/- 2ns skew of rxd/rxctl
create_clock -period 40.000 -name net_phy_rxc -waveform {2.000 22.000} [get_ports net_phy_rxc]
set_clock_groups -asynchronous -group [get_clocks chipset_clk_clk_mmcm] -group [get_clocks net_phy_rxc]
set_input_delay -clock [get_clocks net_phy_rxc_virt] -min -add_delay 0.000 [get_ports {net_phy_rxd[*]}]
set_input_delay -clock [get_clocks net_phy_rxc_virt] -max -add_delay 4.000 [get_ports {net_phy_rxd[*]}]
set_input_delay -clock [get_clocks net_phy_rxc_virt] -clock_fall -min -add_delay 0.000 [get_ports net_phy_rxctl]
set_input_delay -clock [get_clocks net_phy_rxc_virt] -clock_fall -max -add_delay 4.000 [get_ports net_phy_rxctl]
set_input_delay -clock [get_clocks net_phy_rxc_virt] -min -add_delay 0.000 [get_ports net_phy_rxctl]
set_input_delay -clock [get_clocks net_phy_rxc_virt] -max -add_delay 4.000 [get_ports net_phy_rxctl]

########## Output Constraints
create_generated_clock -name net_phy_txc -source [get_pins chipset/net_phy_txc_oddr/C] -divide_by 1 -invert [get_ports net_phy_txc]

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
