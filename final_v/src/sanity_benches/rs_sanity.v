//`timescale 1ns/100ps
module testbench;
reg 		clock;
reg	[63:0]		clocks;
reg			reset;

reg [6:0] 	mt_T1A;
reg [6:0] 	mt_T2A;
reg [6:0] 	mt_T1B;
reg [6:0] 	mt_T2B;
 
reg [4:0] 	archIdxA; //unused	
reg [4:0] 	archIdxB; //unused	
 
reg [5:0] 	fl_TA;
reg [5:0] 	fl_TB;
 
reg [5:0] 	cdbAIdx; //unused
reg [5:0] 	cdbBIdx; //unused
reg [5:0] 	cdbCIdx; //unused
reg [5:0] 	cdbDIdx; //unused
 
reg [4:0] 	alu_funcA;
reg [4:0] 	alu_funcB;

reg			ex_cm_cdbA_en;
reg			ex_cm_cdbB_en;
reg			ex_cm_cdbC_en;
reg			ex_cm_cdbD_en;
 
reg [31:0] 	IRA; //unused needed for ALU FU.
reg [31:0] 	IRB; //unused
reg 	   	id_IRA_valid; //unused don't know if need 
reg			id_IRB_valid; //unused
 
reg [4:0] 	rob_idxA;
reg [4:0] 	rob_idxB;
reg			rob_instA_en;
reg			rob_instB_en;

reg [1:0]	id_op1A_select;
reg [1:0]	id_op2A_select;
reg [1:0]	id_op1B_select;
reg [1:0]	id_op2B_select;

reg [63:0]  id_NPCA;
reg [63:0]  id_NPCB;

reg 		id_rd_memA;
reg 		id_rd_memB;
reg 		id_wr_memA;
reg 		id_wr_memB;
reg 		id_cond_branchA;
reg 		id_cond_branchB;
reg 		id_uncond_branchA;
reg 		id_uncond_branchB;
reg 		id_haltA;
reg 		id_haltB;
reg 		id_illegalA;
reg 		id_illegalB;

reg 		if_branch_predictionA;
reg 		if_branch_predictionB;
reg  [63:0] if_predicted_PCA;
reg  [63:0] if_predicted_PCB;

reg			ex_ld_full;
reg			ex_sv_full;

reg 		ex_ld_almostfull;
reg 		ex_sv_almostfull;

reg 		ex_ld_stall;

reg  [2:0]  lq_idxA;
reg  [2:0]  lq_idxB;
reg  [2:0]  sq_idxA;
reg  [2:0]  sq_idxB;
reg   	    lq_alu_stall;

reg 		rob_branch_recover;
reg 		rob_halt;

wire		almostFull;
wire [4:0]  rs_alu_funcA_out;
wire [4:0]  rs_alu_funcB_out;

wire		busy;

wire [31:0] rs_IRA_out;
wire [31:0] rs_IRB_out;

wire 		issueArdy; 
wire 		issueBrdy; 

wire [1:0]	rs_op1A_select_out;
wire [1:0]	rs_op2A_select_out;
wire [1:0]	rs_op1B_select_out;
wire [1:0]	rs_op2B_select_out;

wire [4:0]  rob_idxA_out;
wire [4:0]  rob_idxB_out;

wire [4:0]  rs_archIdxA_out;
wire [4:0]  rs_archIdxB_out;

wire [5:0]	rs_TA; //unused
wire [5:0]	rs_TB; //unused

wire [5:0]	rs_T1A; //unused
wire [5:0]	rs_T2A; //unused
wire [5:0]	rs_T1B; //unused
wire [5:0]	rs_T2B; //unused
wire [63:0] rs_npcA_out;
wire [63:0] rs_npcB_out;

//output debug sigs
wire [3:0] slotFinderA;
wire [7:0] busyREAL;
wire [7:0] next_busyREAL;
wire [7:0] next1_busyREAL;
wire [7:0] next2_busyREAL;

wire   	rs_rd_memA_out;
wire   	rs_rd_memB_out;
wire   	rs_wr_memA_out;
wire   	rs_wr_memB_out;
wire   	rs_cond_branchA_out;
wire   	rs_cond_branchB_out;
wire   	rs_uncond_branchA_out;
wire   	rs_uncond_branchB_out;
wire   	rs_haltA_out;
wire   	rs_haltB_out;
wire   	rs_illegalA_out;
wire   	rs_illegalB_out;

wire 	[2:0] rs_lq_idxA_out;
wire 	[2:0] rs_lq_idxB_out;
wire 	[2:0] rs_sq_idxA_out;
wire 	[2:0] rs_sq_idxB_out;

wire 			rs_branch_predictionA_out;
wire 			rs_branch_predictionB_out;
wire 	[63:0]	rs_predicted_PCA_out;
wire 	[63:0]	rs_predicted_PCB_out;

//dummies
reg 		ex_mulq_full;
reg 		ex_alu_full;
reg 		ex_mulq_almostfull;
reg 		ex_alu_almostfull;
rs rs_0(
	//inputs
	.clock (clock),
	.reset (reset),
	
	.mt_T1A (mt_T1A), 
	.mt_T2A (mt_T2A), 
	.mt_T1B (mt_T1B), 
	.mt_T2B (mt_T2B), 
	.mt_archIdxA (archIdxA), 
	.mt_archIdxB (archIdxB), 

	.fl_TA (fl_TA), 
	.fl_TB (fl_TB), 

	.ex_cm_cdbAIdx (cdbAIdx),
	.ex_cm_cdbBIdx (cdbBIdx),
	.ex_cm_cdbCIdx (cdbCIdx),
	.ex_cm_cdbDIdx (cdbDIdx),
	.ex_cm_cdbA_en (ex_cm_cdbA_en),
	.ex_cm_cdbB_en (ex_cm_cdbB_en),
	.ex_cm_cdbC_en (ex_cm_cdbC_en),
	.ex_cm_cdbD_en (ex_cm_cdbD_en),

	.id_alu_funcA (alu_funcA),
	.id_alu_funcB (alu_funcB),
	.id_NPCA(id_NPCA),
	.id_NPCB(id_NPCB),

	.id_IRA (IRA),
	.id_IRB (IRB),
	.id_IRA_valid (id_IRA_valid),
	.id_IRB_valid (id_IRB_valid),

	.lq_idxA(lq_idxA),
	.lq_idxB(lq_idxB),
	.sq_idxA(sq_idxA),
	.sq_idxB(sq_idxB),
	.lq_alu_stall(lq_alu_stall),

	.rob_idxA (rob_idxA),
	.rob_idxB (rob_idxB),
	.rob_instA_en(rob_instA_en),
	.rob_instB_en(rob_instB_en),
	.rob_branch_recover(rob_branch_recover),
	.rob_halt(rob_halt),

	.id_op1A_select (id_op1A_select),
	.id_op2A_select (id_op2A_select),
	.id_op1B_select (id_op1B_select),
	.id_op2B_select (id_op2B_select),
	.id_rd_memA(id_rd_memA),
	.id_rd_memB(id_rd_memB),
	.id_wr_memA(id_wr_memA),
	.id_wr_memB(id_wr_memB),
	.id_cond_branchA(id_cond_branchA),
	.id_cond_branchB(id_cond_branchB),
	.id_uncond_branchA(id_uncond_branchA),
	.id_uncond_branchB(id_uncond_branchB),
	.id_haltA(id_haltA),
	.id_haltB(id_haltB),
	.id_illegalA(id_illegalA),
	.id_illegalB(id_illegalB),

	.if_branch_predictionA(if_branch_predictionA),
	.if_branch_predictionB(if_branch_predictionB),
	.if_predicted_PCA(if_predicted_PCA),
	.if_predicted_PCB(if_predicted_PCB),	


	//TODO: input ports from branch

	//TODO: put a bunch of shit in from ID

	//outputs
	.rs_almostFull_out(almostFull),
	.rs_alu_funcA_out(rs_alu_funcA_out),
	.rs_alu_funcB_out(rs_alu_funcB_out),

	.rs_busy_out (busy),

	.rs_IRA_out(rs_IRA_out),
	.rs_IRB_out(rs_IRB_out),

	.rs_issueArdy_out(issueArdy),
	.rs_issueBrdy_out(issueBrdy),

	.rs_op1A_select_out(rs_op1A_select_out),
	.rs_op2A_select_out(rs_op2A_select_out),
	.rs_op1B_select_out(rs_op1B_select_out),
	.rs_op2B_select_out(rs_op2B_select_out),

	.rs_rob_idxA_out(rob_idxA_out),
	.rs_rob_idxB_out(rob_idxB_out),
	.rs_archIdxA_out(rs_archIdxA_out),
	.rs_archIdxB_out(rs_archIdxB_out),

	.rs_TA_out (rs_TA),
	.rs_TB_out (rs_TB),

	.rs_T1A_out (rs_T1A),
	.rs_T2A_out (rs_T2A),
	.rs_T1B_out (rs_T1B),
	.rs_T2B_out (rs_T2B),
	.rs_npcA_out (rs_npcA_out),
	.rs_npcB_out (rs_npcB_out),
	.rs_rd_memA_out (rs_rd_memA_out),
	.rs_rd_memB_out (rs_rd_memB_out),
	.rs_wr_memA_out (rs_wr_memA_out),
	.rs_wr_memB_out (rs_wr_memB_out),
	.rs_cond_branchA_out (rs_cond_branchA_out),
	.rs_cond_branchB_out (rs_cond_branchB_out),
	.rs_uncond_branchA_out (rs_uncond_branchA_out),
	.rs_uncond_branchB_out (rs_uncond_branchB_out),
	.rs_haltA_out (rs_haltA_out),
	.rs_haltB_out (rs_haltB_out),
	.rs_illegalA_out (rs_illegalA_out),
	.rs_illegalB_out (rs_illegal_outB),
	.rs_branch_predictionA_out(rs_branch_predictionA_out),
	.rs_branch_predictionB_out(rs_branch_predictionB_out),
	.rs_predicted_PCA_out(rs_predicted_PCA_out),
	.rs_predicted_PCB_out(rs_predicted_PCB_out),

	.rs_lq_idxA_out(rs_lq_idxA_out),
	.rs_lq_idxB_out(rs_lq_idxB_out),
	.rs_sq_idxA_out(rs_sq_idxA_out),
	.rs_sq_idxB_out(rs_sq_idxB_out)


	//TODO: output ports for branch mask
);


//system clock
reg [3:0] i; //counter for forloop display
always
begin
	#(`VERILOG_CLOCK_PERIOD/2);
	clock=~clock;
end
always @(posedge clock)
begin
	clocks=clocks+1;
//	$display("sfA:%4b issueAready:%1b busy:%8b n_busy:%8b, n1_busy:%8b, n2_busy:%8b reset:%1b, free: %2d",slotFinderA, issueArdy, rs_0.busy, rs_0.next_busy, rs_0.next1_busy, rs_0.next2_busy, reset, rs_0.free);
	//archmap + branch mask needed still

`ifdef DEBUG_OUT
	$display("POSEDGE #:%20d \t Iteration:%20d ", clocks, j);
	// $display("initFreeA:%4d \t multfull:%1b \t truth:%1b \t free:%1d \t T1Aout:%5d \t T2Aout:%5d \
	//  \t T1Bout:%5d \t T1Bout:%5d  \t issueArdy:%1b \t issueBrdy:%1b", 
	// 	rs_0.initFreeA, ex_mulq_full, rs_0.alu_func[rs_0.initFreeA]==`ALU_MULQ && ~rs_0.ex_mulq_full && ~(rs_0.initFreeA=='d8),
	// 	rs_0.free, rs_T1A,rs_T2A,rs_T1B,rs_T2B, issueArdy, issueBrdy);
	$display("Slot info: \t | initFreeA:%4d \t initFreeB:%4d \t allocA:%4d \t  allocB:%4d\t\nFree info: \t | free:%1d \t T1Aout:%5d \t T2Aout:%5d \
	 \t T1Bout:%5d \t T1Bout:%5d\nIssue info: \t | issueArdy:%1b \t issueBrdy:%1b \t cdbAidx/enable:%6d/%1d \t cdbBidx/enable:%6d/%1d\n\
Outputs: \t | robAout:%6d \t robBout:%6d \t full:%1b \t almostfull:%1b \t\n \t \t | multfree:%2b \t multfree1:%2b \t alufree:%2b \t alufree1:%2b", 
		rs_0.initFreeA, rs_0.initFreeB, rs_0.allocA, rs_0.allocB,
		rs_0.free, rs_T1A,rs_T2A,rs_T1B,rs_T2B, issueArdy, issueBrdy, cdbAIdx, ex_cm_cdbA_en, cdbBIdx, ex_cm_cdbB_en,
		rob_idxA_out, rob_idxB_out, busy, almostFull, rs_0.multfree, rs_0.multfree1,
		rs_0.alufree,rs_0.alufree1);
	//$display("cdbidx A:%6d, cdbidx B:%6d", rs_0.ex_cm_cdbA_en, rs_0.ex_cm_cdbB_en);
	// $display("mulq_full:%1b \t alu_full:%1b alu_funcA_out:%5b alu_funcB_out:%5b \t", ex_mulq_full, ex_alu_full, rs_alu_funcA_out, rs_alu_funcB_out);
	$display("-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------");
	$display("| \t busy \t | \t     t \t \t | \t     t1 + \t | \t     t2 + \t | \t ROB# \t | \t \t \t instr \t \t \t | \t alu_func \t |   select_1 \t |   select_2 \t | \t NPC \t\t | LogReg \t | \t LQidx/SQidx \t | \n\
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------");
	for (i=0;i<8;i=i+1) begin
		$display("|\t %8b \t | \t %6d \t | \t %6d %1b \t | \t %6d %1b \t | \t %5d \t | \t 32%b \t | \t %5b \t \t | \t %2b \t | \t %2b \t | %64h\t | \t %5d \t | \t %2d/%2d| \t |",
				rs_0.busy[i], rs_0.t[i], rs_0.t1[i][6:1], rs_0.t1[i][0], rs_0.t2[i][6:1], rs_0.t2[i][0], rs_0.robIdx[i], rs_0.instr[i],
				rs_0.alu_func[i], rs_0.op1_select[i], rs_0.op2_select[i], rs_0.npc[i], rs_0.archIdx[i],
				rs_0.lq_idx[i],rs_0.sq_idx[i]);
	end
	$display("-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");


`endif
end

reg [31:0] j;
initial
begin
//TODO: almost full

 // $monitor("busy:%1h rs0.busy:%8b, rs0.next_busy:%8b, rs0.almostfull:%4h, sfA:%1b, sfB:%1b, clk:%d \n",
 // 			busy, rs_0.busy, rs_0.next_busy, rs_0.almostFull_out, rs_0.slotFinderA, rs_0.slotFinderB, clocks);
clock=0;
clocks=0;
reset=1;
ex_ld_stall=0;
//always alu_mulq for now; will add multiple FU logic later.
alu_funcA=`ALU_MULQ;
alu_funcB=`ALU_MULQ;

cdbAIdx = 6'd0; 
cdbBIdx = 6'd1;

if_branch_predictionA=0;
if_branch_predictionB=0;
if_predicted_PCA=0;
if_predicted_PCB=0;


id_IRA_valid=1'b1;
id_IRB_valid=1'b1;
id_NPCA=64'hF0F0_F0F0_BEEF_DEAD;
id_NPCB=64'hFFFF_FFFF_FFFF_FFFF;
ex_mulq_full=1'b1;
ex_alu_full=1'b1;
ex_alu_almostfull=1'b1;
ex_cm_cdbA_en=1'b1;
ex_cm_cdbB_en=1'b1;

fl_TA=6'h1E;
fl_TB=6'h23;
 
mt_T1A={6'd15,1'b0};
mt_T2A={6'd20,1'b0};
mt_T1B={6'd14,1'b0};
mt_T2B={6'd16,1'b0};
archIdxA=5'h0;
archIdxB=5'h0;
ex_alu_almostfull=0;
ex_mulq_almostfull=0;
ex_ld_almostfull=0;
ex_sv_almostfull=0;

lq_idxA='d10;
lq_idxB='d12;
sq_idxA='d13;
sq_idxB='d14;
lq_alu_stall=1'b0;
rob_branch_recover=1'b0;
rob_halt=1'b1;


rob_idxA=5'h0A;
rob_idxB=5'h0C;
rob_instA_en=1'b1;
rob_instB_en=1'b1;

IRA=32'hFFFF_FFFF; //unused needed for ALU FU.
IRB=32'hFFFF_FFFF; //unused needed for ALU FU.

id_op1A_select=`ALU_OPA_IS_REGA;
id_op1B_select=`ALU_OPB_IS_REGB;
id_op2A_select=`ALU_OPA_IS_REGA;
id_op2B_select=`ALU_OPB_IS_REGB;

@(negedge clock); //posedge read reset state
//fill up RS
for (j=0; j<'d4; j=j+1) begin
reset=0;
cdbAIdx = 6'd0;
cdbBIdx = 6'd1;
id_IRA_valid=1'b1;
id_IRB_valid=1'b1;
ex_cm_cdbA_en=1'b0;
ex_cm_cdbB_en=1'b0;
fl_TA=6'd31+2*j;
fl_TB=6'd32+2*j;
mt_T1A={6'd0+4*j,1'b0};
mt_T2A={6'd1+4*j,1'b0};
mt_T1B={6'd2+4*j,1'b0};
mt_T2B={6'd3+4*j,1'b0};
rob_idxA=5'd1+2*j;
rob_idxB=5'd2+2*j;
@(negedge clock);
end


//unfill RS
id_IRA_valid=1'b0; //no overloading w/ instructions
id_IRB_valid=1'b0;
rob_instA_en=1'b0;
rob_instB_en=1'b0;
ex_cm_cdbA_en=1'b1; //activate ability to + bits
ex_cm_cdbB_en=1'b1;
//fill RS with + bits
for (j=0;j<'d8;j=j+1) begin
cdbAIdx = 6'd0+2*j;
cdbBIdx = 6'd1+2*j;
@(negedge clock);
end
//refill with rob_instA_en disabled
for (j=0; j<'d4; j=j+1) begin
cdbAIdx = 6'd0;
cdbBIdx = 6'd1;
id_IRA_valid=1'b1;
id_IRB_valid=1'b1;
ex_mulq_full=1'b1; //almost_full implemented later.
ex_cm_cdbA_en=1'b0;
ex_cm_cdbB_en=1'b0;
fl_TA=6'd31+2*j;
fl_TB=6'd32+2*j;
mt_T1A={6'd10+4*j,1'b0};
mt_T2A={6'd11+4*j,1'b0};
mt_T1B={6'd12+4*j,1'b0};
mt_T2B={6'd13+4*j,1'b0};
rob_idxA=5'd11+2*j;
rob_idxB=5'd12+2*j;
rob_instA_en=1'b0;
rob_instB_en=1'b1;
@(negedge clock);
end
//unfill RS
id_IRA_valid=1'b0; //no overloading w/ instructions
id_IRB_valid=1'b0;
ex_cm_cdbA_en=1'b1; //activate ability to + bits
ex_cm_cdbB_en=1'b1;
//unfill one by one half of them.
for (j=0;j<'d4;j=j+1) begin
//switched order
cdbAIdx = 6'd12+4*j;
cdbBIdx = 6'd13+4*j;
@(negedge clock); //22
end
reset=1;
@(negedge clock); //23

//refill with IRA_valid=0
for (j=0; j<'d8; j=j+1) begin
reset=0;
cdbAIdx = 6'd0;
cdbBIdx = 6'd1;
id_IRA_valid=1'b0;
id_IRB_valid=1'b1;
ex_cm_cdbA_en=1'b0;
ex_cm_cdbB_en=1'b0;
fl_TA=6'd31+2*j;
fl_TB=6'd32+2*j;
mt_T1A={6'd10+4*j,1'b0};
mt_T2A={6'd11+4*j,1'b0};
mt_T1B={6'd12+4*j,1'b0};
mt_T2B={6'd13+4*j,1'b0};
rob_idxA=5'd11+2*j;
rob_idxB=5'd12+2*j;
@(negedge clock); //31
end
//unfill
id_IRA_valid=1'b0; //no overloading w/ instructions
id_IRB_valid=1'b0;
rob_instA_en=1'b0;
rob_instB_en=1'b0;
ex_cm_cdbA_en=1'b1; //activate ability to + bits
ex_cm_cdbB_en=1'b1;
//fill RS with + bits
for (j=0;j<'d8;j=j+1) begin
cdbAIdx = 6'd12+4*j;
cdbBIdx = 6'd13+4*j;
@(negedge clock); //39
end
//refill with IRB_valid=0
for (j=0; j<'d8; j=j+1) begin
cdbAIdx = 6'd0;
cdbBIdx = 6'd1;
id_IRA_valid=1'b1;
id_IRB_valid=1'b0;
ex_cm_cdbA_en=1'b0;
ex_cm_cdbB_en=1'b0;
fl_TA=6'd31+2*j;
fl_TB=6'd32+2*j;
mt_T1A={6'd10+4*j,1'b0};
mt_T2A={6'd11+4*j,1'b0};
mt_T1B={6'd12+4*j,1'b0};
mt_T2B={6'd13+4*j,1'b0};
rob_idxA=5'd11+2*j;
rob_idxB=5'd12+2*j;
rob_instA_en=1'b1;
rob_instB_en=1'b1;
@(negedge clock); //47
end
reset=1;
@(negedge clock); //48
//refill 7 slots
for (j=0; j<'d7; j=j+1) begin
reset=0;
cdbAIdx = 6'd0;
cdbBIdx = 6'd1;
id_IRA_valid=1'b0;
id_IRB_valid=1'b1;
ex_cm_cdbA_en=1'b0;
ex_cm_cdbB_en=1'b0;
fl_TA=6'd31+2*j;
fl_TB=6'd32+2*j;
mt_T1A={6'd10+4*j,1'b0};
mt_T2A={6'd11+4*j,1'b0};
mt_T1B={6'd5+4*j,1'b0};
mt_T2B={6'd10+4*j,1'b0};
rob_idxA=5'd4+2*j;
rob_idxB=5'd13+2*j;
@(negedge clock); //55
end
//give 1 instruction
id_IRA_valid=1'b1;
id_IRB_valid=1'b0;
mt_T1A={6'd1,1'b0};
mt_T2A={6'd1,1'b0};

@(negedge clock); //56
//pop that instruction, give new instruction
cdbAIdx = 6'd17;
cdbBIdx = 6'd1;
ex_cm_cdbA_en=1'b1;
ex_cm_cdbB_en=1'b1;
ex_mulq_full=1'b0;

id_IRA_valid=1'b1; //A is priority over B, so it is impossible for B to be valid but A to be not valid.
id_IRB_valid=1'b0;
mt_T1A={6'd5,1'b0};
mt_T2A={6'd5,1'b0};
@(negedge clock); //57

//pop that instruction, give new instruction, and pop THAT LATTER instruction, and give the SECOND new instruction
cdbAIdx = 6'd5;
cdbBIdx = 6'd11;
ex_cm_cdbA_en=1'b1;
ex_cm_cdbB_en=1'b1;
ex_mulq_full=1'b0;

mt_T1A={6'd11,1'b0};
mt_T2A={6'd11,1'b0};
mt_T1B={6'd5,1'b0};
mt_T2B={6'd5,1'b0};
id_IRA_valid=1'b1; //new A is also popped.
id_IRB_valid=1'b1; //B in injected, also ready but not popped due to previous and this instr begin popped..
@(negedge clock); //58


//clear as many instr as possible
id_IRA_valid=1'b0;
id_IRB_valid=1'b0; 
cdbAIdx = 6'd22;
cdbBIdx = 6'd10;
@(negedge clock);

//unfill
reset=1;
@(negedge clock); //60

//fill halfway
for (j=0; j<'d2; j=j+1) begin
reset=0;
cdbAIdx = 6'd0;
cdbBIdx = 6'd1;
id_IRA_valid=1'b1;
id_IRB_valid=1'b1;
ex_mulq_full=1'b1; //almost_full implemented later.
ex_cm_cdbA_en=1'b0;
ex_cm_cdbB_en=1'b0;
fl_TA=6'd1+2*j;
fl_TB=6'd0+2*j;
mt_T1A={6'd30+4*j,1'b0};
mt_T2A={6'd30+4*j,1'b0};
mt_T1B={6'd29+4*j,1'b0};
mt_T2B={6'd29+4*j,1'b0};
rob_idxA=5'd7+2*j;
rob_idxB=5'd8+2*j;
@(negedge clock); //62
end

//unfill while filling up
for (j=0; j<'d10; j=j+1) begin
reset=0;
cdbAIdx = 6'd29+4*j;
cdbBIdx = 6'd30+4*j;
id_IRA_valid=1'b1;
id_IRB_valid=1'b1;
ex_mulq_full=1'b0; //almost_full implemented later.
ex_cm_cdbA_en=1'b1;
ex_cm_cdbB_en=1'b1;
fl_TA=6'd31+2*j;
fl_TB=6'd32+2*j;
mt_T1A={6'd38+4*j,1'b0};
mt_T2A={6'd38+4*j,1'b0};
mt_T1B={6'd37+4*j,1'b0};
mt_T2B={6'd37+4*j,1'b0};
rob_idxA=5'd11+2*j;
rob_idxB=5'd12+2*j;
rob_instA_en=1'b1;
rob_instB_en=1'b1;
@(negedge clock); //72
end
//more unfilling while filling up: just have maptable ready but CDB not ready:
for (j=0; j<'d10; j=j+1) begin
reset=0;
cdbAIdx = 6'd29+4*j;
cdbBIdx = 6'd30+4*j;
id_IRA_valid=1'b1;
id_IRB_valid=1'b1;
ex_mulq_full=1'b0; //almost_full implemented later.
ex_cm_cdbA_en=1'b0;
ex_cm_cdbB_en=1'b0;
fl_TA=6'd31+2*j;
fl_TB=6'd32+2*j;
mt_T1A={6'd38+4*j,1'b1};
mt_T2A={6'd38+4*j,1'b1};
mt_T1B={6'd37+4*j,1'b1};
mt_T2B={6'd37+4*j,1'b1};
rob_idxA=5'd11+2*j;
rob_idxB=5'd12+2*j;
rob_instA_en=1'b1;
rob_instB_en=1'b1;
@(negedge clock); //82
end

//unfill
reset=1;
@(negedge clock); //83

//fill all but one; done by filling all and emptying one of the middle entries
for (j=0; j<'d4; j=j+1) begin
reset=0;
cdbAIdx = 6'd0;
cdbBIdx = 6'd1;
cdbCIdx = 6'd2;
cdbDIdx = 6'd3;
id_IRA_valid=1'b1;
id_IRB_valid=1'b1;
ex_cm_cdbA_en=1'b0;
ex_cm_cdbB_en=1'b0;
ex_cm_cdbC_en=1'b0;
ex_cm_cdbD_en=1'b0;
fl_TA=6'd7+2*j;
fl_TB=6'd11+2*j;
mt_T1A={6'd22+4*j,1'b0};
mt_T2A={6'd23+4*j,1'b0};
mt_T1B={6'd24+4*j,1'b0};
mt_T2B={6'd25+4*j,1'b0};
rob_idxA=5'd0+2*j;
rob_idxB=5'd1+2*j;
@(negedge clock);
end //87
//get rid of 34/35 entry for T1/T2
ex_mulq_full=1'b0;
ex_mulq_almostfull=1'b0;
cdbAIdx = 6'd35;
cdbBIdx = 6'd34;
id_IRA_valid=1'b0;
id_IRB_valid=1'b0;
ex_cm_cdbA_en=1'b1;
ex_cm_cdbB_en=1'b1;
@(negedge clock); // 88
//Give it 2 instructions that are both ready through same slot s.t.:
//1) instrA goes in, gets forwarded
//2) instrB goes in, gets forwarded (one is cdb forwarding, another one is maptable +1 already)
reset=0;
cdbAIdx = 6'd5;
cdbBIdx = 6'd7;
cdbCIdx = 6'd7;
cdbDIdx = 6'd7;
id_IRA_valid=1'b1;
id_IRB_valid=1'b1;
ex_cm_cdbA_en=1'b1;
ex_cm_cdbB_en=1'b1;
ex_cm_cdbC_en=1'b1;
ex_cm_cdbD_en=1'b1;
fl_TA=6'd19;
fl_TB=6'd17;
mt_T1A={6'd11,1'b1};
mt_T2A={6'd13,1'b1};
mt_T1B={6'd5,1'b0};
mt_T2B={6'd7,1'b0};
rob_idxA=5'd11;
rob_idxB=5'd12;
@(negedge clock); //89
//simple maptable ready test:
//unfill
reset=1;
@(negedge clock); //90
//ready all instr
//fill
for (j=0; j<'d4; j=j+1) begin
reset=0;
cdbAIdx = 6'd22;
cdbBIdx = 6'd23;
cdbCIdx = 6'd24;
cdbDIdx = 6'd25;
id_IRA_valid=1'b1;
id_IRB_valid=1'b1;
ex_cm_cdbA_en=1'b0;
ex_cm_cdbB_en=1'b0;
ex_cm_cdbC_en=1'b0;
ex_cm_cdbD_en=1'b0;
fl_TA=6'd7+2*j;
fl_TB=6'd11+2*j;
mt_T1A={6'd22,1'b0};
mt_T2A={6'd23,1'b0};
mt_T1B={6'd24,1'b0};
mt_T2B={6'd25,1'b0};
rob_idxA=5'd0+2*j;
rob_idxB=5'd1+2*j;
@(negedge clock); //94
end
//input 1 at a time, so -1 instr.
for (j=0; j<'d8;j=j+1) begin
id_IRA_valid=1'b1;
id_IRB_valid=1'b0;
ex_cm_cdbA_en=1'b1;
ex_cm_cdbB_en=1'b1;
ex_cm_cdbC_en=1'b1;
ex_cm_cdbD_en=1'b1;
@(negedge clock); //102
end

////////////////////// ALU INCLUDED IN TEST ///////////////////////
//load ALU instr 2-by-2
for(j=0;j<'d4;j=j+1) begin
alu_funcA=`ALU_ADDQ;
alu_funcB=`ALU_ADDQ;
reset=0;
cdbAIdx = 6'd29+4*j;
cdbBIdx = 6'd30+4*j;
cdbBIdx = 6'd31+4*j;
cdbBIdx = 6'd32+4*j;
id_IRA_valid=1'b1;
id_IRB_valid=1'b1;
ex_cm_cdbA_en=1'b0;
ex_cm_cdbB_en=1'b0;
fl_TA=6'd31+2*j;
fl_TB=6'd32+2*j;
mt_T1A={6'd31+4*j,1'b0};
mt_T2A={6'd32+4*j,1'b0};
mt_T1B={6'd33+4*j,1'b0};
mt_T2B={6'd34+4*j,1'b0};
rob_idxA=5'd11+2*j;
rob_idxB=5'd12+2*j;
@(negedge clock); //106
end
//reset
reset=1;
@(negedge clock); //107
//load ALU instr 1-by-1
for (j=0;j<'d8;j=j+1)begin
alu_funcA=`ALU_ADDQ;
alu_funcB=`ALU_ADDQ;
reset=0;
cdbAIdx = 6'd29+4*j;
cdbBIdx = 6'd30+4*j;
id_IRA_valid=1'b1;
id_IRB_valid=1'b0;
ex_cm_cdbA_en=1'b0;
ex_cm_cdbB_en=1'b0;
fl_TA=6'd31+2*j;
fl_TB=6'd32+2*j;
mt_T1A={6'd1+4*j,1'b0};
mt_T2A={6'd2+4*j,1'b0};
mt_T1B={6'd3+4*j,1'b0};
mt_T2B={6'd4+4*j,1'b0};
rob_idxA=5'd4+2*j;
rob_idxB=5'd5+2*j;
@(negedge clock); //115
end
//reset
reset=1;
@(negedge clock); //116
//"load" ALU 1-by-1; make sure ex_mulq_full doesn't block freeing of adds
for (j=0;j<'d8;j=j+1)begin
alu_funcA=`ALU_ADDQ;
alu_funcB=`ALU_ADDQ;
reset=0;
cdbAIdx = 6'd29+4*j;
cdbBIdx = 6'd30+4*j;
cdbCIdx = 6'd31+4*j;
cdbDIdx = 6'd32+4*j;
id_IRA_valid=1'b1;
id_IRB_valid=1'b1;
ex_cm_cdbA_en=1'b0;
ex_cm_cdbB_en=1'b0;
fl_TA=6'd31+2*j;
fl_TB=6'd32+2*j;
mt_T1A={6'd1+4*j,1'b0};
mt_T2A={6'd2+4*j,1'b0};
mt_T1B={6'd3+4*j,1'b1};
mt_T2B={6'd4+4*j,1'b1};
rob_idxA=5'd10+2*j;
rob_idxB=5'd11+2*j;
@(negedge clock); //124
end

//free ALU instr 1-by-1 (via 1 valid but 2 freed per cycle)
for(j=0;j<'d4;j=j+1) begin
alu_funcA=`ALU_ADDQ;
alu_funcB=`ALU_ADDQ;
reset=0;
cdbAIdx = 6'd1+4*j;
cdbBIdx = 6'd2+4*j;
cdbCIdx = 6'd17+4*j;
cdbDIdx = 6'd18+4*j;
id_IRA_valid=1'b1;
id_IRB_valid=1'b0;

ex_cm_cdbA_en=1'b1;
ex_cm_cdbB_en=1'b1;
ex_cm_cdbC_en=1'b1;
ex_cm_cdbD_en=1'b1;
fl_TA=6'd31+2*j;
fl_TB=6'd32+2*j;
mt_T1A={6'd31+4*j,1'b0};
mt_T2A={6'd32+4*j,1'b0};
mt_T1B={6'd33+4*j,1'b1};
mt_T2B={6'd34+4*j,1'b1};
@(negedge clock); //128
end

for(j=0;j<'d4;j=j+1) begin //second half: CDB frees 1, forwarding frees another 1, 1 is valid. # of busy -1 til empty.
alu_funcA=`ALU_ADDQ;
alu_funcB=`ALU_ADDQ;
reset=0;
cdbAIdx = 6'd31+4*j;
cdbBIdx = 6'd32+4*j;
id_IRA_valid=1'b1;
id_IRB_valid=1'b0;
ex_cm_cdbA_en=1'b1;
ex_cm_cdbB_en=1'b1;
fl_TA=6'd31+2*j;
fl_TB=6'd32+2*j;
mt_T1A={6'd1+4*j,1'b1};
mt_T2A={6'd2+4*j,1'b1};
mt_T1B={6'd36+4*j,1'b1};
mt_T2B={6'd37+4*j,1'b1};
rob_idxA=5'd11+2*j;
rob_idxB=5'd12+2*j;
@(negedge clock); //132
end
//load ALU/mult instr (2x1s)
for (j=0; j<'d4;j=j+1) begin
alu_funcA=`ALU_ADDQ;
alu_funcB=`ALU_MULQ;
reset=0;
cdbAIdx = 6'd21+4*j;
cdbBIdx = 6'd22+4*j;
id_IRA_valid=1'b1;
id_IRB_valid=1'b1;
ex_cm_cdbA_en=1'b0;
ex_cm_cdbB_en=1'b0;
fl_TA=6'd31+2*j;
fl_TB=6'd32+2*j;
mt_T1A={6'd1+4*j,1'b0};
mt_T2A={6'd2+4*j,1'b1};
mt_T1B={6'd36+4*j,1'b1};
mt_T2B={6'd37+4*j,1'b0};
rob_idxA=5'd11+2*j;
rob_idxB=5'd12+2*j;

@(negedge clock); //136
end
//free instrs (2x2s)
for (j=0; j<'d2;j=j+1) begin
alu_funcA=`ALU_ADDQ;
alu_funcB=`ALU_MULQ;
reset=0;
cdbAIdx = 6'd1+4*j;
cdbBIdx = 6'd9+4*j;
cdbCIdx = 6'd37+4*j;
cdbDIdx = 6'd45+4*j;
id_IRA_valid=1'b0;
id_IRB_valid=1'b0;
ex_cm_cdbA_en=1'b1;
ex_cm_cdbB_en=1'b1;
ex_cm_cdbC_en=1'b1;
ex_cm_cdbD_en=1'b1;
fl_TA=6'd31+2*j;
fl_TB=6'd32+2*j;
mt_T1A={6'd1+4*j,1'b0};
mt_T2A={6'd2+4*j,1'b1};
mt_T1B={6'd36+4*j,1'b1};
mt_T2B={6'd37+4*j,1'b0};
rob_idxA=5'd11+2*j;
rob_idxB=5'd12+2*j;
@(negedge clock);
end
@(negedge clock);
@(negedge clock); //140 Shows mult > add priority.
//make sure add/mult can be released at same time.
//allocate add/mulq
alu_funcA=`ALU_ADDQ;
alu_funcB=`ALU_MULQ;
reset=0;
cdbAIdx = 6'd1;
cdbBIdx = 6'd9;
cdbCIdx = 6'd37;
cdbDIdx = 6'd45;
id_IRA_valid=1'b1;
id_IRB_valid=1'b1;
ex_cm_cdbA_en=1'b0;
ex_cm_cdbB_en=1'b0;
ex_cm_cdbC_en=1'b0;
ex_cm_cdbD_en=1'b0;
fl_TA=6'd31+2*j;
fl_TB=6'd32+2*j;
mt_T1A={6'd1,1'b0};
mt_T2A={6'd2,1'b1};
mt_T1B={6'd36,1'b1};
mt_T2B={6'd37,1'b0};
rob_idxA=5'd11+2*j;
rob_idxB=5'd12+2*j;
@(negedge clock); 
//free add/mulq
alu_funcA=`ALU_ADDQ;
alu_funcB=`ALU_MULQ;
reset=0;
cdbAIdx = 6'd1;
cdbBIdx = 6'd9;
cdbCIdx = 6'd37;
cdbDIdx = 6'd45;
id_IRA_valid=1'b0;
id_IRB_valid=1'b0;
ex_cm_cdbA_en=1'b1;
ex_cm_cdbB_en=1'b0;
ex_cm_cdbC_en=1'b1;
ex_cm_cdbD_en=1'b0;
fl_TA=6'd31+2*j;
fl_TB=6'd32+2*j;
mt_T1A={6'd1,1'b0};
mt_T2A={6'd2,1'b1};
mt_T1B={6'd36,1'b1};
mt_T2B={6'd37,1'b0};
rob_idxA=5'd11+2*j;
rob_idxB=5'd12+2*j;
@(negedge clock); //142

//fill w/ ld/store instr.
for(j=0;j<'d4;j=j+1) begin
alu_funcA=`ALU_MULQ;
alu_funcB=`ALU_ADDQ; //load
id_op1A_select=2'b00;
id_op2A_select=2'b00;
id_op1B_select=`ALU_OPA_IS_MEM_DISP; //load or store.
id_op2B_select=2'b00;
reset=0;
cdbAIdx = 6'd0+4*j;
cdbBIdx = 6'd0+4*j;
cdbCIdx = 6'd0+4*j;
cdbDIdx = 6'd0+4*j;
id_IRA_valid=1'b1;
id_IRB_valid=1'b1;
ex_cm_cdbA_en=1'b0;
ex_cm_cdbB_en=1'b0;
ex_cm_cdbC_en=1'b0;
ex_cm_cdbD_en=1'b0;
fl_TA=6'd31+2*j;
fl_TB=6'd32+2*j;
mt_T1A={6'd31+4*j,1'b0};
mt_T2A={6'd32+4*j,1'b0};
mt_T1B={6'd33+4*j,1'b0};
mt_T2B={6'd34+4*j,1'b0};
rob_idxA=5'd11+2*j;
rob_idxB=5'd12+2*j;
@(negedge clock); //146
end
//do not free when ex_ld_stall is high
ex_ld_stall=1'b1; 
for(j=0;j<'d4;j=j+1) begin
alu_funcA=`ALU_MULQ;
alu_funcB=`ALU_ADDQ; //load
id_op1A_select=2'b00;
id_op2A_select=2'b00;
id_op1B_select=`ALU_OPA_IS_MEM_DISP; //load or store.
id_op2B_select=2'b00;
reset=0;
cdbAIdx = 6'd32+4*j;
cdbBIdx = 6'd31+4*j;
cdbCIdx = 6'd33+4*j;
cdbDIdx = 6'd34+4*j;
id_IRA_valid=1'b0;
id_IRB_valid=1'b0;
ex_cm_cdbA_en=1'b1;
ex_cm_cdbB_en=1'b1;
ex_cm_cdbC_en=1'b1;
ex_cm_cdbD_en=1'b1;
fl_TA=6'd31+2*j;
fl_TB=6'd32+2*j;
mt_T1A={6'd1+4*j,1'b0};
mt_T2A={6'd2+4*j,1'b0};
mt_T1B={6'd3+4*j,1'b0};
mt_T2B={6'd4+4*j,1'b0};
rob_idxA=5'd11+2*j;
rob_idxB=5'd12+2*j;
@(negedge clock); //150
end
//free everything.  
for (j=0;j<'d4;j=j+1) begin
ex_ld_stall=1'b0;
@(negedge clock);
end //154
//fill 1 mult 1 ld/store
ex_ld_stall=1'b1;
alu_funcA=`ALU_MULQ;
alu_funcB=`ALU_ADDQ; //load
id_op1A_select=2'b00;
id_op2A_select=2'b00;
id_op1B_select=`ALU_OPA_IS_MEM_DISP; //load or store.
id_op2B_select=2'b00;
reset=0;
cdbAIdx = 6'd32;
cdbBIdx = 6'd31;
cdbCIdx = 6'd33;
cdbDIdx = 6'd34;
id_IRA_valid=1'b1;
id_IRB_valid=1'b1;
ex_cm_cdbA_en=1'b0;
ex_cm_cdbB_en=1'b0;
ex_cm_cdbC_en=1'b0;
ex_cm_cdbD_en=1'b0;
fl_TA=6'd31+2*j;
fl_TB=6'd32+2*j;
mt_T1A={6'd1+4*j,1'b1};
mt_T2A={6'd2+4*j,1'b1};
mt_T1B={6'd3+4*j,1'b1};
mt_T2B={6'd4+4*j,1'b1};
rob_idxA=5'd11;
rob_idxB=5'd12;
@(negedge clock); //155
//fill 2 with alu
ex_ld_stall=1'b1;
alu_funcA=`ALU_ADDQ;
alu_funcB=`ALU_ADDQ;
id_op1A_select=2'b00;
id_op2A_select=2'b00;
id_op1B_select=2'b00; //plain ole' add.
id_op2B_select=2'b00;
reset=0;
cdbAIdx = 6'd32;
cdbBIdx = 6'd31;
cdbCIdx = 6'd33;
cdbDIdx = 6'd34;
id_IRA_valid=1'b1;
id_IRB_valid=1'b1;
ex_cm_cdbA_en=1'b0;
ex_cm_cdbB_en=1'b0;
ex_cm_cdbC_en=1'b0;
ex_cm_cdbD_en=1'b0;
fl_TA=6'd31+2*j;
fl_TB=6'd32+2*j;
mt_T1A={6'd5+4*j,1'b1};
mt_T2A={6'd6+4*j,1'b1};
mt_T1B={6'd7+4*j,1'b1};
mt_T2B={6'd8+4*j,1'b1};
rob_idxA=5'd11;
rob_idxB=5'd12;
@(negedge clock); //156
//fill 2 mult and 2 ld/store
for (j=0;j<'d2;j=j+1) begin
ex_ld_stall=1'b1;
alu_funcA=`ALU_MULQ;
alu_funcB=`ALU_ADDQ; //load
id_op1A_select=2'b00;
id_op2A_select=2'b00;
id_op1B_select=`ALU_OPA_IS_MEM_DISP; //load or store.
id_op2B_select=2'b00;
reset=0;
cdbAIdx = 6'd32;
cdbBIdx = 6'd31;
cdbCIdx = 6'd33;
cdbDIdx = 6'd34;
id_IRA_valid=1'b1;
id_IRB_valid=1'b1;
ex_cm_cdbA_en=1'b0;
ex_cm_cdbB_en=1'b0;
ex_cm_cdbC_en=1'b0;
ex_cm_cdbD_en=1'b0;
fl_TA=6'd31+2*j;
fl_TB=6'd32+2*j;
mt_T1A={6'd9+4*j,1'b1};
mt_T2A={6'd10+4*j,1'b1};
mt_T1B={6'd11+4*j,1'b1};
mt_T2B={6'd12+4*j,1'b1};
rob_idxA=5'd11;
rob_idxB=5'd12;
@(negedge clock); //158
end
//free lds first, then mult, then alu instrs.
for (j=0;j<'d4;j=j+1) begin
id_IRA_valid=1'b0;
id_IRB_valid=1'b0;
ex_ld_stall=1'b0;
@(negedge clock); //162
end
//refill
//fill 2 with alu
alu_funcA=`ALU_ADDQ;
alu_funcB=`ALU_ADDQ;
id_op1A_select=2'b00;
id_op2A_select=2'b00;
id_op1B_select=2'b00; //plain ole' add.
id_op2B_select=2'b00;
reset=0;
cdbAIdx = 6'd32;
cdbBIdx = 6'd31;
cdbCIdx = 6'd33;
cdbDIdx = 6'd34;
id_IRA_valid=1'b1;
id_IRB_valid=1'b1;
ex_cm_cdbA_en=1'b0;
ex_cm_cdbB_en=1'b0;
ex_cm_cdbC_en=1'b0;
ex_cm_cdbD_en=1'b0;
fl_TA=6'd31+2*j;
fl_TB=6'd32+2*j;
mt_T1A={6'd5+4*j,1'b0};
mt_T2A={6'd6+4*j,1'b0};
mt_T1B={6'd7+4*j,1'b0};
mt_T2B={6'd8+4*j,1'b0};
rob_idxA=5'd11;
rob_idxB=5'd12;
@(negedge clock); //163
//fill 3 mult and 3 ld/store
for (j=0;j<'d3;j=j+1) begin
alu_funcA=`ALU_MULQ;
alu_funcB=`ALU_ADDQ; //load
id_op1A_select=2'b00;
id_op2A_select=2'b00;
id_op1B_select=`ALU_OPA_IS_MEM_DISP; //load or store.
id_op2B_select=2'b00;
reset=0;
cdbAIdx = 6'd32;
cdbBIdx = 6'd31;
cdbCIdx = 6'd33;
cdbDIdx = 6'd34;
id_IRA_valid=1'b1;
id_IRB_valid=1'b1;
ex_cm_cdbA_en=1'b0;
ex_cm_cdbB_en=1'b0;
ex_cm_cdbC_en=1'b0;
ex_cm_cdbD_en=1'b0;
fl_TA=6'd31+2*j;
fl_TB=6'd32+2*j;
mt_T1A={6'd9+4*j,1'b0};
mt_T2A={6'd10+4*j,1'b0};
mt_T1B={6'd11+4*j,1'b0};
mt_T2B={6'd12+4*j,1'b0};
rob_idxA=5'd11;
rob_idxB=5'd12;
@(negedge clock); //165
end

for (j=0;j<'d4;j=j+1) begin
	id_IRA_valid=1'b0;
	id_IRB_valid=1'b0;
	cdbAIdx = 6'd9+j*4;
	cdbBIdx = 6'd10+j*4;
	cdbCIdx = 6'd11+j*4;
	cdbDIdx = 6'd12+j*4;
	ex_cm_cdbA_en=1'b1;
	ex_cm_cdbB_en=1'b1;
	ex_cm_cdbC_en=1'b1;
	ex_cm_cdbD_en=1'b1;
	if (j>2) begin
		lq_alu_stall=1'b1;
	end
	@(negedge clock);
end
@(negedge clock); //need extra delay for display since some input here changes next_var, and
//display is of var (last output vector means nothing--output vector is top printouts above table)

$finish;
end //initial

endmodule

// alu_funcA=`ALU_MULQ;
// alu_funcB=`ALU_MULQ;
// ex_alu_full=1'b1;
// ex_alu_almostfull=1'b1;