`define CDBWIDTH 6

   module rob_connect( // inputs
                      // from ID
                      clock,
                      reset,
                      id_valid_instA,
                      id_valid_instB,
                      id_destAidx,
                      id_destBidx,
                      id_rdaAidx,
                      id_rdbAidx,
                      id_rdaBidx,
                      id_rdbBidx,
                      id_IRA,
                      id_IRB,
                      id_opcodeA,
                      id_opcodeB,
                      id_PCA,
                      id_PCB,
                      id_uncond_branchA,
                      id_cond_branchA,
                      id_uncond_branchB,
                      id_cond_branchB,
                      id_wr_memA,
                      id_wr_memB,
                      ex_set_mispredictA,
                      ex_set_mispredictB,

                      ex_cm_cdbA_rdy,
                      ex_cm_cdbB_rdy,
                      ex_cm_cdbC_rdy,
                      ex_cm_cdbD_rdy,
                      ex_cm_robAIdx,      // for rob to retire
                      ex_cm_robBIdx,
                      ex_cm_robCIdx,
                      ex_cm_robDIdx,

                      exA_branch_mistaken,
                      exA_branch_still_taken,
		                  exA_if_predicted_taken,
		                  exA_result,
		                  exA_take_branch,

                      exB_branch_mistaken,
                      exB_branch_still_taken,
		                  exB_if_predicted_taken,
		                  exB_result,
		                  exB_take_branch,

                      CDBvalueA,         // actually it is the PR number for maptable to set + bits
                      CDBvalueB,
                      CDBvalueC,
                      CDBvalueD,

                      mt_indexA,          // choose the maptable index to update
                      mt_indexB,
                      mt_indexC,
                      mt_indexD,
               
                      mshr_full,
                      ldq_rob_mem_req,
                      stq_idxA,
                      stq_idxB,
                      mem_stq_idx,
                      mem_grant,
                     // output   signals
                      rob_one_inst_out,
                      rob_none_inst_out,
                      rob_instA_en_out,
                      rob_instB_en_out,
                      rob_dispidxA_out,
                      rob_dispidxB_out,
                      rob_head,
                      rob_branch_idxA,
                      rob_branch_idxB,
                      rob_retireIdxA_out,
                      rob_branch_retire_out,
                      rob_rs_halt_en,
                      fl_TA,
                      fl_TB,
                      mt_T1A_out,
                      mt_T1B_out,
                      mt_T2A_out,
                      mt_T2B_out,
		      rob_branch_mistakenA_out,
		      rob_branch_mistakenB_out,
		      rob_take_branchA_out,
		      rob_take_branchB_out,
		      rob_branch_still_takenA_out,
		      rob_branch_still_takenB_out,
		      rob_PCA_out,
		      rob_PCB_out,
		      rob_target_PCA_out,
		      rob_target_PCB_out,
		      rob_if_predicted_takenA_out,
		      rob_if_predicted_takenB_out,
		      rob_retireA_out,
		      rob_retireB_out,

                      rob_stq_retire_en_out


);
                                         
       input		clock;
       input 		reset;
       input 		id_valid_instA;
       input 		id_valid_instB;
       input    [4:0]   id_destAidx;
       input    [4:0]   id_destBidx;
       input    [4:0]   id_rdaAidx;
       input    [4:0]   id_rdbAidx;
       input    [4:0]   id_rdaBidx;
       input    [4:0]   id_rdbBidx;
       input   [31:0]   id_IRA;
       input   [31:0]   id_IRB;
       input    [4:0]   id_opcodeA;
       input    [4:0]   id_opcodeB;
       input   [63:0]   id_PCA;
       input   [63:0]   id_PCB;

       input            id_uncond_branchA;
       input            id_cond_branchA;
       input            id_uncond_branchB;
       input            id_cond_branchB;
       input            id_wr_memA;
       input            id_wr_memB;
       input            ex_set_mispredictA;
       input            ex_set_mispredictB;

       input            ex_cm_cdbA_rdy;
       input            ex_cm_cdbB_rdy;
       input            ex_cm_cdbC_rdy;
       input            ex_cm_cdbD_rdy;
       input    [4:0]   ex_cm_robAIdx;
       input    [4:0]   ex_cm_robBIdx;
       input    [4:0]   ex_cm_robCIdx;
       input    [4:0]   ex_cm_robDIdx;

       input            exA_branch_mistaken;
       input            exA_branch_still_taken;
       input            exA_if_predicted_taken;
       input   [63:0]   exA_result;
       input  		exA_take_branch;

       input            exB_branch_mistaken;
       input            exB_branch_still_taken;
       input            exB_if_predicted_taken;
       input   [63:0]   exB_result;
       input  		exB_take_branch;

       input    [5:0]   CDBvalueA;
       input    [5:0]   CDBvalueB;
       input    [5:0]   CDBvalueC;
       input    [5:0]   CDBvalueD;

       input    [4:0]   mt_indexA;
       input    [4:0]   mt_indexB;
       input    [4:0]   mt_indexC;
       input    [4:0]   mt_indexD;

       input            mshr_full;
       input            ldq_rob_mem_req;
       input   [2:0]    stq_idxA;
       input   [2:0]    stq_idxB;
       input   [2:0]     mem_stq_idx;
       input            mem_grant;

       // outputs
       output           rob_one_inst_out;
       output           rob_none_inst_out;
       output           rob_instA_en_out;
       output           rob_instB_en_out;
       output   [4:0]   rob_dispidxA_out;
       output   [4:0]   rob_dispidxB_out;
       output   [5:0]   fl_TA;
       output   [5:0]   fl_TB;
       output   [6:0]   mt_T1A_out;
       output   [6:0]   mt_T1B_out;
       output   [6:0]   mt_T2A_out;
       output   [6:0]   mt_T2B_out;

       output   [4:0]   rob_head;
       output   [4:0]   rob_branch_idxA;
       output   [4:0]   rob_branch_idxB;
       output   [4:0]   rob_retireIdxA_out;
       output           rob_branch_retire_out;
       output           rob_rs_halt_en;

       output           rob_branch_mistakenA_out;
       output           rob_take_branchA_out;
       output           rob_branch_still_takenA_out;
       output  [63:0]   rob_PCA_out;
       output  [63:0]   rob_target_PCA_out;
       output           rob_if_predicted_takenA_out;

       output           rob_branch_mistakenB_out;
       output           rob_take_branchB_out;
       output           rob_branch_still_takenB_out;
       output  [63:0]   rob_PCB_out;
       output  [63:0]   rob_target_PCB_out;
       output           rob_if_predicted_takenB_out;
     
       output           rob_stq_retire_en_out;
       output           rob_retireA_out;
       output           rob_retireB_out;

     // internal signals

      // wire                     rob_retireA_out;
      // wire                     rob_retireB_out;
       wire   [`CDBWIDTH-1:0]   rob_ToldA_out;
       wire   [`CDBWIDTH-1:0]   rob_ToldB_out;   
       wire         [4:0]       rob_logidxA_out;
       wire         [4:0]       rob_logidxB_out;
       wire   [`CDBWIDTH-1:0]   rob_TA_out;
       wire   [`CDBWIDTH-1:0]   rob_TB_out;
       // wire                     full;
       wire                     empty;
       // wire                     almost_empty;
       wire   [`CDBWIDTH-1:0]   mt_ToldA_out;
       wire   [`CDBWIDTH-1:0]   mt_ToldB_out; 
       wire         branch_recovery_en;
       wire   [4:0] branch_recovery_head;
       wire   [4:0] head_at_branch_signal;
       wire   [4:0] next_head_at_branch_signal;
       wire   [4:0] head_add_one_at_branch_signal;
       wire   [4:0] next_head_add_one_at_branch_signal;
       wire   [5:0] archtable_copy_0;
       wire   [5:0] archtable_copy_1;
       wire   [5:0] archtable_copy_2;
       wire   [5:0] archtable_copy_3;
       wire   [5:0] archtable_copy_4;
       wire   [5:0] archtable_copy_5;
       wire   [5:0] archtable_copy_6;
       wire   [5:0] archtable_copy_7;
       wire   [5:0] archtable_copy_8;
       wire   [5:0] archtable_copy_9;
       wire   [5:0] archtable_copy_10;
       wire   [5:0] archtable_copy_11;
       wire   [5:0] archtable_copy_12;
       wire   [5:0] archtable_copy_13;
       wire   [5:0] archtable_copy_14;
       wire   [5:0] archtable_copy_15;
       wire   [5:0] archtable_copy_16;
       wire   [5:0] archtable_copy_17;
       wire   [5:0] archtable_copy_18;
       wire   [5:0] archtable_copy_19;
       wire   [5:0] archtable_copy_20;
       wire   [5:0] archtable_copy_21;
       wire   [5:0] archtable_copy_22;
       wire   [5:0] archtable_copy_23;
       wire   [5:0] archtable_copy_24;
       wire   [5:0] archtable_copy_25;
       wire   [5:0] archtable_copy_26;
       wire   [5:0] archtable_copy_27;
       wire   [5:0] archtable_copy_28;
       wire   [5:0] archtable_copy_29;
       wire   [5:0] archtable_copy_30;
       wire   [5:0] archtable_copy_31;
       wire         recovery_en;

  rob    rob_0 (    // inputs
                 .clock(clock),
                 .reset(reset),
                 .mt_ToldA(mt_ToldA_out),
                 .mt_ToldB(mt_ToldB_out),
                 .fl_TA(fl_TA),
                 .fl_TB(fl_TB),
                 .id_IRA(id_IRA),
                 .id_IRB(id_IRB),
                 .id_opcodeA(id_opcodeA),                 
                 .id_opcodeB(id_opcodeB),
                 .id_PCA(id_PCA),
                 .id_PCB(id_PCB),

                 .id_valid_instA(id_valid_instA),
                 .id_valid_instB(id_valid_instB),
                 .id_logdestAIdx(id_destAidx),
                 .id_logdestBIdx(id_destBidx),
                 .id_uncond_branchA(id_uncond_branchA),
                 .id_cond_branchA(id_cond_branchA),
                 .id_uncond_branchB(id_uncond_branchB),
                 .id_cond_branchB(id_cond_branchB),
                 .id_wr_memA(id_wr_memA),
                 .id_wr_memB(id_wr_memB),

                 .ex_cm_cdbA_rdy(ex_cm_cdbA_rdy),
                 .ex_cm_cdbB_rdy(ex_cm_cdbB_rdy),
                 .ex_cm_cdbC_rdy(ex_cm_cdbC_rdy),
                 .ex_cm_cdbD_rdy(ex_cm_cdbD_rdy),

                 .ex_cm_robAIdx(ex_cm_robAIdx),
                 .ex_cm_robBIdx(ex_cm_robBIdx),
                 .ex_cm_robCIdx(ex_cm_robCIdx),
                 .ex_cm_robDIdx(ex_cm_robDIdx),

                 .ex_set_mispredictA(ex_set_mispredictA),//mixed
                 .ex_set_mispredictB(ex_set_mispredictB),//mixed
	         .ex_branch_mistakenA(exA_branch_mistaken),//
 	         .ex_branch_mistakenB(exB_branch_mistaken),//
 	         .ex_take_branchA(exA_take_branch),
 	         .ex_take_branchB(exB_take_branch),
  	         .ex_branch_still_takenA(exA_branch_still_taken),
  	         .ex_branch_still_takenB(exB_branch_still_taken),
   	         .ex_target_PCA(exA_result),
    		 .ex_target_PCB(exB_result),
                 .mshr_full(mshr_full),
                 .ldq_rob_mem_req(ldq_rob_mem_req),
                 .stq_idxA(stq_idxA),
                 .stq_idxB(stq_idxB),
                 .mem_stq_idx(mem_stq_idx),
                 .mem_grant(mem_grant), 
                  // outputs
                 .rob_ToldA_out(rob_ToldA_out),
                 .rob_ToldB_out(rob_ToldB_out),

                 .rob_retireA_out(rob_retireA_out),
                 .rob_retireB_out(rob_retireB_out),

                 .rob_one_inst_out(rob_one_inst_out),
                 .rob_none_inst_out(rob_none_inst_out),

                 .rob_instA_en_out(rob_instA_en_out),
                 .rob_instB_en_out(rob_instB_en_out),

                 .rob_dispidxA_out(rob_dispidxA_out),
                 .rob_dispidxB_out(rob_dispidxB_out),

                 .rob_logidxA_out(rob_logidxA_out),
                 .rob_logidxB_out(rob_logidxB_out),
                 .rob_TA_out(rob_TA_out),
                 .rob_TB_out(rob_TB_out),
                 .rob_head(rob_head),
                 .rob_branch_idxA(rob_branch_idxA),
                 .rob_branch_idxB(rob_branch_idxB),
                 .rob_retireIdxA_out(rob_retireIdxA_out),
                 .rob_branch_retire_out(rob_branch_retire_out),
                 .rob_rs_halt_en(rob_rs_halt_en),

	         .rob_branch_mistakenA_out(rob_branch_mistakenA_out),
	         .rob_branch_mistakenB_out(rob_branch_mistakenB_out),
	         .rob_take_branchA_out(rob_take_branchA_out),
	         .rob_take_branchB_out(rob_take_branchB_out),
	         .rob_branch_still_takenA_out(rob_branch_still_takenA_out),
	         .rob_branch_still_takenB_out(rob_branch_still_takenB_out),
	         .rob_PCA_out(rob_PCA_out),
	         .rob_PCB_out(rob_PCB_out),
	         .rob_target_PCA_out(rob_target_PCA_out),
	         .rob_target_PCB_out(rob_target_PCB_out),
                 .rob_stq_retire_en_out(rob_stq_retire_en_out)

);



  freelist freelist_0 (  // inputs
                        .clock(clock),
                        .reset(reset),
                        .id_valid_IRA(id_valid_instA),
                        .id_valid_IRB(id_valid_instB),
                        .rob_retire_enA(rob_retireA_out),
                        .rob_retire_enB(rob_retireB_out),
                        .rob_ToldA(rob_ToldA_out),
                        .rob_ToldB(rob_ToldB_out),
                        .id_destA(id_destAidx),
                        .id_destB(id_destBidx),
                        .branch_recovery_en(rob_branch_retire_out),
                        .branch_recovery_head(branch_recovery_head),
//			.id_IRA(id_IRA),
//			.id_IRB(id_IRB),
                          // outputs
                        .fl_TA(fl_TA),
                        .fl_TB(fl_TB),
                        .empty(empty),
                        .head_at_branch_signal(head_at_branch_signal),
                        .head_add_one_at_branch_signal(head_add_one_at_branch_signal),
                        .next_head_at_branch_signal(next_head_at_branch_signal),
                        .next_head_add_one_at_branch_signal(next_head_add_one_at_branch_signal)
);

   maptable maptable_0 ( // inputs
                        .clock(clock),
                        .reset(reset),
                        .id_destAidx(id_destAidx),
                        .id_destBidx(id_destBidx),
                        .id_valid_IRA(id_valid_instA),
                        .id_valid_IRB(id_valid_instB),
                        .mt_indexA(mt_indexA),
                        .mt_indexB(mt_indexB),
                        .mt_indexC(mt_indexC),
                        .mt_indexD(mt_indexD),
                        .CDBvalueA(CDBvalueA),
                        .CDBvalueB(CDBvalueB),
                        .CDBvalueC(CDBvalueC),
                        .CDBvalueD(CDBvalueD),
                        .broadcastA(ex_cm_cdbA_rdy),
                        .broadcastB(ex_cm_cdbB_rdy),
                        .broadcastC(ex_cm_cdbC_rdy),
                        .broadcastD(ex_cm_cdbD_rdy),
                        .archtable_copy_0(archtable_copy_0),
                        .archtable_copy_1(archtable_copy_1),
                        .archtable_copy_2(archtable_copy_2),
                        .archtable_copy_3(archtable_copy_3),
                        .archtable_copy_4(archtable_copy_4),
                        .archtable_copy_5(archtable_copy_5),
                        .archtable_copy_6(archtable_copy_6),
                        .archtable_copy_7(archtable_copy_7),
                        .archtable_copy_8(archtable_copy_8),
                        .archtable_copy_9(archtable_copy_9),
                        .archtable_copy_10(archtable_copy_10),
                        .archtable_copy_11(archtable_copy_11),
                        .archtable_copy_12(archtable_copy_12),
                        .archtable_copy_13(archtable_copy_13),
                        .archtable_copy_14(archtable_copy_14),
                        .archtable_copy_15(archtable_copy_15),
                        .archtable_copy_16(archtable_copy_16),
                        .archtable_copy_17(archtable_copy_17),
                        .archtable_copy_18(archtable_copy_18),
                        .archtable_copy_19(archtable_copy_19),
                        .archtable_copy_20(archtable_copy_20),
                        .archtable_copy_21(archtable_copy_21),
                        .archtable_copy_22(archtable_copy_22),
                        .archtable_copy_23(archtable_copy_23),
                        .archtable_copy_24(archtable_copy_24),
                        .archtable_copy_25(archtable_copy_25),
                        .archtable_copy_26(archtable_copy_26),
                        .archtable_copy_27(archtable_copy_27),
                        .archtable_copy_28(archtable_copy_28),
                        .archtable_copy_29(archtable_copy_29),
                        .archtable_copy_30(archtable_copy_30),
                        .archtable_copy_31(archtable_copy_31),
                        .recovery_en(rob_branch_retire_out),
                        .id_rdaAidx(id_rdaAidx),
                        .id_rdbAidx(id_rdbAidx),
                        .id_rdaBidx(id_rdaBidx),
                        .id_rdbBidx(id_rdbBidx),
                        .fl_prNumA(fl_TA),
                        .fl_prNumB(fl_TB),

                          // outputs
                        .mt_ToldA_out(mt_ToldA_out),
                        .mt_ToldB_out(mt_ToldB_out),
                        .mt_T1A_out(mt_T1A_out),
                        .mt_T1B_out(mt_T1B_out),
                        .mt_T2A_out(mt_T2A_out),
                        .mt_T2B_out(mt_T2B_out)

);


   archtable archtable_0 (  //inputs
                           .clock(clock),
                           .reset(reset),
                           .retire_enA(rob_retireA_out),
                           .retire_enB(rob_retireB_out),
                           .retire_valueA(rob_TA_out),
                           .retire_valueB(rob_TB_out),
                           .retire_indexA(rob_logidxA_out),
                           .retire_indexB(rob_logidxB_out),
                           //OUTPUTS!!!
                           .archtable_copy_0(archtable_copy_0),
                           .archtable_copy_1(archtable_copy_1),
                           .archtable_copy_2(archtable_copy_2),
                           .archtable_copy_3(archtable_copy_3),
                           .archtable_copy_4(archtable_copy_4),
                           .archtable_copy_5(archtable_copy_5),
                           .archtable_copy_6(archtable_copy_6),
                           .archtable_copy_7(archtable_copy_7),
                           .archtable_copy_8(archtable_copy_8),
                           .archtable_copy_9(archtable_copy_9),
                           .archtable_copy_10(archtable_copy_10),
                           .archtable_copy_11(archtable_copy_11),
                           .archtable_copy_12(archtable_copy_12),
                           .archtable_copy_13(archtable_copy_13),
                           .archtable_copy_14(archtable_copy_14),
                           .archtable_copy_15(archtable_copy_15),
                           .archtable_copy_16(archtable_copy_16),
                           .archtable_copy_17(archtable_copy_17),
                           .archtable_copy_18(archtable_copy_18),
                           .archtable_copy_19(archtable_copy_19),
                           .archtable_copy_20(archtable_copy_20),
                           .archtable_copy_21(archtable_copy_21),
                           .archtable_copy_22(archtable_copy_22),
                           .archtable_copy_23(archtable_copy_23),
                           .archtable_copy_24(archtable_copy_24),
                           .archtable_copy_25(archtable_copy_25),
                           .archtable_copy_26(archtable_copy_26),
                           .archtable_copy_27(archtable_copy_27),
                           .archtable_copy_28(archtable_copy_28),
                           .archtable_copy_29(archtable_copy_29),
                           .archtable_copy_30(archtable_copy_30),
                           .archtable_copy_31(archtable_copy_31)
);

   bs bs_0 (  //input
			.clock(clock),
			.reset(reset),
			.id_uncond_branchA(id_uncond_branchA),
			.id_cond_branchA(id_cond_branchA),
			.id_uncond_branchB(id_uncond_branchB),
			.id_cond_branchB(id_cond_branchB), 
      .id_destAidx(id_destAidx),
      .id_destBidx(id_destBidx),      
			.rob_branch_idxA_in(rob_branch_idxA),   // this is for the set up case
			.rob_branch_idxB_in(rob_branch_idxB),
      .fl_headA_in(head_at_branch_signal),
			.next_fl_headA_in(next_head_at_branch_signal),
      .fl_headB_in(head_add_one_at_branch_signal),
			.next_fl_headB_in(next_head_add_one_at_branch_signal),
			.rob_branch_retire_in(rob_branch_retire_out),
			.rob_broadcastA_in(rob_retireIdxA_out),      // this is for the retire case
      .IRA_valid(id_valid_instA),
      .IRB_valid(id_valid_instB),      
		//output
			.fl_broadcastA_out(branch_recovery_head)
);


endmodule

