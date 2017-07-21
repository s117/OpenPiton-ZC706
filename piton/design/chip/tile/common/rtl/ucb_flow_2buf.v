// Modified by Princeton University on June 9th, 2015
// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: ucb_flow_2buf.v
// Copyright (c) 2006 Sun Microsystems, Inc.  All Rights Reserved.
// DO NOT ALTER OR REMOVE COPYRIGHT NOTICES.
// 
// The above named program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public
// License version 2 as published by the Free Software Foundation.
// 
// The above named program is distributed in the hope that it will be 
// useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// General Public License for more details.
// 
// You should have received a copy of the GNU General Public
// License along with this work; if not, write to the Free Software
// Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA.
// 
// ========== Copyright Header End ============================================
////////////////////////////////////////////////////////////////////////
/*
//  Module Name:        ucb_flow_2buf
//	Description:	Unit Control Block
//                      - supports 64-bit or 128-bit read with flow control
//                      - supports 64-bit write with flow control
//                      - automactically drops non-64-bit writes
//                      - supports interrupt return to IO Bridge
//                      - provides 1+2 deep buffer for incoming requests
//                        from the IO Bridge
//                      - provides single buffer for returns going back
//                        to the IO Bridge
//
//                      This module is intended for units that have
//                      64-bit (no 128-bit) registers.
//
//                      Data bus width to and from the IO Bridge is
//                      configured through parameters UCB_IOB_WIDTH and
//                      IOB_UCB_WIDTH.  Supported widths are:
//
//                      IOB_UCB_WIDTH  UCB_IOB_WIDTH
//                      ----------------------------
//                      32             8
//                      16             8
//                       8             8
//                       4             4             
 */ 
////////////////////////////////////////////////////////////////////////
// Global header file includes
////////////////////////////////////////////////////////////////////////
`include	"sys.h" // system level definition file which 
                        // contains the time scale definition

`include        "iop.h"

////////////////////////////////////////////////////////////////////////
// Local header file includes / local defines
////////////////////////////////////////////////////////////////////////
`define         UCB_BUF_DEPTH   2
`define         UCB_BUF_WIDTH   64+(`UCB_ADDR_HI-`UCB_ADDR_LO+1)+(`UCB_SIZE_HI-`UCB_SIZE_LO+1)+(`UCB_BUF_HI-`UCB_BUF_LO+1)+(`UCB_THR_HI-`UCB_THR_LO+1)+1+1

module ucb_flow_2buf (/*AUTOARG*/
   // Outputs
   ucb_iob_stall, rd_req_vld, wr_req_vld, thr_id_in, buf_id_in, 
   size_in, addr_in, data_in, ack_busy, int_busy, ucb_iob_vld, 
   ucb_iob_data, 
   // Inputs
   clk, rst_l, iob_ucb_vld, iob_ucb_data, req_acpted, rd_ack_vld, 
   rd_nack_vld, thr_id_out, buf_id_out, data128, data_out, int_vld, 
   int_typ, int_thr_id, dev_id, int_stat, int_vec, iob_ucb_stall
   );
   // synopsys template
   
   parameter IOB_UCB_WIDTH = 32;  // data bus width from IOB to UCB
   parameter UCB_IOB_WIDTH = 8;   // data bus width from UCB to IOB
   parameter REG_WIDTH     = 64;  // please do not change this parameter
   

   // Globals
   input                                clk;
   input 				rst_l;
   
   // Request from IO Bridge
   input 				iob_ucb_vld;
   input [IOB_UCB_WIDTH-1:0] 		iob_ucb_data;
   output 				ucb_iob_stall;

   // Request to local unit
   output 				rd_req_vld;
   output 				wr_req_vld;
   output [`UCB_THR_HI-`UCB_THR_LO:0]   thr_id_in;
   output [`UCB_BUF_HI-`UCB_BUF_LO:0]   buf_id_in;
   output [`UCB_SIZE_HI-`UCB_SIZE_LO:0] size_in;   // only pertinent to PCI
   output [`UCB_ADDR_HI-`UCB_ADDR_LO:0] addr_in;
   output [`UCB_DATA_HI-`UCB_DATA_LO:0] data_in;
   input 				req_acpted;
   
   // Ack/Nack from local unit
   input 				rd_ack_vld;
   input 				rd_nack_vld;
   input [`UCB_THR_HI-`UCB_THR_LO:0] 	thr_id_out;
   input [`UCB_BUF_HI-`UCB_BUF_LO:0] 	buf_id_out;
   input 				data128;   // set to 1 if data returned is 128 bit
   input [REG_WIDTH-1:0] 		data_out;
   output 				ack_busy;

   // Interrupt from local unit
   input 				int_vld;
   input [`UCB_PKT_HI-`UCB_PKT_LO:0] 	int_typ;          // interrupt type
   input [`UCB_THR_HI-`UCB_THR_LO:0] 	int_thr_id;       // interrupt thread ID
   input [`UCB_INT_DEV_HI-`UCB_INT_DEV_LO:0] dev_id;      // interrupt device ID
   input [`UCB_INT_STAT_HI-`UCB_INT_STAT_LO:0] int_stat;  // interrupt status
   input [`UCB_INT_VEC_HI-`UCB_INT_VEC_LO:0]   int_vec;   // interrupt vector
   output 				int_busy;
   
   // Output to IO Bridge
   output 				ucb_iob_vld;
   output [UCB_IOB_WIDTH-1:0] 		ucb_iob_data;
   input 				iob_ucb_stall;
   
   // Local signals
   wire                                 indata_buf_vld;
   wire [127:0]                         indata_buf;
   wire                                 ucb_iob_stall_a1;
   
   wire                                 read_pending;
   wire                                 write_pending;
   wire                                 illegal_write_size;

   wire 				rd_buf;
   wire [`UCB_BUF_DEPTH-1:0] 		buf_head_next;
   wire [`UCB_BUF_DEPTH-1:0] 		buf_head;
   wire 				wr_buf;
   wire [`UCB_BUF_DEPTH-1:0] 		buf_tail_next;
   wire [`UCB_BUF_DEPTH-1:0] 		buf_tail;
   wire 				buf_full_next;
   wire 				buf_full;
   wire 				buf_empty_next;
   wire 				buf_empty;
   wire [`UCB_BUF_WIDTH-1:0] 		req_in;
   wire 				buf0_en;
   wire [`UCB_BUF_WIDTH-1:0] 		buf0;
   wire 				buf1_en;
   wire [`UCB_BUF_WIDTH-1:0] 		buf1;
   wire [`UCB_BUF_WIDTH-1:0] 		req_out;
   wire 				rd_req_vld_nq;
   wire 				wr_req_vld_nq;

   wire                                 ack_buf_rd;
   wire                                 ack_buf_wr;
   wire                                 ack_buf_vld;
   wire                                 ack_buf_vld_next;
   wire                                 ack_buf_is_nack;
   wire                                 ack_buf_is_data128;
   wire [`UCB_PKT_HI-`UCB_PKT_LO:0]     ack_typ_out;
   wire [REG_WIDTH+`UCB_BUF_HI-`UCB_PKT_LO:0] ack_buf_in;
   wire [REG_WIDTH+`UCB_BUF_HI-`UCB_PKT_LO:0] ack_buf;
   wire [(REG_WIDTH+64)/UCB_IOB_WIDTH-1:0] ack_buf_vec;
   
   wire                                 int_buf_rd;
   wire                                 int_buf_wr;
   wire                                 int_buf_vld;
   wire                                 int_buf_vld_next;
   wire [`UCB_INT_VEC_HI-`UCB_PKT_LO:0] int_buf_in;
   wire [`UCB_INT_VEC_HI-`UCB_PKT_LO:0] int_buf;
   wire [(REG_WIDTH+64)/UCB_IOB_WIDTH-1:0] int_buf_vec;
   
   wire                                 int_last_rd;
   wire                                 outdata_buf_busy;
   wire                                 outdata_buf_wr;
   wire [REG_WIDTH+63:0]                outdata_buf_in;
   wire [(REG_WIDTH+64)/UCB_IOB_WIDTH-1:0] outdata_vec_in;
   
   
////////////////////////////////////////////////////////////////////////
// Code starts here
////////////////////////////////////////////////////////////////////////
   /************************************************************
    * Inbound Data
    ************************************************************/
   // Register size is hardcoded to 64 bits here because all
   // units using the UCB module will only write to 64 bit registers.
   ucb_bus_in #(IOB_UCB_WIDTH,64) ucb_bus_in (.rst_l(rst_l),
                                              .clk(clk),
                                              .vld(iob_ucb_vld),
                                              .data(iob_ucb_data),
                                              .stall(ucb_iob_stall),
                                              .indata_buf_vld(indata_buf_vld),
                                              .indata_buf(indata_buf),
                                              .stall_a1(ucb_iob_stall_a1));


   /************************************************************
    * Decode inbound packet type
    ************************************************************/
   assign 	 read_pending = (indata_buf[`UCB_PKT_HI:`UCB_PKT_LO] ==
				 `UCB_READ_REQ) &
			        indata_buf_vld;

   assign 	 write_pending = (indata_buf[`UCB_PKT_HI:`UCB_PKT_LO] == 
				  `UCB_WRITE_REQ) &
        	                  indata_buf_vld;

   // 3'b011 is the encoding for double word.  All writes have to be
   // 64 bits except writes going to PCI.  PCI will instantiate a
   // customized version of UCB.
   assign 	 illegal_write_size = (indata_buf[`UCB_SIZE_HI:`UCB_SIZE_LO] !=
				       3'b011);
   
   assign 	 ucb_iob_stall_a1 = (read_pending | write_pending) & buf_full;

   
   /************************************************************
    * Inbound buffer
    ************************************************************/
   // Head pointer
   assign 	 rd_buf = req_acpted;
   assign 	 buf_head_next = ~rst_l ? `UCB_BUF_DEPTH'b01 :
                                 rd_buf ? {buf_head[`UCB_BUF_DEPTH-2:0],
				           buf_head[`UCB_BUF_DEPTH-1]} :
	                                  buf_head;
   dff_ns #(`UCB_BUF_DEPTH) buf_head_ff (.din(buf_head_next),
					 .clk(clk),
					 .q(buf_head));

   // Tail pointer
   assign 	 wr_buf = (read_pending |
		           (write_pending & ~illegal_write_size)) &
			  ~buf_full;
   assign 	 buf_tail_next = ~rst_l ? `UCB_BUF_DEPTH'b01 :
                                 wr_buf ? {buf_tail[`UCB_BUF_DEPTH-2:0],
				           buf_tail[`UCB_BUF_DEPTH-1]} :
	                                  buf_tail;
   dff_ns #(`UCB_BUF_DEPTH) buf_tail_ff (.din(buf_tail_next),
					 .clk(clk),
					 .q(buf_tail));

   // Buffer full
   assign 	 buf_full_next = (buf_head_next == buf_tail_next) &
				 wr_buf;
   dffrle_ns #(1) buf_full_ff (.din(buf_full_next),
			       .rst_l(rst_l),
			       .en(rd_buf|wr_buf),
			       .clk(clk),
			       .q(buf_full));

   // Buffer empty
   assign 	 buf_empty_next = ((buf_head_next == buf_tail_next) &
				   rd_buf) | ~rst_l;
   dffe_ns #(1) buf_empty_ff (.din(buf_empty_next),
			      .en(rd_buf|wr_buf|~rst_l), 
			      .clk(clk),
			      .q(buf_empty));
   

   assign 	 req_in = {indata_buf[`UCB_DATA_HI:`UCB_DATA_LO],
			   indata_buf[`UCB_ADDR_HI:`UCB_ADDR_LO],
			   indata_buf[`UCB_SIZE_HI:`UCB_SIZE_LO],
			   indata_buf[`UCB_BUF_HI:`UCB_BUF_LO],
			   indata_buf[`UCB_THR_HI:`UCB_THR_LO],
			   write_pending & ~illegal_write_size,
			   read_pending};
	  
   // Buffer 0
   assign 	 buf0_en = buf_tail[0] & wr_buf;
   dffe_ns #(`UCB_BUF_WIDTH) buf0_ff (.din(req_in),
				      .en(buf0_en),
				      .clk(clk),
				      .q(buf0));
   // Buffer 1
   assign 	 buf1_en = buf_tail[1] & wr_buf;
   dffe_ns #(`UCB_BUF_WIDTH) buf1_ff (.din(req_in),
				      .en(buf1_en),
				      .clk(clk),
				      .q(buf1));

   assign 	 req_out = buf_head[0] ? buf0 :
	                   buf_head[1] ? buf1 :
	                                 {`UCB_BUF_WIDTH{1'b0}};

   
   /************************************************************
    * Inbound interface to local unit
    ************************************************************/
   assign 	 {data_in,
		  addr_in,
		  size_in,
		  buf_id_in,
		  thr_id_in,
		  wr_req_vld_nq,
		  rd_req_vld_nq} = req_out;
   
   assign 	 rd_req_vld = rd_req_vld_nq & ~buf_empty;
   assign 	 wr_req_vld = wr_req_vld_nq & ~buf_empty;
   
	  
   /************************************************************
    * Outbound Ack/Nack
    ************************************************************/
   assign        ack_buf_wr = rd_ack_vld | rd_nack_vld;
   
   assign        ack_buf_vld_next = ack_buf_wr ? 1'b1 :
                                    ack_buf_rd ? 1'b0 :
                                                 ack_buf_vld;
   
   dffrl_ns #(1) ack_buf_vld_ff (.din(ack_buf_vld_next),
                                 .clk(clk),
                                 .rst_l(rst_l),
                                 .q(ack_buf_vld));
   
   dffe_ns #(1) ack_buf_is_nack_ff (.din(rd_nack_vld),
                                    .en(ack_buf_wr),
                                    .clk(clk),
                                    .q(ack_buf_is_nack));

   dffe_ns #(1) ack_buf_is_data128_ff (.din(data128),
                                       .en(ack_buf_wr),
                                       .clk(clk),
                                       .q(ack_buf_is_data128));

   assign        ack_typ_out = rd_ack_vld ? `UCB_READ_ACK:
                                            `UCB_READ_NACK;

   assign        ack_buf_in = {data_out,
                               buf_id_out,
                               thr_id_out,
                               ack_typ_out};
   
   dffe_ns #(REG_WIDTH+`UCB_BUF_HI-`UCB_PKT_LO+1) ack_buf_ff (.din(ack_buf_in),
                                                              .en(ack_buf_wr),
                                                              .clk(clk),
                                                              .q(ack_buf));

   assign        ack_buf_vec = ack_buf_is_nack    ? {{REG_WIDTH/UCB_IOB_WIDTH{1'b0}},
                                                     {64/UCB_IOB_WIDTH{1'b1}}} :
                               ack_buf_is_data128 ? {(REG_WIDTH+64)/UCB_IOB_WIDTH{1'b1}} :
                                                    {(64+64)/UCB_IOB_WIDTH{1'b1}};
   
   assign        ack_busy = ack_buf_vld;
   

   /************************************************************
    * Outbound Interrupt
    ************************************************************/
   // Assertion: int_buf_wr shoudn't be asserted if int_buf_busy
   assign        int_buf_wr = int_vld;
   
   assign        int_buf_vld_next = int_buf_wr ? 1'b1 :
                                    int_buf_rd ? 1'b0 :
                                                 int_buf_vld;
   
   dffrl_ns #(1) int_buf_vld_ff (.din(int_buf_vld_next),
                                 .clk(clk),
                                 .rst_l(rst_l),
                                 .q(int_buf_vld));

   assign        int_buf_in = {int_vec,
                               int_stat,
                               dev_id,
                               int_thr_id,
                               int_typ};
   
   dffe_ns #(`UCB_INT_VEC_HI-`UCB_PKT_LO+1) int_buf_ff (.din(int_buf_in),
                                                        .en(int_buf_wr),
                                                        .clk(clk),
                                                        .q(int_buf));

   assign        int_buf_vec = {{REG_WIDTH/UCB_IOB_WIDTH{1'b0}},
                                {64/UCB_IOB_WIDTH{1'b1}}};

   assign        int_busy = int_buf_vld;


   /************************************************************
    * Outbound ack/interrupt Arbitration
    ************************************************************/
   dffrle_ns #(1) int_last_rd_ff (.din(int_buf_rd),
                                  .en(ack_buf_rd|int_buf_rd),
                                  .rst_l(rst_l),
                                  .clk(clk),
                                  .q(int_last_rd));
                           
   assign        ack_buf_rd = ~outdata_buf_busy & ack_buf_vld &
                              (~int_buf_vld | int_last_rd);
   
   assign        int_buf_rd = ~outdata_buf_busy & int_buf_vld &
                              (~ack_buf_vld | ~int_last_rd);

   assign        outdata_buf_wr = ack_buf_rd | int_buf_rd;
   
   assign        outdata_buf_in = ack_buf_rd ? {ack_buf[REG_WIDTH+`UCB_BUF_HI:`UCB_BUF_HI+1],
                                                {(`UCB_RSV_HI-`UCB_RSV_LO+1){1'b0}},
                                                {(`UCB_ADDR_HI-`UCB_ADDR_LO+1){1'b0}},
                                                {(`UCB_SIZE_HI-`UCB_SIZE_LO+1){1'b0}},
                                                ack_buf[`UCB_BUF_HI:`UCB_BUF_LO],
                                                ack_buf[`UCB_THR_HI:`UCB_THR_LO],
                                                ack_buf[`UCB_PKT_HI:`UCB_PKT_LO]}:
                                               {{REG_WIDTH{1'b0}},
                                                {(`UCB_INT_RSV_HI-`UCB_INT_RSV_LO+1){1'b0}},
                                                int_buf[`UCB_INT_VEC_HI:`UCB_INT_VEC_LO],
                                                int_buf[`UCB_INT_STAT_HI:`UCB_INT_STAT_LO],
                                                int_buf[`UCB_INT_DEV_HI:`UCB_INT_DEV_LO],
                                                int_buf[`UCB_THR_HI:`UCB_THR_LO],
                                                int_buf[`UCB_PKT_HI:`UCB_PKT_LO]};
   
   assign        outdata_vec_in = ack_buf_rd ? ack_buf_vec :
                                               int_buf_vec;
   
   ucb_bus_out #(UCB_IOB_WIDTH, REG_WIDTH) ucb_bus_out (.rst_l(rst_l),
                                                        .clk(clk),
                                                        .outdata_buf_wr(outdata_buf_wr),
                                                        .outdata_buf_in(outdata_buf_in),
                                                        .outdata_vec_in(outdata_vec_in),
                                                        .outdata_buf_busy(outdata_buf_busy),
                                                        .vld(ucb_iob_vld),
                                                        .data(ucb_iob_data),
                                                        .stall(iob_ucb_stall));
   

`undef		UCB_BUF_WIDTH
	  
endmodule // ucb_flow_2buf


// Local Variables:
// verilog-library-directories:(".")
// End:







