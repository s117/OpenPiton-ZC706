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

/*
 * This is a test bench for the ifu_esl module
 *
 * Author: Michael McKeown
 */

`include "test_infrstrct.v"

`define VERBOSITY 0    // Can override from the command line

// Testbench helper module
module ifu_esl_top_helper
(
    input       clk,
    input       rst_n,
    output reg  done
);
    localparam SRC_BIT_WIDTH        = 604;
    localparam SRC_ENTRIES          = 1024;
    localparam SRC_LOG2_ENTRIES     = 10;
    localparam SINK_BIT_WIDTH       = 10;
    localparam SINK_ENTRIES         = 1024;
    localparam SINK_LOG2_ENTRIES    = 10;

    //
    // Signal Declarations
    //

    wire [SRC_BIT_WIDTH-1:0]    src_bits;
    wire                        src_val;
    wire                        src_done;

    wire [SINK_BIT_WIDTH-1:0]   sink_bits;
    wire                        sink_rdy;
    wire                        sink_done;

    //
    // Combinational Logic
    //

    always @ *
        done = src_done & sink_done;

    //
    // Module Instantiations
    //

    // Source module
    test_source
    #(
        .BIT_WIDTH (SRC_BIT_WIDTH),
        .ENTRIES (SRC_ENTRIES),
        .LOG2_ENTRIES (SRC_LOG2_ENTRIES)
    ) src
    (
        .clk (clk),
        .rst_n (rst_n),
        .rdy (rst_n), 
        .bits (src_bits),
        .val (src_val), 
        .done (src_done)
    );

    // Design under test (DUT)
    sparc_ifu_esl dut
    (
        .clk (clk),
        .rst_n (rst_n),
        .config_esl_en (src_bits[0]),
        .config_esl_sync_method (src_bits[2:1]),
        .config_esl_lfsr_seed (src_bits[18:3]),
        .config_esl_lfsr_ld (src_bits[19]),
        .config_esl_pc_diff_thresh (src_bits[69:20]),
        .config_esl_counter_timeout (src_bits[85:70]),
        .swl_esl_thr_active (src_bits[89:86]),
        .swl_esl_thr_urdy (src_bits[93:90]),
        .swl_esl_thr_sprdy_or_urdy (src_bits[97:94]),
        .swl_esl_use_spec (src_bits[98]),
        .fcl_esl_thr_f (src_bits[102:99]),
        .fdp_esl_t0inst_next_s2 (src_bits[135:103]),
        .fdp_esl_t1inst_next_s2 (src_bits[168:136]),
        .fdp_esl_t2inst_next_s2 (src_bits[201:169]),
        .fdp_esl_t3inst_next_s2 (src_bits[234:202]),
        .fdp_esl_t0inst_paddr_next_s2 (src_bits[272:235]),
        .fdp_esl_t1inst_paddr_next_s2 (src_bits[310:273]),
        .fdp_esl_t2inst_paddr_next_s2 (src_bits[348:311]),
        .fdp_esl_t3inst_paddr_next_s2 (src_bits[386:349]),
        .fdp_esl_t0pc_next_s2 (src_bits[435:387]),
        .fdp_esl_t1pc_next_s2 (src_bits[484:436]),
        .fdp_esl_t2pc_next_s2 (src_bits[533:485]),
        .fdp_esl_t3pc_next_s2 (src_bits[582:534]),
        .fcl_esl_tinst_vld_next_s (src_bits[586:583]),
        .fcl_esl_brtaken_e (src_bits[587]),
        .fcl_esl_brtaken_m (src_bits[588]),
        .fcl_esl_thr_e (src_bits[592:589]),
        .fcl_esl_thr_m (src_bits[596:593]),
        .fcl_esl_inst_vld_e (src_bits[597]),
        .fcl_esl_inst_vld_m (src_bits[598]),
        .fcl_esl_thr_trap_bf (src_bits[602:599]),
        .fcl_esl_rb_stg_s (src_bits[603]),
        .esl_fcl_nextthr_bf (sink_bits[3:0]),
        .esl_fcl_stall_bf (sink_bits[4]),
        .esl_fcl_switch_bf (sink_bits[5]),
        .esl_fdp_sync_pcs_bf (sink_bits[6]),
        .esl_fcl_ntr_s (sink_bits[7]),
        .esl_fdp_issue_prev_inst_next_s (sink_bits[8]),
        .esl_fcl_force_running_s (sink_bits[9])
    );

    // Sink module
    test_sink
    #(
        .VERBOSITY (`VERBOSITY),
        .BIT_WIDTH (SINK_BIT_WIDTH),
        .ENTRIES (SINK_ENTRIES),
        .LOG2_ENTRIES (SINK_LOG2_ENTRIES)
    ) sink
    (
        .clk (clk),
        .rst_n (rst_n),
        .bits (sink_bits),
        .val (rst_n), 
        .rdy (sink_rdy),
        .out_data_popped (),
        .done (sink_done)
    );

    // Initialize source and sink random delay values
    initial
    begin
        src.RANDOM_DELAY = 0;
        sink.RANDOM_DELAY = 0;
    end

endmodule

// Top-level testbench module
module ifu_esl_top;

    `TEST_INFRSTRCT_BEGIN("ifu_esl")

    wire done;
    integer i;

    // Plus args for test case
    reg [64*8:1] test_case;
    initial
        $value$plusargs("test_case=%s", test_case);

    ifu_esl_top_helper helper
    (
        .clk (clk),
        .rst_n (rst_n),
        .done (done)
    );

    `TEST_CASE_BEGIN(1, test_case)
    begin
        
        // Read src and sink .vmh files based off of the test name
        $readmemb({test_cases_path, test_case, "_src.vmh"}, helper.src.m_f);
        $readmemb({test_cases_path, test_case, "_sink.vmh"}, helper.sink.m_f);

        // Apply reset signal
        `TEST_CASE_RESET

        // Do a timeout check in case DUT stalls
        #10000000 `TEST_CHECK("Timeout check", done, `VERBOSITY)

        // Reset memories to all x so the next test has fresh memories
        for (i = 0; i < helper.src.ENTRIES; i = i + 1)
            helper.src.m_f[i] = {helper.src.BIT_WIDTH{1'bx}};
        for (i = 0; i < helper.sink.ENTRIES; i = i + 1)
            helper.sink.m_f[i] = {helper.sink.BIT_WIDTH{1'bx}};

    end
    `TEST_CASE_END

    `TEST_INFRSTRCT_END(1)

endmodule
