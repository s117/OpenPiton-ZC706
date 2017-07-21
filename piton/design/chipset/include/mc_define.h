// ========== Copyright Header Begin ============================================
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
// ========== Copyright Header End ============================================

`define MIG_WR_CMD  3'b000
`define MIG_RD_CMD  3'b001

`ifdef VC707_BOARD
    `define MIG_APP_ADDR_WIDTH      28
    `define MIG_APP_CMD_WIDTH       3
    `define MIG_APP_DATA_WIDTH      512
    `define MIG_APP_BURST_OFFSET    6   // in bits: logb2(MIG_APP_DATA_WIDTH / 8)
    `define MIG_APP_MASK_WIDTH      64

    `define DDR3_DQ_WIDTH           64
    `define DDR3_DQS_WIDTH          8
    `define DDR3_ADDR_WIDTH         14
    `define DDR3_BA_WIDTH           3
    `define DDR3_DM_WIDTH           8
    `define DDR3_CK_WIDTH           1
    `define DDR3_CKE_WIDTH          1
    `define DDR3_CS_WIDTH           1
`elsif NEXYS4DDR_BOARD
    `define MIG_APP_ADDR_WIDTH      27
    `define MIG_APP_CMD_WIDTH       3
    `define MIG_APP_DATA_WIDTH      128
    `define MIG_APP_BURST_OFFSET    4   // in bits: logb2(MIG_APP_DATA_WIDTH / 8) 
    `define MIG_APP_MASK_WIDTH      16

    `define DDR3_DQ_WIDTH           16
    `define DDR3_DQS_WIDTH          2
    `define DDR3_ADDR_WIDTH         13
    `define DDR3_BA_WIDTH           3
    `define DDR3_DM_WIDTH           2
    `define DDR3_CK_WIDTH           1
    `define DDR3_CKE_WIDTH          1
    `define DDR3_CS_WIDTH           1
`elsif GENESYS2_BOARD
    `define MIG_APP_ADDR_WIDTH      29
    `define MIG_APP_CMD_WIDTH       3
    `define MIG_APP_DATA_WIDTH      256
    `define MIG_APP_BURST_OFFSET    5      // in bits: logb2(MIG_APP_DATA_WIDTH / 8)
    `define MIG_APP_MASK_WIDTH      32

    `define DDR3_DQ_WIDTH           32
    `define DDR3_DQS_WIDTH          4
    `define DDR3_ADDR_WIDTH         15
    `define DDR3_BA_WIDTH           3
    `define DDR3_DM_WIDTH           4
    `define DDR3_CK_WIDTH           1
    `define DDR3_CKE_WIDTH          1
    `define DDR3_CS_WIDTH           1
`elsif NEXYSVIDEO_BOARD
    `define MIG_APP_ADDR_WIDTH      29
    `define MIG_APP_CMD_WIDTH       3
    `define MIG_APP_DATA_WIDTH      128
    `define MIG_APP_BURST_OFFSET    4   // in bits: logb2(MIG_APP_DATA_WIDTH / 8) 
    `define MIG_APP_MASK_WIDTH      16

    `define DDR3_DQ_WIDTH           16
    `define DDR3_DQS_WIDTH          2
    `define DDR3_ADDR_WIDTH         15
    `define DDR3_BA_WIDTH           3
    `define DDR3_DM_WIDTH           2
    `define DDR3_CK_WIDTH           1
    `define DDR3_CKE_WIDTH          1
    `define DDR3_CS_WIDTH           1
`else
    `define MIG_APP_ADDR_WIDTH      29
    `define MIG_APP_CMD_WIDTH       3
    `define MIG_APP_DATA_WIDTH      512
    `define MIG_APP_BURST_OFFSET    6   // in bits: logb2(MIG_APP_DATA_WIDTH / 8)
    `define MIG_APP_MASK_WIDTH      64

    `define DDR3_DQ_WIDTH           64
    `define DDR3_DQS_WIDTH          8
    `define DDR3_ADDR_WIDTH         15
    `define DDR3_BA_WIDTH           3
    `define DDR3_DM_WIDTH           8
    `define DDR3_CK_WIDTH           1
    `define DDR3_CKE_WIDTH          1
    `define DDR3_CS_WIDTH           1
`endif
