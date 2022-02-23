//////////////////////////////////////////////////////////////////////
////                                                              ////
////  or1200_fpu_mul                                              ////
////                                                              ////
////  This file is part of the OpenRISC 1200 project              ////
////  http://opencores.org/project,or1k                           ////
////                                                              ////
////  Description                                                 ////
////  Serial multiplication entity for the multiplication unit    ////
////                                                              ////
////  To Do:                                                      ////
////                                                              ////
////                                                              ////
////  Author(s):                                                  ////
////      - Original design (FPU100) -                            ////
////        Jidan Al-eryani, jidan@gmx.net                        ////
////      - Conv. to Verilog and inclusion in OR1200 -            ////
////        Julius Baxter, julius@opencores.org                   ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2006, 2010
//
//	This source file may be used and distributed without        
//	restriction provided that this copyright statement is not   
//	removed from the file and that any derivative work contains 
//	the original copyright notice and the associated disclaimer.
//                                                           
//		THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY     
//	EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED   
//	TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS   
//	FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR      
//	OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,         
//	INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES    
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE   
//	GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR        
//	BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF  
//	LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT  
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT  
//	OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE         
//	POSSIBILITY OF SUCH DAMAGE. 
//

module or1200_fpu_mul 
(  
   clk_i,
   fracta_i,
   fractb_i,
   signa_i,
   signb_i,
   start_i,
   fract_o,
   sign_o,
   ready_o
   );

   parameter FP_WIDTH = 32;
   parameter FRAC_WIDTH = 23;
   parameter EXP_WIDTH = 8;
   parameter ZERO_VECTOR = 31'd0;
   parameter INF = 31'b1111111100000000000000000000000;
   parameter QNAN = 31'b1111111110000000000000000000000;
   parameter SNAN = 31'b1111111100000000000000000000001;
   
   input clk_i;
   input [FRAC_WIDTH:0] fracta_i;   
   input [FRAC_WIDTH:0] fractb_i;   
   input 		signa_i;
   input 		signb_i;
   input 		start_i;
   output reg [2*FRAC_WIDTH+1:0] fract_o;
   output reg 		     sign_o;
   output reg 		     ready_o;
   
   parameter t_state_waiting = 1'b0,
	       t_state_busy = 1'b1;

   wire [47:0] 		     s_fract_o;
   reg [23:0] 		     s_fracta_i;
   reg [23:0] 		     s_fractb_i;
   reg 			     s_signa_i, s_signb_i;
   wire 		     s_sign_o;
   reg 			     s_start_i;
   reg 			     s_ready_o;
   reg 			     s_state;
   reg [4:0] 		     s_count;
   wire [23:0] 		     s_tem_prod;

   // Input Register
   always @(posedge clk_i)
     begin
	s_fracta_i <= fracta_i;
	s_fractb_i <= fractb_i;
	s_signa_i<= signa_i;
	s_signb_i<= signb_i;
	s_start_i <= start_i;
     end
   
   // Output Register
   always @(posedge clk_i)
     begin
	fract_o <= s_fract_o;
	sign_o <= s_sign_o;	
	ready_o <= s_ready_o;
     end

   assign s_sign_o = signa_i ^ signb_i;

   // FSM
   always @(posedge clk_i)
     if (s_start_i)
       begin
	  s_state <= t_state_busy;
	  s_count <= 0;
       end
     else if (s_count==6)
       begin
	  s_state <= t_state_waiting;
	  s_ready_o <= 1;
	  s_count <=0;
       end
     else if (s_state==t_state_busy)
       s_count <= s_count + 1;
     else
       begin
	  s_state <= t_state_waiting;
	  s_ready_o <= 0;
       end
   
DW02_mult_inst 
	U1 ( .inst_A(s_fracta_i),
	.inst_B(s_fractb_i),
	.PRODUCT_inst(s_fract_o),
	.clk(clk_i) );
endmodule // or1200_fpu_mul

