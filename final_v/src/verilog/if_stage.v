/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  if_stage.v                                          //
//                                                                     //
//  Description :  instruction fetch (IF) stage of the pipeline;       //
//                 fetch instruction, compute next PC location, and    //
//                 send them down the pipeline.                        //
//                                                                     //
//                                                                     //
/////////////////////////////////////////////////////////////////////////
//`define SD #1


//`timescale 1ns/100ps

module if_stage(// Inputs
		clock,
		reset,
		Imem2proc_dataA,
		Imem2proc_dataB,
		one_ins_en_in,
		non_ins_en_in, 
		rs_almost_full,
		rs_full,
                Icache2proc_addr_outB,
/********************************************************
signal added by Lily
*********************************************************/		
// all the signals from rob
		branch_target_PCA,
		branch_target_PCB,
		ex_PCA,		   //PC of recover branch
		ex_PCB,
		ex_take_branchA,
		ex_take_branchB,
		IR_validA,          //whether the fetched instruction is valid
		IR_validB,
		need_take_branchA,
		need_take_branchB,
		mispredict_branchA,
		mispredict_branchB,
		rob_recover,
		rob_retire_enA,
		rob_retire_enB,
		fetch_grant,

		lq_full,
		lq_almost_full,
		sq_full,
		sq_almost_full,

/********************************************************/   
// Outputs

		if_IRA_out,         // fetched instruction out
		if_IRB_out,
		if_PCA_out,
		if_PCB_out,
		if_NPCA_out,
		if_NPCB_out,
		proc2Imem_addr,
		if_valid_instA_out,  // when low, instruction is garbage
		if_valid_instB_out,
		fetch_request,
		branch_predictionA,  // the prediction result, pass the ex_stage to check whether the prediction is right
		branch_predictionB,
		predicted_PCA,
		predicted_PCB,
		next_PC,
    if_stall_out
               );

  input         clock;              // system clock
  input         reset;  
  input         rs_almost_full;
  input         rs_full;
  input  [63:0] Imem2proc_dataA;     // Data coming back from instruction-memory
  input  [63:0] Imem2proc_dataB;     // Data coming back from instruction-memory
  input         one_ins_en_in;
  input         non_ins_en_in;  

  input  [63:0]  Icache2proc_addr_outB;
/********************************************************
		signal added by Lily
*********************************************************/

  input		IR_validA;
  input		IR_validB;
  input		fetch_grant;	    // dis-asserted when memory do not receive the request due
// to priority,deal with request	    

  
// input for recovery
		
  input	 [63:0]	branch_target_PCA;  // ex_alu_result
  input	 [63:0]	branch_target_PCB;
  input  [63:0] ex_PCA;             // PC address from ROB, store to BTB if the branch taken
  input  [63:0] ex_PCB;
  input         ex_take_branchA;
  input         ex_take_branchB;  
  input 	need_take_branchA;  // predict not taken, but taken, or predicted taken but the target address is not right
  input 	need_take_branchB;
  input 	mispredict_branchA;
  input 	mispredict_branchB; // do not need take branch, but taken 
  input		rob_recover;  	    // do the recovery
  input		rob_retire_enA;
  input		rob_retire_enB;
// input for LSQ

  input		lq_full;
  input		lq_almost_full;
  input		sq_full;
  input		sq_almost_full;

/********************************************************/
  output [63:0] proc2Imem_addr;     // Address sent to Instruction memory
//  output [63:0] if_NPC_out;       // PC of instruction after fetched (PC+4).
  output [31:0] if_IRA_out;         // fetched instruction
  output [31:0] if_IRB_out;
  output reg    if_valid_instA_out;
  output reg    if_valid_instB_out;
  output [63:0] if_PCA_out;
  output [63:0] if_PCB_out;
  output [63:0] if_NPCA_out;
  output [63:0] if_NPCB_out;
  output        branch_predictionA;
  output        branch_predictionB;
  output [63:0] predicted_PCA ;	    //predicted PC to compare whether get the right prediction
  output [63:0] predicted_PCB ;
  output reg	fetch_request ;     //send to cache controller
  output [63:0] next_PC;		// next_pc, output to prefetch
  output        if_stall_out;

  reg    [63:0] PC_reg;             // PC are currently fetching
  wire   [63:0] PC_plus_4;
  wire   [63:0] PC_plus_8;
  wire          PC_enable;
  wire          stall;
  wire   [63:0] proc2Imem_addr_plus_8;
  wire		next_fetch_request;
  wire		instB_stall;

// signals for checking target address  
//  wire 		target_address_invalidA; 
//  wire 		target_address_invalidB;
//  wire 		predict_PC_invalidA;
//  wire 		predict_PC_invalidB;
//  wire 		ex_NPCA_invalidA;
//  wire 		ex_NPCB_invalidB;

// signals for BTB    
  wire		hitA;
  wire		hitB;
  wire   [63:0] ex_NPCA; 
  wire   [63:0] ex_NPCB;
  wire		pc_change;

 
  assign ex_NPCA = ex_PCA + 4; 
  assign ex_NPCB = ex_PCB + 4;
 
      
  wire hitA_BTB;
  wire hitB_BTB;
  
 BTB BTB_1 (		
		.clock(clock), 
		.reset(reset), 
		.wr0_en(need_take_branchA), 
		.wr1_en(need_take_branchB), 
		.delete0_en(mispredict_branchA),
		.delete1_en(mispredict_branchB),
		.wr_PCA_tag(ex_PCA[63:6]),
		.wr_PCB_tag(ex_PCB[63:6]), 
		.wr_PCA_idx(ex_PCA[5:2]),
		.wr_PCB_idx(ex_PCB[5:2]), 
		.wr_PCA_data(branch_target_PCA),
                .wr_PCB_data(branch_target_PCB),
		.rd_PCA_tag(if_PCA_out[63:6]),
	        .rd_PCB_tag(if_PCB_out[63:6]),
		.rd_PCA_idx(if_PCA_out[5:2]),
		.rd_PCB_idx(if_PCB_out[5:2]), 
		.mispredicted_PCA(ex_PCA),
		.mispredicted_PCB(ex_PCB),
		.target_PCA(predicted_PCA),
		.target_PCB(predicted_PCB),
		.hitA(hitA_BTB),
		.hitB(hitB_BTB)
	    );

  assign	branch_predictionA = hitA;
  assign	branch_predictionB = hitB;



  assign proc2Imem_addr = {PC_reg[63:3], 3'b0};
// Imem gives us 64 bits not 32 bits
  assign stall =  non_ins_en_in | one_ins_en_in | rs_almost_full | rs_full |( !IR_validA && !(IR_validB && (Icache2proc_addr_outB == PC_reg))) | rob_recover | lq_full | lq_almost_full | sq_full | sq_almost_full;
  assign if_stall_out =  stall;
 
  assign if_PCA_out  = PC_reg;
  assign if_NPCA_out = PC_plus_4;
  assign if_PCB_out  = PC_plus_4;
  assign if_NPCB_out = PC_plus_8;

  assign PC_plus_4 = PC_reg + 4;
  assign PC_plus_8 = PC_reg + 8;

  assign proc2Imem_addr_plus_8 = proc2Imem_addr + 8;

/*********************************************************/
//  Condition to set if_valid_instB_out to be 0:
//  a. stall
//  b. PC_reg can not be devided by 8. move instruction output to A, set the
//  valid bit of the second instruction to be 0
//  c. instA branch hit, then do not do the instB




  wire	[63:0] Imem2proc_data;
  assign       Imem2proc_data = IR_validA ? Imem2proc_dataA : (IR_validB && (Icache2proc_addr_outB == PC_reg)) ? Imem2proc_dataB : 64'h0;
  assign if_IRA_out = PC_reg[2]? Imem2proc_data[63:32] : Imem2proc_data[31:0];
  assign if_IRB_out = Imem2proc_data[63:32];
  assign instB_stall = stall | PC_reg[2] | hitA_BTB;
 
  always @*
  begin
      if_valid_instA_out = 1'b1;  
    if (stall)
      if_valid_instA_out = 1'b0;
  end
  
  
  always @*
  begin
      if_valid_instB_out = 1'b1;  
    if (instB_stall)
      if_valid_instB_out = 1'b0;
  end

  assign hitA = hitA_BTB & if_valid_instA_out;
  assign hitB = hitB_BTB & if_valid_instB_out;
/*********************************************************/
// a. predict not taken, but taken => take the branch
// b. predict taken, but not taken => recover
// c. nothing happened, predict this pc will take branch => take the predicted
// address.

  assign next_PC = (need_take_branchA && rob_retire_enA) ? branch_target_PCA : 
                   (need_take_branchB && rob_retire_enB) ? branch_target_PCB : 
                   (mispredict_branchA && rob_retire_enA) ? ex_NPCA : 
                   (mispredict_branchB && rob_retire_enB) ? ex_NPCB : 
                   hitA ? predicted_PCA : 
                   hitB ? predicted_PCB : 
                   stall ? PC_reg : 
                   proc2Imem_addr_plus_8;

//  assign PC_enable = !non_ins_en_in | !one_ins_en_in ;


  always @(posedge clock)
  begin
    if(reset)
      PC_reg <= `SD 0;       // initial PC value is 0
    else 
      PC_reg <= `SD next_PC; // transition to next PC

  end  

  

// fetch request
// grant from memory

  assign pc_change = (PC_reg == next_PC) ? 1'b0 : 1'b1;
  assign next_fetch_request = rob_recover ? 1'b1:
			      pc_change ? 1'b1 : 			// next_pc != pc, request = 1
			      !fetch_grant ? fetch_request :	// grant = 0, next_request = request, next_PC = PC, waiting for receive grant
			      1'b0; 				// grant = 1, grant received, do not need wait
 
  always @(posedge clock)
  begin
	if(reset)
		fetch_request <= `SD 1'b1;
	else
		fetch_request <= `SD next_fetch_request;
  end

             
 /*********************************************************/
// signal for recovery
/*  wire		stall_for_recovery = need_take_branchA | need_take_branchB | mispredict_branchA | mispredict_branchB;
  reg 		state;     // 1 for work, 0 for wait	
  reg		next_state;
  reg		wait_for_recovery;

// if stall_for_recovery is asserted, the if_stage will not fetch instruction
// untill rob_recover_fin is asserted.

  always @*
  begin
	case(state)
	1'b0 : begin // WAIT stage
		wait_for_recovery = 1;
		if (rob_recover_fin) next_state = 1;
	       end
	1'b1 : begin // WORK stage
		wait_for_recovery = 0;
		if (rob_recover_start) next_state = 0;
	       end
	default : next_state = 1;
	endcase
  end

 always @(posedge clock)
 begin
	if (reset)
	state <= 1'b1;
	else
	state <= next_state;
 end
*/
/*********************************************************/

 
endmodule  // module if_stage
