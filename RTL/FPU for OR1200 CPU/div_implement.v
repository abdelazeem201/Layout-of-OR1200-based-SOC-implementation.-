module DW_div_inst (a, b, quotient, remainder, divide_by_0,clk);
	parameter tc_mode = 0;
	parameter rem_mode = 1; // corresponds to "%" in Verilog
	input [26:0] a;
	input [26:0] b;
	input clk;
	output reg [26:0] quotient;
	output reg [26:0] remainder;
	output reg            divide_by_0;

	wire [26:0] q0;
	wire [26:0] r0;
	reg [26:0] q1;
	reg [26:0] r1;
	reg [26:0] q2;
	reg [26:0] r2;
	reg [26:0] q3;
	reg [26:0] r3;
	reg [26:0] q4;
	reg [26:0] r4;
	reg [26:0] q5;
	reg [26:0] r5;
	reg [26:0] q6;
	reg [26:0] r6;
	wire db0;
	reg db1;
	reg db2;
	reg db3;
	reg db4;
	reg db5;
	reg db6;

	DW_div #(27, 27, tc_mode, rem_mode)
		U1 (.a(a), .b(b),
		    .quotient(q0), .remainder(r0),
		    .divide_by_0(db0));

	always @ (posedge clk)
	begin
		q1 = q0;
		r1 = r0;
		db1 = db0;
	end

	always @ (posedge clk)
	begin
		q2 = q1;
		r2 = r1;
		db2 = db1;
	end

	always @ (posedge clk)
	begin
		q3 = q2;
		r3 = r2;
		db3 = db2;
	end

	always @ (posedge clk)
	begin
		q4 = q3;
		r4 = r3;
		db4 = db3;
	end

	always @ (posedge clk)
	begin
		q5 = q4;
		r5 = r4;
		db5 = db4;
	end

	always @ (posedge clk)
	begin
		quotient = q5;
		remainder = r5;
		divide_by_0 = db5;
	end
		
endmodule


