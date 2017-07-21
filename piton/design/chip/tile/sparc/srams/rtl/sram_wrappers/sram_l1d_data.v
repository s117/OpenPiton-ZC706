
/*
Copyright (c) 2015 Princeton University
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of Princeton University nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY PRINCETON UNIVERSITY "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL PRINCETON UNIVERSITY BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

// 02/06/2015 14:58:59
// This file is auto-generated
// Author: Tri Nguyen
`include "define.vh"
`include "lsu.tmp.h"
`ifdef DEFAULT_NETTYPE_NONE
`default_nettype none
`endif

`ifndef SPLIT_L1_DCACHE

module sram_l1d_data_piton
(
input wire MEMCLK,
input wire RESET_N,
input wire CE,
input wire [`L1D_SET_IDX_MASK] A,
input wire RDWEN,
input wire [287:0] BW,
input wire [287:0] DIN,
output wire [287:0] DOUT,
input wire [`BIST_OP_WIDTH-1:0] BIST_COMMAND,
input wire [`SRAM_WRAPPER_BUS_WIDTH-1:0] BIST_DIN,
output reg [`SRAM_WRAPPER_BUS_WIDTH-1:0] BIST_DOUT,
input wire [`BIST_ID_WIDTH-1:0] SRAMID
);
reg [287:0] cache [`L1D_SET_COUNT-1:0];

integer i;
initial
begin
   for (i = 0; i < `L1D_SET_COUNT; i = i + 1)
   begin
      cache[i] = 0;
   end
end



   reg [287:0] dout_f;

   assign DOUT = dout_f;

   always @ (posedge MEMCLK)
   begin
      if (CE)
      begin
         if (RDWEN == 1'b0)
            cache[A] <= (DIN & BW) | (cache[A] & ~BW);
         else
            dout_f <= cache[A];
      end
   end
   
endmodule

`else

module sram_l1d_data
(
input wire MEMCLK,
input wire RESET_N,
input wire CE,
input wire [`L1D_SET_IDX_MASK] A,
input wire RDWEN,
input wire [`L1D_DATA_ENTRY_WIDTH*`L1D_WAY_COUNT-1:0] BW,
input wire [`L1D_DATA_ENTRY_WIDTH*`L1D_WAY_COUNT-1:0] DIN,
output wire [`L1D_DATA_ENTRY_WIDTH*`L1D_WAY_COUNT-1:0] DOUT,
input wire [`BIST_OP_WIDTH-1:0] BIST_COMMAND,
input wire [`SRAM_WRAPPER_BUS_WIDTH-1:0] BIST_DIN,
output reg [`SRAM_WRAPPER_BUS_WIDTH-1:0] BIST_DOUT,
input wire [`BIST_ID_WIDTH-1:0] SRAMID
);
reg [`L1D_DATA_ENTRY_WIDTH*`L1D_WAY_COUNT-1:0] cache [`L1D_SET_COUNT-1:0];

integer i;
initial
begin
   for (i = 0; i < `L1D_SET_COUNT; i = i + 1)
   begin
      cache[i] = 0;
   end
end



   reg [`L1D_DATA_ENTRY_WIDTH*`L1D_WAY_COUNT-1:0] dout_f;

   assign DOUT = dout_f;

   always @ (posedge MEMCLK)
   begin
      if (CE)
      begin
         if (RDWEN == 1'b0)
            cache[A] <= (DIN & BW) | (cache[A] & ~BW);
         else
            dout_f <= cache[A];
      end
   end
   
endmodule

`endif
