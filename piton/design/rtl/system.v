// Copyright (c) 2015 Princeton University
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in the
//       documentation and/or other materials provided with the distribution.
//     * Neither the name of Princeton University nor the
//       names of its contributors may be used to endorse or promote products
//       derived from this software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY PRINCETON UNIVERSITY "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL PRINCETON UNIVERSITY BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

// Filename: system.v
// Author: mmckeown
// Description: Top-level system module for a Piton chip and chipset.
//              This code is synthesizeable, and is used for both simulation
//              with different chipsets and for FPGA synthesis for 
//              OpenPiton.

`include "define.vh"
`include "piton_system.vh"

// Macros used in this file:
//  PITON_FPGA_SYNTH            set to remove any RTL that is ASIC specific,
//                              such as clock gating, latches, etc.  This also
//                              ties off any ASIC IP control signals that
//                              are not used in FPGA implementations
//  PITON_NO_CHIP_BRIDGE        This indicates no chip bridge should be used on
//                              off chip link.  The 3 NoCs are exposed as credit
//                              based interfaces directly.  This is mainly used for FPGA
//                              where there are no pin constraints. Cannot be used with
//                              PITONSYS_INC_PASSTHRU. Note that if PITON_NO_CHIP_BRIDGE
//                              is set, io_clk is not really used.
//  PITON_NO_JTAG               set to remove JTAG support from Piton chip.
//                              Usually used for FPGA implementations, as JTAG
//                              is not needed.
//  PITON_CLKS_CHIPSET          indicates Piton clocks are to be generated
//                              by the chipset. Requires
//                              PITON_CHIPSET_CLKS_GEN
//  PITON_CLKS_PASSTHRU         indicates Piton clocks are to be generated by
//                              the passthru FPGA. Requires PITONSYS_INC_PASSTHRU
//                              and PITON_PASSTHRU_CLKS_GEN
//  PITON_CLKS_SIM              Piton clocks should be driven by simulated
//                              clocks from simulation testbench (input to
//                              this module).  This is set by default
//  PITON_CHIPSET_DIFF_CLK      Some chipset boards use single ended clocks and some
//                              use differential clocks as input
//  PITON_CHIPSET_CLKS_GEN      If this is set, the chipset generates it own
//                              internal clocks.  Otherwise, clocks are
//                              simulated and are inputs to this module
//  PITON_FPGA_RST_ACT_HIGH     This indicates we need to invert input reset signal
//  VC707_BOARD GENESYS2_BOARD  Used to indicate which board this code is being synthesized for
//                              There are more than just these
//  PITONSYS_INC_PASSTHRU       Set this to include the passthrough FPGA
//                              (spartan6) for real chip Piton testing. Note
//                              this macro is not compatible with
//                              PITON_NO_CHIP_BRIDGE, as it does not make
//                              sense to have the passthru FPGA if there is no
//                              chip bridge.  The design will have compile
//                              errors if both are specified
//  PITON_PASSTHRU_CLKS_GEN     Set to have the passthrough generate its own
//                              internal clocks.  Otherwise they are simulated
//  PITONSYS_NO_MC              If set, no memory controller is used. This is used
//                              in the testing of the Piton system, where a small test
//                              can be run on the chip with DRAM
//                              emulated in BRAMs
//  PITON_FPGA_MC_DDR3          Set to indicate an FPGA implementation will
//                              use a DDR2/3 memory controller.  If
//                              this is not set, a default "fake"
//                              simulated DRAM is used.

module system(
`ifndef PITON_FPGA_SYNTH
    // I/O settings
    input                                       chip_io_slew,
    input [1:0]                                 chip_io_impsel,
`endif // endif PITON_FPGA_SYNTH

    // Clocks and resets
`ifdef PITON_CLKS_SIM
    input                                       core_ref_clk,
    input                                       io_clk,
`endif // endif PITON_CLKS_SIM

`ifdef PITONSYS_INC_PASSTHRU
`ifdef PITON_PASSTHRU_CLKS_GEN
    input                                       passthru_clk_osc_p,
    input                                       passthru_clk_osc_n,
`else // ifndef PITON_PASSTHRU_CLKS_GEN
    input                                       passthru_chipset_clk_p,
    input                                       passthru_chipset_clk_n,
`endif // endif PITON_PASSTHRU_CLKS_GEN
`endif // endif PITON_SYS_INC_PASSTHRU

`ifdef PITON_CHIPSET_CLKS_GEN
`ifdef PITON_CHIPSET_DIFF_CLK
    input                                       chipset_clk_osc_p,
    input                                       chipset_clk_osc_n,
`else // ifndef PITON_CHIPSET_DIFF_CLK
    input                                       chipset_clk_osc,
`endif // endif PITON_CHIPSET_DIFF_CLK
`else // ifndef PITON_CHIPSET_CLKS_GEN
    input                                       chipset_clk,
`ifndef PITONSYS_NO_MC
`ifdef PITON_FPGA_MC_DDR3
    input                                       mc_clk,
`endif // endif PITON_FPGA_MC_DDR3
`endif // endif PITONSYS_NO_MC
`ifdef PITONSYS_SPI
    input                                       spi_sys_clk,
`endif // endif PITONSYS_SPI
`ifdef PITONSYS_INC_PASSTHRU
    input                                       chipset_passthru_clk_p,
    input                                       chipset_passthru_clk_n,
`endif // endif PITONSYS_INC_PASSTHRU
`endif // endif PITON_CHIPSET_CLKS_GEN

    input                                       sys_rst_n,

`ifndef PITON_FPGA_SYNTH
    input                                       pll_rst_n,
`endif // endif PITON_FPGA_SYNTH
    
    // Chip-level clock enable
`ifndef PITON_FPGA_SYNTH
    input                                       clk_en,
`endif // endif PITON_FPGA_SYNTH
    
    // Chip PLL settings
`ifndef PITON_FPGA_SYNTH
    input                                       pll_bypass,
    input [4:0]                                 pll_rangea,
    output                                      pll_lock,
`endif // endif PITON_FPGA_SYNTH

    // Chip clock mux selection (bypass PLL or not)
`ifndef PITON_FPGA_SYNTH
    input [1:0]                                 clk_mux_sel,
`endif // endif PITON_FPGA_SYNTH

    // Chip JTAG
`ifndef PITON_NO_JTAG
    input                                       jtag_clk,
    input                                       jtag_rst_l,
    input                                       jtag_modesel,
    input                                       jtag_datain,
    output                                      jtag_dataout,
`endif  // endif PITON_NO_JTAG

    // Asynchronous FIFOs enable
    // for off-chip link (core<->io_clk)
`ifndef PITON_NO_CHIP_BRIDGE
`ifndef PITON_FPGA_SYNTH
    input                                       async_mux,
`endif // endif PITON_FPGA_SYNTH
`endif // endif PITON_NO_CHIP_BRIDGE

    // DRAM and I/O interfaces
`ifndef PITONSYS_NO_MC
`ifdef PITON_FPGA_MC_DDR3
    // Generalized interface for any FPGA board we support.
    // Not all signals will be used for all FPGA boards (see constraints)
    output [`DDR3_ADDR_WIDTH-1:0]               ddr_addr,
    output [`DDR3_BA_WIDTH-1:0]                 ddr_ba,
    output                                      ddr_cas_n,
    output [`DDR3_CK_WIDTH-1:0]                 ddr_ck_n,
    output [`DDR3_CK_WIDTH-1:0]                 ddr_ck_p,
    output [`DDR3_CKE_WIDTH-1:0]                ddr_cke,
    output                                      ddr_ras_n,
    output                                      ddr_reset_n,
    output                                      ddr_we_n,
    inout  [`DDR3_DQ_WIDTH-1:0]                 ddr_dq,
    inout  [`DDR3_DQS_WIDTH-1:0]                ddr_dqs_n,
    inout  [`DDR3_DQS_WIDTH-1:0]                ddr_dqs_p,
    `ifndef NEXYSVIDEO_BOARD
        output [`DDR3_CS_WIDTH-1:0]                 ddr_cs_n,
    `endif // endif NEXYSVIDEO_BOARD
    output [`DDR3_DM_WIDTH-1:0]                 ddr_dm,
    output                                      ddr_odt,
`else // ifndef PITON_FPGA_MC_DDR3
    output                                      chipset_mem_val,
    output [`NOC_DATA_WIDTH-1:0]                chipset_mem_data,
    input                                       chipset_mem_rdy,
    input                                       mem_chipset_val,
    input  [`NOC_DATA_WIDTH-1:0]                mem_chipset_data,
    output                                      mem_chipset_rdy,
`endif // endif PITON_FPGA_MC_DDR3
`endif // endif PITONSYS_NO_MC

`ifdef PITONSYS_IOCTRL
`ifdef PITONSYS_UART
    output                                      uart_tx,
    input                                       uart_rx,
`endif // endif PITONSYS_UART

`ifdef PITONSYS_SPI
    input                                       spi_data_in,
    output                                      spi_data_out,
    output                                      spi_clk_out,
    output                                      spi_cs_n,
`endif // endif PITONSYS_SPI

// Emaclite interface
`ifdef GENESYS2_BOARD
    output                                          net_phy_txc,
    output                                          net_phy_txctl,
    output      [3:0]                               net_phy_txd,
    input                                           net_phy_rxc,
    input                                           net_phy_rxctl,
    input       [3:0]                               net_phy_rxd,
    output                                          net_phy_rst_n,
    inout                                           net_phy_mdio_io,
    output                                          net_phy_mdc,
`elsif NEXYSVIDEO_BOARD
    output                                          net_phy_txc,
    output                                          net_phy_txctl,
    output      [3:0]                               net_phy_txd,
    input                                           net_phy_rxc,
    input                                           net_phy_rxctl,
    input       [3:0]                               net_phy_rxd,
    output                                          net_phy_rst_n,
    inout                                           net_phy_mdio_io,
    output                                          net_phy_mdc,
`endif 

`else // ifndef PITONSYS_IOCTRL
    output                                      chipset_fake_iob_val,
    output [`NOC_DATA_WIDTH-1:0]                chipset_fake_iob_data,
    input                                       chipset_fake_iob_rdy,
    input                                       fake_iob_chipset_val,
    input  [`NOC_DATA_WIDTH-1:0]                fake_iob_chipset_data,
    output                                      fake_iob_chipset_rdy,

    output                                      chipset_io_val,
    output [`NOC_DATA_WIDTH-1:0]                chipset_io_data,
    input                                       chipset_io_rdy,
    input                                       io_chipset_val,
    input  [`NOC_DATA_WIDTH-1:0]                io_chipset_data,
    output                                      io_chipset_rdy,
`endif // endif PITONSYS_IOCTRL

`ifdef GENESYS2_BOARD
    input                                       btnl,
    input                                       btnr,
    input                                       btnu,
    input                                       btnd,

    output                                      oled_sclk,
    output                                      oled_dc,
    output                                      oled_data,
    output                                      oled_vdd_n,
    output                                      oled_vbat_n,
    output                                      oled_rst_n,
`elsif NEXYSVIDEO_BOARD
    input                                       btnl,
    input                                       btnr,
    input                                       btnu,
    input                                       btnd,

    output                                      oled_sclk,
    output                                      oled_dc,
    output                                      oled_data,
    output                                      oled_vdd_n,
    output                                      oled_vbat_n,
    output                                      oled_rst_n,
`endif

    input  [7:0]                                sw,
    output [7:0]                                leds

);

///////////////////////
// Type declarations //
///////////////////////

`ifndef PITON_CLKS_SIM
// If these are not provided from
// simulation testbench, we need to connect
// them to chipset or passthru
wire                core_ref_clk;
wire                io_clk;
`endif // endif PITON_CLKS_SIM

// Loopback I/O clock for when the passthru FPGA
// is used to generate Piton clocks
wire                io_clk_loopback;

// Rectified sys_rst_n, some boards
// have inverted sense
reg                 sys_rst_n_rect;

// Chip resets derived from sys_rst_n and passthru output reset
reg                 chip_rst_n;

// JTAG and PLL resets derived from inputs and passthru output resets
reg                 jtag_rst_n_full;
reg                 pll_rst_n_full;

// Passthru module reset derived from sys_rst_n
reg                 passthru_rst_n;

// Passthru output clocks to chip
wire                passthru_chip_rst_n;
wire                passthru_jtag_rst_n;
wire                passthru_pll_rst_n;

// Chipset module reset derived from sys_rst_n
reg                 chipset_rst_n;

`ifdef PITON_FPGA_SYNTH
wire                pll_lock;
`endif // endif PITON_FPGA_SYNTH

// Signal from passthru to chipset to signal
// when Piton comes out of reset and is ready
wire                piton_prsnt_n;
wire                piton_ready_n;

// Chip interface signals with a chip bridge
wire [31:0]         intf_chip_data;
wire [1:0]          intf_chip_channel;
wire [2:0]          intf_chip_credit_back;
wire [31:0]         chip_intf_data;
wire [1:0]          chip_intf_channel;
wire [2:0]          chip_intf_credit_back;

// Chip interface signals without a chip bridge
// the three NoCs are not decoded. Optimization for FPGA
wire                         processor_offchip_noc1_valid;
wire [`NOC_DATA_WIDTH-1:0]   processor_offchip_noc1_data;
wire                         processor_offchip_noc1_yummy;
wire                         processor_offchip_noc2_valid;
wire [`NOC_DATA_WIDTH-1:0]   processor_offchip_noc2_data;
wire                         processor_offchip_noc2_yummy;
wire                         processor_offchip_noc3_valid;
wire [`NOC_DATA_WIDTH-1:0]   processor_offchip_noc3_data;
wire                         processor_offchip_noc3_yummy;

wire                         offchip_processor_noc1_valid; 
wire [`NOC_DATA_WIDTH-1:0]   offchip_processor_noc1_data;
wire                         offchip_processor_noc1_yummy;
wire                         offchip_processor_noc2_valid;
wire [`NOC_DATA_WIDTH-1:0]   offchip_processor_noc2_data;
wire                         offchip_processor_noc2_yummy;
wire                         offchip_processor_noc3_valid;
wire [`NOC_DATA_WIDTH-1:0]   offchip_processor_noc3_data;
wire                         offchip_processor_noc3_yummy;

// Passthru<->chipset source synchronous differential clocks
`ifdef PITON_CHIPSET_CLKS_GEN
wire                chipset_passthru_clk_p;
wire                chipset_passthru_clk_n;
`endif // endif PITON_CHIPSET_CLKS_GEN
`ifdef PITON_PASSTHRU_CLKS_GEN
wire                passthru_chipset_clk_p;
wire                passthru_chipset_clk_n;
`endif // endif PITON_PASSTHRU_CLKS_GEN

// Passthru<->chipset source synchronous differential interface
wire [31:0]         chipset_passthru_data_p;
wire [31:0]         chipset_passthru_data_n;
wire [1:0]          chipset_passthru_channel_p;
wire [1:0]          chipset_passthru_channel_n;
wire [2:0]          chipset_passthru_credit_back_p;
wire [2:0]          chipset_passthru_credit_back_n;
                
wire [31:0]         passthru_chipset_data_p;
wire [31:0]         passthru_chipset_data_n;
wire [1:0]          passthru_chipset_channel_p;
wire [1:0]          passthru_chipset_channel_n;
wire [2:0]          passthru_chipset_credit_back_p;
wire [2:0]          passthru_chipset_credit_back_n;

`ifdef PITONSYS_UART_BOOT
    wire                                    test_start;
`endif

//////////////////////
// Sequential Logic //
//////////////////////

/////////////////////////
// Combinational Logic //
/////////////////////////

// Different reset active levels for different boards
always @ *
begin
`ifdef PITON_FPGA_RST_ACT_HIGH
    sys_rst_n_rect = ~sys_rst_n;
`else // ifndef PITON_FPGA_RST_ACT_HIGH
    sys_rst_n_rect = sys_rst_n;
`endif
end

// Resets combinational logic
// All modules have their own internal
// reset synchronization
always @ *
begin
    chip_rst_n = sys_rst_n_rect & passthru_chip_rst_n;
`ifdef PITONSYS_UART_BOOT
    chip_rst_n = sys_rst_n_rect & passthru_chip_rst_n & test_start;
`endif  // PITONSYS_UART_BOOT

`ifdef PITON_NO_JTAG
    jtag_rst_n_full = passthru_jtag_rst_n;
`else // ifndef PITON_NO_JTAG
    jtag_rst_n_full = jtag_rst_l & passthru_jtag_rst_n;
`endif // endif PITON_NO_JTAG
`ifdef PITON_FPGA_SYNTH
    pll_rst_n_full = passthru_pll_rst_n;
`else // ifnddef PITON_FPGA_SYNTH
    pll_rst_n_full = pll_rst_n & passthru_pll_rst_n;
`endif // endif PITON_FPGA_SYNTH
    // These should have their own internal
    // synchronization if needed
    passthru_rst_n = sys_rst_n_rect;
    // Chipset also has its own internal correction
    // for active high resets as it can be
    // intantiated alone on an FPGA board (not
    // part of system).  Current boards supported
    // for passthru only use active low, so it always
    // expects active low
    chipset_rst_n = sys_rst_n;
end

// If there is no passthru, we need to set the resets
// it controls
`ifndef PITONSYS_INC_PASSTHRU
assign passthru_chip_rst_n = 1'b1;
assign passthru_jtag_rst_n = 1'b1;
assign passthru_pll_rst_n = 1'b1;
`endif

//////////////////////////
// Sub-module Instances //
//////////////////////////

// Piton chip
chip chip(
    // I/O settings
`ifdef PITON_FPGA_SYNTH
    // Tie these off if not used
    .slew (1'b1),
    .impsel1(1'b1),
    .impsel2(1'b1),
`else // ifndef PITON_FPGA_SYNTH
    .slew (chip_io_slew),
    .impsel1 (chip_io_impsel[0]),
    .impsel2 (chip_io_impsel[1]),
`endif // endif PITON_FPGA_SYNTH

    // Clocks and resets
    .core_ref_clk(core_ref_clk),
    .io_clk(io_clk),
    .rst_n(chip_rst_n),
    .pll_rst_n(pll_rst_n_full),

    // Chip-level clock enable
`ifdef PITON_FPGA_SYNTH
    // Tie off if unused
    .clk_en(1'b1),
`else // ifndef PITON_FPGA_SYNTH
    .clk_en(clk_en),
`endif

    // PLL settings
    .pll_lock (pll_lock),
`ifdef PITON_FPGA_SYNTH
    // Tie off when not used
    .pll_bypass (1'b1),
    .pll_rangea (5'b0),
`else // ifndef PITON_FPGA_SYNTH
    .pll_bypass (pll_bypass),
    .pll_rangea (pll_rangea),
`endif // endif PITON_FPGA_SYNTH

    // Clock mux selection (bypass PLL or not)
    // Double redundancy with PLL internal bypass
`ifdef PITON_FPGA_SYNTH
    // Tie off, not used
    .clk_mux_sel (2'b0),
`else // ifndef PITON_FPGA_SYNTH
    .clk_mux_sel (clk_mux_sel),
`endif // endif PITON_FPGA_SYNTH
        
    // JTAG
`ifdef PITON_NO_JTAG
    // Tie off when not used
    .jtag_clk(1'b0),
    .jtag_rst_l(1'b1),
    .jtag_modesel(1'b1),
    .jtag_datain(1'b0),
    .jtag_dataout(),
`else // ifndef PITON_NO_JTAG
    .jtag_clk(jtag_clk),
    .jtag_rst_l(jtag_rst_n_full),
    .jtag_modesel(jtag_modesel),
    .jtag_datain(jtag_datain),
    .jtag_dataout(jtag_dataout),
`endif // endif PITON_NO_JTAG

    // Asynchronous FIFOs enable
    // for off-chip link (core<->io_clk)
`ifdef PITON_NO_CHIP_BRIDGE
    // Not used
    .async_mux (1'b1),
`else // ifndef PITON_NO_CHIP_BRIDGE
`ifdef PITON_FPGA_SYNTH
    // Not used
    .async_mux (1'b1),
`else // ifndef PITON_FPGA_SYNTH
    .async_mux (async_mux),
`endif // endif PITON_FPGA_SYNTH
`endif // endif PITON_NO_CHIP_BRIDGE

`ifndef PITON_NO_CHIP_BRIDGE 
    // Chipset (intf) to chip channel
    .intf_chip_data(intf_chip_data),
    .intf_chip_channel(intf_chip_channel),
    .intf_chip_credit_back(intf_chip_credit_back),

    // Chip to chipset (intf) channel
    .chip_intf_data(chip_intf_data),
    .chip_intf_channel(chip_intf_channel),
    .chip_intf_credit_back(chip_intf_credit_back)
`else // ifdef PITON_NO_CHIP_BRIDGE
    // NoCs are not decoded if there is no chip bridge.
    // This is mainly used for FPGA implementations
    // where the chip and memory controller, i/o, etc. 
    // are both in the FPGA and are thus not pin limitted

    // Chip to offchip (chipset) channels
    .processor_offchip_noc1_valid   (processor_offchip_noc1_valid),
    .processor_offchip_noc1_data    (processor_offchip_noc1_data),
    .processor_offchip_noc1_yummy   (processor_offchip_noc1_yummy),
    .processor_offchip_noc2_valid   (processor_offchip_noc2_valid),
    .processor_offchip_noc2_data    (processor_offchip_noc2_data),
    .processor_offchip_noc2_yummy   (processor_offchip_noc2_yummy),
    .processor_offchip_noc3_valid   (processor_offchip_noc3_valid),
    .processor_offchip_noc3_data    (processor_offchip_noc3_data),
    .processor_offchip_noc3_yummy   (processor_offchip_noc3_yummy),

    // Offchip (chipset) channels
    .offchip_processor_noc1_valid   (offchip_processor_noc1_valid),
    .offchip_processor_noc1_data    (offchip_processor_noc1_data),
    .offchip_processor_noc1_yummy   (offchip_processor_noc1_yummy),
    .offchip_processor_noc2_valid   (offchip_processor_noc2_valid),
    .offchip_processor_noc2_data    (offchip_processor_noc2_data),
    .offchip_processor_noc2_yummy   (offchip_processor_noc2_yummy),
    .offchip_processor_noc3_valid   (offchip_processor_noc3_valid),
    .offchip_processor_noc3_data    (offchip_processor_noc3_data),
    .offchip_processor_noc3_yummy   (offchip_processor_noc3_yummy)
`endif // endif PITON_NO_CHIP_BRIDGE
);

`ifdef PITONSYS_INC_PASSTHRU
// Pasthru FPGA, generally used in Piton ASIC test system
// for converting single ended signals from Piton ASIC
// to differential signals to transmit to chipset FPGA.
// Can be included or removed without any difference to
// the functionality
passthru passthru(
    // If PITON_PASSTHRU_CLKS_GEN is set
    // we need to generate chip clocks
    // from this input differential clock
`ifdef PITON_PASSTHRU_CLKS_GEN
    .clk_osc_p(passthru_clk_osc_p),
    .clk_osc_n(passthru_clk_osc_n),
`endif // endif PITON_PASSTHRU_CLKS_GEN
    
    // Need to generate these if specified.  Note
    // these may be inputs or outputs.  Outputs if
    // passthru is generating the piton clocks, inputs
    // if not
    .core_ref_clk(core_ref_clk),
`ifdef PITON_CLKS_PASSTHRU
    .io_clk(io_clk),
`endif // endif PITON_CLKS_PASSTHRU
    
`ifdef PITON_PASSTHRU_CLKS_GEN
    .io_clk_loobpack_out(io_clk_loopback),
    .io_clk_loopback_in(io_clk_loopback),
`else // ifndef PITON_PASSTHRU_CLKS_GEN
    .io_clk_loopback_out(),
    .io_clk_loopback_in(io_clk),
`endif // endif PITON_PASSTHRU_CLKS_GEN

    // Passthru reset input
    .rst_n(passthru_rst_n),

    // Passthru reset outputs to other modules
    .chip_rst_n(passthru_chip_rst_n),
    .jtag_rst_n(passthru_jtag_rst_n),
    .pll_rst_n(passthru_pll_rst_n),

    // PLL lock input
    .pll_lock(pll_lock),

    // Piton ready signal, used to signal to chipset
    // when Piton is out of reset and ready for action.
    .piton_prsnt_n(piton_prsnt_n),
    .piton_ready_n(piton_ready_n),

    // Chip<->passthru interface.  Synchronous to io_clk. 
    // Note this is not compatible with PITON_NO_CHIP_BRIDGE
    // as having a passthru without a chip bridge does
    // not make much sense.
    .intf_chip_data(intf_chip_data),
    .intf_chip_channel(intf_chip_channel),
    .intf_chip_credit_back(intf_chip_credit_back),

    .chip_intf_data(chip_intf_data),
    .chip_intf_channel(chip_intf_channel),
    .chip_intf_credit_back(chip_intf_credit_back),

    // Source synchronous differential clocks
    // between chipset and passthrough
    // Note passthru_chipset_clk may be an input
    // in the case passthru is not generating clocks
    .chipset_passthru_clk_p(chipset_passthru_clk_p),
    .chipset_passthru_clk_n(chipset_passthru_clk_n),
    .passthru_chipset_clk_p(passthru_chipset_clk_p),
    .passthru_chipset_clk_n(passthru_chipset_clk_n),

    // Chipset<->passthru differential interface source
    // synchronous to above clocks.
    .chipset_passthru_data_p(chipset_passthru_data_p),
    .chipset_passthru_data_n(chipset_passthru_data_n),
    .chipset_passthru_channel_p(chipset_passthru_channel_p),
    .chipset_passthru_channel_n(chipset_passthru_channel_n),
    .chipset_passthru_credit_back_p(chipset_passthru_credit_back_p),
    .chipset_passthru_credit_back_n(chipset_passthru_credit_back_n),

    .passthru_chipset_data_p(passthru_chipset_data_p),
    .passthru_chipset_data_n(passthru_chipset_data_n),
    .passthru_chipset_channel_p(passthru_chipset_channel_p),
    .passthru_chipset_channel_n(passthru_chipset_channel_n),
    .passthru_chipset_credit_back_p(passthru_chipset_credit_back_p),
    .passthru_chipset_credit_back_n(passthru_chipset_credit_back_n)

    // Other board specific misc. I/Os in this module are left out as they currently
    // do not affect the functionality of the design as far as communicating
    // with the chip is concerned
);
`endif // endif PITONSYS_INC_PASSTHRU

// Piton chipset
chipset chipset(
    // Only need oscillator clock if 
    // chipset is generating its own clocks
`ifdef PITON_CHIPSET_CLKS_GEN
`ifdef PITON_CHIPSET_DIFF_CLK
    .clk_osc_p(chipset_clk_osc_p),
    .clk_osc_n(chipset_clk_osc_n),
`else // ifndef PITON_CHIPSET_DIFF_CLK
    .clk_osc(chipset_clk_osc),
`endif // endif PITON_CHIPSET_DIFF_CLK
`else // ifndef PITON_CHIPSET_CLKS_GEN
    .chipset_clk(chipset_clk),
`ifndef PITONSYS_NO_MC
`ifdef PITON_FPGA_MC_DDR3
    .mc_clk(mc_clk),
`endif // endif PITON_FPGA_MC_DDR3
`endif // endif PITONSYS_NO_MC
`ifdef PITONSYS_SPI
    .spi_sys_clk(spi_sys_clk),
`endif // endif PITONSYS_SPI
`endif // endif PITON_CHIPSET_CLKS_GEN

`ifdef PITON_CLKS_CHIPSET
    // Need to generate these clocks if specified
    .core_ref_clk(core_ref_clk),
    .io_clk(io_clk),
`else // ifndef PITON_CLKS_CHIPSET
`ifndef PITONSYS_INC_PASSTHRU
`ifndef PITON_NO_CHIP_BRIDGE
    .io_clk(io_clk),
`endif // endif PITON_NO_CHIP_BRIDGE
`endif // endif PITONSYS_INC_PASSTHRU
`endif // endif PITON_CLKS_CHIPSET

    // Chipset reset
    .rst_n(chipset_rst_n),

    // In the case of passthru, it should
    // tell us when Piton is ready since it
    // has control of chip resets and has a
    // separate reset from the chipset. Otherwise,
    // assume piton is always ready (same reset)
`ifdef PITONSYS_INC_PASSTHRU
    .piton_prsnt_n(piton_prsnt_n),
    .piton_ready_n(piton_ready_n),
`else // ifndef PITONSYS_INC_PASSTHRU
    .piton_prsnt_n(1'b0),
    .piton_ready_n(1'b0),
`endif // endif PITONSYS_INC_PASSTHRU

    // There are actually 3 options for how to
    // communicate to the chip: directly without a
    // chip bridge, through the passthrough, or directly
    // with a chip bridge
`ifdef PITON_NO_CHIP_BRIDGE
    // Synchronous with core_ref_clk (same as io_clk in this case) and no virtual channels
    .processor_offchip_noc1_valid   (processor_offchip_noc1_valid),
    .processor_offchip_noc1_data    (processor_offchip_noc1_data),
    .processor_offchip_noc1_yummy   (processor_offchip_noc1_yummy),
    .processor_offchip_noc2_valid   (processor_offchip_noc2_valid),
    .processor_offchip_noc2_data    (processor_offchip_noc2_data),
    .processor_offchip_noc2_yummy   (processor_offchip_noc2_yummy),
    .processor_offchip_noc3_valid   (processor_offchip_noc3_valid),
    .processor_offchip_noc3_data    (processor_offchip_noc3_data),
    .processor_offchip_noc3_yummy   (processor_offchip_noc3_yummy),

    .offchip_processor_noc1_valid   (offchip_processor_noc1_valid),
    .offchip_processor_noc1_data    (offchip_processor_noc1_data),
    .offchip_processor_noc1_yummy   (offchip_processor_noc1_yummy),
    .offchip_processor_noc2_valid   (offchip_processor_noc2_valid),
    .offchip_processor_noc2_data    (offchip_processor_noc2_data),
    .offchip_processor_noc2_yummy   (offchip_processor_noc2_yummy),
    .offchip_processor_noc3_valid   (offchip_processor_noc3_valid),
    .offchip_processor_noc3_data    (offchip_processor_noc3_data),
    .offchip_processor_noc3_yummy   (offchip_processor_noc3_yummy),
`elsif PITONSYS_INC_PASSTHRU
    // Source synchronous differential interface with virtual channels
    .chipset_passthru_clk_p(chipset_passthru_clk_p),
    .chipset_passthru_clk_n(chipset_passthru_clk_n),
    .passthru_chipset_clk_p(passthru_chipset_clk_p),
    .passthru_chipset_clk_n(passthru_chipset_clk_n),

    .chipset_passthru_data_p(chipset_passthru_data_p),
    .chipset_passthru_data_n(chipset_passthru_data_n),
    .chipset_passthru_channel_p(chipset_passthru_channel_p),
    .chipset_passthru_channel_n(chipset_passthru_channel_n),
    .chipset_passthru_credit_back_p(chipset_passthru_credit_back_p),
    .chipset_passthru_credit_back_n(chipset_passthru_credit_back_n),

    .passthru_chipset_data_p(passthru_chipset_data_p),
    .passthru_chipset_data_n(passthru_chipset_data_n),
    .passthru_chipset_channel_p(passthru_chipset_channel_p),
    .passthru_chipset_channel_n(passthru_chipset_channel_n),
    .passthru_chipset_credit_back_p(passthru_chipset_credit_back_p),
    .passthru_chipset_credit_back_n(passthru_chipset_credit_back_n),
`else // ifndef PITON_NO_CHIP_BRIDGE && ifndef PITON_SYS_INC_PASSTHRU
    // Credit interface synchronous to io_clk with virtual channels
    .intf_chip_data(intf_chip_data),
    .intf_chip_channel(intf_chip_channel),
    .intf_chip_credit_back(intf_chip_credit_back),

    .chip_intf_data(chip_intf_data),
    .chip_intf_channel(chip_intf_channel),
    .chip_intf_credit_back(chip_intf_credit_back),
`endif // endif PITON_NO_CHIP_BRIDGE PITON_SYS_INC_PASSTHRU

    // DRAM and I/O interfaces
`ifndef PITONSYS_NO_MC
`ifdef PITON_FPGA_MC_DDR3
    .ddr_addr(ddr_addr),
    .ddr_ba(ddr_ba),
    .ddr_cas_n(ddr_cas_n),
    .ddr_ck_n(ddr_ck_n),
    .ddr_ck_p(ddr_ck_p),
    .ddr_cke(ddr_cke),
    .ddr_ras_n(ddr_ras_n),
    .ddr_reset_n(ddr_reset_n),
    .ddr_we_n(ddr_we_n),
    .ddr_dq(ddr_dq),
    .ddr_dqs_n(ddr_dqs_n),
    .ddr_dqs_p(ddr_dqs_p),
`ifndef NEXYSVIDEO_BOARD
    .ddr_cs_n(ddr_cs_n),
`endif // endif NEXYSVIDEO_BOARD
    .ddr_dm(ddr_dm),
    .ddr_odt(ddr_odt),
`else // ifndef PITON_FPGA_MC_DDR3
    .chipset_mem_val(chipset_mem_val),
    .chipset_mem_data(chipset_mem_data),
    .chipset_mem_rdy(chipset_mem_rdy),
    .mem_chipset_val(mem_chipset_val),
    .mem_chipset_data(mem_chipset_data),
    .mem_chipset_rdy(mem_chipset_rdy),
`endif // endif PITON_FPGA_MC_DDR3
`endif // endif PITONSYS_NO_MC

`ifdef PITONSYS_IOCTRL
`ifdef PITONSYS_UART
    .uart_tx(uart_tx),
    .uart_rx(uart_rx),
`ifdef PITONSYS_UART_BOOT
`ifdef PITONSYS_NON_UART_BOOT
    .test_start(test_start),
`endif // endif PITONSYS_NON_UART_BOOT
`endif // endif PITONSYS_UART_BOOT
`endif // endif PITONSYS_UART

`ifdef PITONSYS_SPI
    .spi_data_in(spi_data_in),
    .spi_data_out(spi_data_out),
    .spi_clk_out(spi_clk_out),
    .spi_cs_n(spi_cs_n),
`endif // endif PITONSYS_SPI

    .net_phy_txc        (net_phy_txc),
    .net_phy_txctl      (net_phy_txctl),
    .net_phy_txd        (net_phy_txd),
    .net_phy_rxc        (net_phy_rxc),
    .net_phy_rxctl      (net_phy_rxctl),
    .net_phy_rxd        (net_phy_rxd),
    .net_phy_rst_n      (net_phy_rst_n),
    .net_phy_mdio_io    (net_phy_mdio_io),
    .net_phy_mdc        (net_phy_mdc),

`else // ifndef PITONSYS_IOCTRL
    .chipset_fake_iob_val(chipset_fake_iob_val),
    .chipset_fake_iob_data(chipset_fake_iob_data),
    .chipset_fake_iob_rdy(chipset_fake_iob_rdy),
    .fake_iob_chipset_val(fake_iob_chipset_val),
    .fake_iob_chipset_data(fake_iob_chipset_data),
    .fake_iob_chipset_rdy(fake_iob_chipset_rdy),

    .chipset_io_val(chipset_io_val),
    .chipset_io_data(chipset_io_data),
    .chipset_io_rdy(chipset_io_rdy),
    .io_chipset_val(io_chipset_val),
    .io_chipset_data(io_chipset_data),
    .io_chipset_rdy(io_chipset_rdy),
`endif // endif PITONSYS_IOCTRL

`ifdef GENESYS2_BOARD
    .btnl(btnl),
    .btnr(btnr),
    .btnu(btnu),
    .btnd(btnd),

    .oled_sclk(oled_sclk),
    .oled_dc(oled_dc),
    .oled_data(oled_data),
    .oled_vdd_n(oled_vdd_n),
    .oled_vbat_n(oled_vbat_n),
    .oled_rst_n(oled_rst_n),
`elsif NEXYSVIDEO_BOARD
    .btnl(btnl),
    .btnr(btnr),
    .btnu(btnu),
    .btnd(btnd),

    .oled_sclk(oled_sclk),
    .oled_dc(oled_dc),
    .oled_data(oled_data),
    .oled_vdd_n(oled_vdd_n),
    .oled_vbat_n(oled_vbat_n),
    .oled_rst_n(oled_rst_n),
`endif

    .sw(sw),
    .leds(leds)


);

endmodule
