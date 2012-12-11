/////////////////////////////////////////////////////////////////////////
//                                                                     //
//                                                                     //
//   Modulename :  visual_testbench.v                                  //
//                                                                     //
//  Description :  Testbench module for the verisimple pipeline        //
//                   for the visual debugger                           //
//                                                                     //
/////////////////////////////////////////////////////////////////////////

// `timescale 1ns/100ps

extern void initcurses(int,int,int,int,int,int,int,int,int,int);
extern void flushpipe();
extern void waitforresponse();
extern void initmem();
extern int get_instr_at_pc(int);
extern int not_valid_pc(int);

module testbench();

  // Registers and wires used in the testbench
  reg        clock;
  reg        reset;
  reg [31:0] clock_count;
  reg [31:0] instr_count;

// external input for memory
wire    [1:0]    proc2mem_command;
wire   [63:0]    proc2mem_data;  
wire   [63:0]    proc2mem_addr;
// output signal for memory     
wire    [3:0]   mem2proc_response;
wire   [63:0]   mem2proc_data;
wire    [3:0]   mem2proc_tag;
wire    [3:0]   pipeline_error_status;
wire    [63:0]  pipeline_commit_wr_dataA;
wire    [63:0]  pipeline_commit_wr_dataB;
wire    [63:0]  pipeline_commit_wr_dataC;
wire    [63:0]  pipeline_commit_wr_dataD;
wire    [5:0]   pipeline_commit_wr_idxA;
wire    [5:0]   pipeline_commit_wr_idxB;
wire    [5:0]   pipeline_commit_wr_idxC;
wire    [5:0]   pipeline_commit_wr_idxD;
wire            pipeline_commit_wr_enA;
wire            pipeline_commit_wr_enB;
wire            pipeline_commit_wr_enC;
wire            pipeline_commit_wr_enD;
wire    [3:0]   pipeline_completed_instA;
wire    [3:0]   pipeline_completed_instB;
wire    [3:0]   pipeline_completed_instC;
wire    [3:0]   pipeline_completed_instD;

  integer i;

  // Instantiate the Pipeline
pipeline pipeline_0 ( // inputs
                .clock(clock),
                .reset(reset),
                .mem2proc_data(mem2proc_data),
                .mem2proc_tag(mem2proc_tag),
                .mem2proc_response(mem2proc_response),
                 // outputs
                .proc2mem_addr(proc2mem_addr),
                .proc2mem_command(proc2mem_command),
                .proc2mem_data(proc2mem_data),
                .pipeline_error_status(pipeline_error_status),
                .pipeline_commit_wr_dataA(pipeline_commit_wr_dataA),
                .pipeline_commit_wr_dataB(pipeline_commit_wr_dataB),
                .pipeline_commit_wr_dataC(pipeline_commit_wr_dataC),
                .pipeline_commit_wr_dataD(pipeline_commit_wr_dataD),
                .pipeline_commit_wr_idxA(pipeline_commit_wr_idxA),
                .pipeline_commit_wr_idxB(pipeline_commit_wr_idxB),
                .pipeline_commit_wr_idxC(pipeline_commit_wr_idxC),
                .pipeline_commit_wr_idxD(pipeline_commit_wr_idxD),
                .pipeline_commit_wr_enA(pipeline_commit_wr_enA),
                .pipeline_commit_wr_enB(pipeline_commit_wr_enB),
                .pipeline_commit_wr_enC(pipeline_commit_wr_enC),
                .pipeline_commit_wr_enD(pipeline_commit_wr_enD),
                .pipeline_completed_instA(pipeline_completed_instA),
                .pipeline_completed_instB(pipeline_completed_instB),
                .pipeline_completed_instC(pipeline_completed_instC),
                .pipeline_completed_instD(pipeline_completed_instD)
                );

  // Instantiate the Data Memory
  mem memory (// Inputs
            .clk               (clock),
            .proc2mem_command  (proc2mem_command),
            .proc2mem_addr     (proc2mem_addr),
            .proc2mem_data     (proc2mem_data),

             // Outputs

            .mem2proc_response (mem2proc_response),
            .mem2proc_data     (mem2proc_data),
            .mem2proc_tag      (mem2proc_tag)
           );

  // Generate System Clock
  always
  begin
    #(`VERILOG_CLOCK_PERIOD/2.0);
    clock = ~clock;
  end

  // Count the number of posedges and number of instructions completed
  // till simulation ends
  always @(posedge clock)
  begin
    if(reset)
    begin
      clock_count <= `SD 0;
      instr_count <= `SD 0;
    end
    else
    begin
      clock_count <= `SD (clock_count + 1);
      instr_count <= `SD (instr_count + pipeline_completed_instA
       + pipeline_completed_instB
       + pipeline_completed_instC
       + pipeline_completed_instD);
    end
  end  

  initial
  begin
    clock = 0;
    reset = 0;

    // Call to initialize visual debugger
    // *Note that after this, all stdout output goes to visual debugger*
    // each argument is number of registers/signals for the group
    // (IF/ID, PR, RS, EX_PIPE, ROB_CONNECT, LQ/SQ, MEM, I/DCache, $controller, ex-LSQ ???)
    initcurses(37,4,44,56,31,26,5,4,38,22);

    // Pulse the reset signal
    reset = 1'b1;
    @(posedge clock);
    @(posedge clock);

    // Read program contents into memory array
    $readmemh("program.mem", memory.unified_memory);

    @(posedge clock);
    @(posedge clock);
    `SD;
    // This reset is at an odd time to avoid the pos & neg clock edges
    reset = 1'b0;
  end

  always @(negedge clock)
  begin
    if(!reset)
    begin
      `SD;
      `SD;

      // deal with any halting conditions
      if(pipeline_error_status!=`NO_ERROR)
      begin
        #100
        $display("\nDONE\n");
        waitforresponse();
        flushpipe();
        $finish;
      end

    end
  end 

  // This block is where we dump all of the signals that we care about to
  // the visual debugger.  Notice this happens at *every* clock edge.
  always @(clock) begin
    #2;

    // Dump clock and time onto stdout
    $display("c%h%7.0d",clock,clock_count);
    $display("t%8.0f",$time);
    $display("z%h",reset);

    // dump ARF contents
    $write("a");
    for(i = 0; i < 'd64; i=i+1)
    begin
      $write("%020d", pipeline_0.pr_0.registers[i]);
    end
    $display("");

    // dump IR information so we can see which instruction
    // is in each stage
    // $write("p");
    // $write("%h%h%h%h%h%h%h%h%h%h ",
    //         pipeline_0.if_IR_out, pipeline_0.if_valid_inst_out,
    //         pipeline_0.if_id_IR,  pipeline_0.if_id_valid_inst,
    //         pipeline_0.id_ex_IR,  pipeline_0.id_ex_valid_inst,
    //         pipeline_0.ex_mem_IR, pipeline_0.ex_mem_valid_inst,
    //         pipeline_0.mem_wb_IR, pipeline_0.mem_wb_valid_inst);
    // $display("");
    
    // Dump interesting register/signal contents onto stdout
    // format is "<reg group prefix><name> <width in hex chars>:<data>"
    // Current register groups (and prefixes) are:
    // f: IF   d: ID   e: EX   m: MEM    w: WB  v: misc. reg
    // g: IF/ID   h: ID/EX  i: EX/MEM  j: MEM/WB

    // f: IF/ID
    // g: PR
    // d: RS
    // h: EX_PIPELINE

    // IF/ID signals (37) - prefix 'f'
    $display("fproc2Imem_addr 16:%h", pipeline_0.proc2Imem_addr);
    $display("fopa_selectA 1:%h", pipeline_0.id_opa_select_outA);
    $display("fopb_selectA 1:%h", pipeline_0.id_opb_select_outA);
    $display("fopa_selectB 1:%h", pipeline_0.id_opa_select_outB);
    $display("fopb_selectB 1:%h", pipeline_0.id_opb_select_outB);
    $display("fread1Aidx 2:%02d", pipeline_0.id_rdaAidx);
    $display("fread2Aidx 2:%02d", pipeline_0.id_rdbAidx);
    $display("fread1Bidx 2:%02d", pipeline_0.id_rdaBidx);
    $display("fread2Bidx 2:%02d", pipeline_0.id_rdbBidx);
    $display("fdest_regA 2:%02d", pipeline_0.id_dest_reg_idx_outA);
    $display("fdest_regB 2:%02d", pipeline_0.id_dest_reg_idx_outB);
    $display("falu_funcA 2:%h", pipeline_0.id_alu_func_outA);
    $display("falu_funcB 2:%h", pipeline_0.id_alu_func_outB);
    $display("fIRA 8:%h", pipeline_0.id_IRA_out);
    $display("fIRB 8:%h", pipeline_0.id_IRB_out);
    $display("fPCA 16:%h", pipeline_0.id_PCA_out);
    $display("fNPCA 16:%h", pipeline_0.id_NPCA_out);
    $display("fPCB 16:%h", pipeline_0.id_PCB_out);
    $display("fNPCB 16:%h", pipeline_0.id_NPCB_out);
    $display("fIRA_valid 1:%h", pipeline_0.id_IRA_valid_out);
    $display("fIRB_valid 1:%h", pipeline_0.id_IRB_valid_out);
    $display("fillegalA 1:%h", pipeline_0.id_illegal_outA);
    $display("fillegalB 1:%h", pipeline_0.id_illegal_outB);
    $display("fhaltA 1:%h", pipeline_0.id_halt_outA);
    $display("fhaltB 1:%h", pipeline_0.id_halt_outB);
    $display("frd_memA? 1:%h", pipeline_0.id_rd_mem_outA);
    $display("fwr_memA? 1:%h", pipeline_0.id_wr_mem_outA);
    $display("fcond_brA? 1:%h", pipeline_0.id_cond_branch_outA);
    $display("funcond_brA? 1:%h", pipeline_0.id_uncond_branch_outA);
    $display("frd_memB? 1:%h", pipeline_0.id_rd_mem_outB);
    $display("fwr_memB? 1:%h", pipeline_0.id_wr_mem_outB);
    $display("fcond_brB? 1:%h", pipeline_0.id_cond_branch_outB);
    $display("funcond_brB? 1:%h", pipeline_0.id_uncond_branch_outB);
    $display("fbranch_predictionA 1:%h", pipeline_0.branch_predictionA);
    $display("fbranch_predictionB 1:%h", pipeline_0.branch_predictionB);
    $display("fpredicted_PCA 16:%h", pipeline_0.predicted_PCA);
    $display("fpredicted_PCB 16:%h", pipeline_0.predicted_PCB);

    // PR output signals (4) - prefix 'g'
    $display("gsrcvalT1A 20:%020d", pipeline_0.pr_T1A_out);
    $display("gsrcvalT2A 20:%020d", pipeline_0.pr_T2A_out);
    $display("gsrcvalT1B 20:%020d", pipeline_0.pr_T1B_out);
    $display("gsrcvalT2B 20:%020d", pipeline_0.pr_T2B_out);

    // RS signals (40) - prefix 'd'
    $display("dalmostFull 1:%h",pipeline_0.rs_almostFull_out);
    $display("dalu_funcA 2:%h",pipeline_0.rs_alu_funcA_out);
    $display("dalu_funcB 2:%h",pipeline_0.rs_alu_funcB_out);
    $display("dFull 1:%h",pipeline_0.rs_busy_out);
    $display("dIRA 8:%h",pipeline_0.rs_IRA_out);
    $display("dIRB 8:%h",pipeline_0.rs_IRB_out);
    $display("dArdy? 1:%h",pipeline_0.rs_issueArdy_out);
    $display("dBRdy? 1:%h",pipeline_0.rs_issueBrdy_out);
    $display("dop1A_select 1:%h",pipeline_0.rs_op1A_select_out);
    $display("dop2A_select 1:%h",pipeline_0.rs_op2A_select_out);
    $display("dop1B_select 1:%h",pipeline_0.rs_op1B_select_out);
    $display("dop2B_select 1:%h",pipeline_0.rs_op2B_select_out);
    $display("drob_idxA 2:%02d",pipeline_0.rs_rob_idxA_out);
    $display("drob_idxB 2:%02d",pipeline_0.rs_rob_idxB_out);
    $display("darch_idxA 2:%02d",pipeline_0.rs_archIdxA_out);
    $display("darch_idxB 2:%02d",pipeline_0.rs_archIdxB_out);
    $display("ddestTA 2:%02d",pipeline_0.rs_TA_out);
    $display("ddestTB 2:%02d",pipeline_0.rs_TB_out);
    $display("dsrcT1A 2:%02d",pipeline_0.rs_T1A_out);
    $display("dsrcT2A 2:%02d",pipeline_0.rs_T2A_out);
    $display("dsrcT1B 2:%02d",pipeline_0.rs_T1B_out);
    $display("dsrcT2B 2:%02d",pipeline_0.rs_T2B_out);
    $display("dnpcA 16:%h",pipeline_0.rs_npcA_out);
    $display("dnpcB 16:%h",pipeline_0.rs_npcB_out);
    $display("drdA? 1:%h",pipeline_0.rs_rd_memA_out);
    $display("drdB? 1:%h",pipeline_0.rs_rd_memB_out);
    $display("dwrA? 1:%h",pipeline_0.rs_wr_memA_out);
    $display("dwrB? 1:%h",pipeline_0.rs_wr_memB_out);
    $display("dcond_branchA 1:%h",pipeline_0.rs_cond_branchA_out);
    $display("dcond_branchB 1:%h",pipeline_0.rs_cond_branchB_out);
    $display("dunccond_branchA 1:%h",pipeline_0.rs_uncond_branchA_out);
    $display("dunccond_branchB 1:%h",pipeline_0.rs_uncond_branchB_out);
    $display("dhaltA 1:%h",pipeline_0.rs_haltA_out);
    $display("dhaltB 1:%h",pipeline_0.rs_haltB_out);
    $display("dillegalA 1:%h",pipeline_0.rs_illegalA_out);
    $display("dillegalB 1:%h",pipeline_0.rs_illegalB_out);
    $display("dbranch_predictionA 1:%h",pipeline_0.rs_branch_predictionA_out);
    $display("dbranch_predictionB 1:%h",pipeline_0.rs_branch_predictionB_out);
    $display("dpredicted_PCA 16:%h",pipeline_0.rs_predicted_PCA_out);
    $display("dpredicted_PCB 16:%h",pipeline_0.rs_predicted_PCB_out);
    $display("drs_lq_idxA 2:%02d", pipeline_0.rs_lq_idxA_out);
    $display("drs_lq_idxB 2:%02d", pipeline_0.rs_lq_idxB_out);
    $display("drs_sq_idxA 2:%02d", pipeline_0.rs_sq_idxA_out);
    $display("drs_sq_idxB 2:%02d", pipeline_0.rs_sq_idxB_out);

    // ID/EX signals (56) - prefix 'h'
    $display("hexA_en 1:%h", pipeline_0.exA_en_out);
    $display("hexA_result 20:%020d", pipeline_0.exA_result_out);
    $display("hexA_prIdx 2:%02d", pipeline_0.exA_pr_idx_out);
    $display("hexA_mtIdx 2:%02d", pipeline_0.exA_mt_idx_out);
    $display("hexA_robIdx 2:%02d", pipeline_0.exA_rob_idx_out);
    $display("hexA_take_branch 1:%h", pipeline_0.exA_take_branch_out);
    $display("hexA_br_mistaken 1:%h", pipeline_0.exA_branch_mistaken_out);
    $display("hexA_br_still_taken 1:%h", pipeline_0.exA_branch_still_taken_out);
    $display("hexA_mispredict 1:%h", pipeline_0.exA_mispredicted_out);
    $display("hexA_if_predicted_taken 1:%h", pipeline_0.exA_if_predicted_taken_out);
    $display("hexA_NPC 16:%h", pipeline_0.exA_NPC_out);
    $display("hexA_PC 16:%h", pipeline_0.exA_predicted_PC_out);
    $display("hexA_cond_br 1:%h", pipeline_0.exA_cond_branch_out);
    $display("hexA_uncond_br 1:%h", pipeline_0.exA_uncond_branch_out);
    $display("hexA_rd_mem? 1:%h", pipeline_0.exA_rd_mem_out);
    $display("hexA_wr_mem? 1:%h", pipeline_0.exA_wr_mem_out);
    $display("hexA_halt? 1:%h", pipeline_0.exA_halt_out);
    $display("hexA_illegal? 1:%h", pipeline_0.exA_illegal_out);

    $display("hexB_en 1:%h", pipeline_0.exB_en_out);
    $display("hexB_result 20:%020d", pipeline_0.exB_result_out);
    $display("hexB_prIdx 2:%02d", pipeline_0.exB_pr_idx_out);
    $display("hexB_mtIdx 2:%02d", pipeline_0.exB_mt_idx_out);
    $display("hexB_robIdx 2:%02d", pipeline_0.exB_rob_idx_out);
    $display("hexB_take_branch 1:%h", pipeline_0.exB_take_branch_out);
    $display("hexB_br_mistaken 1:%h", pipeline_0.exB_branch_mistaken_out);
    $display("hexB_br_still_taken 1:%h", pipeline_0.exB_branch_still_taken_out);
    $display("hexB_mispredict 1:%h", pipeline_0.exB_mispredicted_out);
    $display("hexB_if_predicted_taken 1:%h", pipeline_0.exB_if_predicted_taken_out);
    $display("hexB_NPC 16:%h", pipeline_0.exB_NPC_out);
    $display("hexB_PC 16:%h", pipeline_0.exB_predicted_PC_out);
    $display("hexB_cond_br 1:%h", pipeline_0.exB_cond_branch_out);
    $display("hexB_uncond_br 1:%h", pipeline_0.exB_uncond_branch_out);
    $display("hexB_rd_mem 1:%h", pipeline_0.exB_rd_mem_out);
    $display("hexB_wr_mem 1:%h", pipeline_0.exB_wr_mem_out);
    $display("hexB_halt 1:%h", pipeline_0.exB_halt_out);
    $display("hexB_illegal 1:%h", pipeline_0.exB_illegal_out);

    $display("hexC_en 1:%h", pipeline_0.exC_mult_valid_out);
    $display("hexC_result 20:%020d", pipeline_0.exC_mult_result_out);
    $display("hexC_prIdx 2:%02d", pipeline_0.exC_pr_idx_out);
    $display("hexC_mtIdx 2:%02d", pipeline_0.exC_mt_idx_out);
    $display("hexC_robIdx 2:%02d", pipeline_0.exC_rob_idx_out);
    $display("hexC_en_early 1:%h", pipeline_0.exC_mult_valid_out_early);
    $display("hexC_result_early 20:%020d", pipeline_0.exC_mult_result_out_early);
    $display("hexC_prIdx_early 2:%02d", pipeline_0.exC_pr_idx_early);
    $display("hexC_mtIdx_early 2:%02d", pipeline_0.exC_mt_idx_early);
    $display("hexC_robIdx_early 2%02d", pipeline_0.exC_rob_idx_early);
    $display("hexD_en 1:%h", pipeline_0.exD_mult_valid_out);
    $display("hexD_result 20:%020d", pipeline_0.exD_mult_result_out);
    $display("hexD_prIdx 2:%02d", pipeline_0.exD_pr_idx_out);
    $display("hexD_mtIdx 2:%02d", pipeline_0.exD_mt_idx_out);
    $display("hexD_robIdx 2:%02d", pipeline_0.exD_rob_idx_out);
    $display("hexD_en_early 1:%h", pipeline_0.exD_mult_valid_out_early);
    $display("hexD_result_early 20:%020d", pipeline_0.exD_mult_result_out_early);
    $display("hexD_prIdx_early 2:%02d", pipeline_0.exD_pr_idx_early);
    $display("hexD_mtIdx_early 2:%02d", pipeline_0.exD_mt_idx_early);
    $display("hexD_robIdx_early 2%02d", pipeline_0.exD_rob_idx_early);

    // Rob Connect (31) - prefix 'e'
    $display("erob_one_inst 1:%h", pipeline_0.rob_one_inst_out);
    $display("erob_none_inst 1:%h", pipeline_0.rob_none_inst_out);
    $display("erob_instA_en 1:%h", pipeline_0.rob_instA_en_out);
    $display("erob_instB_en 1:%h", pipeline_0.rob_instB_en_out);
    $display("erob_dispIdxA 2:%02d", pipeline_0.rob_dispidxA_out);
    $display("erob_dispIdxB 2:%02d", pipeline_0.rob_dispidxB_out);
    $display("erob_head 2:%02d", pipeline_0.rob_head);
    $display("erob_branch_idxA 2:%02d", pipeline_0.rob_branch_idxA);
    $display("erob_branch_idxB 2:%02d", pipeline_0.rob_branch_idxB);
    $display("erob_retireIdxA 2:%02d", pipeline_0.rob_retireIdxA_out);
    $display("erob_branch_recover 1:%h", pipeline_0.rob_branch_retire_out);
    $display("erob_halt_en 1:%h", pipeline_0.rob_rs_halt_en);
    $display("erob_stq_retire 1:%h", pipeline_0.rob_stq_retire_en_out);
    $display("efl_destTA 2:%02d", pipeline_0.fl_TA);
    $display("efl_destTB 2:%02d", pipeline_0.fl_TB);
    $display("emt_srcT1A 2:%02d", pipeline_0.mt_T1A_out[6:1]);
    $display("emt_srcT2A 2:%02d", pipeline_0.mt_T2A_out[6:1]);
    $display("emt_srcT1B 2:%02d", pipeline_0.mt_T1B_out[6:1]);
    $display("emt_srcT2B 2:%02d", pipeline_0.mt_T2B_out[6:1]);
    $display("erob_br_mistakenA 1:%h", pipeline_0.rob_branch_mistakenA_out);
    $display("erob_br_mistakenB 1:%h", pipeline_0.rob_branch_mistakenB_out);
    $display("erob_take_brA 1:%h", pipeline_0.rob_take_branchA_out);
    $display("erob_take_brB 1:%h", pipeline_0.rob_take_branchB_out);
    $display("erob_br_still_takenA 1:%h", pipeline_0.rob_branch_still_takenA_out);
    $display("erob_br_still_takenB 1:%h", pipeline_0.rob_branch_still_takenB_out);
    $display("erob_PCA 16:%h", pipeline_0.rob_PCA_out);
    $display("erob_PCB 16:%h", pipeline_0.rob_PCB_out);
    $display("erob_target_PCA 16:%h", pipeline_0.rob_target_PCA_out);
    $display("erob_target_PCB 16:%h", pipeline_0.rob_target_PCB_out);
    $display("erob_predicted_takenA 1:%h", pipeline_0.rob_if_predicted_takenA_out);
    $display("erob_predicted_takenB 1:%h", pipeline_0.rob_if_predicted_takenB_out);

    // LQ/SQ signals (26) - prefix 'i'
    $display("iLQ_rs_stall 1:%h",       pipeline_0.ldq_0.ldq_rs_stall_out );
    $display("iLQ_rs_ldqIdxA 1:%0d",     pipeline_0.ldq_0.ldq_rs_ldqidxA_out );
    $display("iLQ_rs_ldqIdxB 1:%d",     pipeline_0.ldq_0.ldq_rs_ldqidxB_out );
    $display("iLQ_almostfull 1:%h",     pipeline_0.ldq_0.ldq_almostfull_out );
    $display("iLQ_full 1:%h",           pipeline_0.ldq_0.ldq_full_out );
    $display("iLQ_mem_idx 1:%h",        pipeline_0.ldq_0.ldq_mem_addr_out );
    $display("iLQ_mem_req 1:%h",        pipeline_0.ldq_0.ldq_mem_req_out );
    $display("iLQ_ex_cdb_en 1:%h",      pipeline_0.ldq_0.ldq_mem_idx_out );
    $display("iLQ_mem_addr 16:%h",       pipeline_0.ldq_0.ldq_ex_cdb_en_out );
    $display("iLQ_ex_data 16:%h",        pipeline_0.ldq_0.ldq_ex_data_out );
    $display("iLQ_ex_robIdx 2:%0d",      pipeline_0.ldq_0.ldq_ex_robidx_out );
    $display("iLQ_ex_prIdx 2:%0d",       pipeline_0.ldq_0.ldq_ex_pridx_out );
    $display("iLQ_ex_mtIdx 2:%0d",       pipeline_0.ldq_0.ldq_ex_mtidx_out );
    $display("iLQ_ex_illegal 1:%h",     pipeline_0.ldq_0.ldq_ex_illegal_out );    
    $display("iLQ_ex_halt 1:%h",        pipeline_0.ldq_0.ldq_ex_halt_out ); 
    //there will be npc here (LQ)
    //(15 + 11 = 26 total)
    $display("iSQ_store_request 1:%h",      pipeline_0.stq_0.store_request); 
    $display("iSQ_store_retire_addr 1:%h",  pipeline_0.stq_0.store_retire_addr); 
    $display("iSQ_store_retire_data 1:%h",  pipeline_0.stq_0.store_retire_data); 
    $display("iSQ_rs_stqIdxA 1:%h",         pipeline_0.stq_0.SQ2RS_idxA); 
    $display("iSQ_rs_stqIdxB 1:%h",         pipeline_0.stq_0.SQ2RS_idxB); 
    $display("iSQ_tail 1:%h",               pipeline_0.stq_0.tail); 
    $display("iSQ_next_tail 1:%h",          pipeline_0.stq_0.next_tail); 
    $display("iSQ_full 1:%h",               pipeline_0.stq_0.SQ_full); 
    $display("iSQ_almostfull 1:%h",         pipeline_0.stq_0.SQ_almost_full); 
    $display("iSQ_next_busy 2:%h",          pipeline_0.stq_0.next_busy); 
    $display("iSQ_head 1:%h",               pipeline_0.stq_0.head); 


    // MEM signals (5) - prefix 'm'
    $display("mm2p_response 1:%h",    mem2proc_response);
    $display("mm2p_data 16:%h",  mem2proc_data);
    $display("mp2m_command 1:%h",  proc2mem_command);
    $display("mp2m_addr 16:%h",  proc2mem_addr);
    $display("mp2m_data 16:%h",   proc2mem_data);

    // I/Dcache signals (4) - prefix 'j'
    $display("jI$_data 16:%h",        pipeline_0.cache_0.Icache_0.rd_data);
    $display("jI$_hit 1:%h",          pipeline_0.cache_0.Icache_0.rd_valid);
    $display("jD$_data 16:%h",        pipeline_0.cache_0.Dcache_0.rd_data);
    $display("jD$_hit 1:%h",          pipeline_0.cache_0.Dcache_0.rd_valid);

    // $ control signals (38) - prefix 'w'
    $display("wproc2mem_addr 16:%h", pipeline_0.cache_0.cachecontroller_0.proc2mem_addr);
    $display("wproc2mem_command 1:%h", pipeline_0.cache_0.cachecontroller_0.proc2mem_command);
    $display("wproc2mem_data 16:%h", pipeline_0.cache_0.cachecontroller_0.proc2mem_data);
    $display("wI$_current_tag 14:%h", pipeline_0.cache_0.cachecontroller_0.Icache_current_tag);
    $display("wI$_current_idx 2:%h", pipeline_0.cache_0.cachecontroller_0.Icache_current_idx);
    $display("wMSHR2I$_last_tag 14:%h", pipeline_0.cache_0.cachecontroller_0.MSHR2Icache_last_tag);
    $display("wMSHR2I$_last_idx 2:%h", pipeline_0.cache_0.cachecontroller_0.MSHR2Icache_last_idx);
    $display("wMSHR2I$_last_data_write_en 1:%h", pipeline_0.cache_0.cachecontroller_0.MSHR2Icache_last_data_write_en);
    $display("wMSHR2I$_last_data 16:%h", pipeline_0.cache_0.cachecontroller_0.MSHR2Icache_last_data);
    $display("wDcache2I$_coherence_tag 14:%h", pipeline_0.cache_0.cachecontroller_0.Dcache2Icache_coherence_tag);
    $display("wDcache2I$_coherence_idx 2:%h", pipeline_0.cache_0.cachecontroller_0.Dcache2Icache_coherence_idx);
    $display("wDcache2I$_coherence_data_write_en 1:%h", pipeline_0.cache_0.cachecontroller_0.Dcache2Icache_coherence_data_write_en);
    $display("wDcache2I$_coherence_data 16:%h", pipeline_0.cache_0.cachecontroller_0.Dcache2Icache_coherence_data);
    $display("wcontroller2D$_current_tag 14:%h", pipeline_0.cache_0.cachecontroller_0.controller2Dcache_current_tag);
    $display("wcontroller2D$_current_idx 2:%h", pipeline_0.cache_0.cachecontroller_0.controller2Dcache_current_idx);
    $display("wcontroller2D$_store_tag 14:%h", pipeline_0.cache_0.cachecontroller_0.controller2Dcache_store_tag);
    $display("wcontroller2D$_store_idx 2:%h", pipeline_0.cache_0.cachecontroller_0.controller2Dcache_store_idx);
    $display("wcontroller2D$_store_data 63:%h", pipeline_0.cache_0.cachecontroller_0.controller2Dcache_store_data);
    $display("wcontroller2D$_store_write_en 1:%h", pipeline_0.cache_0.cachecontroller_0.controller2Dcache_store_write_en);
    $display("wMSHR2D$_last_tag 14:%h", pipeline_0.cache_0.cachecontroller_0.MSHR2Dcache_last_tag);
    $display("wMSHR2D$_last_idx 2:%h", pipeline_0.cache_0.cachecontroller_0.MSHR2Dcache_last_idx);
    $display("wMSHR2D$_last_data_write_en 1:%h", pipeline_0.cache_0.cachecontroller_0.MSHR2Dcache_last_data_write_en);
    $display("wMSHR2D$_last_data 16:%h", pipeline_0.cache_0.cachecontroller_0.MSHR2Dcache_last_data);
    $display("wI$2proc_data_outA 16:%h", pipeline_0.cache_0.cachecontroller_0.Icache2proc_data_outA);
    $display("wI$2proc_valid_outA 1:%h", pipeline_0.cache_0.cachecontroller_0.Icache2proc_valid_outA);
    $display("wI$2proc_data_outB 16:%h", pipeline_0.cache_0.cachecontroller_0.Icache2proc_data_outB);
    $display("wI$2proc_valid_outB 1:%h", pipeline_0.cache_0.cachecontroller_0.Icache2proc_valid_outB);
    $display("wD$2proc_data_outA 16:%h", pipeline_0.cache_0.cachecontroller_0.Dcache2proc_data_outA);
    $display("wD$2proc_valid_outA 1:%h", pipeline_0.cache_0.cachecontroller_0.Dcache2proc_valid_outA);
    $display("wD$2proc_LQ_idxA 1:%h", pipeline_0.cache_0.cachecontroller_0.Dcache2proc_LQ_idxA);
    $display("wD$2proc_data_outB 16:%h", pipeline_0.cache_0.cachecontroller_0.Dcache2proc_data_outB);
    $display("wD$2proc_valid_outB 1:%h", pipeline_0.cache_0.cachecontroller_0.Dcache2proc_valid_outB);
    $display("wD$2proc_LQ_idxB 1:%h", pipeline_0.cache_0.cachecontroller_0.Dcache2proc_LQ_idxB);
    $display("wMSHR_full 1:%h", pipeline_0.cache_0.cachecontroller_0.MSHR_full);
    $display("wI$2proc_grant 1:%h", pipeline_0.cache_0.cachecontroller_0.Icache2proc_grant);
    $display("wI$2prefetch_grant 1:%h", pipeline_0.cache_0.cachecontroller_0.Icache2prefetch_grant);
    $display("wD$2proc_load_grant 1:%h", pipeline_0.cache_0.cachecontroller_0.Dcache2proc_load_grant);
    $display("wD$2proc_store_grant 1:%h", pipeline_0.cache_0.cachecontroller_0.Dcache2proc_store_grant);

    // X-LSQ signals (22) - prefix 'v'
    $display("vexA_lq_pr_idx 2:%02d", pipeline_0.exA_lq_pr_idx_out);
    $display("vexA_lq_mt_idx 2:%02d", pipeline_0.exA_lq_mt_idx_out);
    $display("vexA_lq_rob_idx 2:%02d", pipeline_0.exA_lq_rob_idx_out);
    $display("vexA_sq_idx 1:%0d", pipeline_0.exA_sq_idx_out);
    $display("vexA_lsq_NPC 16:%h", pipeline_0.exA_lsq_NPC_out);
    $display("vexA_lsq_data 20:%020d", pipeline_0.exA_lsq_data_out);
    $display("vexA_lsq_addr 16:%h", pipeline_0.exA_lsq_addr_out);
    $display("vexA_lq_data_rdy 1:%h", pipeline_0.exA_lq_data_rdy_out);
    $display("vexA_sq_data_rdy 1:%h", pipeline_0.exA_sq_data_rdy_out);
    $display("vexA_lsq_halt 1:%h", pipeline_0.exA_lsq_halt_out);
    $display("vexA_lsq_illegal 1:%h", pipeline_0.exA_lsq_illegal_out);
    $display("vexA_lq_pr_idx 2:%02d", pipeline_0.exA_lq_pr_idx_out);
    $display("vexB_lq_mt_idx 2:%02d", pipeline_0.exB_lq_mt_idx_out);
    $display("vexB_lq_rob_idx 2:%02d", pipeline_0.exB_lq_rob_idx_out);
    $display("vexB_sq_idx 1:%0d", pipeline_0.exB_sq_idx_out);
    $display("vexB_lsq_NPC 16:%h", pipeline_0.exB_lsq_NPC_out);
    $display("vexB_lsq_data 20:%020d", pipeline_0.exB_lsq_data_out);
    $display("vexB_lsq_addr 16:%h", pipeline_0.exB_lsq_addr_out);
    $display("vexB_lq_data_rdy 1:%h", pipeline_0.exB_lq_data_rdy_out);
    $display("vexB_sq_data_rdy 1:%h", pipeline_0.exB_sq_data_rdy_out);
    $display("vexB_lsq_halt 1:%h", pipeline_0.exB_lsq_halt_out);
    $display("vexB_lsq_illegal 1:%h", pipeline_0.exB_lsq_illegal_out);    

    // must come last
    $display("break");

    // This is a blocking call to allow the debugger to control when we
    // advance the simulation
    waitforresponse();
  end
endmodule
