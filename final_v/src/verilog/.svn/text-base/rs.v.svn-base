/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  rs.v	                                               //
//                                                                     //
//  Description :  This module creates the Regfile used by the ID and  // 
//                 WB Stages of the Pipeline.                          //
//                                                                     //
/////////////////////////////////////////////////////////////////////////


//`timescale 1ns/100ps

module rs(
	//inputs
	clock,
	reset,
	
	mt_T1A, 
	mt_T2A, 
	mt_T1B, 
	mt_T2B, 
        mt_archIdxA, 
        mt_archIdxB, 

	fl_TA, 
	fl_TB, 

	ex_cm_cdbAIdx,
	ex_cm_cdbBIdx,
	ex_cm_cdbCIdx,
	ex_cm_cdbDIdx,
	ex_cm_cdbA_en,
	ex_cm_cdbB_en,
	ex_cm_cdbC_en,
	ex_cm_cdbD_en,

	id_alu_funcA,
	id_alu_funcB,

	id_IRA,
	id_IRB,
	id_IRA_valid,
	id_IRB_valid,
	id_NPCA,
	id_NPCB,

	id_rd_memA,
	id_rd_memB,
	id_wr_memA,
	id_wr_memB,
	id_cond_branchA,
	id_cond_branchB,
	id_uncond_branchA,
	id_uncond_branchB,
	id_haltA,
	id_haltB,
	id_illegalA,
	id_illegalB,

	lq_idxA,
	lq_idxB,
	sq_idxA,
	sq_idxB,
	lq_alu_stall, //alu conflict


	if_branch_predictionA,
	if_branch_predictionB,
	if_predicted_PCA,
	if_predicted_PCB,


	rob_idxA,
	rob_idxB,
	rob_instA_en,
	rob_instB_en,

	rob_branch_recover,
	rob_halt,

	id_op1A_select,
	id_op2A_select,
	id_op1B_select,
	id_op2B_select,

	// ex_branch_recover, //not lol early branch recov
	// rob_head, //early
	// rob_branch_idx, //early

	//outputs
	rs_almostFull_out,
	rs_alu_funcA_out,
	rs_alu_funcB_out,

	rs_busy_out, // "full"

	rs_IRA_out,
	rs_IRB_out,

	rs_issueArdy_out,
	rs_issueBrdy_out,

	rs_op1A_select_out,
	rs_op2A_select_out,
	rs_op1B_select_out,
	rs_op2B_select_out,

	rs_rob_idxA_out,
	rs_rob_idxB_out,

	rs_archIdxA_out,
	rs_archIdxB_out,

	rs_TA_out,
	rs_TB_out,

	rs_T1A_out,
	rs_T2A_out,
	rs_T1B_out,
	rs_T2B_out,

	rs_npcA_out,
	rs_npcB_out,
	rs_rd_memA_out,
	rs_rd_memB_out,
	rs_wr_memA_out,
	rs_wr_memB_out,
	rs_cond_branchA_out,
	rs_cond_branchB_out,
	rs_uncond_branchA_out,
	rs_uncond_branchB_out,
	rs_haltA_out,
	rs_haltB_out,
	rs_illegalA_out,
	rs_illegalB_out,
	rs_branch_predictionA_out,
	rs_branch_predictionB_out,
	rs_predicted_PCA_out,
	rs_predicted_PCB_out,

	rs_lq_idxA_out,
	rs_lq_idxB_out,
	rs_sq_idxA_out,
	rs_sq_idxB_out
);
////////////////////////////////
////////// inputs //////////////
////////////////////////////////
input clock;
input reset;

input [`MTSRCWIDTH-1:0]		mt_T1A; //copies map table value(s) along with ready bit into reservation station (LSB is ready bit)
input [`MTSRCWIDTH-1:0]		mt_T2A;
input [`MTSRCWIDTH-1:0]		mt_T1B;
input [`MTSRCWIDTH-1:0]		mt_T2B;

input [4:0] 	mt_archIdxA; //unused	
input [4:0] 	mt_archIdxB; //unused	

input [`FLWIDTH-1:0]		fl_TA; //copies the appropriate free list entry into the T column of the reservation station.
input [`FLWIDTH-1:0]		fl_TB;

input [`CDBWIDTH-1:0]		ex_cm_cdbAIdx; //used to compare to see whether or not T1 or T2(s) are ready so that the ready bit can be put in.
input [`CDBWIDTH-1:0] 	ex_cm_cdbBIdx;
input [`CDBWIDTH-1:0] 	ex_cm_cdbCIdx;
input [`CDBWIDTH-1:0] 	ex_cm_cdbDIdx;
input 			ex_cm_cdbA_en;
input 			ex_cm_cdbB_en;
input 			ex_cm_cdbC_en;
input 			ex_cm_cdbD_en;

input [1:0]		id_op1A_select; //selects to pass to the execution unit
input [1:0]		id_op2A_select;
input [1:0]		id_op1B_select;
input [1:0]		id_op2B_select;

input [4:0]		id_alu_funcA; //function code that tells ALU1 what to do
input [4:0]		id_alu_funcB; //function code that tells ALU2 what to do

input [31:0]	id_IRA; //Gets instruction(s) from decode so that we can output the appropriate source values for execution
input [31:0]	id_IRB;
input			id_IRA_valid; //are IRA and IRB valid instructions?
input			id_IRB_valid;
input [63:0] 	id_NPCA; //NPC for X to pass or calculate.
input [63:0] 	id_NPCB;

input  			id_rd_memA; //reading mem?
input  			id_rd_memB;
input  			id_wr_memA; //writing mem?
input  			id_wr_memB;
input  			id_cond_branchA; //cond br?
input  			id_cond_branchB;
input  			id_uncond_branchA; //uncond br?
input  			id_uncond_branchB;
input  			id_haltA; //stop instr?
input  			id_haltB;
input  			id_illegalA; //illegal instr? (used to calculate cpi)
input  			id_illegalB;

input 			if_branch_predictionA;
input 			if_branch_predictionB;
input [63:0]	if_predicted_PCA;
input [63:0]	if_predicted_PCB;

input [`ROBWIDTH-1:0]		rob_idxA; //grab the respective indices for instruction A and B
input [`ROBWIDTH-1:0]		rob_idxB;
input 			rob_instA_en; //whether A/B can be put in since a struct hazard might be in the midst
input 			rob_instB_en;
input 			rob_halt;
// input 			ex_ld_full;
// input 			ex_ld_almostfull;
// input 			ex_sv_full;
// input 			ex_sv_almostfull;
input 			rob_branch_recover;

input [`LQWIDTH-1:0] 		lq_idxA;
input [`LQWIDTH-1:0] 		lq_idxB;
input [`SQWIDTH-1:0] 		sq_idxA;
input [`SQWIDTH-1:0] 		sq_idxB;
input 				 		lq_alu_stall;
///////////////////////////////////
///////////// outputs /////////////
///////////////////////////////////
output 			rs_almostFull_out; //1 when exactly 1 slot is available, 0 otherwise  
output			rs_busy_out; //is everything busy? 

output reg [4:0]	rs_alu_funcA_out; //pass ALU function to execution.   
output reg [4:0]	rs_alu_funcB_out;  


output reg [31:0]	rs_IRA_out;//pass full instruction out to execution (maybe not needed)   
output reg [31:0]	rs_IRB_out;   
   
 
output reg	 		rs_issueArdy_out; //is the first functional unit ready to issue?   
output reg 			rs_issueBrdy_out; //"" but for second functional unit   
   
output reg [1:0]	rs_op1A_select_out; //passes select bits to execution unit   
output reg [1:0]	rs_op2A_select_out;   
output reg [1:0]	rs_op1B_select_out;   
output reg [1:0]	rs_op2B_select_out;   
   
output reg [`ROBWIDTH-1:0]	rs_rob_idxA_out; //will eventually need to pass ROB index instructions to execution and ROB to unbusy a tail pointer.   
output reg [`ROBWIDTH-1:0]	rs_rob_idxB_out;   
output reg [4:0] 			rs_archIdxA_out;
output reg [4:0] 			rs_archIdxB_out;

output reg [`FLWIDTH-1:0]	rs_TA_out; //tells execution unit exactly where the fuck to write the shit.
output reg [`FLWIDTH-1:0]	rs_TB_out;

output reg [`FLWIDTH-1:0]	rs_T1A_out;
output reg [`FLWIDTH-1:0]	rs_T2A_out;
output reg [`FLWIDTH-1:0]	rs_T1B_out;
output reg [`FLWIDTH-1:0]	rs_T2B_out;

output reg [63:0] 			rs_npcA_out;
output reg [63:0] 			rs_npcB_out;

output reg 					rs_rd_memA_out;
output reg 					rs_rd_memB_out;
output reg 					rs_wr_memA_out;
output reg 					rs_wr_memB_out;
output reg 					rs_cond_branchA_out;
output reg 					rs_cond_branchB_out;
output reg 					rs_uncond_branchA_out;
output reg 					rs_uncond_branchB_out;
output reg 					rs_haltA_out;
output reg 					rs_haltB_out;
output reg 					rs_illegalA_out;
output reg 					rs_illegalB_out;
output reg   		  		rs_branch_predictionA_out;
output reg   		  		rs_branch_predictionB_out;
output reg   [63:0]  		rs_predicted_PCA_out;
output reg   [63:0]  		rs_predicted_PCB_out;
output reg   [`LQWIDTH-1:0] rs_lq_idxA_out;
output reg   [`LQWIDTH-1:0] rs_lq_idxB_out;
output reg   [`SQWIDTH-1:0] rs_sq_idxA_out;
output reg   [`SQWIDTH-1:0] rs_sq_idxB_out;
////////////////////////////////////////
///////////// CODE START ///////////////
////////////////////////////////////////
//idx	FU(?)	busy	op(?)	t	t1	t2	rob#	instr 	alu_func 	select_A 	select_B	archreg(?)		branchmask
//0	any 
//1	any 
//2	any 
//3	any 
//4	any 
//5	any 
//6	any 
//7	any 
reg [3:0]		i; //a counter for forloops
/////////// RS TABLE COLUMN VARIABLES /////////
reg [4:0] 		archIdx [`RSWIDTH-1:0];
reg [`RSWIDTH-1:0] 		busy; //array of busies for the 8 FU
reg [`FLWIDTH-1:0] 		t  		[`RSWIDTH-1:0]; //array of T values (no blank bit)
reg [`FLWIDTH:0] 		t1 		[`RSWIDTH-1:0]; //array of T1 values (plus a + bit) (MSB is "blank" bit)
reg [`FLWIDTH:0] 		t2 		[`RSWIDTH-1:0]; //array of T2 values (plus a + bit) (MSB is "blank" bit)
reg [`ROBWIDTH-1:0] 		robIdx  [`RSWIDTH-1:0]; //array of ROB index values (no "blank" bit)



reg [31:0]		instr   [`RSWIDTH-1:0]; //array (column) of instructions corresponding to each slot.
reg [4:0]		alu_func[`RSWIDTH-1:0]; //array (column) of ALU funcs to pass to execution unit
reg [1:0]		op1_select[`RSWIDTH-1:0]; //selects for opA and opB to pass to execution unit
reg [1:0]		op2_select[`RSWIDTH-1:0];
reg [63:0] 		npc 	  [`RSWIDTH-1:0];
reg 			rd_mem	  [`RSWIDTH-1:0];
reg 			wr_mem	  [`RSWIDTH-1:0];
reg 			cond_branch	  [`RSWIDTH-1:0];
reg 			uncond_branch	  [`RSWIDTH-1:0];
reg 			halt	  [`RSWIDTH-1:0];
reg 			illegal	  [`RSWIDTH-1:0];
reg 			branch_prediction [`RSWIDTH-1:0];
reg [63:0] 		predicted_PC [`RSWIDTH-1:0];
reg [`LQWIDTH-1:0] lq_idx 	 [`RSWIDTH-1:0];
reg [`SQWIDTH-1:0] sq_idx 	 [`RSWIDTH-1:0];
////////// RS TABLE COLUMN NEXTS (FOR THE ONES THAT NEED IT) //////////
reg [`RSWIDTH:0] 		next_busy;
//Two nexts for t1,t2s's b/c there are dependencies from t1 -> next_t1 -> next1_t1 otherwise this 2-step dependency
//(t1 -> synch next_t1 -> assign slot/MT value to next_t1 -> check next_t1 and then assign next_t2 check bits)
//will create a loop (e.g. -> assign next_t1 -> check next_t1 and then assign next_t1 check bits => latch)
//next1_t1 next1_t2 avoided if datapath from CDB->maptable->RS, but this is faster and more robust (though much more ugly)
//because maptable will grab the correct bit and essentially serve to resolve the intermediate dependency
reg [`FLWIDTH-1:0] 		next_t [`RSWIDTH-1:0]; //mem element 
reg [`FLWIDTH:0] 		next_t1 [`RSWIDTH-1:0]; //mem element 
reg [`FLWIDTH:0] 		next1_t1 [`RSWIDTH-1:0]; //mem element 

reg [`FLWIDTH:0] 		next_t2 [`RSWIDTH-1:0]; //mem element 
reg [`FLWIDTH:0] 		next1_t2 [`RSWIDTH-1:0]; //mem element 

reg [`ROBWIDTH-1:0] 	next_robIdx [`RSWIDTH-1:0];//mem element 
reg [4:0] 				next_archIdx [`RSWIDTH-1:0];	

reg [31:0]		next_instr	[`RSWIDTH-1:0]; //mem element
reg [4:0]		next_alu_func [`RSWIDTH-1:0]; //mem element
reg [1:0]		next_op1_select[`RSWIDTH-1:0]; //selects for opA and opB to pass to execution unit //mem element
reg [1:0]		next_op2_select[`RSWIDTH-1:0]; //mem element
reg [63:0] 		next_npc [`RSWIDTH-1:0];

reg 			next_rd_mem [`RSWIDTH-1:0];
reg 			next_wr_mem [`RSWIDTH-1:0];
reg 			next_cond_branch [`RSWIDTH-1:0];
reg 			next_uncond_branch [`RSWIDTH-1:0];
reg 			next_halt [`RSWIDTH-1:0];
reg 			next_illegal [`RSWIDTH-1:0];
reg 			next_branch_prediction [`RSWIDTH-1:0];
reg [63:0] 		next_predicted_PC [`RSWIDTH-1:0];
reg [`LQWIDTH-1:0] 		next_lq_idx [`RSWIDTH-1:0];
reg [`SQWIDTH-1:0] 		next_sq_idx [`RSWIDTH-1:0];
/////////// NON_NEXT REGISTERS //////////////////
reg [3:0]				initFreeA; //finds an empty slot in the res station. (MSB is none found)
reg [3:0] 				initFreeB;
reg [3:0] 				allocA;
reg [3:0] 				allocB;
reg 	  				almostFull_out; //an output that says only one slot is left in the RS
reg     	  			busy_out; //an output that says only one slot is left in the RS
reg [1:0]				free, free1, free2; //number of slots freed in this cycle (can't be more than 2)
reg [1:0]				multfree,multfree1,multfree2; //00 means can releast 2 mult instr, 01 means can release 1 mult instr, 10 means mult freeing is saturated
reg [1:0]				alufree,alufree1,alufree2; //"" for alu.
reg [1:0] 				memfree,memfree1,memfree2; //"" for mem ops.
reg [`RSWIDTH-1:0]		truthvectorFU; //keeps track of FU structural hazards.
reg [`RSWIDTH-1:0]		truthvectorRdy; //keeps track of readiness
reg [`RSWIDTH-1:0]		truthvectorAlmost; //used for keeping track of almost full conditions. Free a lot with almostfull => will be full.
//and not abstract enough
reg 					multrdy;
reg [`RSWIDTH-1:0] 		multvect; //vector of readies for multiply
reg 					alurdy;
reg [`RSWIDTH-1:0] 		aluvect;
reg 					memrdy;
reg [`RSWIDTH-1:0] 		memvect;
reg 					multforward;
reg 					multforward1;
reg 					aluforward;
reg 					aluforward1;
reg 					memforward;
reg 					memforward1;
reg [`RSWIDTH-1:0] 		squashVector;

//////////// OUTPUT ASSIGNMENTS //////////////
assign rs_busy_out = busy_out;
assign rs_almostFull_out = almostFull_out; 

always @*
begin
almostFull_out=0;
busy_out=0;
initFreeA=4'd`RSWIDTH;
initFreeB=4'd`RSWIDTH;
allocA=4'd`RSWIDTH;
allocB=4'd`RSWIDTH;


rs_alu_funcA_out=0;
rs_alu_funcB_out=0;
rs_IRA_out=0;
rs_IRB_out=0;
rs_issueArdy_out=0;
rs_issueBrdy_out=0;
rs_op1A_select_out=0;
rs_op2A_select_out=0;
rs_op1B_select_out=0;
rs_op2B_select_out=0;
rs_rob_idxA_out=0;
rs_rob_idxB_out=0;

rs_rd_memA_out=0;
rs_rd_memB_out=0;
rs_wr_memA_out=0;
rs_wr_memB_out=0;
rs_cond_branchA_out=0;
rs_cond_branchB_out=0;
rs_uncond_branchA_out=0;
rs_uncond_branchB_out=0;
rs_haltA_out=0;
rs_haltB_out=0;
rs_illegalA_out=0;
rs_illegalB_out=0;
rs_branch_predictionA_out=0;
rs_branch_predictionB_out=0;
rs_predicted_PCA_out=0;
rs_predicted_PCB_out=0;

rs_TA_out='d31;
rs_TB_out='d31;
rs_T1A_out='d31;
rs_T2A_out='d31;
rs_T1B_out='d31;
rs_T2B_out='d31;

rs_npcA_out=0;
rs_npcB_out=0;
rs_archIdxA_out=0;
rs_archIdxB_out=0;

rs_lq_idxA_out=0;
rs_lq_idxB_out=0;
rs_sq_idxA_out=0;
rs_sq_idxB_out=0;

next_busy=busy;

free=0;
free1=0;
free2=0;
multfree=2'b00;
multfree1=2'b00;
multfree2=2'b00;
alufree=0;
alufree1=0;
alufree2=0;
memfree=2'b00;
memfree1=2'b00;
memfree2=2'b00;
truthvectorRdy=0;
truthvectorAlmost=0;
truthvectorFU=0;
squashVector=0;

multrdy=0;
multvect=`RSWIDTH'b0;
alurdy=0;
aluvect=`RSWIDTH'b0;
memrdy=0;
memvect=`RSWIDTH'b0;
multforward=0;
multforward1=0;
aluforward=0;
aluforward1=0;
memforward=0;
memforward1=0;

for (i=0; i<'d`RSWIDTH; i=i+1) begin
	next_t[i]=t[i];
	next_t1[i]=t1[i];
	next1_t1[i]=t1[i];
	next_t2[i]=t2[i];
	next1_t2[i]=t2[i];
	next_robIdx[i]=robIdx[i];
	next_archIdx[i]=archIdx[i];
	next_instr[i]=instr[i];
	next_alu_func[i]=alu_func[i];
	next_op1_select[i]=op1_select[i];
	next_op2_select[i]=op2_select[i];
	next_npc[i]=npc[i];
	next_rd_mem[i]=rd_mem[i];
	next_wr_mem[i]=wr_mem[i];
	next_cond_branch[i]=cond_branch[i];
	next_uncond_branch[i]=uncond_branch[i];
	next_halt[i]=halt[i];
	next_illegal[i]=illegal[i];
	next_branch_prediction[i]=branch_prediction[i];
	next_predicted_PC[i]=predicted_PC[i];
	next_lq_idx[i]=lq_idx[i];
	next_sq_idx[i]=sq_idx[i];
end

	////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////
	/////            BRANCH        RECOVERY            /////
	////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////   
	// for (i=0; i<'d`RSWIDTH;i=i+1) begin
	// 	//same side
	// 	if (robIdx[i] < rob_head && ex_branch_recover < rob_head || 
	// 		robIdx[i] >= rob_head && ex_branch_recover >= rob_head
	// 		) begin
	// 			squashVector[i] = busy[i] & (robIdx[i] > ex_branch_idx) & ex_branch_recover;
	// 			next_busy[i]=1'b0;
	// 			next_t1[i][0]=1'b0;
	// 			next_t2[i][0]=1'b0;
	// 			next1_t1[i][0]=1'b0;
	// 			next1_t2[i][0]=1'b0;
	//  	end
	// 	else begin //opposite side
	// 			squashVector[i] = busy[i] & (robIdx[i] < ex_branch_idx) & ex_branch_recover;
	// 			next_busy[i]=1'b0;
	// 			next_t1[i][0]=1'b0;
	// 			next_t2[i][0]=1'b0;
	// 			next1_t2[i][0]=1'b0;
	// 			next1_t1[i][0]=1'b0;
	// 	end
	// end
	if (rob_branch_recover) begin
		squashVector=8'b00000000;
		next_busy=8'b00000000;
		for (i=0;i<'d`RSWIDTH;i=i+1) begin
			next_t1[i][0]=1'b0;
			next1_t1[i][0]=1'b0;
			next_t2[i][0]=1'b0;
			next1_t2[i][0]=1'b0;
		end
	end


	
	////////////////////////////////////////////////////////////
    //	       									 		      //
	//	 PRE-FREEING LOGIC (ALLOW NEW INST WHEN FULL)         //
	//										 				  //
	////////////////////////////////////////////////////////////

	//posedge CDB++ when full?  Free an entry and then put in entries.
	for (i=0; i<'d`RSWIDTH; i=i+1) begin
	//update some T1/T2+ bits from CDB.
		if (
			(
			((t1[i][`MTSRCWIDTH-1:1]==ex_cm_cdbAIdx) && (ex_cm_cdbA_en)) ||
	        ((t1[i][`MTSRCWIDTH-1:1]==ex_cm_cdbBIdx) && (ex_cm_cdbB_en)) ||
			((t1[i][`MTSRCWIDTH-1:1]==ex_cm_cdbCIdx) && (ex_cm_cdbC_en)) ||
			((t1[i][`MTSRCWIDTH-1:1]==ex_cm_cdbDIdx) && (ex_cm_cdbD_en))
			) && busy[i] 
			  && ~squashVector[i]
		   ) begin
			next_t1[i][0]=1'b1;
			next1_t1[i][0]=1'b1;
		end
		if (
			(
			((t2[i][`MTSRCWIDTH-1:1]==ex_cm_cdbAIdx) && (ex_cm_cdbA_en)) || 
			((t2[i][`MTSRCWIDTH-1:1]==ex_cm_cdbBIdx) && (ex_cm_cdbB_en)) ||
			((t2[i][`MTSRCWIDTH-1:1]==ex_cm_cdbCIdx) && (ex_cm_cdbC_en)) ||
			((t2[i][`MTSRCWIDTH-1:1]==ex_cm_cdbDIdx) && (ex_cm_cdbD_en))
			) && busy[i] 
			  && ~squashVector[i] 
		   ) begin
			next_t2[i][0]=1'b1;
			next1_t2[i][0]=1'b1;
		end
	end

	//optimize to 3 embedded ifs:
	for (i=0;i<'d`RSWIDTH; i=i+1) begin
		multrdy = (alu_func[i]==`ALU_MULQ);
		alurdy = (~(alu_func[i]==`ALU_MULQ) & op1_select[i]==`ALU_OPA_IS_REGA);
		memrdy = (alu_func[i]==`ALU_ADDQ & ~(op1_select[i]==`ALU_OPA_IS_REGA)) | uncond_branch[i]; //mem, cond or uncond branch

		truthvectorRdy[i] = ( busy[i] & next_t1[i][0] & next_t2[i][0] );

		multvect[i]=multrdy&truthvectorRdy[i] & (~lq_alu_stall);
		aluvect[i]=alurdy&truthvectorRdy[i] 
			& (~(instr[i][25:0]==`PAL_HALT) | (instr[i][25:0]==`PAL_HALT & rob_halt))
			& (~lq_alu_stall);
		memvect[i]=memrdy&truthvectorRdy[i] 
			& (~(instr[i][25:0]==`PAL_HALT) | (instr[i][25:0]==`PAL_HALT & rob_halt))
			& (~lq_alu_stall);
	end


	// TODO: optimization with {memvect[i], multvect[i], aluvect[i]}. 



	//first search mem, then mult, then add
		for (i=`RSWIDTH-1;~(i==4'b1111);i=i-1) begin
			if(memvect[i]) begin
				initFreeA=i;
				if (memfree==2'b00) begin
					memfree1=2'b01;
					memfree2=2'b01;
				end else begin
					memfree1=2'b10;
					memfree2=2'b10;
				end
				if (free==2'b00) free=2'b01;
				else free=2'b10;
			end
		end
		for (i=0; i<'d8; i=i+1) begin
			if (memvect[i] && ~(initFreeA==i)) begin
				initFreeB=i;
				if (memfree1==2'b00) begin
					memfree1=2'b01;
					memfree2=2'b01;
				end else begin
					memfree1=2'b10;
					memfree2=2'b10;
				end
				if (free==2'b00) free=2'b01;
				else free=2'b10;
			end
		end

	//mult
	if (initFreeA=='d`RSWIDTH) begin
		for (i=`RSWIDTH-1;~(i==4'b1111);i=i-1) begin
			if (multvect[i]) begin
				initFreeA=i;
				if (multfree==2'b00) begin
					multfree1=2'b01;
					multfree2=2'b01;
				end else begin
					multfree1=2'b10;
					multfree2=2'b10;
				end
				if (free==2'b00) free=2'b01;
				else free=2'b10;
			end
		end
	end
	if (initFreeB=='d`RSWIDTH) begin
		for (i=0; i<'d8; i=i+1) begin
			if (multvect[i] && ~(initFreeA==i)) begin
				initFreeB=i;
				if (multfree1==2'b00) begin
					multfree1=2'b01;
					multfree2=2'b01;
				end else begin
					multfree1=2'b10;
					multfree2=2'b10;
				end
				if (free==2'b00) free=2'b01;
				else free=2'b10;
			end
		end
	end

	//nothing is freed? look for alu instr
	if (initFreeA=='d`RSWIDTH) begin
		for (i=`RSWIDTH-1;~(i==4'b1111);i=i-1) begin
			if (aluvect[i]) begin
				initFreeA=i;
				if (alufree==2'b00) begin
					alufree1=2'b01;
					alufree2=2'b01;
				end else begin
					alufree1=2'b10;
					alufree2=2'b10;
				end
				if (free==2'b00) free=2'b01;
				else free=2'b10;
			end
		end
	end
	if (initFreeB=='d`RSWIDTH) begin
		for (i=0; i<'d`RSWIDTH;i=i+1) begin
			if (aluvect[i] && ~(initFreeA==i)) begin
				initFreeB=i;
				if (alufree1==2'b00) begin
					alufree1=2'b01;
					alufree2=2'b01;
				end else begin
					alufree1=2'b10;
					alufree2=2'b10;
				end
				if (free==2'b00) free=2'b01;
				else free=2'b10;
			end
		end
	end


	////////////////////////////////////////////////////////////
	//										 				  //
	//                    DISPATCH LOGIC                      //
	//										 				  //
	////////////////////////////////////////////////////////////
	
	if (id_IRA_valid) begin
		//forward allocation slots.
	    //search for a suitable slot to dump things in.
		//alloc = 'd8 means nothing is freed so search for possibly empty slots.
		if (~(initFreeA=='d`RSWIDTH))
	    	allocA=initFreeA;
	    else begin
			if (~(busy[3:0]==4'b1111)) begin
				if (~(busy[1:0]==2'b11)) begin
					if (~busy[0]) allocA='d0;
					else allocA='d1;
				end else begin
					if (~busy[2]) allocA='d2;
					else allocA='d3;
				end
			end else if (~(busy[7:4]==4'b1111)) begin
				if(~(busy[5:4]==2'b11)) begin
					if(~busy[4]) allocA='d4;
					else allocA='d5;
				end else begin
					if(~busy[6]) allocA='d6;
					else allocA='d7;
				end
			end else begin
				allocA='d`RSWIDTH;
			end
		end
	end
	if (id_IRB_valid) begin
		//second pointer runs backwards
		if (~(initFreeB=='d`RSWIDTH)) 
			allocB=initFreeB;
		else begin
			if (~(busy[7:4]==4'b1111)) begin
				if(~(busy[7:6]==2'b11)) begin
					if(~busy[7]) allocB='d7;
					else allocB='d6;
				end else begin
					if(~busy[5]) allocB='d5;
					else allocB='d4;
				end
			end else if (~(busy[3:0]==4'b1111)) begin
				if(~(busy[3:2]==2'b11)) begin
					if(~busy[3]) allocB='d3;
					else allocB='d2;
				end else begin
					if(~busy[1]) allocB='d1;
					else allocB='d0;
				end
			end else begin
				allocB='d`RSWIDTH;
			end

		end
		//save allocation slotsA/B, write later.
	end

	////////////////////////////////////////////////////////////
    //										 				  //
	//		  FREE ENTRY/ISSUE LOGIC (FORWARD FREEING)        //
	//										 				  //
	////////////////////////////////////////////////////////////
	//free old instr(s) if there is actually anything to free
	if (~(free==2'b00) && ~(initFreeA=='d`RSWIDTH)) begin
		next1_t1[initFreeA][0]=1'b0; //probably can comment out.  "rdy" doesn't matter if I overwrite it later anyway.
		next1_t2[initFreeA][0]=1'b0; //probably can comment out.  "rdy" doesn't matter if I overwrite it later anyway.
		next_busy[initFreeA]=1'b0; //this is crucial, however, lets next iteration look for a non-busy slot.
		rs_IRA_out=instr[initFreeA];
		rs_alu_funcA_out=alu_func[initFreeA];
		rs_op1A_select_out=op1_select[initFreeA];
		rs_op2A_select_out=op2_select[initFreeA];
		rs_rob_idxA_out=robIdx[initFreeA];
		rs_archIdxA_out=archIdx[initFreeA];
		rs_npcA_out=npc[initFreeA];
		rs_issueArdy_out=1'b1;
		rs_TA_out=t[initFreeA];
		rs_T1A_out=t1[initFreeA][6:1];
		rs_T2A_out=t2[initFreeA][6:1];
		rs_rd_memA_out=rd_mem[initFreeA];
		rs_wr_memA_out=wr_mem[initFreeA];
		rs_cond_branchA_out=cond_branch[initFreeA];
		rs_uncond_branchA_out=uncond_branch[initFreeA];
		rs_haltA_out=halt[initFreeA];
		rs_illegalA_out=illegal[initFreeA];
		rs_branch_predictionA_out=branch_prediction[initFreeA];
		rs_predicted_PCA_out=predicted_PC[initFreeA];
		rs_lq_idxA_out=lq_idx[initFreeA];
		rs_sq_idxA_out=sq_idx[initFreeA];

	end
	if ((free==2'b10) && ~(initFreeB=='d`RSWIDTH)) begin
		next1_t1[initFreeB][0]=1'b0;
		next1_t2[initFreeB][0]=1'b0;
		next_busy[initFreeB]=1'b0;
		rs_IRB_out=instr[initFreeB];
		rs_alu_funcB_out=alu_func[initFreeB];
		rs_op1B_select_out=op1_select[initFreeB];
		rs_op2B_select_out=op2_select[initFreeB];
		rs_rob_idxB_out=robIdx[initFreeB];
		rs_archIdxB_out=archIdx[initFreeB];
		rs_npcB_out=npc[initFreeB];
		rs_issueBrdy_out=1'b1;
		rs_TB_out=t[initFreeB];
		rs_T1B_out=t1[initFreeB][6:1];
		rs_T2B_out=t2[initFreeB][6:1];
		rs_rd_memB_out=rd_mem[initFreeB];
		rs_wr_memB_out=wr_mem[initFreeB];
		rs_cond_branchB_out=cond_branch[initFreeB];
		rs_uncond_branchB_out=uncond_branch[initFreeB];
		rs_haltB_out=halt[initFreeB];
		rs_illegalB_out=illegal[initFreeB];
		rs_branch_predictionB_out=branch_prediction[initFreeB];
		rs_predicted_PCB_out=predicted_PC[initFreeB];
		rs_lq_idxB_out=lq_idx[initFreeB];
		rs_sq_idxB_out=sq_idx[initFreeB];		
	end

	//if newly dispatched instructions are ready, get rid of it immediately. (initFree has more priority than forwardFree).
	//forward freeing only needs to check incoming instr.  Older instr would've been freed already.

	if (~(allocA=='d`RSWIDTH) & ~rob_branch_recover) begin //we care to allocate this to begin with?
		//are these instr forwardable?
		multforward= id_alu_funcA==`ALU_MULQ & ~(multfree==2'b10);
		aluforward= ~(id_alu_funcA==`ALU_MULQ) & id_op1A_select==`ALU_OPA_IS_REGA & ~(alufree==2'b10);
		memforward = ( id_alu_funcA==`ALU_ADDQ & ~(id_op1A_select==`ALU_OPA_IS_REGA) & ~(memfree==2'b10) ) | id_uncond_branchA;
		//gigantic if statement determines if I can forward this instr.
		if ( 
				( mt_T1A[0] ||
					(mt_T1A[`MTSRCWIDTH-1:1]==ex_cm_cdbAIdx && (ex_cm_cdbA_en)) || 
					(mt_T1A[`MTSRCWIDTH-1:1]==ex_cm_cdbBIdx && (ex_cm_cdbB_en)) ||
					(mt_T1A[`MTSRCWIDTH-1:1]==ex_cm_cdbCIdx && (ex_cm_cdbC_en)) ||
					(mt_T1A[`MTSRCWIDTH-1:1]==ex_cm_cdbDIdx && (ex_cm_cdbD_en)) ||
					(id_rd_memA) ||
					mt_T1A[`MTSRCWIDTH-1:1]=='d31 ||
					(~id_rd_memA & ~id_wr_memA & id_op1A_select==`ALU_OPA_IS_MEM_DISP) //lda
				) && //src1,instr1 is rdy 
				( mt_T2A[0] || 
					(mt_T2A[`MTSRCWIDTH-1:1]==ex_cm_cdbAIdx && (ex_cm_cdbA_en)) || 
					(mt_T2A[`MTSRCWIDTH-1:1]==ex_cm_cdbBIdx && (ex_cm_cdbB_en)) ||
					(mt_T2A[`MTSRCWIDTH-1:1]==ex_cm_cdbCIdx && (ex_cm_cdbC_en)) ||
					(mt_T2A[`MTSRCWIDTH-1:1]==ex_cm_cdbDIdx && (ex_cm_cdbD_en)) ||
					~(id_op2A_select==`ALU_OPB_IS_REGB) ||
					mt_T2A[`MTSRCWIDTH-1:1]=='d31
				) && //src2,instr1 is rdy.
				~(free==2'b10) && //can still free isntr. (redundant?)
				(multforward | aluforward | memforward) &&
				(~(id_haltA) | (id_haltA & rob_halt)) &&
				(~lq_alu_stall)
			)
		begin
			//don't bother allocating this instr
			if (free==2'b01) begin
			//already freed one instr, and i am freeing another, so put it in output port B, but i wanna prioritize freeing the first "A" instr coming in.
				free=2'b10;
				rs_IRB_out=id_IRA;
				rs_alu_funcB_out=id_alu_funcA;
				rs_op1B_select_out=id_op1A_select;
				rs_op2B_select_out=id_op2A_select;
				rs_rob_idxB_out=rob_idxA;
				rs_archIdxB_out=mt_archIdxA;
				rs_npcB_out=id_NPCA;
				rs_issueBrdy_out=1'b1;
				rs_TB_out=fl_TA;
				rs_T1B_out=mt_T1A[6:1]; //plus bit.
				rs_T2B_out=mt_T2A[6:1];
				rs_rd_memB_out=id_rd_memA;
				rs_wr_memB_out=id_wr_memA;
				rs_cond_branchB_out=id_cond_branchA;
				rs_uncond_branchB_out=id_uncond_branchA;
				rs_haltB_out=id_haltA;
				rs_illegalB_out=id_illegalA;
				rs_branch_predictionB_out=if_branch_predictionA;
				rs_predicted_PCB_out=if_predicted_PCA;
				rs_lq_idxB_out=lq_idxA;
				rs_sq_idxB_out=sq_idxA;

				//BUT then THIS means that there's one more free slot so we gotta put instr B in. BUT only if B is even valid.
				if (id_IRB_valid) allocB=allocA;
				else allocB='d`RSWIDTH;

			end else begin
				free=2'b01;
				rs_IRA_out=id_IRA;
				rs_alu_funcA_out=id_alu_funcA;
				rs_op1A_select_out=id_op1A_select;
				rs_op2A_select_out=id_op2A_select;
				rs_rob_idxA_out=rob_idxA;
				rs_archIdxA_out=mt_archIdxA;
				rs_npcA_out=id_NPCA;
				rs_issueArdy_out=1'b1;
				rs_TA_out=fl_TA;
				rs_T1A_out=mt_T1A[6:1]; //plus bit.
				rs_T2A_out=mt_T2A[6:1];
				rs_rd_memA_out=id_rd_memA;
				rs_wr_memA_out=id_wr_memA;
				rs_cond_branchA_out=id_cond_branchA;
				rs_uncond_branchA_out=id_uncond_branchA;
				rs_haltA_out=id_haltA;
				rs_illegalA_out=id_illegalA;
				rs_branch_predictionA_out=if_branch_predictionA;
				rs_predicted_PCA_out=if_predicted_PCA;
				rs_lq_idxA_out=lq_idxA;
				rs_sq_idxA_out=sq_idxA;

				if (multforward) begin
					if (multfree==2'b00) multfree1=2'b01;
					else multfree1=2'b10;
				end
				if (aluforward) begin
					if (alufree==2'b00) alufree1=2'b01;
					else alufree1=2'b10;
				end
				if (memforward) begin
					if (memfree==2'b00) memfree1=2'b01;
					else memfree1=2'b10;
				end
			end
		end else begin
			//allocate instruction
			//if (~(allocA=='d8)) begin //if allocA isn't 8 then either its 1)currently busy but something else has been free, or its not currently busy.
				next_t[allocA]={fl_TA}; 
				next1_t1[allocA]=mt_T1A; //blank bit is now 0
				next1_t2[allocA]=mt_T2A;
				next_robIdx[allocA]={rob_idxA};
				next_archIdx[allocA]=mt_archIdxA;
				next_busy[allocA]=1'b1;
				next_instr[allocA]=id_IRA;
				next_alu_func[allocA]=id_alu_funcA;
				next_op1_select[allocA]=id_op1A_select;
				next_op2_select[allocA]=id_op2A_select;
				next_npc[allocA]=id_NPCA;
				next_rd_mem[allocA]=id_rd_memA;
				next_wr_mem[allocA]=id_wr_memA;
				next_cond_branch[allocA]=id_cond_branchA;
				next_uncond_branch[allocA]=id_uncond_branchA;
				next_halt[allocA]=id_haltA;
				next_illegal[allocA]=id_illegalA;
				next_branch_prediction[allocA]=if_branch_predictionA;
				next_predicted_PC[allocA]=if_predicted_PCA;
				next_lq_idx[allocA]=lq_idxA;
				next_sq_idx[allocA]=sq_idxA;
				if ( ((mt_T1A[`MTSRCWIDTH-1:1]==ex_cm_cdbAIdx && (ex_cm_cdbA_en)) || 
					 (mt_T1A[`MTSRCWIDTH-1:1]==ex_cm_cdbBIdx && (ex_cm_cdbB_en)) ||
					 (mt_T1A[`MTSRCWIDTH-1:1]==ex_cm_cdbCIdx && (ex_cm_cdbC_en)) ||
					 (mt_T1A[`MTSRCWIDTH-1:1]==ex_cm_cdbDIdx && (ex_cm_cdbD_en)) ||
					 (id_rd_memA) ||
					 mt_T1A[`MTSRCWIDTH-1:1]=='d31) ||
					(~id_rd_memA & ~id_wr_memA & id_op1A_select==`ALU_OPA_IS_MEM_DISP)
				   )//next_t1[allocA][0] = 1'b1; 
						next1_t1[allocA][0]=1'b1;
				if ( ((mt_T2A[`MTSRCWIDTH-1:1]==ex_cm_cdbAIdx && (ex_cm_cdbA_en)) || 
					 (mt_T2A[`MTSRCWIDTH-1:1]==ex_cm_cdbBIdx && (ex_cm_cdbB_en)) ||
					 (mt_T2A[`MTSRCWIDTH-1:1]==ex_cm_cdbCIdx && (ex_cm_cdbC_en)) ||
					 (mt_T2A[`MTSRCWIDTH-1:1]==ex_cm_cdbDIdx && (ex_cm_cdbD_en)) ||
					 ~(id_op2A_select==`ALU_OPB_IS_REGB) ||
					 mt_T2A[`MTSRCWIDTH-1:1]=='d31) /*&& (mt_T2A != t2[i]) && (mt_T2B != t2[i])*/
					) //next_t2[allocA][0] = 1'b1;
                        next1_t2[allocA][0]=1'b1;
			//end
		end
	end
	//2nd instr. 
	if (~(allocB=='d`RSWIDTH) & ~rob_branch_recover) begin
		multforward1= id_alu_funcB==`ALU_MULQ & ~(multfree1==2'b10);
		aluforward1= ~(id_alu_funcB==`ALU_MULQ) & id_op1B_select==`ALU_OPA_IS_REGA & ~(alufree1==2'b10);
		memforward1= ( id_alu_funcB==`ALU_ADDQ & ~(id_op1B_select==`ALU_OPA_IS_REGA) & ~(memfree1==2'b10) ) | id_uncond_branchB;

		if ( 
				( mt_T1B[0] || 
					(mt_T1B[`MTSRCWIDTH-1:1]==ex_cm_cdbAIdx && (ex_cm_cdbA_en)) || 
					(mt_T1B[`MTSRCWIDTH-1:1]==ex_cm_cdbBIdx && (ex_cm_cdbB_en)) ||
					(mt_T1B[`MTSRCWIDTH-1:1]==ex_cm_cdbCIdx && (ex_cm_cdbC_en)) ||
					(mt_T1B[`MTSRCWIDTH-1:1]==ex_cm_cdbDIdx && (ex_cm_cdbD_en)) ||
					(id_rd_memB) ||
					mt_T1B[`MTSRCWIDTH-1:1]=='d31 ||
					(~id_rd_memB & ~id_wr_memB & id_op1B_select==`ALU_OPA_IS_MEM_DISP)
				) && //src1,instr1 is rdy 
				( mt_T2B[0] || 
					(mt_T2B[`MTSRCWIDTH-1:1]==ex_cm_cdbAIdx && (ex_cm_cdbA_en)) || 
					(mt_T2B[`MTSRCWIDTH-1:1]==ex_cm_cdbBIdx && (ex_cm_cdbB_en)) ||
					(mt_T2B[`MTSRCWIDTH-1:1]==ex_cm_cdbCIdx && (ex_cm_cdbC_en)) ||
					(mt_T2B[`MTSRCWIDTH-1:1]==ex_cm_cdbDIdx && (ex_cm_cdbD_en)) ||
					~(id_op2B_select==`ALU_OPB_IS_REGB) ||
					mt_T2B[`MTSRCWIDTH-1:1]=='d31
				) && //src2,instr2 is rdy.
				~(free==2'b10) &&
				(multforward1 | aluforward1 | memforward1) &&
				(~(id_haltB) | (id_haltB & rob_halt)) &&
				(~lq_alu_stall) //struct hazard with completing loads
			) 
		begin
			rs_IRB_out=id_IRB;
			rs_alu_funcB_out=id_alu_funcB;
			rs_op1B_select_out=id_op1B_select;
			rs_op2B_select_out=id_op2B_select;
			rs_rob_idxB_out=rob_idxB;
			rs_archIdxB_out = mt_archIdxB;
			rs_npcB_out=id_NPCB;
			rs_issueBrdy_out=1'b1;
			rs_TB_out=fl_TB;	 
			rs_T1B_out=mt_T1B[6:1];
			rs_T2B_out=mt_T2B[6:1];
			rs_rd_memB_out=id_rd_memB;
			rs_wr_memB_out=id_wr_memB;
			rs_cond_branchB_out=id_cond_branchB;
			rs_uncond_branchB_out=id_uncond_branchB;
			rs_haltB_out=id_haltB;
			rs_illegalB_out=id_illegalB;
			rs_branch_predictionB_out=if_branch_predictionB;
			rs_predicted_PCB_out=if_predicted_PCB;
			rs_lq_idxB_out=lq_idxB;
			rs_sq_idxB_out=sq_idxB;
			if (free==2'b00) free=2'b01;
			else free=2'b10; //2nd instruction to free must saturate freeing.
		end else begin
				next_t[allocB]={fl_TB};
                next1_t1[allocB]=mt_T1B;
				next1_t2[allocB]=mt_T2B;
				next_robIdx[allocB]={rob_idxB};     
				next_archIdx[allocB]=mt_archIdxB;
                next_busy[allocB]=1'b1;
				next_instr[allocB]=id_IRB;
				next_alu_func[allocB]=id_alu_funcB;
				next_op1_select[allocB]=id_op1B_select;
				next_op2_select[allocB]=id_op2B_select;
				next_npc[allocB]=id_NPCB;
				next_rd_mem[allocB]=id_rd_memB;
				next_wr_mem[allocB]=id_wr_memB;
				next_cond_branch[allocB]=id_cond_branchB;
				next_uncond_branch[allocB]=id_uncond_branchB;
				next_halt[allocB]=id_haltB;
				next_illegal[allocB]=id_illegalB;
				next_branch_prediction[allocB]=if_branch_predictionB;
				next_predicted_PC[allocB]=if_predicted_PCB;
				next_lq_idx[allocB]=lq_idxB;
				next_sq_idx[allocB]=sq_idxB;
				if ( ((mt_T1B[`MTSRCWIDTH-1:1]==ex_cm_cdbAIdx && (ex_cm_cdbA_en)) || 
					 (mt_T1B[`MTSRCWIDTH-1:1]==ex_cm_cdbBIdx && (ex_cm_cdbB_en)) ||
					 (mt_T1B[`MTSRCWIDTH-1:1]==ex_cm_cdbCIdx && (ex_cm_cdbC_en)) ||
					 (mt_T1B[`MTSRCWIDTH-1:1]==ex_cm_cdbDIdx && (ex_cm_cdbD_en)) ||
					 (id_rd_memB) ||
					 mt_T1B[`MTSRCWIDTH-1:1]=='d31)  ||
					(~id_rd_memB & ~id_wr_memB & id_op1B_select==`ALU_OPA_IS_MEM_DISP)
				   ) 
                     next1_t1[allocB][0]=1'b1;
				if ( ((mt_T2B[`MTSRCWIDTH-1:1]==ex_cm_cdbAIdx && (ex_cm_cdbA_en)) || 
					 (mt_T2B[`MTSRCWIDTH-1:1]==ex_cm_cdbBIdx && (ex_cm_cdbB_en)) ||
					 (mt_T2B[`MTSRCWIDTH-1:1]==ex_cm_cdbCIdx && (ex_cm_cdbC_en)) ||
					 (mt_T2B[`MTSRCWIDTH-1:1]==ex_cm_cdbDIdx && (ex_cm_cdbD_en)) ||
					 ~(id_op2B_select==`ALU_OPB_IS_REGB) ||
					 mt_T2B[`MTSRCWIDTH-1:1]=='d31)
				   ) 
                     next1_t2[allocB][0]=1'b1;
		end
	end


	///////////////////////////////////////////////////////////
	////              ALMOST BUSY/BUSY LOGIC               ////
	///////////////////////////////////////////////////////////
	case (next_busy)
		`RSWIDTH'b01111111: almostFull_out=1;
		`RSWIDTH'b10111111: almostFull_out=1;
		`RSWIDTH'b11011111: almostFull_out=1;
		`RSWIDTH'b11101111: almostFull_out=1;
		`RSWIDTH'b11110111: almostFull_out=1;
		`RSWIDTH'b11111011: almostFull_out=1;
		`RSWIDTH'b11111101: almostFull_out=1;
		`RSWIDTH'b11111110: almostFull_out=1;
		default: almostFull_out=0;
	endcase

	if (next_busy==`RSWIDTH'b11111111) busy_out=1'b1;

end //always @*

always @(posedge clock)
begin

	if (reset)
	begin
		//set everything to not busy
		busy<=`SD `RSWIDTH'b0;
		//t, t1, t2, rob indices and reset to 0s.
		//{data, free bit}
		for (i=0; i<'d`RSWIDTH; i=i+1) begin
			t[i]<=`SD 6'b000000;
			t1[i]<=`SD {6'b000000,1'b0};			
			t2[i]<=`SD {6'b000000,1'b0};
			robIdx[i]<=`SD 5'b00000;
			archIdx[i] <= `SD 5'b00000;
			instr[i]<=`SD 32'h0000_0000;
			alu_func[i]<=`SD 5'b00000;
			op1_select[i]<=`SD 2'b00;
			op2_select[i]<=`SD 2'b00;
			npc[i]<=`SD 64'h0;
			rd_mem[i]<=`SD 0;
			wr_mem[i]<=`SD 0;
			cond_branch[i]<=`SD 0;
			uncond_branch[i]<=`SD 0;
			halt[i]<=`SD 0;
			illegal[i]<=`SD 0;
			branch_prediction[i]<=`SD 0;
			predicted_PC[i]<=`SD 0;
			lq_idx[i]<=`SD 0;
			sq_idx[i]<=`SD 0;
		end
	end else begin
		busy<=`SD next_busy;
		for (i=0; i<'d`RSWIDTH; i=i+1) begin
			t[i]<=`SD next_t[i];
			t1[i]<=`SD next1_t1[i];
			t2[i]<=`SD next1_t2[i];
			robIdx[i]<=`SD next_robIdx[i];
			archIdx[i] <= `SD next_archIdx[i];
			instr[i]<=`SD next_instr[i];
			alu_func[i]<=`SD next_alu_func[i];
			op1_select[i]<=`SD next_op1_select[i];
			op2_select[i]<=`SD next_op2_select[i];
			npc[i]<=`SD next_npc[i];
			rd_mem[i]<=`SD next_rd_mem[i];
			wr_mem[i]<=`SD next_wr_mem[i];
			cond_branch[i]<=`SD next_cond_branch[i];
			uncond_branch[i]<=`SD next_uncond_branch[i];
			halt[i]<=`SD next_halt[i];
			illegal[i]<=`SD next_illegal[i];
			branch_prediction[i]<=`SD next_branch_prediction[i];
			predicted_PC[i]<=`SD next_predicted_PC[i];
			lq_idx[i]<=`SD next_lq_idx[i];
			sq_idx[i]<=`SD next_sq_idx[i];
		end
	end
`ifdef DEBUG_OUT
	//assertions
	FULL_AND_ALMOSTFULL: assert (~(almostFull_out==1 && rs_busy_out==1)) else $error("full and almost full @ same time.");
	ALLOC_PROPERTIES: assert(
							(id_IRA_valid && ~(allocA=='d8 & allocB=='d8)) | 
							(~id_IRA_valid && (allocA=='d8 & allocB=='d8))
							) else 
							$error("allocA:%d,allocB:%d,ira_valid:%1b",allocA,allocB,id_IRA_valid);
	ONLY_HALT: assert(
					(rs_IRA_out[25:0]==`PAL_HALT && rs_issueArdy_out==1 && rs_issueBrdy_out==0) |
					~(rs_IRA_out[25:0]==`PAL_HALT)
					) else
					$error("Halt and another instr issued:IRA=%64h, Brdy=%1b", rs_IRA_out, rs_issueBrdy_out);
`endif
end //always

endmodule
