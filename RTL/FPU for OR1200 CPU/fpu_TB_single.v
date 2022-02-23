`include "timescale.v"

module fpu_tb;

reg clk;
reg rst;
reg ex_freeze;
//reg [1:0]rmode;
reg [7:0]fpu_op;
reg [31:0]a;
reg [31:0]b;
reg spr_cs;
reg spr_write;
reg [31:0] spr_addr;
reg [31:0] spr_dat_i;
reg except_started;
reg fpcsr_we;


wire [31:0]result;
wire [11:0] fpcsr;
wire done;
wire flagforw;
wire flag_we;
wire exception;  
wire sig_fp; // exception signal 
wire [31:0] spr_dat_o;

reg [6:0] count;


	or1200_fpu UUT (
		.clk(clk),
		.rst(rst),
		.ex_freeze(ex_freeze),
		.fpu_op(fpu_op),
		.a(a),
		.b(b),
		.result(result),
		.done(done),
		.flagforw(flagforw),
		.flag_we(flag_we),
		.fpcsr_we(fpcsr_we),
		.fpcsr(fpcsr),
		.sig_fp(sig_fp),
		.except_started(except_started),
		.spr_cs(1'b0),
		.spr_write(1'b0),
		.spr_addr(0),
		.spr_dat_i(0),
		.spr_dat_o(spr_dat_o));
		  		  
initial
begin : STIMUL 
	#0			  
	count = 0;
	rst = 1'b1;
	#10000;
	rst = 1'b0;	   // paste after this
//inputA:1.6
//inputB:4.0
ex_freeze = 1'b0;
fpcsr_we = 1'b1;
except_started = 1'b0;
a = 32'h3FCCCCCD;
b = 32'h40800000;
fpu_op = 8'b10000011;
#10000;
ex_freeze = 1'b1;
#200000;
//Output:
if (result==32'h0BA6274C)
	$display($time,"ps Answer is correct %h", result);
else
	begin
	$display($time,"ps Error! result is incorrect %h", result);
	$display($time,"ps Correct result is %h",32'h0BA6274C);
	end
// end of paste
//$finish;
$stop;
end 
	
always
begin : CLOCK_clk
	clk = 1'b0;
	#5000; 
	clk = 1'b1;
	#5000; 
end
endmodule
