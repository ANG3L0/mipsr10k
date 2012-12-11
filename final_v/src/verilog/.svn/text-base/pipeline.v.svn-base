
  module pipeline ( // inputs
                   clock,
                   reset,
                   mem2proc_data,
                   mem2proc_response,
                   mem2proc_tag,
                   // outputs
                   proc2mem_addr,
                   proc2mem_command,      
                   proc2mem_data,
                   pipeline_error_status,
                   pipeline_commit_wr_dataA,
                   pipeline_commit_wr_dataB,
                   pipeline_commit_wr_dataC,
                   pipeline_commit_wr_dataD,
                   pipeline_commit_wr_idxA,
                   pipeline_commit_wr_idxB,
                   pipeline_commit_wr_idxC,
                   pipeline_commit_wr_idxD,
                   pipeline_commit_wr_enA,
                   pipeline_commit_wr_enB,
                   pipeline_commit_wr_enC,
                   pipeline_commit_wr_enD,
                   pipeline_completed_instA,
                   pipeline_completed_instB,
                   pipeline_completed_instC,
                   pipeline_completed_instD
);

         input 	          	clock;
         input 	        	reset;
         input 	   [63:0]	mem2proc_data;
         input      [3:0]       mem2proc_tag;
         input      [3:0]       mem2proc_response;


         output	   [63:0]	proc2mem_addr;
         output     [1:0]       proc2mem_command;
         output    [63:0]       proc2mem_data;

         output    [3:0]   pipeline_error_status;
         output    [63:0]  pipeline_commit_wr_dataA;
         output    [63:0]  pipeline_commit_wr_dataB;
         output    [63:0]  pipeline_commit_wr_dataC;
         output    [63:0]  pipeline_commit_wr_dataD;
         output    [5:0]   pipeline_commit_wr_idxA;
         output    [5:0]   pipeline_commit_wr_idxB;
         output    [5:0]   pipeline_commit_wr_idxC;
         output    [5:0]   pipeline_commit_wr_idxD;
         output            pipeline_commit_wr_enA;
         output            pipeline_commit_wr_enB;
         output            pipeline_commit_wr_enC;
         output            pipeline_commit_wr_enD;
         output    [3:0]   pipeline_completed_instA;
         output    [3:0]   pipeline_completed_instB;
         output    [3:0]   pipeline_completed_instC;
         output    [3:0]   pipeline_completed_instD;
   ////////////////about memory staffs///////////////
   /////////////////////////////////////////////////
        wire       [1:0]       proc2Dmem_command;
        wire      [63:0]       proc2Dmem_addr;
        wire      [63:0]       proc2Imem_addr;     
        wire       [3:0]       mem2proc_response;
        wire       [3:0]       mem2proc_tag;
	wire   [63:0]   proc2Icache_addr;
	wire            proc2Icache_request;

//Input from Processor for load
	wire   [63:0]   proc2Dcache_load_addr;
	wire   [2:0]         proc2Dcache_LQ_idx;
	wire            proc2Dcache_load_request;
 
//Input from Processor for store
	wire   [63:0]   proc2Dcache_store_addr;
	wire   [63:0]   proc2Dcache_store_data;
	wire            proc2Dcache_store_write_en;
	wire   [2:0]    proc2Dcache_SQ_idx;
       
//        assign          proc2Dcache_store_write_en = 0;

//Input from prefetch
	wire   [63:0]   prefetch2Icache_addr;
	wire            prefetch2Icache_request;



        wire    [63:0]       Icache2proc_data_outA;  //from Icache
        wire                 Icache2proc_valid_outA;

        wire                 Icache2proc_grant;
        wire                 Icache2prefetch_grant;
        wire                 Dcache2proc_load_grant;
        wire                 Dcache2proc_store_grant;

        wire    [63:0]       Icache2proc_data_outB;  //from mem
        wire                 Icache2proc_valid_outB;

        wire     [63:0]      Dcache2proc_data_outA; //from Dcache
        wire                 Dcache2proc_valid_outA;
        wire      [2:0]      Dcache2proc_LQ_idxA;

        wire      [63:0]     Dcache2proc_data_outB;   //connect to Dcache_last_data
        wire                 Dcache2proc_valid_outB;  //connect to Dcache_last_data write_en
        wire      [2:0]      Dcache2proc_LQ_idxB;  //read from MSHR
        wire                 MSHR_full;
        

     // internal signals 
  
    // internal  output signal from id to rob, rs
      wire          [63:0]  Imem2proc_dataA;

      wire           [1:0]  id_opa_select_outA;
      wire           [1:0]  id_opb_select_outA;
      wire           [1:0]  id_opa_select_outB;
      wire           [1:0]  id_opb_select_outB;
      wire           [4:0]  id_rdaAidx;
      wire          [4:0]  id_rdbAidx;
      wire           [4:0]  id_rdaBidx;
      wire           [4:0]  id_rdbBidx;
      wire                  id_IRA_valid_out;
      wire                  id_IRB_valid_out;
      wire           [4:0]  id_dest_reg_idx_outA;
      wire           [4:0]  id_dest_reg_idx_outB;    
      wire           [4:0]  id_alu_func_outA;
      wire           [4:0]  id_alu_func_outB;
      wire          [31:0]  id_IRA_out;
      wire          [31:0]  id_IRB_out;
      wire          [63:0]  id_PCA_out;
      wire          [63:0]  id_PCB_out;
      wire          [63:0]  id_NPCA_out;
      wire          [63:0]  id_NPCB_out;


      wire                  id_rd_mem_outA;
      wire                  id_wr_mem_outA;
      wire                  id_rd_mem_outB;
      wire                  id_wr_mem_outB;
      wire                  id_cond_branch_outA;
      wire                  id_uncond_branch_outA;
      wire                  id_cond_branch_outB;
      wire                  id_uncond_branch_outB;
      wire                  id_halt_outA;
      wire                  id_halt_outB;
      wire                  id_illegal_outA;
      wire                  id_illegal_outB;
      wire                  branch_predictionA;
      wire                  branch_predictionB;
      wire          [63:0]  predicted_PCA;
      wire          [63:0]  predicted_PCB;
      wire                  lq_full_out;
      wire                  lq_almost_full_out;
      wire                  sq_full_out;
      wire                  sq_almost_full_out;
//      wire          [63:0]  proc2Imem_addr;



  // internal output signal from rob
      wire                  rob_one_inst_out;
      wire                  rob_none_inst_out;
      wire                  rob_instA_en_out;
      wire                  rob_instB_en_out;
      wire           [4:0]  rob_dispidxA_out;
      wire           [4:0]  rob_dispidxB_out;       
      wire    [4:0]         rob_head;
      wire    [4:0]         rob_branch_idxA;
      wire    [4:0]         rob_branch_idxB;
      wire    [4:0]         rob_retireIdxA_out;
      wire                  rob_branch_retire_out;
      wire                  rob_rs_halt_en;
      wire		    rob_branch_mistakenA_out;
      wire		    rob_branch_mistakenB_out;
      wire		    rob_branch_still_takenA_out;
      wire		    rob_branch_still_takenB_out;
      wire		    rob_take_branchA_out;
      wire		    rob_take_branchB_out;
      wire	[63:0]      rob_PCA_out;
      wire	[63:0]      rob_PCB_out; 
      wire      [63:0]      rob_target_PCA_out;
      wire      [63:0]      rob_target_PCB_out;
      wire      	    rob_if_predicted_takenA_out;
      wire		    rob_if_predicted_takenB_out;
      wire                  rob_stq_retire_en_out;
      wire                  rob_retireA_out;
      wire                  rob_retireB_out;


  //  internal output signal from freelist
      wire           [5:0]  fl_TA;
      wire           [5:0]  fl_TB;


  //  internal outputsignal from maptable
      wire   [`CDBWIDTH:0]  mt_T1A_out;
      wire   [`CDBWIDTH:0]  mt_T2A_out;
      wire   [`CDBWIDTH:0]  mt_T1B_out;
      wire   [`CDBWIDTH:0]  mt_T2B_out;

  //  internal output signal from rs
      wire   [`CDBWIDTH-1:0]  rs_TA_out;
      wire   [`CDBWIDTH-1:0]  rs_TB_out;
      wire                  rs_almostFull_out;
      wire                  rs_busy_out;
      wire           [4:0]  rs_alu_funcA_out;
      wire           [4:0]  rs_alu_funcB_out;
      wire        [1:0]     rs_op1A_select_out;
      wire        [1:0]     rs_op2A_select_out;
      wire        [1:0]     rs_op1B_select_out;         
      wire        [1:0]     rs_op2B_select_out;
      wire        [4:0]     rs_rob_idxA_out;
      wire        [4:0]     rs_rob_idxB_out;
      wire   [`CDBWIDTH-1:0]  rs_T1A_out;
      wire   [`CDBWIDTH-1:0]  rs_T2A_out;
      wire   [`CDBWIDTH-1:0]  rs_T1B_out;
      wire   [`CDBWIDTH-1:0]  rs_T2B_out;
      wire          [31:0]  rs_IRA_out;
      wire          [31:0]  rs_IRB_out;
      wire                  rs_issueArdy_out;
      wire                  rs_issueBrdy_out;
      wire           [4:0]  rs_archIdxA_out;
      wire           [4:0]  rs_archIdxB_out;
      wire           [63:0] rs_npcA_out;
      wire           [63:0] rs_npcB_out;

      wire                  ex_stall_rs_out;
      wire   [`LQWIDTH-1:0] rs_lq_idxA_out;
      wire   [`LQWIDTH-1:0] rs_lq_idxB_out;
      wire   [`SQWIDTH-1:0] rs_sq_idxA_out;
      wire   [`SQWIDTH-1:0] rs_sq_idxB_out;
      wire                  rs_lq_alu_stall_out;

    //  internal output signal fro pr
      wire     [63:0]       pr_T1A_out;
      wire     [63:0]       pr_T2A_out;
      wire     [63:0]       pr_T1B_out;
      wire     [63:0]       pr_T2B_out;


   // internal output signal from CDB
	wire    exA_en_out;
	wire  [63:0]  exA_result_out;
	wire   [5:0] exA_pr_idx_out;
	wire   [4:0] exA_mt_idx_out;
	wire   [4:0] exA_rob_idx_out;
	wire    exA_take_branch_out;
	wire    exA_branch_mistaken_out;
	wire    exA_branch_still_taken_out;
	wire    exA_mispredicted_out;
	wire	exA_if_predicted_taken_out;
        wire  [63:0]  exA_predicted_PC_out;

	wire    exA_cond_branch_out;
	wire    exA_uncond_branch_out;
	wire   [63:0] exA_NPC_out;
	wire    exA_halt_out;
 	wire    exA_illegal_out;

 	wire    	exA_wr_mem_out;
 	wire    	exA_rd_mem_out;
 	wire     [`LQWIDTH-1:0]	exA_lq_idx_out;
 	wire     [5:0]	exA_lq_pr_idx_out;
 	wire     [4:0]	exA_lq_mt_idx_out;
 	wire     [4:0]	exA_lq_rob_idx_out;
 	wire    [63:0]	exA_lq_NPC_out;
 	wire    	exA_lq_data_rdy_out;
 	wire    	exA_sq_data_rdy_out;
 	wire     [`SQWIDTH-1:0]	exA_sq_idx_out;
 	wire    [63:0]	exA_lsq_data_out;
 	wire    [63:0]	exA_lsq_addr_out;
 	wire    	exA_lsq_halt_out;
 	wire    	exA_lsq_illegal_out;
        wire    [63:0] exA_lsq_NPC_out;
	wire    exB_en_out;
	wire   [63:0] exB_result_out;
	wire   [5:0] exB_pr_idx_out;
	wire   [4:0] exB_mt_idx_out;
	wire   [4:0] exB_rob_idx_out;
	wire    exB_take_branch_out;
	wire    exB_branch_mistaken_out;
	wire    exB_branch_still_taken_out;
	wire    exB_mispredicted_out;
	wire	exB_if_predicted_taken_out;


        wire  [63:0] exB_predicted_PC_out;
	wire   [63:0] exB_NPC_out;
	wire    exB_halt_out;
	wire    exB_illegal_out;

 	wire    	exB_wr_mem_out;
 	wire    	exB_rd_mem_out;
 	wire     [`LQWIDTH-1:0]	exB_lq_idx_out;
 	wire     [5:0]	exB_lq_pr_idx_out;
 	wire     [4:0]	exB_lq_mt_idx_out;
 	wire     [4:0]	exB_lq_rob_idx_out;
 	wire    [63:0]	exB_lq_NPC_out;
 	wire    	exB_lq_data_rdy_out;
 	wire    	exB_sq_data_rdy_out;
 	wire     [`SQWIDTH-1:0]	exB_sq_idx_out;
 	wire    [63:0]	exB_lsq_data_out;
 	wire    [63:0]	exB_lsq_addr_out;
 	wire    	exB_lsq_halt_out;
 	wire    	exB_lsq_illegal_out;
        wire    [63:0] exB_lsq_NPC_out;
	wire    exC_mult_valid_out;
	wire   [63:0] exC_mult_result_out;
	wire   [5:0] exC_pr_idx_out;
	wire   [4:0] exC_mt_idx_out;
	wire   [4:0] exC_rob_idx_out;
  	wire   [63:0] exC_NPC_out;
	wire    exD_mult_valid_out;
	wire   [63:0] exD_mult_result_out;
	wire   [5:0]  exD_pr_idx_out;
	wire   [4:0]  exD_mt_idx_out;
	wire   [4:0]  exD_rob_idx_out;
 	wire   [63:0] exD_NPC_out;
 /*	 //early wire later.
 	wire    exC_mult_valid_out_early;
  	wire  [63:0]  exC_mult_result_out_early;
  	wire   [5:0]  exC_pr_idx_early;
  	wire   [4:0]  exC_mt_idx_early;
 	wire   [4:0]  exC_rob_idx_early;
 	wire   [63:0] exC_NPC_early;
 	wire    exD_mult_valid_out_early;
 	wire  [63:0]  exD_mult_result_out_early;
 	wire   [5:0]  exD_pr_idx_early;
  	wire   [4:0]  exD_mt_idx_early;
 	wire   [4:0]  exD_rob_idx_early;
 	wire   [63:0] exD_NPC_early;*/
 	//cache wires
 	wire    mem2proc_valid;


  	 // internal signal from stq
     wire           store_request;
     wire  [63:0]   store_retire_addr;
     wire  [63:0]   store_retire_data;
     wire   [2:0]   SQ2RS_idxA;
     wire   [2:0]   SQ2RS_idxB;
     wire   [2:0]   tail;
     wire   [2:0]   next_tail;
     wire           SQ_full;
     wire           SQ_almost_full;
     wire   [7:0]   next_busy;
     wire   [2:0]   head;
     wire           stq_retiring_out;
     wire   [7:0]   busy;
    // internal signal from ldq
     wire                ldq_rs_stall_out;
     wire    [2:0]       ldq_rs_ldqidxA_out;
     wire    [2:0]       ldq_rs_ldqidxB_out;
     wire                ldq_almostfull_out;
     wire                ldq_full_out;
     wire   [63:0]       ldq_mem_addr_out;
     wire                ldq_mem_req_out;
     wire    [2:0]       ldq_mem_idx_out;

     wire                ldq_ex_cdb_en_out;
     wire   [63:0]       ldq_ex_data_out;
     wire    [4:0]       ldq_ex_robidx_out;
     wire    [5:0]       ldq_ex_pridx_out;
     wire    [4:0]       ldq_ex_mtidx_out;
     wire                ldq_ex_illegal_out;
     wire                ldq_ex_halt_out;
     wire    [63:0]      ldq_ex_NPC_out;

    //      signal that no use
     wire                   done_to_robC;
     wire                   done_to_robD;
     wire       [5:0]       pr_idx_out_to_robC;
     wire       [5:0]       pr_idx_out_to_robD;
     wire       [4:0]       mt_idx_out_to_robC; 
     wire       [4:0]       mt_idx_out_to_robD;
     wire       [4:0]       rob_idx_out_robC;
     wire       [4:0]       rob_idx_out_robD;


     wire                   take_branchA;
     wire                   take_branchB;
     wire       [63:0]      branch_target_PCA;
     wire       [63:0]      branch_target_PCB;
//     wire                   access_memory;

     wire       [63:0]      rs_npc_out;
     wire                   ex_alu_full;
     wire                   ex_alu_almostfull;
     wire                   ex_mulq_full;
     wire                   ex_mulq_almostfull;
     wire                   ex_ld_full;
     wire                   ex_ld_almostfull;
     wire                   ex_sv_full;
     wire                   ex_sv_almostfull;
     wire                   rs_rd_memA_out;
     wire                   rs_wr_memA_out;
     wire                   rs_rd_memB_out;
     wire                   rs_wr_memB_out;
     wire                   rs_cond_branchA_out;
     wire                   rs_uncond_branchA_out;
     wire                   rs_cond_branchB_out;
     wire                   rs_uncond_branchB_out;
     wire                   rs_haltA_out;
     wire                   rs_haltB_out;
     wire                   rs_illegalA_out;
     wire                   rs_illegalB_out;
     wire                   rs_branch_predictionA_out;
     wire                   rs_branch_predictionB_out;
     wire       [63:0]      rs_predicted_PCA_out;
     wire	[63:0]      rs_predicted_PCB_out;
     wire		    exB_cond_branch_out;
     wire		    exB_uncond_branch_out;
     assign         ex_alu_almostfull  =  1'b0;
     assign         ex_mulq_almostfull = 1'b0;
     assign         ex_mulq_full       = 1'b0;
     assign         ex_ld_full         = 1'b0;
     assign         ex_ld_almostfull   = 1'b0;
     assign         ex_sv_full         = 1'b0;
     assign         ex_sv_almostfull   = 1'b0;
     assign         take_branchA       = 1'b0;
     assign         take_branchB       = 1'b0;
//     assign         branch_target_PCA  = 63'd0;
//     assign         branch_target_PCB  = 63'd0;
//     assign         access_memory      = 1'b0;
     assign	        ex_stall_rs_out    = 1'b0;

     //assign         mem2proc_valid=1'b1;
     //assign         proc2Dmem_command=`BUS_NONE; //for the lack of a mem_stage :(

     assign pipeline_commit_wr_idxA = exA_mt_idx_out;
     assign pipeline_commit_wr_idxB = exB_mt_idx_out;
     assign pipeline_commit_wr_idxC = exC_mt_idx_out;
     assign pipeline_commit_wr_idxD = exD_mt_idx_out;
     assign pipeline_commit_wr_dataA = exA_take_branch_out ? exA_NPC_out : exA_result_out;
     assign pipeline_commit_wr_dataB = exB_take_branch_out ? exB_NPC_out : exB_result_out;
     assign pipeline_commit_wr_dataC = exC_mult_result_out;
     assign pipeline_commit_wr_dataD = exD_mult_result_out;
     assign pipeline_commit_wr_enA = exA_en_out;
     assign pipeline_commit_wr_enB = exB_en_out;
     assign pipeline_commit_wr_enC = exC_mult_valid_out;
     assign pipeline_commit_wr_enD = exD_mult_valid_out;
     assign pipeline_completed_instA = {3'b0, exA_en_out}; //no idea why the 3'b0 is needed; it probably isn't w/e
     assign pipeline_completed_instB = {3'b0, exB_en_out};
     assign pipeline_completed_instC = {3'b0, exC_mult_valid_out};
     assign pipeline_completed_instD = {3'b0, exD_mult_valid_out};


     //probably illegalness needs to passed further along (i.e. ex_cm_illegal_out)
     assign pipeline_error_status = 
     ( exA_illegal_out | exB_illegal_out) ? `HALTED_ON_ILLEGAL
                     : (exA_halt_out | exB_halt_out) ? `HALTED_ON_HALT : `NO_ERROR;

     wire [63:0] Icache2proc_addr_outB;



	cache cache_0(
	    .clock(clock),
            .reset(reset),

            .proc2Icache_addr(proc2Icache_addr),
            .proc2Icache_request(proc2Icache_request),

            .prefetch2Icache_addr(prefetch2Icache_addr),
            .prefetch2Icache_request(prefetch2Icache_request),

            .proc2Dcache_load_addr(proc2Dcache_load_addr),
            .proc2Dcache_LQ_idx(proc2Dcache_LQ_idx),
            .proc2Dcache_load_request(proc2Dcache_load_request),

            .proc2Dcache_store_addr(proc2Dcache_store_addr),
            .proc2Dcache_store_data(proc2Dcache_store_data),
            .proc2Dcache_store_write_en(proc2Dcache_store_write_en),
            .proc2Dcache_SQ_idx(proc2Dcache_SQ_idx),

            .mem2proc_tag(mem2proc_tag),
            .mem2proc_response(mem2proc_response),
            .mem2proc_data(mem2proc_data),

            .branch_recovery(rob_branch_retire_out),
            //output
            .proc2mem_addr(proc2mem_addr),
            .proc2mem_command(proc2mem_command),
            .proc2mem_data(proc2mem_data),

            .Icache2proc_data_outA(Icache2proc_data_outA),  //from Icache
            .Icache2proc_valid_outA(Icache2proc_valid_outA),

            .Icache2proc_grant(Icache2proc_grant),
            .Icache2prefetch_grant(Icache2prefetch_grant),
            .Dcache2proc_load_grant(Dcache2proc_load_grant),
            .Dcache2proc_store_grant(Dcache2proc_store_grant),

            .Icache2proc_data_outB(Icache2proc_data_outB),  //from mem
            .Icache2proc_valid_outB(Icache2proc_valid_outB),

            .Dcache2proc_data_outA(Dcache2proc_data_outA), //from Dcache
            .Dcache2proc_valid_outA(Dcache2proc_valid_outA),
            .Dcache2proc_LQ_idxA(Dcache2proc_LQ_idxA),

            .Dcache2proc_data_outB(Dcache2proc_data_outB),   //connect to Dcache_last_data
            .Dcache2proc_valid_outB(Dcache2proc_valid_outB),  //connect to Dcache_last_data write_en
            .Dcache2proc_LQ_idxB(Dcache2proc_LQ_idxB),  //read from MSHR

            .MSHR_full(MSHR_full),
            .Icache2proc_addr_outB(Icache2proc_addr_outB)
          );

        

           if_id   if_id_0  ( // inputs
                            .clock(clock),
                            .reset(reset),
                            .one_ins_en_in(rob_one_inst_out),
                            .non_ins_en_in(rob_none_inst_out),
                            .rs_almost_full(rs_almostFull_out),
                            .rs_full(rs_busy_out),
                            .Imem2proc_dataA(Icache2proc_data_outA),
                            .Imem2proc_dataB(Icache2proc_data_outB),
                            .branch_target_PCA(rob_target_PCA_out),
                            .branch_target_PCB(rob_target_PCB_out),
                            .ex_PCA(rob_PCA_out),
                            .ex_PCB(rob_PCB_out),
                            .ex_take_branchA(rob_take_branchA_out),
                            .ex_take_branchB(rob_take_branchB_out),                            
                            .need_take_branchA(rob_branch_still_takenA_out), //need to change to ROB.
                            .need_take_branchB(rob_branch_still_takenB_out),
                            .mispredict_branchA(rob_branch_mistakenA_out),
                            .mispredict_branchB(rob_branch_mistakenB_out),
                            .rob_recover(rob_branch_retire_out),
			    .fetch_grant(Icache2proc_grant),
                            .IR_validA(Icache2proc_valid_outA),
                            .IR_validB(Icache2proc_valid_outB),
			    .Icache2prefetch_grant(Icache2prefetch_grant),
                            .lq_full(lq_full_out),
                            .lq_almost_full(lq_almost_full_out),
                            .sq_full(sq_full_out),
                            .sq_almost_full(sq_almost_full_out),  
                            .load_request(proc2Dcache_load_request),
                            .store_request(rob_stq_retire_en_out),
                            .Icache2proc_addr_outB(Icache2proc_addr_outB),
			    .rob_retire_enA(rob_retireA_out),
		 	    .rob_retire_enB(rob_retireB_out),

                            // outputs

                            .prefetch2Icache_request(prefetch2Icache_request),
                            .prefetch2Icache_addr(prefetch2Icache_addr),

                            .proc2Imem_addr(proc2Icache_addr),
			    .fetch_request(proc2Icache_request),

                             
                            .id_opa_select_outA_reg(id_opa_select_outA),
                            .id_opb_select_outA_reg(id_opb_select_outA),
                            .id_opa_select_outB_reg(id_opa_select_outB),
                            .id_opb_select_outB_reg(id_opb_select_outB),

                            .id_rdaAidx_reg(id_rdaAidx),
                            .id_rdbAidx_reg(id_rdbAidx),
                            .id_rdaBidx_reg(id_rdaBidx),
                            .id_rdbBidx_reg(id_rdbBidx),

                            .id_dest_reg_idx_outA_reg(id_dest_reg_idx_outA),   // ????????there is no destination for this signal
                            .id_dest_reg_idx_outB_reg(id_dest_reg_idx_outB),
                            .id_alu_func_outA_reg(id_alu_func_outA),
                            .id_alu_func_outB_reg(id_alu_func_outB),
                            .id_IRA_out_reg(id_IRA_out),
                            .id_IRB_out_reg(id_IRB_out),
                            .id_PCA_out_reg(id_PCA_out),
                            .id_NPCA_out_reg(id_NPCA_out),
                            .id_PCB_out_reg(id_PCB_out),
                            .id_NPCB_out_reg(id_NPCB_out),

                            .id_IRA_valid_out_reg(id_IRA_valid_out),
                            .id_IRB_valid_out_reg(id_IRB_valid_out),
                            .id_illegal_outA_reg(id_illegal_outA),
                            .id_illegal_outB_reg(id_illegal_outB),
                            .id_halt_outA_reg(id_halt_outA),
                            .id_halt_outB_reg(id_halt_outB),
                            .id_rd_mem_outA_reg(id_rd_mem_outA),
                            .id_wr_mem_outA_reg(id_wr_mem_outA),
                            .id_cond_branch_outA_reg(id_cond_branch_outA),
                            .id_uncond_branch_outA_reg(id_uncond_branch_outA),
                            .id_rd_mem_outB_reg(id_rd_mem_outB),
                            .id_wr_mem_outB_reg(id_wr_mem_outB),
                            .id_cond_branch_outB_reg(id_cond_branch_outB),
                            .id_uncond_branch_outB_reg(id_uncond_branch_outB),
			    .id_branch_predictionA_reg(branch_predictionA),
			    .id_branch_predictionB_reg(branch_predictionB),
			    .id_predicted_PCA_reg(predicted_PCA),
			    .id_predicted_PCB_reg(predicted_PCB)
                            );


      rob_connect rob_connect_0 ( // inputs
                                 .clock(clock),
                                 .reset(reset),
                                 .id_valid_instA(id_IRA_valid_out),
                                 .id_valid_instB(id_IRB_valid_out),
                                 .id_destAidx(id_dest_reg_idx_outA),
                                 .id_destBidx(id_dest_reg_idx_outB),
                                 .id_rdaAidx(id_rdaAidx),
                                 .id_rdbAidx(id_rdbAidx),
                                 .id_rdaBidx(id_rdaBidx),
                                 .id_rdbBidx(id_rdbBidx),
                                 .id_IRA(id_IRA_out),
                                 .id_IRB(id_IRB_out),
                                 .id_opcodeA(id_alu_func_outA),
                                 .id_opcodeB(id_alu_func_outB),
                                 .id_PCA(id_PCA_out),
                                 .id_PCB(id_PCB_out),
                                 .id_uncond_branchA(id_uncond_branch_outA),
                                 .id_cond_branchA(id_cond_branch_outA),
                                 .id_uncond_branchB(id_uncond_branch_outB),
                                 .id_cond_branchB(id_cond_branch_outB),
                                 .ex_set_mispredictA(exA_mispredicted_out),//mixed
                                 .ex_set_mispredictB(exB_mispredicted_out),//mixed
                                 .ex_cm_cdbA_rdy(exA_en_out),
                                 .ex_cm_cdbB_rdy(exB_en_out),
                                 .ex_cm_cdbC_rdy(exC_mult_valid_out),
                                 .ex_cm_cdbD_rdy(exD_mult_valid_out),
                                 .ex_cm_robAIdx(exA_rob_idx_out),
                                 .ex_cm_robBIdx(exB_rob_idx_out),
                                 .ex_cm_robCIdx(exC_rob_idx_out),
                                 .ex_cm_robDIdx(exD_rob_idx_out),
                                 //finish implementing l8r
                                 .exA_branch_mistaken(exA_branch_mistaken_out),
                                 .exA_branch_still_taken(exA_branch_still_taken_out),
				 .exA_if_predicted_taken(exA_if_predicted_taken_out),//needed by Lily (TODO)
				 .exA_result(exA_result_out),
				 .exA_take_branch(exA_take_branch_out),
                                 .id_wr_memA(id_wr_mem_outA),
                                 .id_wr_memB(id_wr_mem_outB),

                                 .exB_branch_mistaken(exB_branch_mistaken_out),
                                 .exB_branch_still_taken(exB_branch_still_taken_out),
				 .exB_if_predicted_taken(exB_if_predicted_taken_out),//needed by Lily (TODO)
				 .exB_result(exB_result_out),
				 .exB_take_branch(exB_take_branch_out),

                                 .CDBvalueA(exA_pr_idx_out),
                                 .CDBvalueB(exB_pr_idx_out),
                                 .CDBvalueC(exC_pr_idx_out),
                                 .CDBvalueD(exD_pr_idx_out),
                                 .mt_indexA(exA_mt_idx_out),
                                 .mt_indexB(exB_mt_idx_out),
                                 .mt_indexC(exC_mt_idx_out),
                                 .mt_indexD(exD_mt_idx_out),
                                 .mshr_full(MSHR_full),
                                 .ldq_rob_mem_req(proc2Dcache_load_request),
                                 .stq_idxA(SQ2RS_idxA),
                                 .stq_idxB(SQ2RS_idxB),
                                 .mem_stq_idx(head),
                                 .mem_grant(Dcache2proc_store_grant),
                                  // outputs
                                 .rob_one_inst_out(rob_one_inst_out),
                                 .rob_none_inst_out(rob_none_inst_out),
                                 .rob_instA_en_out(rob_instA_en_out),
                                 .rob_instB_en_out(rob_instB_en_out),
                                 .rob_dispidxA_out(rob_dispidxA_out),
                                 .rob_dispidxB_out(rob_dispidxB_out),
                                 .rob_head(rob_head),
                                 .rob_branch_idxA(rob_branch_idxA),
                                 .rob_branch_idxB(rob_branch_idxB),
                                 .rob_retireIdxA_out(rob_retireIdxA_out),
                                 .rob_branch_retire_out(rob_branch_retire_out),
                                 .rob_rs_halt_en(rob_rs_halt_en),
                                 .fl_TA(fl_TA),
                                 .fl_TB(fl_TB),
                                 .mt_T1A_out(mt_T1A_out),
                                 .mt_T2A_out(mt_T2A_out),
                                 .mt_T1B_out(mt_T1B_out),
                                 .mt_T2B_out(mt_T2B_out),
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
		      	         .rob_if_predicted_takenA_out(rob_if_predicted_takenA_out),
		      	         .rob_if_predicted_takenB_out(rob_if_predicted_takenB_out),
		                 .rob_retireA_out(rob_retireA_out),
		     	 	 .rob_retireB_out(rob_retireB_out),

                                 .rob_stq_retire_en_out(rob_stq_retire_en_out)
                     );

                   rs rs_0   ( //inputs    
                              .clock(clock),
                              .reset(reset),
                              .mt_T1A(mt_T1A_out),
                              .mt_T1B(mt_T1B_out),
                              .mt_T2A(mt_T2A_out),
                              .mt_T2B(mt_T2B_out),
                              .mt_archIdxA(id_dest_reg_idx_outA),
                              .mt_archIdxB(id_dest_reg_idx_outB),
                              .fl_TA(fl_TA),
                              .fl_TB(fl_TB),

                              .ex_cm_cdbAIdx(exA_pr_idx_out),
                              .ex_cm_cdbBIdx(exB_pr_idx_out),
                              .ex_cm_cdbCIdx(exC_pr_idx_out),
                              .ex_cm_cdbDIdx(exD_pr_idx_out),
                              .ex_cm_cdbA_en(exA_en_out),
                              .ex_cm_cdbB_en(exB_en_out),
                              .ex_cm_cdbC_en(exC_mult_valid_out),
                              .ex_cm_cdbD_en(exD_mult_valid_out),

                              .id_alu_funcA(id_alu_func_outA),
                              .id_alu_funcB(id_alu_func_outB),
                              .id_IRA(id_IRA_out),
                              .id_IRB(id_IRB_out),
                              .id_IRA_valid(id_IRA_valid_out),
                              .id_IRB_valid(id_IRB_valid_out),
                              .id_NPCA(id_NPCA_out),
                              .id_NPCB(id_NPCB_out),
                              .id_rd_memA(id_rd_mem_outA),
                              .id_wr_memA(id_wr_mem_outA),
                              .id_rd_memB(id_rd_mem_outB),
                              .id_wr_memB(id_wr_mem_outB),
                              .id_cond_branchA(id_cond_branch_outA),
                              .id_cond_branchB(id_cond_branch_outB),
                              .id_uncond_branchA(id_uncond_branch_outA),
                              .id_uncond_branchB(id_uncond_branch_outB),
                              .if_branch_predictionA(branch_predictionA),
                              .if_branch_predictionB(branch_predictionB),
                              .if_predicted_PCA(predicted_PCA),
                              .if_predicted_PCB(predicted_PCB),
                              .id_haltA(id_halt_outA),
                              .id_haltB(id_halt_outB),
                              .id_illegalA(id_illegal_outA),      
                              .id_illegalB(id_illegal_outB),

                              .rob_idxA(rob_dispidxA_out),
                              .rob_idxB(rob_dispidxB_out),
                              .rob_instA_en(rob_instA_en_out),
                              .rob_instB_en(rob_instB_en_out),
                              .rob_branch_recover(rob_branch_retire_out),
                              .rob_halt(rob_rs_halt_en),
                              .id_op1A_select(id_opa_select_outA),
                              .id_op2A_select(id_opb_select_outA),
                              .id_op1B_select(id_opa_select_outB),
                              .id_op2B_select(id_opb_select_outB),
                              .lq_idxA(ldq_rs_ldqidxA_out),  // need lq/sq wires HERE.                              
                              .lq_idxB(ldq_rs_ldqidxB_out),  // need lq/sq wires HERE.
                              .sq_idxA(SQ2RS_idxA),  // need lq/sq wires HERE.
                              .sq_idxB(SQ2RS_idxB),  // need lq/sq wires HERE.
                              .lq_alu_stall(ldq_ex_cdb_en_out),                              
                             // output

                              .rs_almostFull_out(rs_almostFull_out),
                              .rs_alu_funcA_out(rs_alu_funcA_out),
                              .rs_alu_funcB_out(rs_alu_funcB_out),
                              .rs_busy_out(rs_busy_out), 
                              .rs_IRA_out(rs_IRA_out),
                              .rs_IRB_out(rs_IRB_out),
                              .rs_issueArdy_out(rs_issueArdy_out),
                              .rs_issueBrdy_out(rs_issueBrdy_out),
                              .rs_op1A_select_out(rs_op1A_select_out),
                              .rs_op2A_select_out(rs_op2A_select_out),
                              .rs_op1B_select_out(rs_op1B_select_out),
                              .rs_op2B_select_out(rs_op2B_select_out),
                              .rs_rob_idxA_out(rs_rob_idxA_out),
                              .rs_rob_idxB_out(rs_rob_idxB_out),
                              .rs_archIdxA_out(rs_archIdxA_out),
                              .rs_archIdxB_out(rs_archIdxB_out),
                              .rs_TA_out(rs_TA_out),
                              .rs_TB_out(rs_TB_out),
                              .rs_T1A_out(rs_T1A_out),
                              .rs_T2A_out(rs_T2A_out),
                              .rs_T1B_out(rs_T1B_out),
                              .rs_T2B_out(rs_T2B_out),
                              .rs_npcA_out(rs_npcA_out),
                              .rs_npcB_out(rs_npcB_out),
                              .rs_rd_memA_out(rs_rd_memA_out),
                              .rs_rd_memB_out(rs_rd_memB_out),
                              .rs_wr_memA_out(rs_wr_memA_out),
                              .rs_wr_memB_out(rs_wr_memB_out),
                              .rs_cond_branchA_out(rs_cond_branchA_out),
                              .rs_cond_branchB_out(rs_cond_branchB_out),
                              .rs_uncond_branchA_out(rs_uncond_branchA_out),
                              .rs_uncond_branchB_out(rs_uncond_branchB_out),
                              .rs_haltA_out(rs_haltA_out),
                              .rs_haltB_out(rs_haltB_out),
                              .rs_illegalA_out(rs_illegalA_out),
                              .rs_illegalB_out(rs_illegalB_out),
                              .rs_branch_predictionA_out(rs_branch_predictionA_out),
                              .rs_branch_predictionB_out(rs_branch_predictionB_out),                              
          	 	      .rs_predicted_PCA_out(rs_predicted_PCA_out),
          		      .rs_predicted_PCB_out(rs_predicted_PCB_out),
                              .rs_lq_idxA_out(rs_lq_idxA_out),
                              .rs_lq_idxB_out(rs_lq_idxB_out),
                              .rs_sq_idxA_out(rs_sq_idxA_out),
                              .rs_sq_idxB_out(rs_sq_idxB_out)
                             );


                  pr pr_0   ( // inputs      
                             .wr_clk(clock),
                             .reset(reset),
                             .rs_T1A(rs_T1A_out),
                             .rs_T1B(rs_T1B_out),
                             .rs_T2A(rs_T2A_out),
                             .rs_T2B(rs_T2B_out),
                             .ex_cm_cdbAIdx(exA_pr_idx_out),
                             .ex_cm_cdbBIdx(exB_pr_idx_out),
                             .ex_cm_cdbCIdx(exC_pr_idx_out),
                             .ex_cm_cdbDIdx(exD_pr_idx_out),
                             .ex_cm_resultA(exA_result_out),
                             .ex_cm_resultB(exB_result_out),
                             .ex_cm_resultC(exC_mult_result_out),
                             .ex_cm_resultD(exD_mult_result_out),
                             .exA_NPC_out(exA_NPC_out),
                             .exB_NPC_out(exB_NPC_out),
                             .exA_cond_branch_out(exA_cond_branch_out),
                             .exB_cond_branch_out(exB_cond_branch_out),
                             .exA_uncond_branch_out(exA_uncond_branch_out),
                             .exB_uncond_branch_out(exB_uncond_branch_out),                             
                             .wr_cdbAIdx_en(exA_en_out),
                             .wr_cdbBIdx_en(exB_en_out),
                             .wr_cdbCIdx_en(exC_mult_valid_out),
                             .wr_cdbDIdx_en(exD_mult_valid_out),
                             // outoputs
                             .pr_T1A_out(pr_T1A_out),
                             .pr_T2A_out(pr_T2A_out),
                             .pr_T1B_out(pr_T1B_out),     
                             .pr_T2B_out(pr_T2B_out)
                            );

                ldq ldq_0 (  // inputs
                            .clock(clock),
                            .reset(reset),
 	                    .id_valid_instA(id_IRA_valid_out),
	                    .id_valid_instB(id_IRB_valid_out),
	                    .id_rd_memA(id_rd_mem_outA),
	                    .id_rd_memB(id_rd_mem_outB),
	                    .id_wr_memA(id_wr_mem_outA),

	                    .ex_rd_memA_en(exA_rd_mem_out),
	                    .ex_rd_memB_en(exB_rd_mem_out),
	                    .ex_cdbA_rdy(exA_lq_data_rdy_out),
	                    .ex_cdbB_rdy(exB_lq_data_rdy_out),
	                    .ex_rd_addrA(exA_lsq_addr_out),
	                    .ex_rd_addrB(exB_lsq_addr_out),
	                    .ex_ldq_idxA(exA_lq_idx_out),
	                    .ex_ldq_idxB(exB_lq_idx_out),
                  
	                    .ex_ldq_prA_idx(exA_lq_pr_idx_out),
	                    .ex_ldq_mtA_idx(exA_lq_mt_idx_out),
                            .ex_ldq_robA_idx(exA_lq_rob_idx_out),
	                    .ex_ldq_haltA(exA_lsq_halt_out),
	                    .ex_ldq_illegalA(exA_lsq_illegal_out),
                            .ex_ldq_NPCA(exA_lsq_NPC_out),  

 	                    .ex_ldq_prB_idx(exB_lq_pr_idx_out),
 	                    .ex_ldq_mtB_idx(exB_lq_mt_idx_out),
                            .ex_ldq_robB_idx(exB_lq_rob_idx_out),
 	                    .ex_ldq_haltB(exB_lsq_halt_out),
 	                    .ex_ldq_illegalB(exB_lsq_illegal_out),
                            .ex_ldq_NPCB(exB_lsq_NPC_out),

	                    .stq_current_tail(next_tail),
	                    .stq_tail_minus_one(tail),
	                    .rob_recovery_en(rob_branch_retire_out),
	                    .stq_valid_graph(next_busy),
                            .stq_valid_graph_old(busy),
	                    .stq_head(head),
                            .rob_stq_retire_en(rob_stq_retire_en_out),                            

	                    .mshr_full(MSHR_full),
	                    .mem_back_validA(Dcache2proc_valid_outA),
	                    .mem_ldq_idxA(Dcache2proc_LQ_idxA),
	                    .mem_back_dataA(Dcache2proc_data_outA),
	                    .mem_back_validB(Dcache2proc_valid_outB),
	                    .mem_ldq_idxB(Dcache2proc_LQ_idxB),
	                    .mem_back_dataB(Dcache2proc_data_outB),
                            .mem_grantB(Dcache2proc_load_grant),
                            .stq_retiring(stq_retiring_out),
                  	    // outputs
	                    .ldq_rs_stall_out(ldq_rs_stall_out),
	                    .ldq_rs_ldqidxA_out(ldq_rs_ldqidxA_out),
	                    .ldq_rs_ldqidxB_out(ldq_rs_ldqidxB_out),
	                    .ldq_almostfull_out(lq_almost_full_out),
	                    .ldq_full_out(lq_full_out),
	                    .ldq_mem_addr_out(proc2Dcache_load_addr),
	                    .ldq_mem_req_out(proc2Dcache_load_request),
	                    .ldq_mem_idx_out(proc2Dcache_LQ_idx),
	                    .ldq_ex_cdb_en_out(ldq_ex_cdb_en_out),
	                    .ldq_ex_data_out(ldq_ex_data_out),
	                    .ldq_ex_robidx_out(ldq_ex_robidx_out),
	                    .ldq_ex_pridx_out(ldq_ex_pridx_out),
	                    .ldq_ex_mtidx_out(ldq_ex_mtidx_out),
	                    .ldq_ex_illegal_out(ldq_ex_illegal_out),
	                    .ldq_ex_halt_out(ldq_ex_halt_out),
                            .ldq_ex_NPC(ldq_ex_NPC_out)
	                   );

                stq  stq_0 ( // inputs
			        .clock(clock),
			        .reset(reset),
			        .id_wr_mem_enA(id_wr_mem_outA),
			        .id_wr_mem_enB(id_wr_mem_outB),
			        .id_valid_IRA(id_IRA_valid_out),
			        .id_valid_IRB(id_IRB_valid_out),

			        .ALU_SQ_idxA(exA_sq_idx_out),
			        .ALU_SQ_idxB(exB_sq_idx_out),
			        .ALU_store_dataA(exA_lsq_data_out),                            
			        .ALU_store_dataB(exB_lsq_data_out),
			        .ALU_store_addrA(exA_lsq_addr_out),
			        .ALU_store_addrB(exB_lsq_addr_out),
			        .ALU_wr_mem_enA(exA_wr_mem_out),
			        .ALU_wr_mem_enB(exB_wr_mem_out),
			        .ex_cdbA_rdy(exA_sq_data_rdy_out),
			        .ex_cdbB_rdy(exB_sq_data_rdy_out),
			        .ROB2SQ_retire_en(rob_stq_retire_en_out),
			        .branch_recovery(rob_branch_retire_out),
                                
                                .store_grant(Dcache2proc_store_grant),
                                .mshr_full(MSHR_full),
			        // outputs
			        .store_request(proc2Dcache_store_write_en),
			        .store_retire_addr(proc2Dcache_store_addr),
			        .store_retire_data(proc2Dcache_store_data),

			        .SQ2RS_idxA(SQ2RS_idxA),
			        .SQ2RS_idxB(SQ2RS_idxB),
			        .tail(tail),
			        .next_tail(next_tail),
			        .SQ_full(sq_full_out),
			        .SQ_almost_full(sq_almost_full_out),
			        .next_busy(next_busy),
                                .busy(busy),
			        .head(head),
                                .stq_retiring_out(stq_retiring_out)
				);
       


	ex_pipeline ex_pipeline_0 ( //inputs
	    .clock(clock),
	    .reset(reset),
	    .rs_en_in_1(rs_issueArdy_out),
	    .rs_IR_1(rs_IRA_out),
	    .rs_NPC_1(rs_npcA_out),
	    .rs_predicted_PC_1(rs_predicted_PCA_out),
	    .rs_rega_1(pr_T1A_out),
	    .rs_regb_1(pr_T2A_out),
	    .rs_opa_select_1(rs_op1A_select_out),
  	    .rs_opb_select_1(rs_op2A_select_out),
  	    .rs_alu_func_1(rs_alu_funcA_out),
   	    .rs_cond_branch_1(rs_cond_branchA_out),
   	    .rs_uncond_branch_1(rs_uncond_branchA_out),
    	    .rs_pr_idx_1(rs_TA_out),
    	    .rs_mt_idx_1(rs_archIdxA_out),
    	    .rs_rob_idx_1(rs_rob_idxA_out),
    	    .rs_rd_mem_1(rs_rd_memA_out),
    	    .rs_wr_mem_1(rs_wr_memA_out), 
    	    .rs_halt_1(rs_haltA_out),
   	    .rs_illegal_1(rs_illegalA_out),
	    .rs_lq_idx_1(rs_lq_idxA_out),
	    .rs_sq_idx_1(rs_sq_idxA_out),
   	    .rs_branch_predict_taken_1(rs_branch_predictionA_out),

   	    .rs_en_in_2(rs_issueBrdy_out),
   	    .rs_IR_2(rs_IRB_out),
    	    .rs_NPC_2(rs_npcB_out),
    	    .rs_predicted_PC_2(rs_predicted_PCB_out),
   	    .rs_rega_2(pr_T1B_out),
   	    .rs_regb_2(pr_T2B_out),
    	    .rs_opa_select_2(rs_op1B_select_out),
   	    .rs_opb_select_2(rs_op2B_select_out),
    	    .rs_alu_func_2(rs_alu_funcB_out),
   	    .rs_cond_branch_2(rs_cond_branchB_out),
   	    .rs_uncond_branch_2(rs_uncond_branchB_out),
   	    .rs_pr_idx_2(rs_TB_out),
   	    .rs_mt_idx_2(rs_archIdxB_out),
   	    .rs_rob_idx_2(rs_rob_idxB_out),
    	    .rs_rd_mem_2(rs_rd_memB_out),
   	    .rs_wr_mem_2(rs_wr_memB_out), 
   	    .rs_halt_2(rs_haltB_out),
   	    .rs_illegal_2(rs_illegalB_out),
	    .rs_lq_idx_2(rs_lq_idxB_out),
	    .rs_sq_idx_2(rs_sq_idxB_out),
   	    .rs_branch_predict_taken_2(rs_branch_predictionB_out),

   	    .rob_recovery(rob_branch_retire_out),
	    .ldq_en(ldq_ex_cdb_en_out),
	    .ldq_data(ldq_ex_data_out),
	    .ldq_pr_idx(ldq_ex_pridx_out),
	    .ldq_mt_idx(ldq_ex_mtidx_out),
	    .ldq_rob_idx(ldq_ex_robidx_out),
            .ldq_NPC(ldq_ex_NPC_out),
	    .ldq_illegal(ldq_ex_illegal_out),
	    .ldq_halt(ldq_ex_halt_out),
	     // outputs
	    .exA_en_out(exA_en_out),
	    .exA_result_out(exA_result_out),
	    .exA_pr_idx_out(exA_pr_idx_out),
	    .exA_mt_idx_out(exA_mt_idx_out),
	    .exA_rob_idx_out(exA_rob_idx_out),

	    .exA_take_branch_out(exA_take_branch_out),//pass needed by Lily
	    .exA_branch_mistaken_out(exA_branch_mistaken_out),//pass needed by Lily
	    .exA_branch_still_taken_out(exA_branch_still_taken_out),//pass needed by Lily
	    .exA_mispredicted_out(exA_mispredicted_out),//mixed signal(or needed by yuga)
	    .exA_if_predicted_taken_out(exA_if_predicted_taken_out),//pass needed by Lily
            .exA_predicted_PC_out(exA_predicted_PC_out),

	    .exA_cond_branch_out(exA_cond_branch_out),
	    .exA_uncond_branch_out(exA_uncond_branch_out),

	    .exA_halt_out(exA_halt_out),
	    .exA_illegal_out(exA_illegal_out),
	    .exA_NPC_out(exA_NPC_out),

	    .exA_wr_mem_out(exA_wr_mem_out),
	    .exA_rd_mem_out(exA_rd_mem_out),
	    .exA_lq_idx_out(exA_lq_idx_out),
	    .exA_lq_pr_idx_out(exA_lq_pr_idx_out),
	    .exA_lq_mt_idx_out(exA_lq_mt_idx_out),
	    .exA_lq_rob_idx_out(exA_lq_rob_idx_out),
	    .exA_lq_data_rdy_out(exA_lq_data_rdy_out),
	    .exA_sq_data_rdy_out(exA_sq_data_rdy_out),
	    .exA_sq_idx_out(exA_sq_idx_out),
	    .exA_lsq_NPC_out(exA_lsq_NPC_out),
	    .exA_lsq_data_out(exA_lsq_data_out),
	    .exA_lsq_addr_out(exA_lsq_addr_out),
	    .exA_lsq_halt_out(exA_lsq_halt_out),
	    .exA_lsq_illegal_out(exA_lsq_illegal_out),

	    .exB_en_out(exB_en_out),
	    .exB_result_out(exB_result_out),
	    .exB_pr_idx_out(exB_pr_idx_out),
	    .exB_mt_idx_out(exB_mt_idx_out),
	    .exB_rob_idx_out(exB_rob_idx_out),

	    .exB_take_branch_out(exB_take_branch_out),//pass needed by Lily
	    .exB_branch_mistaken_out(exB_branch_mistaken_out),//pass needed by Lily
	    .exB_branch_still_taken_out(exB_branch_still_taken_out),//pass needed by Lily
	    .exB_mispredicted_out(exB_mispredicted_out),//mixed signal(or needed by yuga)
	    .exB_if_predicted_taken_out(exB_if_predicted_taken_out),//pass needed by Lily
            .exB_predicted_PC_out(exB_predicted_PC_out),
	    .exB_cond_branch_out(exB_cond_branch_out),
	    .exB_uncond_branch_out(exB_uncond_branch_out),
	
	    .exB_NPC_out(exB_NPC_out),
	    .exB_halt_out(exB_halt_out),
	    .exB_illegal_out(exB_illegal_out),

	    .exB_wr_mem_out(exB_wr_mem_out),
	    .exB_rd_mem_out(exB_rd_mem_out),
	    .exB_lq_idx_out(exB_lq_idx_out),
	    .exB_lq_pr_idx_out(exB_lq_pr_idx_out),
	    .exB_lq_mt_idx_out(exB_lq_mt_idx_out),
	    .exB_lq_rob_idx_out(exB_lq_rob_idx_out),
	    .exB_lq_data_rdy_out(exB_lq_data_rdy_out),
	    .exB_sq_data_rdy_out(exB_sq_data_rdy_out),
	    .exB_sq_idx_out(exB_sq_idx_out),
	    .exB_lsq_NPC_out(exB_lsq_NPC_out),
	    .exB_lsq_data_out(exB_lsq_data_out),
	    .exB_lsq_addr_out(exB_lsq_addr_out),
	    .exB_lsq_halt_out(exB_lsq_halt_out),
	    .exB_lsq_illegal_out(exB_lsq_illegal_out),
	
	    .exC_mult_valid_out(exC_mult_valid_out),
	    .exC_mult_result_out(exC_mult_result_out),
	    .exC_pr_idx_out(exC_pr_idx_out),
	    .exC_mt_idx_out(exC_mt_idx_out),
	    .exC_rob_idx_out(exC_rob_idx_out),
	    .exC_NPC_out(exC_NPC_out),
//	    .exC_mult_valid_out_early(exC_mult_valid_out_early),
//	    .exC_mult_result_out_early(exC_mult_result_out_early),
//	    .exC_pr_idx_early(exC_pr_idx_early),
//	    .exC_mt_idx_early(exC_mt_idx_early),
//	    .exC_rob_idx_early(exC_rob_idx_early),
//	    .exC_NPC_early(exC_NPC_early),
	
	    .exD_mult_valid_out(exD_mult_valid_out),
	    .exD_mult_result_out(exD_mult_result_out),
	    .exD_pr_idx_out(exD_pr_idx_out),
	    .exD_mt_idx_out(exD_mt_idx_out),
	    .exD_rob_idx_out(exD_rob_idx_out),
	    .exD_NPC_out(exD_NPC_out)//,
//	    .exD_mult_valid_out_early(exD_mult_valid_out_early),
//	    .exD_mult_result_out_early(exD_mult_result_out_early),
//	    .exD_pr_idx_early(exD_pr_idx_early),
//	    .exD_mt_idx_early(exD_mt_idx_early),
//	    .exD_rob_idx_early(exD_rob_idx_early),
//	    .exD_NPC_early(exD_NPC_early)
	  );

  endmodule
  








