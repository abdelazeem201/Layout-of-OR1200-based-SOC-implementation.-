`include "timescale.v"
`include "or1200_defines.v"

module or1200_branchpredict(
	clk,
	rst,
	pc,
	id_branch_op,
	id_branch_addrtarget,
	icpu_adr_o,
	predict_taken,
	ex_branch_taken,
	ex_branch_op,
	ex_branch_addrtarget
);

parameter dw = `OR1200_OPERAND_WIDTH;

input clk;
input rst;

input [31:0] pc;
input [`OR1200_BRANCHOP_WIDTH-1:0] id_branch_op;
input [dw-1:2] id_branch_addrtarget;
output [31:0] icpu_adr_o;
output reg predict_taken;
input ex_branch_taken;
input [`OR1200_BRANCHOP_WIDTH-1:0] ex_branch_op;
input [dw-1:2] ex_branch_addrtarget;

`ifdef OR1200_BRANCHPREDICT_DYNAMIC
// fsm[first:2]: addrtarget tag
// fsm[1:0]: state machine
reg [dw-6:0] branch_addrtarget_fsm[31:0];
`endif

assign icpu_adr_o = predict_taken ? id_branch_addrtarget : pc;

`ifdef OR1200_BRANCHPREDICT_STATIC
always @(posedge clk or `OR1200_RST_EVENT rst) begin
	if (rst == `OR1200_RST_VALUE)
		predict_taken <= 1'b0;
	else begin
		if (id_branch_op == `OR1200_BRANCHOP_RFE)
			predict_taken <= 1'b1;
		else if (|id_branch_op)
			predict_taken <= id_branch_addrtarget < pc ? 1'b1 : 1'b0;
		else
			predict_taken <= 1'b0;
	end
end
`else
`ifdef OR1200_BRANCHPREDICT_DYNAMIC
always @(posedge clk or `OR1200_RST_EVENT rst) begin
	if (rst == `OR1200_RST_VALUE)
		predict_taken <= 1'b0;
	else begin
		if(id_branch_op == `OR1200_BRANCHOP_RFE)
			predict_taken <= 1'b1;
		else
			predict_taken <= branch_addrtarget_fsm[id_branch_addrtarget[6:2]][1];
	end
end

always @(ex_branch_taken or ex_branch_op) begin
	if (ex_branch_op != `OR1200_BRANCHOP_RFE) begin
		if (|ex_branch_op) begin
			if (branch_addrtarget_fsm[ex_branch_addrtarget[6:2]][dw-6:2] == ex_branch_addrtarget[dw-1:7]) begin
				case (branch_addrtarget_fsm[ex_branch_addrtarget[6:2]][1:0])
				2'b00: branch_addrtarget_fsm[ex_branch_addrtarget[6:2]][1:0] <= {1'b1, 1'b0, ex_branch_taken};
				2'b01: branch_addrtarget_fsm[ex_branch_addrtarget[6:2]][1:0] <= {1'b1, ex_branch_taken, ex_branch_taken};
				2'b11: branch_addrtarget_fsm[ex_branch_addrtarget[6:2]][1:0] <= {1'b1, ex_branch_taken, ~ex_branch_taken};
				2'b10: branch_addrtarget_fsm[ex_branch_addrtarget[6:2]][1:0] <= {1'b1, 1'b1, ~ex_branch_taken};
				endcase
			end
			else begin
				branch_addrtarget_fsm[ex_branch_addrtarget[6:2]] <= {ex_branch_addrtarget[dw-1:7], 1'b0, ex_branch_taken};
			end
		end
	end
end
`else
always @(posedge clk or `OR1200_RST_EVENT rst) begin
	if (rst == `OR1200_RST_VALUE)
		predict_taken <= 1'b0;
	else
		predict_taken <= 1'b0
end
`endif
`endif

endmodule
