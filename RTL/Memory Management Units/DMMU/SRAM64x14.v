/*********************************************************************
*  saed_mc : SRAM64x14 Verilog description                         *
*  ---------------------------------------------------------------   *
*  Filename      : SRAM64x14.v                         *
*  SRAM name     : SRAM64x14                                         *
*  Word width    : 64    bits                                        *
*  Word number   : 14                                                *
*  Adress width  : 0     bits                                        *
*  ---------------------------------------------------------------   *
*  Creation date : Mon April 14 2014                                 *
*********************************************************************/

`timescale 1ns/1ps

`define numAddr 6 
`define numWords 64
`define wordLength 14


module SRAM64x14 (A,CE,WEB,OEB,CSB,I,O);

input 				CE;
input 				WEB;
input 				OEB;
input 				CSB;

input 	[`numAddr-1:0] 		A;
input 	[`wordLength-1:0] 	I;
output 	[`wordLength-1:0] 	O;

reg    	[`wordLength-1:0]  memory[`numWords-1:0];
reg  	[`wordLength-1:0]	data_out1;
reg 	[`wordLength-1:0] 	O;

wire 				RE;
wire 				WE;


and u1 (RE, ~CSB,  WEB);
and u2 (WE, ~CSB, ~WEB);


always @ (posedge CE) 
	if (RE)
		data_out1 = memory[A];
	else 
	   if (WE)
		memory[A] = I;
		

always @ (data_out1 or OEB)
	if (!OEB) 
		O = data_out1;
	else
		O =  64'bz;

endmodule
