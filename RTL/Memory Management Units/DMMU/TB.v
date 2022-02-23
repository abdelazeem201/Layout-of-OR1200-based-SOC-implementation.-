`timescale 1ns/1ps
`include "or1200_dmmu_top.v" 
//############################3
module test;
parameter aw = 32;
parameter k_input= 32;
reg clk;
reg rst,dc_en,dmmu_en,supv,spr_cs,spr_write, dcpu_cycstb_i,qmemdmmu_err_i,dcpu_we_i;
reg [3:0] qmemdmmu_tag_i;
reg [aw-1:0] spr_addr;
reg [aw-1:0] dcpu_adr_i;
reg [k_input-1 : 0] spr_dat_i ;
wire	[aw-1:0]		dcpu_adr_o;
wire	[3:0]			dcpu_tag_o;
wire				dcpu_rty_o;
wire				dcpu_err_o;
wire	[31:0]			spr_dat_o;
wire	[aw-1:0]		qmemdmmu_adr_o;
wire				qmemdmmu_cycstb_o;
wire				qmemdmmu_ci_o;
or1200_dmmu_top DMMUTOP(
	// Rst and clk
	clk, rst,

	// CPU i/f
	dc_en, dmmu_en, supv, dcpu_adr_i, dcpu_cycstb_i,dcpu_we_i,
        dcpu_tag_o, dcpu_err_o,

	// SPR access
	spr_cs, spr_write, spr_addr, spr_dat_i, spr_dat_o,


	// DC i/f
	qmemdmmu_err_i, qmemdmmu_tag_i, qmemdmmu_adr_o, qmemdmmu_cycstb_o, qmemdmmu_ci_o

);

//initial xjc.size=size;
initial begin 
		clk=1;
                rst=1;
                spr_cs=1;
                supv=1;
                dmmu_en=1;
                spr_write=1;
                qmemdmmu_err_i=0;
                dc_en=1;
                dcpu_we_i=1;
                qmemdmmu_tag_i=1;
                spr_addr=10;
                dcpu_adr_i=13;
                spr_dat_i=32'hACAC01F1;
                #1 rst=0;
                #2 rst=1;
                #96 spr_write=0;
                #36 spr_write=1;
                #200 spr_write=0;
                #201 spr_write=1;
                #201 spr_write=1;
                #30  spr_write=0;
                #100 spr_write=1;
                #400 spr_write=0;
                #401 spr_write=1;
                #30  spr_write=0;
                #100 spr_write=1;
                #229 spr_write=0;
                #36 spr_write=1;
                #401 dcpu_adr_i=2;
                #600 spr_write=0;
                #601 spr_write=1;
                #601 dcpu_adr_i=3;
                #800 $finish;	
	end
//initial $monitor($time,,"[%b]\t%b\tq=%b",clk,r,q);
always #4 clk=~clk;


endmodule
