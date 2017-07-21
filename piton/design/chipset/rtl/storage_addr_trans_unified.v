// Copyright (c) 2017 Princeton University
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

//-----------------------------------------
// Auto generated mapping module
// It is provided for test: unknown 
//-----------------------------------------
module storage_addr_trans_unified #(parameter MEM_ADDR_WIDTH=64, VA_ADDR_WIDTH=40, STORAGE_ADDR_WIDTH=12)
(
    input       [VA_ADDR_WIDTH-1:0]         va_byte_addr,
    
    output      [STORAGE_ADDR_WIDTH-1:0]    storage_addr_out,
    output                                  hit_any_section
);

wire [63:0] storage_addr;

wire [63:0]                      bram_addr_0;
wire [63:0]                      bram_addr_1;
wire [63:0]                      bram_addr_2;
wire [63:0]                      bram_addr_3;
wire [63:0]                      bram_addr_4;
wire [63:0]                      bram_addr_5;
wire [63:0]                      bram_addr_6;
wire [63:0]                      bram_addr_7;
wire [63:0]                      bram_addr_8;
wire [63:0]                      bram_addr_9;
wire [63:0]                      bram_addr_10;
wire [63:0]                      bram_addr_11;
wire [63:0]                      bram_addr_12;
wire [63:0]                      bram_addr_13;

wire                          in_section_0;
wire                          in_section_1;
wire                          in_section_2;
wire                          in_section_3;
wire                          in_section_4;
wire                          in_section_5;
wire                          in_section_6;
wire                          in_section_7;
wire                          in_section_8;
wire                          in_section_9;
wire                          in_section_10;
wire                          in_section_11;
wire                          in_section_12;
wire                          in_section_13;

// Note: section offset base is taken for Genesys2, which has 32-bit interface
// At the same time, ADDR_TRANS_SECTION_MULT is relative to VC707, which has 64-bit interface
// Because of this each base is divided by 2 before multiplication.
// TODO: regenerate without this confusion or make configuration (programmable mapping from the stream)
assign bram_addr_0 = (({{(MEM_ADDR_WIDTH-VA_ADDR_WIDTH){1'b0}}, va_byte_addr} - 64'h40000) >> `ADDR_TRANS_PHYS_WIDTH_ALIGN) + 0/2*`ADDR_TRANS_SECTION_MULT;
assign bram_addr_1 = (({{(MEM_ADDR_WIDTH-VA_ADDR_WIDTH){1'b0}}, va_byte_addr} - 64'h20000000) >> `ADDR_TRANS_PHYS_WIDTH_ALIGN) + 3137808/2*`ADDR_TRANS_SECTION_MULT;
assign bram_addr_2 = (({{(MEM_ADDR_WIDTH-VA_ADDR_WIDTH){1'b0}}, va_byte_addr} - 64'h40008000) >> `ADDR_TRANS_PHYS_WIDTH_ALIGN) + 3138580/2*`ADDR_TRANS_SECTION_MULT;
assign bram_addr_3 = (({{(MEM_ADDR_WIDTH-VA_ADDR_WIDTH){1'b0}}, va_byte_addr} - 64'h60000000) >> `ADDR_TRANS_PHYS_WIDTH_ALIGN) + 3661846/2*`ADDR_TRANS_SECTION_MULT;
assign bram_addr_4 = (({{(MEM_ADDR_WIDTH-VA_ADDR_WIDTH){1'b0}}, va_byte_addr} - 64'h1000120000) >> `ADDR_TRANS_PHYS_WIDTH_ALIGN) + 3662102/2*`ADDR_TRANS_SECTION_MULT;
assign bram_addr_5 = (({{(MEM_ADDR_WIDTH-VA_ADDR_WIDTH){1'b0}}, va_byte_addr} - 64'h1020006000) >> `ADDR_TRANS_PHYS_WIDTH_ALIGN) + 3667846/2*`ADDR_TRANS_SECTION_MULT;
assign bram_addr_6 = (({{(MEM_ADDR_WIDTH-VA_ADDR_WIDTH){1'b0}}, va_byte_addr} - 64'h1040000000) >> `ADDR_TRANS_PHYS_WIDTH_ALIGN) + 3668106/2*`ADDR_TRANS_SECTION_MULT;
assign bram_addr_7 = (({{(MEM_ADDR_WIDTH-VA_ADDR_WIDTH){1'b0}}, va_byte_addr} - 64'h10a8000000) >> `ADDR_TRANS_PHYS_WIDTH_ALIGN) + 4192396/2*`ADDR_TRANS_SECTION_MULT;
assign bram_addr_8 = (({{(MEM_ADDR_WIDTH-VA_ADDR_WIDTH){1'b0}}, va_byte_addr} - 64'h10d0000000) >> `ADDR_TRANS_PHYS_WIDTH_ALIGN) + 4323468/2*`ADDR_TRANS_SECTION_MULT;
assign bram_addr_9 = (({{(MEM_ADDR_WIDTH-VA_ADDR_WIDTH){1'b0}}, va_byte_addr} - 64'h1100144000) >> `ADDR_TRANS_PHYS_WIDTH_ALIGN) + 4339852/2*`ADDR_TRANS_SECTION_MULT;
assign bram_addr_10 = (({{(MEM_ADDR_WIDTH-VA_ADDR_WIDTH){1'b0}}, va_byte_addr} - 64'h1130000000) >> `ADDR_TRANS_PHYS_WIDTH_ALIGN) + 5222588/2*`ADDR_TRANS_SECTION_MULT;
assign bram_addr_11 = (({{(MEM_ADDR_WIDTH-VA_ADDR_WIDTH){1'b0}}, va_byte_addr} - 64'h1170000000) >> `ADDR_TRANS_PHYS_WIDTH_ALIGN) + 5223612/2*`ADDR_TRANS_SECTION_MULT;
assign bram_addr_12 = (({{(MEM_ADDR_WIDTH-VA_ADDR_WIDTH){1'b0}}, va_byte_addr} - 64'h1178020000) >> `ADDR_TRANS_PHYS_WIDTH_ALIGN) + 5223868/2*`ADDR_TRANS_SECTION_MULT;
assign bram_addr_13 = (({{(MEM_ADDR_WIDTH-VA_ADDR_WIDTH){1'b0}}, va_byte_addr} - 64'hfff0000000) >> `ADDR_TRANS_PHYS_WIDTH_ALIGN) + 5225918/2*`ADDR_TRANS_SECTION_MULT;

assign in_section_0 = (va_byte_addr >= 64'h40000) & (va_byte_addr < 64'h6002200);
assign in_section_1 = (va_byte_addr >= 64'h20000000) & (va_byte_addr < 64'h20006080);
assign in_section_2 = (va_byte_addr >= 64'h40008000) & (va_byte_addr < 64'h41000040);
assign in_section_3 = (va_byte_addr >= 64'h60000000) & (va_byte_addr < 64'h60002000);
assign in_section_4 = (va_byte_addr >= 64'h1000120000) & (va_byte_addr < 64'h100014ce00);
assign in_section_5 = (va_byte_addr >= 64'h1020006000) & (va_byte_addr < 64'h1020008080);
assign in_section_6 = (va_byte_addr >= 64'h1040000000) & (va_byte_addr < 64'h1041000040);
assign in_section_7 = (va_byte_addr >= 64'h10a8000000) & (va_byte_addr < 64'h10a8400000);
assign in_section_8 = (va_byte_addr >= 64'h10d0000000) & (va_byte_addr < 64'h10d0080000);
assign in_section_9 = (va_byte_addr >= 64'h1100144000) & (va_byte_addr < 64'h1101c34600);
assign in_section_10 = (va_byte_addr >= 64'h1130000000) & (va_byte_addr < 64'h1130008000);
assign in_section_11 = (va_byte_addr >= 64'h1170000000) & (va_byte_addr < 64'h1170002000);
assign in_section_12 = (va_byte_addr >= 64'h1178020000) & (va_byte_addr < 64'h1178030040);
assign in_section_13 = (va_byte_addr >= 64'hfff0000000) & (va_byte_addr < 64'hfff0010040);

assign storage_addr =
({STORAGE_ADDR_WIDTH{in_section_0}} & bram_addr_0[STORAGE_ADDR_WIDTH-1:0])|
({STORAGE_ADDR_WIDTH{in_section_1}} & bram_addr_1[STORAGE_ADDR_WIDTH-1:0])|
({STORAGE_ADDR_WIDTH{in_section_2}} & bram_addr_2[STORAGE_ADDR_WIDTH-1:0])|
({STORAGE_ADDR_WIDTH{in_section_3}} & bram_addr_3[STORAGE_ADDR_WIDTH-1:0])|
({STORAGE_ADDR_WIDTH{in_section_4}} & bram_addr_4[STORAGE_ADDR_WIDTH-1:0])|
({STORAGE_ADDR_WIDTH{in_section_5}} & bram_addr_5[STORAGE_ADDR_WIDTH-1:0])|
({STORAGE_ADDR_WIDTH{in_section_6}} & bram_addr_6[STORAGE_ADDR_WIDTH-1:0])|
({STORAGE_ADDR_WIDTH{in_section_7}} & bram_addr_7[STORAGE_ADDR_WIDTH-1:0])|
({STORAGE_ADDR_WIDTH{in_section_8}} & bram_addr_8[STORAGE_ADDR_WIDTH-1:0])|
({STORAGE_ADDR_WIDTH{in_section_9}} & bram_addr_9[STORAGE_ADDR_WIDTH-1:0])|
({STORAGE_ADDR_WIDTH{in_section_10}} & bram_addr_10[STORAGE_ADDR_WIDTH-1:0])|
({STORAGE_ADDR_WIDTH{in_section_11}} & bram_addr_11[STORAGE_ADDR_WIDTH-1:0])|
({STORAGE_ADDR_WIDTH{in_section_12}} & bram_addr_12[STORAGE_ADDR_WIDTH-1:0])|
({STORAGE_ADDR_WIDTH{in_section_13}} & bram_addr_13[STORAGE_ADDR_WIDTH-1:0]);

assign storage_addr_out = {storage_addr, 3'b0};

assign hit_any_section = 
in_section_0 |
in_section_1 |
in_section_2 |
in_section_3 |
in_section_4 |
in_section_5 |
in_section_6 |
in_section_7 |
in_section_8 |
in_section_9 |
in_section_10 |
in_section_11 |
in_section_12 |
in_section_13 ;

endmodule
//-----------------------------------------
// End of auto generated mapping
//-----------------------------------------
