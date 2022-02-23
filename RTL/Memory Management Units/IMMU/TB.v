`timescale 1ns/1ps
`include "or1200_immu_top.v" 
//############################3
module test;
parameter aw = 32;
parameter k_input= 32;
reg clk;
reg rst,ic_en,immu_en,supv,boot_adr_sel_i,spr_cs,spr_write, qmemimmu_rty_i,qmemimmu_err_i;
reg [3:0] qmemimmu_tag_i;
reg [aw-1:0] spr_addr;
reg [aw-1:0] icpu_adr_i;
reg [k_input-1 : 0] spr_dat_i ;
wire	[aw-1:0]		icpu_adr_o;
wire	[3:0]			icpu_tag_o;
wire				icpu_rty_o;
wire				icpu_err_o;
wire	[31:0]			spr_dat_o;
wire	[aw-1:0]		qmemimmu_adr_o;
wire				qmemimmu_cycstb_o;
wire				qmemimmu_ci_o;
or1200_immu_top IMMUTOP(
	// Rst and clk
	clk, rst,

	// CPU i/f
	ic_en, immu_en, supv, icpu_adr_i, icpu_cycstb_i,
	icpu_adr_o, icpu_tag_o, icpu_rty_o, icpu_err_o,

	// SR Interface
	boot_adr_sel_i,

	// SPR access
	spr_cs, spr_write, spr_addr, spr_dat_i, spr_dat_o,

	// QMEM i/f
	qmemimmu_rty_i, qmemimmu_err_i, qmemimmu_tag_i, qmemimmu_adr_o, qmemimmu_cycstb_o, qmemimmu_ci_o
);

//initial xjc.size=size;
initial begin 
		clk=1;
                rst=1;
                boot_adr_sel_i=0;
                spr_cs=1;
                supv=1;
                immu_en=1;
                spr_write=1;
                qmemimmu_rty_i=0;
                qmemimmu_err_i=0;
                ic_en=1;
                qmemimmu_tag_i=1;
                spr_addr=10;
                icpu_adr_i=13;
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
                #401 icpu_adr_i=2;
                #600 spr_write=0;
                #601 spr_write=1;
                #601 icpu_adr_i=3;
                #800 $finish;	
	end
//initial $monitor($time,,"[%b]\t%b\tq=%b",clk,r,q);
always #4 clk=~clk;


endmodule
