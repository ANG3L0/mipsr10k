`timescale 1ns/100ps
module testbench;
///////// INPUTS //////////
reg		ex_alu_full;
reg	[5:0]	ex_cm_cdbAIdx;
reg		ex_cm_cdbA_en;
reg	[5:0]	ex_cm_cdbBIdx;
reg		ex_cm_cdbB_en;
reg		ex_ld_full;
reg		ex_mulq_full;
reg		ex_sv_full;
reg	[5:0]	fl_TA;
reg	[5:0]	fl_TB;
reg	[31:0]	id_IRA;
reg		id_IRA_valid;
reg	[31:0]	id_IRB;
reg		id_IRB_valid;
reg	[4:0]	id_alu_funcA;
reg	[4:0]	id_alu_funcB;
reg	[1:0]	id_op1A_select;
reg	[1:0]	id_op1B_select;
reg	[1:0]	id_op2A_select;
reg	[1:0]	id_op2B_select;
reg	[6:0]	mt_T1A;
reg	[6:0]	mt_T1B;
reg	[6:0]	mt_T2A;
reg	[6:0]	mt_T2B;
reg	[4:0]	mt_archIdxA;
reg	[4:0]	mt_archIdxB;
reg		reset;
reg	[4:0]	rob_idxA;
reg	[4:0]	rob_idxB;
reg		rob_instA_en;
reg		rob_instB_en;
///////// OUTPUTS //////////
wire	[3:0]	initFreeA;
wire	[31:0]	rs_IRA_out;
wire	[31:0]	rs_IRB_out;
wire	[5:0]	rs_T1A_out;
wire	[5:0]	rs_T1B_out;
wire	[5:0]	rs_T2A_out;
wire	[5:0]	rs_T2B_out;
wire	[5:0]	rs_TA_out;
wire	[5:0]	rs_TB_out;
wire		rs_almostFull_out;
wire	[4:0]	rs_alu_funcA_out;
wire	[4:0]	rs_alu_funcB_out;
wire		rs_busy_out;
wire	[2:0]	rs_issueA_out;
wire		rs_issueArdy_out;
wire	[2:0]	rs_issueB_out;
wire		rs_issueBrdy_out;
wire	[1:0]	rs_op1A_select_out;
wire	[1:0]	rs_op1B_select_out;
wire	[1:0]	rs_op2A_select_out;
wire	[1:0]	rs_op2B_select_out;
wire	[4:0]	rs_rob_idxA_out;
wire	[4:0]	rs_rob_idxB_out;


rs   rs_0(
	//input ports
	.ex_alu_full(ex_alu_full),
	.ex_cm_cdbAIdx(ex_cm_cdbAIdx),
	.ex_cm_cdbA_en(ex_cm_cdbA_en),
	.ex_cm_cdbBIdx(ex_cm_cdbBIdx),
	.ex_cm_cdbB_en(ex_cm_cdbB_en),
	.ex_ld_full(ex_ld_full),
	.ex_mulq_full(ex_mulq_full),
	.ex_sv_full(ex_sv_full),
	.fl_TA(fl_TA),
	.fl_TB(fl_TB),
	.id_IRA(id_IRA),
	.id_IRA_valid(id_IRA_valid),
	.id_IRB(id_IRB),
	.id_IRB_valid(id_IRB_valid),
	.id_alu_funcA(id_alu_funcA),
	.id_alu_funcB(id_alu_funcB),
	.id_op1A_select(id_op1A_select),
	.id_op1B_select(id_op1B_select),
	.id_op2A_select(id_op2A_select),
	.id_op2B_select(id_op2B_select),
	.mt_T1A(mt_T1A),
	.mt_T1B(mt_T1B),
	.mt_T2A(mt_T2A),
	.mt_T2B(mt_T2B),
	.mt_archIdxA(mt_archIdxA),
	.mt_archIdxB(mt_archIdxB),
	.reset(reset),
	.rob_idxA(rob_idxA),
	.rob_idxB(rob_idxB),
	.rob_instA_en(rob_instA_en),
	.rob_instB_en(rob_instB_en),
	//output ports
	.initFreeA(initFreeA),
	.rs_IRA_out(rs_IRA_out),
	.rs_IRB_out(rs_IRB_out),
	.rs_T1A_out(rs_T1A_out),
	.rs_T1B_out(rs_T1B_out),
	.rs_T2A_out(rs_T2A_out),
	.rs_T2B_out(rs_T2B_out),
	.rs_TA_out(rs_TA_out),
	.rs_TB_out(rs_TB_out),
	.rs_almostFull_out(rs_almostFull_out),
	.rs_alu_funcA_out(rs_alu_funcA_out),
	.rs_alu_funcB_out(rs_alu_funcB_out),
	.rs_busy_out(rs_busy_out),
	.rs_issueA_out(rs_issueA_out),
	.rs_issueArdy_out(rs_issueArdy_out),
	.rs_issueB_out(rs_issueB_out),
	.rs_issueBrdy_out(rs_issueBrdy_out),
	.rs_op1A_select_out(rs_op1A_select_out),
	.rs_op1B_select_out(rs_op1B_select_out),
	.rs_op2A_select_out(rs_op2A_select_out),
	.rs_op2B_select_out(rs_op2B_select_out),
	.rs_rob_idxA_out(rs_rob_idxA_out),
	.rs_rob_idxB_out(rs_rob_idxB_out)
);


reg clock;
always @*
	begin
	#(`VERILOG_CLOCK_PERIOD/2);
	clock=~clock;
end

reg [19:0] clocks;
always @(posedge clock)
begin
	clocks=clocks+1;
end


initial
begin
mt_T1B=6'd49
mt_T2A='d32
reset=0
@(negedge clock)  //end of clock 0 
mt_T1A=1
reset=1
@(negedge clock)  //end of clock 1 
mt_T1A=1
mt_T2A='d15
@(negedge clock)  //end of clock 2 
mt_T1B=6'd10
@(negedge clock)  //end of clock 3 
@(negedge clock)  //end of clock 4 
@(negedge clock)  //end of clock 5 
@(negedge clock)  //end of clock 6 
@(negedge clock)  //end of clock 7 
@(negedge clock)  //end of clock 8 
@(negedge clock)  //end of clock 9 
@(negedge clock)  //end of clock 10 
@(negedge clock)  //end of clock 11 
@(negedge clock)  //end of clock 12 
@(negedge clock)  //end of clock 13 
@(negedge clock)  //end of clock 14 
mt_T1A=2
mt_T1B=6'd14
@(negedge clock)  //end of clock 15 
@(negedge clock)  //end of clock 16 
@(negedge clock)  //end of clock 17 
@(negedge clock)  //end of clock 18 
@(negedge clock)  //end of clock 19 
@(negedge clock)  //end of clock 20 
@(negedge clock)  //end of clock 21 
@(negedge clock)  //end of clock 22 
@(negedge clock)  //end of clock 23 
@(negedge clock)  //end of clock 24 
@(negedge clock)  //end of clock 25 
@(negedge clock)  //end of clock 26 
@(negedge clock)  //end of clock 27 
@(negedge clock)  //end of clock 28 
@(negedge clock)  //end of clock 29 
@(negedge clock)  //end of clock 30 
@(negedge clock)  //end of clock 31 
@(negedge clock)  //end of clock 32 
@(negedge clock)  //end of clock 33 
@(negedge clock)  //end of clock 34 
@(negedge clock)  //end of clock 35 
@(negedge clock)  //end of clock 36 
@(negedge clock)  //end of clock 37 
@(negedge clock)  //end of clock 38 
@(negedge clock)  //end of clock 39 
@(negedge clock)  //end of clock 40 
@(negedge clock)  //end of clock 41 
@(negedge clock)  //end of clock 42 
@(negedge clock)  //end of clock 43 
@(negedge clock)  //end of clock 44 
@(negedge clock)  //end of clock 45 
@(negedge clock)  //end of clock 46 
@(negedge clock)  //end of clock 47 
@(negedge clock)  //end of clock 48 
@(negedge clock)  //end of clock 49 
@(negedge clock)  //end of clock 50 
@(negedge clock)  //end of clock 51 
@(negedge clock)  //end of clock 52 
@(negedge clock)  //end of clock 53 
@(negedge clock)  //end of clock 54 
@(negedge clock)  //end of clock 55 
@(negedge clock)  //end of clock 56 
@(negedge clock)  //end of clock 57 
@(negedge clock)  //end of clock 58 
mt_T1B=6'd3
@(negedge clock)  //end of clock 59 


end //end initialendmodule