`timescale 1ns/100ps
module testbench;
///////// INPUTS //////////
reg clock;
reg	[63:0]	Imem2proc_data;
reg		access_memory;
reg	[63:0]	branch_target_PCA;
reg	[63:0]	branch_target_PCB;
reg	[63:0]	ex_NPCA;
reg	[63:0]	ex_NPCB;
reg		mispredict_branchA;
reg		mispredict_branchB;
reg		need_take_branchA;
reg		need_take_branchB;
reg		non_ins_en_in;
reg		one_ins_en_in;
reg		reset;
reg		rs_almost_full;
reg		rs_full;
reg		IR_valid;
///////// OUTPUTS //////////
wire		branch_predictionA;
wire	[31:0]	if_IRA_out;
wire	[31:0]	if_IRB_out;
wire	[63:0]	if_NPCA_out;
wire	[63:0]	if_NPCB_out;
wire	[63:0]	if_PCA_out;
wire	[63:0]	if_PCB_out;
wire		if_valid_instA_out;
wire		if_valid_instB_out;
wire	[63:0]	proc2Imem_addr;


if_stage   if_stage_0(
	//input ports
	.clock(clock),
	.Imem2proc_data(Imem2proc_data),
	.access_memory(access_memory),
	.branch_target_PCA(branch_target_PCA),
	.branch_target_PCB(branch_target_PCB),
	.ex_NPCA(ex_NPCA),
	.ex_NPCB(ex_NPCB),
	.mispredict_branchA(mispredict_branchA),
	.mispredict_branchB(mispredict_branchB),
	.need_take_branchA(need_take_branchA),
	.need_take_branchB(need_take_branchB),
	.non_ins_en_in(non_ins_en_in),
	.one_ins_en_in(one_ins_en_in),
	.reset(reset),
	.rs_almost_full(rs_almost_full),
	.rs_full(rs_full),
	.IR_valid(IR_valid),
	//output ports
	.branch_predictionA(branch_predictionA),
	.branch_predictionB(branch_predictionB),
	.if_IRA_out(if_IRA_out),
	.if_IRB_out(if_IRB_out),
	.if_NPCA_out(if_NPCA_out),
	.if_NPCB_out(if_NPCB_out),
	.if_PCA_out(if_PCA_out),
	.if_PCB_out(if_PCB_out),
	.if_valid_instA_out(if_valid_instA_out),
	.if_valid_instB_out(if_valid_instB_out),
	.proc2Imem_addr(proc2Imem_addr)
);


always
	begin
	#(`VERILOG_CLOCK_PERIOD/2);
	clock=~clock;
end

reg [19:0] clocks;
reg [10:0] i;
always @(posedge clock)
begin
	clocks=clocks+1;
	$display("POSEDGE %20d:", clocks);
end

initial
begin
clock=0;
clocks=0;

@(negedge clock) 
Imem2proc_data=64'h1111_1111_2222_2222;
access_memory=0;
branch_target_PCA=0;
branch_target_PCB=0;
ex_NPCA=0;
ex_NPCB=0;
mispredict_branchA=0;
mispredict_branchB=0;
need_take_branchA=0;
need_take_branchB=0;
non_ins_en_in=0;
one_ins_en_in=0;
reset=1;
rs_almost_full=0;
rs_full=0;
IR_valid =1;




@(negedge clock) 
Imem2proc_data=64'h1111_1111_2222_2222;
access_memory=0;
branch_target_PCA=0;
branch_target_PCB=0;
ex_NPCA=0;
ex_NPCB=0;
mispredict_branchA=0;
mispredict_branchB=0;
need_take_branchA=0;
need_take_branchB=0;
non_ins_en_in=0;
one_ins_en_in=0;
reset=0;
rs_almost_full=0;
rs_full=0;
IR_valid =1;

@(negedge clock) 
Imem2proc_data=64'h1221_1221_2332_2222;
access_memory=0;
branch_target_PCA=0;
branch_target_PCB=0;
ex_NPCA=0;
ex_NPCB=0;
mispredict_branchA=0;
mispredict_branchB=0;
need_take_branchA=0;
need_take_branchB=0;
non_ins_en_in=0;
one_ins_en_in=0;
reset=0;
rs_almost_full=0;
rs_full=0;
IR_valid =1;



@(negedge clock) 
Imem2proc_data=64'h1441_1441_2442_2442;
access_memory=0;
branch_target_PCA=0;
branch_target_PCB=0;
ex_NPCA=0;
ex_NPCB=0;
mispredict_branchA=0;
mispredict_branchB=0;
need_take_branchA=0;
need_take_branchB=0;
non_ins_en_in=0;
one_ins_en_in=0;
reset=0;
rs_almost_full=0;
rs_full=0;
IR_valid =1;



// still need take branch

@(negedge clock)  //end of clock 0 
Imem2proc_data=64'h3333_3333_4444_4444;
access_memory=0;
branch_target_PCA=64'h0000_0000_0000_0000;
branch_target_PCB=0;
ex_NPCA=64'h0000_0000_0000_0014;
ex_NPCB=0;
mispredict_branchA=0;
mispredict_branchB=0;
need_take_branchA=1;
need_take_branchB=0;
non_ins_en_in=0;
one_ins_en_in=0;
reset=0;
rs_almost_full=0;
rs_full=0;
IR_valid =1;


@(negedge clock)  //end of clock 1 
Imem2proc_data=64'h5555_5555_6666_6666;
access_memory=0;
branch_target_PCA=0;
branch_target_PCB=0;
ex_NPCA=0;
ex_NPCB=0;
mispredict_branchA=0;
mispredict_branchB=0;
need_take_branchA=0;
need_take_branchB=0;
non_ins_en_in=0;
one_ins_en_in=0;
reset=0;
rs_almost_full=0;
rs_full=0;
IR_valid =1;

// access memory

@(negedge clock)  //end of clock 2
Imem2proc_data=64'h7777_5555_7777_6666;
access_memory=1;
branch_target_PCA=0;
branch_target_PCB=0;
ex_NPCA=0;
ex_NPCB=0;
mispredict_branchA=0;
mispredict_branchB=0;
need_take_branchA=0;
need_take_branchB=0;
non_ins_en_in=0;
one_ins_en_in=0;
reset=0;
rs_almost_full=0;
rs_full=0;
IR_valid =1;


@(negedge clock)  //end of clock 3
Imem2proc_data=64'h7777_8888_6666_7777;
access_memory=0;
branch_target_PCA=0;
branch_target_PCB=0;
ex_NPCA=0;
ex_NPCB=0;
mispredict_branchA=0;
mispredict_branchB=0;
need_take_branchA=0;
need_take_branchB=0;
non_ins_en_in=0;
one_ins_en_in=0;
reset=0;
rs_almost_full=0;
rs_full=0;
IR_valid =1;

@(negedge clock)  //end of clock 4 
Imem2proc_data=64'h5115_5115_6666_6666;
access_memory=0;
branch_target_PCA=0;
branch_target_PCB=0;
ex_NPCA=0;
ex_NPCB=0;
mispredict_branchA=0;
mispredict_branchB=0;
need_take_branchA=0;
need_take_branchB=0;
non_ins_en_in=0;
one_ins_en_in=0;
reset=0;
rs_almost_full=0;
rs_full=0;
IR_valid =1;

// branch mistaken, need recover

@(negedge clock)  //end of clock 4 
Imem2proc_data=64'h6555_5555_6776_6666;
access_memory=0;
branch_target_PCA=0;
branch_target_PCB=0;
ex_NPCA=64'h0000_0000_0000_0014;
ex_NPCB=0;
mispredict_branchA=1;
mispredict_branchB=0;
need_take_branchA=0;
need_take_branchB=0;
non_ins_en_in=0;
one_ins_en_in=0;
reset=0;
rs_almost_full=0;
rs_full=0;
IR_valid =1;

@(negedge clock)  //end of clock 4 
Imem2proc_data=64'h5445_5555_6556_6666;
access_memory=0;
branch_target_PCA=0;
branch_target_PCB=0;
ex_NPCA=0;
ex_NPCB=0;
mispredict_branchA=0;
mispredict_branchB=0;
need_take_branchA=0;
need_take_branchB=0;
non_ins_en_in=0;
one_ins_en_in=0;
reset=0;
rs_almost_full=0;
rs_full=0;
IR_valid =1;


@(negedge clock)  //end of clock 4 
Imem2proc_data=64'h5555_5555_6666_6666;
access_memory=0;
branch_target_PCA=0;
branch_target_PCB=0;
ex_NPCA=0;
ex_NPCB=0;
mispredict_branchA=0;
mispredict_branchB=0;
need_take_branchA=0;
need_take_branchB=0;
non_ins_en_in=0;
one_ins_en_in=0;
reset=0;
rs_almost_full=0;
rs_full=0;
IR_valid =1;

// take another branch, the target address can not be divided by 8
@(negedge clock)  //end of clock 4 
Imem2proc_data=64'h5555_5555_6666_6666;
access_memory=0;
branch_target_PCA=64'h4;
branch_target_PCB=0;
ex_NPCA=64'h18;
ex_NPCB=0;
mispredict_branchA=0;
mispredict_branchB=0;
need_take_branchA=1;
need_take_branchB=0;
non_ins_en_in=0;
one_ins_en_in=0;
reset=0;
rs_almost_full=0;
rs_full=0;
IR_valid =1;

@(negedge clock)  //end of clock 4 
Imem2proc_data=64'h5555_5555_6666_6666;
access_memory=0;
branch_target_PCA=0;
branch_target_PCB=0;
ex_NPCA=0;
ex_NPCB=0;
mispredict_branchA=0;
mispredict_branchB=0;
need_take_branchA=0;
need_take_branchB=0;
non_ins_en_in=0;
one_ins_en_in=0;
reset=0;
rs_almost_full=0;
rs_full=0;
IR_valid =1;

@(negedge clock)  //end of clock 4 
Imem2proc_data=64'h5555_5555_6666_6666;
access_memory=0;
branch_target_PCA=0;
branch_target_PCB=0;
ex_NPCA=0;
ex_NPCB=0;
mispredict_branchA=0;
mispredict_branchB=0;
need_take_branchA=0;
need_take_branchB=0;
non_ins_en_in=0;
one_ins_en_in=0;
reset=0;
rs_almost_full=0;
rs_full=0;
IR_valid =1;
@(negedge clock)  //end of clock 4 
Imem2proc_data=64'h5555_5555_6666_6666;
access_memory=0;
branch_target_PCA=0;
branch_target_PCB=0;
ex_NPCA=0;
ex_NPCB=0;
mispredict_branchA=0;
mispredict_branchB=0;
need_take_branchA=0;
need_take_branchB=0;
non_ins_en_in=0;
one_ins_en_in=0;
reset=0;
rs_almost_full=0;
rs_full=0;
IR_valid =1;

$finish;
end //end initial
endmodule
