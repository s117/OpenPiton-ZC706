// Modified by Princeton University on June 9th, 2015
// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T1 Processor File: sparc_ifu_cmp35.v
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
//  Module Name: sparc_ifu_cmp37
//  Description:	
//  37 bit comparator for MIL hit detection
*/
////////////////////////////////////////////////////////////////////////

module sparc_ifu_cmp35(/*AUTOARG*/
   // Outputs
   hit, 
   // Inputs
   a, b, valid
   );

   input [34:0] a, b;
   input 	valid;
   
   output 	hit;

   reg 		hit;
   wire 	valid;
   wire [34:0] 	a, b;

   always @ (a or b or valid)
     begin
	if ((a==b) & valid)
	  hit = 1'b1;
	else
	  hit = 1'b0;
     end // always @ (a or b or valid)

endmodule // sparc_ifu_cmp35

