`include "timescale.v"
module DW02_mult_inst( inst_A, inst_B, PRODUCT_inst,clk );
parameter A_width = 24;
parameter B_width = 24;
input [A_width-1 : 0] inst_A;
input [B_width-1 : 0] inst_B;
//output [A_width+B_width-1 : 0] PRODUCT_inst;
output reg [A_width+B_width-1 : 0] PRODUCT_inst;

input clk;
wire [A_width+B_width-1 : 0] out0;
reg [A_width+B_width-1 : 0] out1;
reg [A_width+B_width-1 : 0] out2;
//reg [A_width+B_width-1 : 0] out3;
//reg [A_width+B_width-1 : 0] out4;
//reg [A_width+B_width-1 : 0] out5;
//reg [A_width+B_width-1 : 0] out6;
//reg [A_width+B_width-1 : 0] out7;
//reg [A_width+B_width-1 : 0] out8;
//reg [A_width+B_width-1 : 0] out9;


//Instance of DW02_mult
DW02_mult #(A_width, B_width)
U1 ( .A(inst_A), .B(inst_B), .TC(1'b0), .PRODUCT(out0) );

always @ (posedge clk)
begin
	out1 = out0;
end
always @ (posedge clk)
begin
	out2 = out1;
end
/*
always @ (posedge clk)
begin
	out3 = out2;
end

always @ (posedge clk)
begin
	out4 = out3;
end

always @ (posedge clk)
begin
	out5 = out4;
end
always @ (posedge clk)
begin
	out6 = out5;
end
always @ (posedge clk)
begin
	out7 = out6;
end
always @ (posedge clk)
begin
	out8 = out7;
end
always @ (posedge clk)
begin
	out9 = out8;
end
*/
always @ (posedge clk)
begin
	PRODUCT_inst = out2;
end

endmodule
