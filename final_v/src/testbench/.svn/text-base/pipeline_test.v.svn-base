
module testbench;
  
reg 	          clock;
reg             reset;
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
// pipeline_commit_NPC


//debugging variables.
reg [8*11:0] str;
reg [21:0]  clocks;
reg [21:0]  i;
reg [31:0]  instr_count;
reg [31:0]  retire_count;
reg [31:0]  total_branch_count;
reg [31:0]  mispredict_count;
reg [31:0]  robfull_count;
reg [31:0]  rsfull_count;
reg [31:0]  lqfull_count;
reg [31:0]  sqfull_count;
reg [31:0]  ifstall_count;
reg [31:0] num_write;
reg [31:0] num_save;
reg [4:0]  log_num;
reg [5:0]  pr_num;
reg [4:0]  head_num;
integer analysis_fileno;
real    prediction_accuracy;
real    robfull_ratio;
real    rsfull_ratio;
real    lqfull_ratio;
real    sqfull_ratio;
real    ifstall_ratio;
integer rob_fileno;
integer mt_fileno;
integer rs_fileno;
integer fl_fileno;
integer wb_fileno;
integer ex_fileno;
integer pr_fileno;
integer ar_fileno;
integer btb_fileno;
integer bs_fileno;
integer monitor_fileno;
integer sq_fileno;
integer lq_fileno;
integer mem_fileno;
integer ras_fileno;
integer commit_fileno;
integer commitTime_fileno;
integer pcplus4_fileno;
integer pcplus4time_fileno;

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

mem     memory    ( //inputs
                 .clk(clock), 
                 .proc2mem_command(proc2mem_command),   
                 .proc2mem_addr   (proc2mem_addr), 
                 .proc2mem_data   (proc2mem_data),
                 // outputs
                 .mem2proc_response(mem2proc_response),
                 .mem2proc_data     (mem2proc_data), 
                 .mem2proc_tag      (mem2proc_tag)
                 ) ;
always
begin
  #(`VERILOG_CLOCK_PERIOD/2.0);
  clock = ~clock;
end

initial begin
  mispredict_count = 0;
  total_branch_count = 0;
  robfull_count=0;
  rsfull_count=0;
  lqfull_count=0;
  sqfull_count=0;
  ifstall_count=0;
  log_num = 0;
  head_num = 0;
  pr_num = 0;
  clock = 1'b0;
  clocks = 0;
  reset = 1'b1;
  num_write = 32'b0;
  num_save = 32'b0;
  // proc2mem_data = 64'b0;
  // proc2mem_command = `BUS_LOAD;
  $display("@@\n@@\n@@  %t  Asserting System reset......", $realtime);
  rob_fileno = $fopen("rob.out");
  rs_fileno = $fopen("rs.out");
  fl_fileno = $fopen("freelist.out");
  mt_fileno = $fopen("maptable.out"); //uncomment when ports are sorted out.
  wb_fileno = $fopen("writeback.out");
  ex_fileno = $fopen("ex_pipe.out");
  pr_fileno = $fopen("pr.out");
  ar_fileno = $fopen("ar.out");
  btb_fileno = $fopen("btb.out");
  bs_fileno = $fopen("bs.out");
  sq_fileno = $fopen("sq.out");
  lq_fileno = $fopen("lq.out");
  monitor_fileno = $fopen("monitor.out");
  mem_fileno = $fopen("mem.out");
  ras_fileno = $fopen("ras.out");
  commit_fileno = $fopen("commit.out");
  commitTime_fileno = $fopen("committime.out");
  pcplus4_fileno = $fopen("pcplus4.out");
  pcplus4time_fileno = $fopen("pcplus4time.out");
  analysis_fileno = $fopen("analysis.out");
  @(negedge clock);
  reset = 1'b1;
  $readmemh("program.mem", memory.unified_memory);
`ifdef DEBUG_OUT
  //write monitor
  $fmonitor(monitor_fileno,
    "Clock:%d\n\
    -----------------------------------------------------------------------------------------------------\n\
    MT monitors:\n\
    mt_T1A:%6d (%1d)   mt_T2A:%6d (%1d)   mt_T1B:%6d (%1d)  mt_T2B:%6d (%1d)\n\n\
    Freelist monitors:\n\
    fl_TA:%6d    fl_TB:%6d    empty:%1b    head_at_branch_signal:%5d    head_add_one_at_branch_signal:%5d\n\n\
    ROB monitors:\n\
    rob_ToldA/B_out:%6d/%6d \t rob_TA/B_out:%6d/%6d\n\
    rob_retireA/B_out:%1b/%1b \t rob_one/none_inst_out:%1b/%1b \t rob_instA/B_en_out:%1b/%1b \t rob_dispidxA/B_out:%1b/%1b\n\
    rob_logidxA/B_out:%5d/%5d \t rob_head:%5d \t rob_branch_idxA/B:%5d/%5d \t rob_retireIdxA_out:%5d\n\
    rob_branch_retire_out:%1b \t rob_branch_mistakenA/B_out:%1b/%1b \t rob_take_branchA/B_out:%1b/%1b  rob_branch_stillA/B_out:%1b/%1b  rob_rs_halt_en:%1b\n\
    rob_PCA/B_out:%64h/%64h \t rob_target_PCA/B_out:%64h/%64h\n\n\
    RS monitors:\n\
    rs_almost/Full:%1b/%1b \t rs_aluA/B_out:%5d/%5d \t  rs_IRA/B_out:%32h/%32h  \t rs_issueA/Brdy_out:%1b/%1b\n\
    rs_op1A/2A/1B/2B_selectOut:%2b/%2b/%2b/%2b    rs_rob_idxA/B_out:%5d/%5d  \t  rs_archIdxA/B_out:%5d/%5d\n\
    rs_TA/B_out:%6d/%6d \t rs_T1A/2A/1B/2B_out:%6d/%6d/%6d/%6d\n\
    rs_NPCA/B_out:%64h/%64h\n\
    rs_rd_memA/B_out:%1b/%1b\t rs_wr_memA/B_out:%1b/%1b \t rs_cond/uncond_branchA/B_out:%1b/%1b/%1b/%1b\t rs_haltA/B_out:%1b/%1b\trs_illegalA/B_out:%1b/%1b\n\
    rs_branch_predictionA/B_out:%1b/%1b \t   rs_predicted_PCA/B_out:%64h/%64h\n\n\
    IF monitor:\n\
    proc2Imem_addr:%64h \t IF_IRA/B_out:%32h/%32h\n\
    if_valid_instA/B_out:%1b/%1b \t if_PCA/B_out:%64h/%64h \t if_NPCA/B_out:%64h/%64h\n\
    rs_branch_predictionA:%1b/%1b \t predicted_PCA:%64h/%64h\n\n\
    PR monitor:\n\
    pr_T1A/2A/1B/2B_out:%64h/%64h/%64h/%64h\n\
    ",
    clocks,
    pipeline_0.rob_connect_0.maptable_0.mt_T1A_out[6:1],pipeline_0.rob_connect_0.maptable_0.mt_T1A_out[0],
    pipeline_0.rob_connect_0.maptable_0.mt_T2A_out[6:1],pipeline_0.rob_connect_0.maptable_0.mt_T2A_out[0],
    pipeline_0.rob_connect_0.maptable_0.mt_T1B_out[6:1],pipeline_0.rob_connect_0.maptable_0.mt_T1B_out[0],
    pipeline_0.rob_connect_0.maptable_0.mt_T2B_out[6:1],pipeline_0.rob_connect_0.maptable_0.mt_T2B_out[0],
    pipeline_0.rob_connect_0.freelist_0.fl_TA,pipeline_0.rob_connect_0.freelist_0.fl_TB,
    pipeline_0.rob_connect_0.freelist_0.empty,
    pipeline_0.rob_connect_0.freelist_0.head_at_branch_signal,
    pipeline_0.rob_connect_0.freelist_0.head_add_one_at_branch_signal,
    pipeline_0.rob_connect_0.rob_0.rob_ToldA_out,
    pipeline_0.rob_connect_0.rob_0.rob_ToldB_out,
    pipeline_0.rob_connect_0.rob_0.rob_TA_out,
    pipeline_0.rob_connect_0.rob_0.rob_TB_out,
    pipeline_0.rob_connect_0.rob_0.rob_retireA_out,
    pipeline_0.rob_connect_0.rob_0.rob_retireB_out,
    pipeline_0.rob_connect_0.rob_0.rob_one_inst_out,
    pipeline_0.rob_connect_0.rob_0.rob_none_inst_out,
    pipeline_0.rob_connect_0.rob_0.rob_instA_en_out,
    pipeline_0.rob_connect_0.rob_0.rob_instB_en_out,
    pipeline_0.rob_connect_0.rob_0.rob_dispidxA_out,
    pipeline_0.rob_connect_0.rob_0.rob_dispidxB_out,
    pipeline_0.rob_connect_0.rob_0.rob_logidxA_out,
    pipeline_0.rob_connect_0.rob_0.rob_logidxB_out,
    pipeline_0.rob_connect_0.rob_0.rob_head,
    pipeline_0.rob_connect_0.rob_0.rob_branch_idxA,
    pipeline_0.rob_connect_0.rob_0.rob_branch_idxB,
    pipeline_0.rob_connect_0.rob_0.rob_retireIdxA_out,
    pipeline_0.rob_connect_0.rob_0.rob_branch_retire_out,
    pipeline_0.rob_connect_0.rob_0.rob_branch_mistakenA_out,
    pipeline_0.rob_connect_0.rob_0.rob_branch_mistakenB_out,
    pipeline_0.rob_connect_0.rob_0.rob_take_branchA_out,
    pipeline_0.rob_connect_0.rob_0.rob_take_branchB_out,
    pipeline_0.rob_connect_0.rob_0.rob_branch_still_takenA_out,
    pipeline_0.rob_connect_0.rob_0.rob_branch_still_takenB_out,
    pipeline_0.rob_connect_0.rob_0.rob_rs_halt_en,
    pipeline_0.rob_connect_0.rob_0.rob_PCA_out,
    pipeline_0.rob_connect_0.rob_0.rob_PCB_out,
    pipeline_0.rob_connect_0.rob_0.rob_target_PCA_out,
    pipeline_0.rob_connect_0.rob_0.rob_target_PCB_out,
    pipeline_0.rs_0.rs_almostFull_out,pipeline_0.rs_0.rs_busy_out,
    pipeline_0.rs_0.rs_alu_funcA_out,
    pipeline_0.rs_0.rs_alu_funcB_out,
    pipeline_0.rs_0.rs_IRA_out,
    pipeline_0.rs_0.rs_IRB_out,
    pipeline_0.rs_0.rs_issueArdy_out,
    pipeline_0.rs_0.rs_issueBrdy_out,
    pipeline_0.rs_0.rs_op1A_select_out,
    pipeline_0.rs_0.rs_op2A_select_out,
    pipeline_0.rs_0.rs_op1B_select_out,
    pipeline_0.rs_0.rs_op2B_select_out,
    pipeline_0.rs_0.rs_rob_idxA_out,
    pipeline_0.rs_0.rs_rob_idxB_out,
    pipeline_0.rs_0.rs_archIdxA_out,
    pipeline_0.rs_0.rs_archIdxB_out,
    pipeline_0.rs_0.rs_TA_out,
    pipeline_0.rs_0.rs_TB_out,
    pipeline_0.rs_0.rs_T1A_out,
    pipeline_0.rs_0.rs_T2A_out,
    pipeline_0.rs_0.rs_T1B_out,
    pipeline_0.rs_0.rs_T2B_out,
    pipeline_0.rs_0.rs_npcA_out,
    pipeline_0.rs_0.rs_npcB_out,
    pipeline_0.rs_0.rs_rd_memA_out,
    pipeline_0.rs_0.rs_rd_memB_out,
    pipeline_0.rs_0.rs_wr_memA_out,
    pipeline_0.rs_0.rs_wr_memB_out,
    pipeline_0.rs_0.rs_cond_branchA_out,
    pipeline_0.rs_0.rs_cond_branchB_out,
    pipeline_0.rs_0.rs_uncond_branchA_out,
    pipeline_0.rs_0.rs_uncond_branchB_out,
    pipeline_0.rs_0.rs_haltA_out,
    pipeline_0.rs_0.rs_haltB_out,
    pipeline_0.rs_0.rs_illegalA_out,
    pipeline_0.rs_0.rs_illegalB_out,
    pipeline_0.rs_0.rs_branch_predictionA_out,
    pipeline_0.rs_0.rs_branch_predictionB_out,
    pipeline_0.rs_0.rs_predicted_PCA_out,
    pipeline_0.rs_0.rs_predicted_PCB_out,
    pipeline_0.if_id_0.if_0.proc2Imem_addr,
    pipeline_0.if_id_0.if_0.if_IRA_out,
    pipeline_0.if_id_0.if_0.if_IRB_out,
    pipeline_0.if_id_0.if_0.if_valid_instA_out,
    pipeline_0.if_id_0.if_0.if_valid_instB_out,
    pipeline_0.if_id_0.if_0.if_PCA_out,
    pipeline_0.if_id_0.if_0.if_PCB_out,
    pipeline_0.if_id_0.if_0.if_NPCA_out,
    pipeline_0.if_id_0.if_0.if_NPCB_out,
    pipeline_0.if_id_0.if_0.branch_predictionA,
    pipeline_0.if_id_0.if_0.branch_predictionB,
    pipeline_0.if_id_0.if_0.predicted_PCA,
    pipeline_0.if_id_0.if_0.predicted_PCB,
    pipeline_0.pr_0.pr_T1A_out,
    pipeline_0.pr_0.pr_T2A_out,
    pipeline_0.pr_0.pr_T1B_out,
    pipeline_0.pr_0.pr_T2B_out
    );

`endif


  @(negedge clock);
  `SD;
  reset = 1'b0;

end  

always @(posedge clock or posedge reset)
begin
  if (reset)
  begin
    clocks<=`SD 0;
    instr_count <=`SD 0;
    retire_count <= `SD 0;
  end
  else
  begin
    clocks <= `SD clocks + 1'b1;
    instr_count <= `SD (instr_count + pipeline_completed_instA + pipeline_completed_instB + pipeline_completed_instC + pipeline_completed_instD);
  end
end

always @(posedge clock)
begin

//might be able to get rid of this if we use all the internals as outputs for synthesis
`ifdef DEBUG_OUT

  //rob-writing
  $fdisplay(rob_fileno,"CC %0d: \t almostfull:%1b \t full:%1b \t halt?:%1b \t cdbmispredictA:%1b \t cdbrdyA:%1b \t storeReq_out:%1b \t next_counter:%0d \t valid:%b",
   clocks,
   pipeline_0.rob_connect_0.rob_0.rob_one_inst_out,
   pipeline_0.rob_connect_0.rob_0.rob_none_inst_out,
   pipeline_0.rob_connect_0.rob_0.rob_rs_halt_en,
   pipeline_0.rob_connect_0.rob_0.ex_cm_cdbA_rdy,
   pipeline_0.rob_connect_0.rob_0.ex_set_mispredictA,
   pipeline_0.rob_connect_0.rob_0.rob_stq_retire_en_out,
   pipeline_0.rob_connect_0.rob_0.next_counter,
   pipeline_0.rob_connect_0.rob_0.valid);
  $fdisplay(rob_fileno,"==================================================================================================================================================================================================================");
  $fdisplay(rob_fileno,"|    ht pos \t | \t    T \t \t | \t Told \t \t | LogReg \t |   complete\t |  \t idx/instr \t\t| \t\t PC \t\t | \t targetPC \t\t |bstill/mp/mist |\n\
==================================================================================================================================================================================================================");
  for (i=0;i<'d32;i=i+1) begin
  str = check_opcode(pipeline_0.rob_connect_0.rob_0.IR[i]);
    if (pipeline_0.rob_connect_0.rob_0.head==i && pipeline_0.rob_connect_0.rob_0.tail==i) begin
    $fdisplay(rob_fileno,"| \t ht \t | \t %6d \t | \t %6d \t | \t %5d \t | \t %1b \t |\t %5d/%s \t| \t %h \t | \t %h \t | \t %1b/%1b/%1b \t |",
        pipeline_0.rob_connect_0.rob_0.T[i],
        pipeline_0.rob_connect_0.rob_0.T_old[i], 
        pipeline_0.rob_connect_0.rob_0.logdestIdx[i], 
        pipeline_0.rob_connect_0.rob_0.done[i],
        i,str,
        pipeline_0.rob_connect_0.rob_0.PC[i],
        pipeline_0.rob_connect_0.rob_0.target_PC[i],
        pipeline_0.rob_connect_0.rob_0.branch_still_taken[i],
        pipeline_0.rob_connect_0.rob_0.mispredict[i],
        pipeline_0.rob_connect_0.rob_0.branch_mistaken[i]);
    end
    else if (pipeline_0.rob_connect_0.rob_0.head==i) begin
    $fdisplay(rob_fileno,"| \t h \t | \t %6d \t | \t %6d \t | \t %5d \t | \t %1b \t |\t %5d/%s \t| \t %h \t | \t %h \t | \t %1b/%1b/%1b \t |",
        pipeline_0.rob_connect_0.rob_0.T[i],
        pipeline_0.rob_connect_0.rob_0.T_old[i], 
        pipeline_0.rob_connect_0.rob_0.logdestIdx[i], 
        pipeline_0.rob_connect_0.rob_0.done[i],
        i,str,
        pipeline_0.rob_connect_0.rob_0.PC[i],
        pipeline_0.rob_connect_0.rob_0.target_PC[i],
        pipeline_0.rob_connect_0.rob_0.branch_still_taken[i],
        pipeline_0.rob_connect_0.rob_0.mispredict[i],
        pipeline_0.rob_connect_0.rob_0.branch_mistaken[i]);
    end 
    else if (pipeline_0.rob_connect_0.rob_0.tail==i) begin
    $fdisplay(rob_fileno,"| \t t \t | \t %6d \t | \t %6d \t | \t %5d \t | \t %1b \t |\t %5d/%s \t| \t %h \t | \t %h \t | \t %1b/%1b/%1b \t |",
        pipeline_0.rob_connect_0.rob_0.T[i],
        pipeline_0.rob_connect_0.rob_0.T_old[i], 
        pipeline_0.rob_connect_0.rob_0.logdestIdx[i], 
        pipeline_0.rob_connect_0.rob_0.done[i],
        i,str,
        pipeline_0.rob_connect_0.rob_0.PC[i],
        pipeline_0.rob_connect_0.rob_0.target_PC[i],
        pipeline_0.rob_connect_0.rob_0.branch_still_taken[i],
        pipeline_0.rob_connect_0.rob_0.mispredict[i],
        pipeline_0.rob_connect_0.rob_0.branch_mistaken[i]);
    end
    else begin
    $fdisplay(rob_fileno,"| \t   \t | \t %6d \t | \t %6d \t | \t %5d \t | \t %1b \t |\t %5d/%s \t| \t %h \t | \t %h \t | \t %1b/%1b/%1b \t |",
        pipeline_0.rob_connect_0.rob_0.T[i],
        pipeline_0.rob_connect_0.rob_0.T_old[i], 
        pipeline_0.rob_connect_0.rob_0.logdestIdx[i], 
        pipeline_0.rob_connect_0.rob_0.done[i],
        i,str,
        pipeline_0.rob_connect_0.rob_0.PC[i],
        pipeline_0.rob_connect_0.rob_0.target_PC[i],
        pipeline_0.rob_connect_0.rob_0.branch_still_taken[i],
        pipeline_0.rob_connect_0.rob_0.mispredict[i],
        pipeline_0.rob_connect_0.rob_0.branch_mistaken[i]);
    end
  end
  $fdisplay(rob_fileno,"==================================================================================================================================================================================================================\n");

  //register commit file-writing
  
  if ($past(pipeline_0.rob_connect_0.rob_0.head_incr_one_en) && ~$past(pipeline_0.rob_connect_0.rob_0.head_incr_two_en)) begin
      log_num = pipeline_0.rob_connect_0.rob_0.logdestIdx[$past(pipeline_0.rob_connect_0.rob_0.head)]; //get head's logdest
      pr_num = pipeline_0.rob_connect_0.archtable_0.at_reg[log_num]; //get pr mapping
      head_num = $past(pipeline_0.rob_connect_0.rob_0.head);
      str = check_opcode(pipeline_0.rob_connect_0.rob_0.IR[head_num]);
      if (~(log_num=='d31)) begin
        $fdisplay(commit_fileno, "r%0d=%0d", log_num, pipeline_0.pr_0.registers[pr_num]); //get pr value no clk
        $fdisplay(commitTime_fileno, "r%0d=%0d   CC:%0d", log_num, pipeline_0.pr_0.registers[pr_num], clocks); //get pr value
      end
      $fdisplay(pcplus4_fileno, "%0d:%0s", pipeline_0.rob_connect_0.rob_0.PC[head_num]+3'b100, str);
      $fdisplay(pcplus4time_fileno, "%0d:%0s  CC:%0d", pipeline_0.rob_connect_0.rob_0.PC[head_num]+3'b100, 
          str, clocks); 
  end else if ($past(pipeline_0.rob_connect_0.rob_0.head_incr_two_en)) begin
      log_num = pipeline_0.rob_connect_0.rob_0.logdestIdx[$past(pipeline_0.rob_connect_0.rob_0.head)];
      pr_num = pipeline_0.rob_connect_0.archtable_0.at_reg[log_num];
      head_num = $past(pipeline_0.rob_connect_0.rob_0.head);
      str = check_opcode(pipeline_0.rob_connect_0.rob_0.IR[head_num]);
      if (~(log_num=='d31)) begin
        $fdisplay(commit_fileno, "r%0d=%0d", log_num, pipeline_0.pr_0.registers[pr_num]); //no clk
        $fdisplay(commitTime_fileno, "r%0d=%0d   CC:%0d", log_num, pipeline_0.pr_0.registers[pr_num],clocks);
      end
      $fdisplay(pcplus4_fileno, "%0d:%0s", pipeline_0.rob_connect_0.rob_0.PC[head_num]+3'b100, str);
      $fdisplay(pcplus4time_fileno, "%0d:%0s  CC:%0d", pipeline_0.rob_connect_0.rob_0.PC[head_num]+3'b100, 
          str, clocks); 
      log_num = pipeline_0.rob_connect_0.rob_0.logdestIdx[$past(pipeline_0.rob_connect_0.rob_0.head+1'b1)];
      pr_num = pipeline_0.rob_connect_0.archtable_0.at_reg[log_num];
      head_num = $past(pipeline_0.rob_connect_0.rob_0.head)+1'b1;
      str = check_opcode(pipeline_0.rob_connect_0.rob_0.IR[head_num]);
      if (~(log_num=='d31)) begin
        $fdisplay(commit_fileno, "r%0d=%0d", log_num, pipeline_0.pr_0.registers[pr_num]); //no clk
        $fdisplay(commitTime_fileno, "r%0d=%0d   CC:%0d", log_num, pipeline_0.pr_0.registers[pr_num],clocks); 
      end
      $fdisplay(pcplus4_fileno, "%0d:%0s", pipeline_0.rob_connect_0.rob_0.PC[head_num]+3'b100, str);
      $fdisplay(pcplus4time_fileno, "%0d:%0s  CC:%0d", pipeline_0.rob_connect_0.rob_0.PC[head_num]+3'b100, 
        str, clocks);
  end

  //rs-writing
  $fdisplay(rs_fileno,"CC %0d:", clocks);
  $fdisplay(rs_fileno,"Slot info: \t | initFreeA:%4d \t initFreeB:%4d \t allocA:%4d \t  allocB:%4d\t\nFree info: \t | free:%1d \t T1Aout:%5d \t T2Aout:%5d  \
   \t T1Bout:%5d \t T1Bout:%5d TAout:%5d TBout:%5d\nIssue info: \t | issueArdy:%1b \t issueBrdy:%1b \t cdbAidx/enable:%6d/%1d \t cdbBidx/enable:%6d/%1d\n\
Outputs: \t | robAout:%6d \t robBout:%6d \t full:%1b \t almostfull:%1b \t\n \t \t | multfree:%2b \t multfree1:%2b \t alufree:%2b \t alufree1:%2b\n\
 \t \t | IRA_out:%s \t \t IRB_out:%s", 
    pipeline_0.rs_0.initFreeA, pipeline_0.rs_0.initFreeB, pipeline_0.rs_0.allocA, pipeline_0.rs_0.allocB,
    pipeline_0.rs_0.free, pipeline_0.rs_T1A_out,pipeline_0.rs_T2A_out,pipeline_0.rs_T1B_out,pipeline_0.rs_T2B_out, pipeline_0.rs_TA_out, pipeline_0.rs_TB_out,
    pipeline_0.rs_issueArdy_out, pipeline_0.rs_issueBrdy_out,
    pipeline_0.exA_pr_idx_out, pipeline_0.exA_en_out, pipeline_0.exB_pr_idx_out, pipeline_0.exB_en_out,
    pipeline_0.rs_rob_idxA_out, pipeline_0.rs_rob_idxB_out,
    pipeline_0.rs_busy_out, pipeline_0.rs_almostFull_out,
    pipeline_0.rs_0.multfree, pipeline_0.rs_0.multfree1,
    pipeline_0.rs_0.alufree,pipeline_0.rs_0.alufree1,
    check_opcode(pipeline_0.rs_0.rs_IRA_out),
    check_opcode(pipeline_0.rs_0.rs_IRB_out));
  
  $fdisplay(rs_fileno,"==================================================================================================================================================================================================================================================");
  $fdisplay(rs_fileno,"| \t busy \t | \t     t \t \t | \t     t1 + \t | \t     t2 + \t | \t ROB# \t | \t \t instr \t | \t alu_func \t |   select_1 \t |   select_2 \t | \t NPC \t\t | LogReg \t | LQ/SQIdx \t |\n\
==================================================================================================================================================================================================================================================");
  for (i=0;i<8;i=i+1) begin
  str = check_opcode(pipeline_0.rs_0.instr[i]);
    $fdisplay(rs_fileno,"|\t %8b \t | \t %6d \t | \t %6d %1b \t | \t %6d %1b \t | \t %5d \t | \t %s \t | \t %5b \t \t | \t %2b \t | \t %2b \t | %64h\t | \t %5d \t | \t %2d/%2d \t |",
        pipeline_0.rs_0.busy[i], pipeline_0.rs_0.t[i], pipeline_0.rs_0.t1[i][6:1], pipeline_0.rs_0.t1[i][0], pipeline_0.rs_0.t2[i][6:1], pipeline_0.rs_0.t2[i][0], pipeline_0.rs_0.robIdx[i],str,
        pipeline_0.rs_0.alu_func[i], pipeline_0.rs_0.op1_select[i], pipeline_0.rs_0.op2_select[i], pipeline_0.rs_0.npc[i], pipeline_0.rs_0.archIdx[i],
        pipeline_0.rs_0.lq_idx[i], pipeline_0.rs_0.sq_idx[i]);
  end
  $fdisplay(rs_fileno,"--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");

  //freelist-writing
  $fdisplay(fl_fileno,"CC %0d:", clocks);
  $fdisplay(fl_fileno,"freelist_TA:%6d \t freelist_TB:%6d \t full:%1b \t empty:%1b \t almost_empty:%1b \t br_recover_head:%5d \t br_recover_en:%1b",
    pipeline_0.rob_connect_0.freelist_0.fl_TA,pipeline_0.rob_connect_0.freelist_0.fl_TB,
    pipeline_0.rob_connect_0.freelist_0.full,pipeline_0.rob_connect_0.freelist_0.empty,
    pipeline_0.rob_connect_0.freelist_0.almost_empty,
    pipeline_0.rob_connect_0.freelist_0.branch_recovery_head,
    pipeline_0.rob_connect_0.freelist_0.branch_recovery_en);
  $fdisplay(fl_fileno,"==========================================================");
  $fdisplay(fl_fileno,"|    ht pos \t | \t PR#(Idx#) \t | \t valid \t |\n\
==========================================================");
  for (i=0;i<32;i=i+1) begin
    if (pipeline_0.rob_connect_0.freelist_0.head==i && pipeline_0.rob_connect_0.freelist_0.tail==i) begin
    $fdisplay(fl_fileno,"| \t ht \t | \t %6d(%2d) \t | \t %1b \t |",
        pipeline_0.rob_connect_0.freelist_0.freelist[i], i, pipeline_0.rob_connect_0.freelist_0.valid[i]);
    end
    else if (pipeline_0.rob_connect_0.freelist_0.head==i) begin
    $fdisplay(fl_fileno,"| \t h \t | \t %6d(%2d) \t | \t %1b \t |",
        pipeline_0.rob_connect_0.freelist_0.freelist[i], i, pipeline_0.rob_connect_0.freelist_0.valid[i]);
    end
    else if (pipeline_0.rob_connect_0.freelist_0.tail==i) begin
    $fdisplay(fl_fileno,"| \t t \t | \t %6d(%2d) \t | \t %1b \t |",
        pipeline_0.rob_connect_0.freelist_0.freelist[i], i, pipeline_0.rob_connect_0.freelist_0.valid[i]);
    end
    else begin
    $fdisplay(fl_fileno,"| \t   \t | \t %6d(%2d) \t | \t %1b \t |",
        pipeline_0.rob_connect_0.freelist_0.freelist[i], i, pipeline_0.rob_connect_0.freelist_0.valid[i]);
    end
  end
  $fdisplay(fl_fileno,"----------------------------------------------------------\n");

  //maptable-writing
   $fdisplay(mt_fileno,"CC %0d:", clocks);
   $fdisplay(mt_fileno,"==========================================");
   $fdisplay(mt_fileno,"|      LogReg \t |      Phys Reg (rdy) \t |");
   $fdisplay(mt_fileno,"==========================================");
   for (i=0;i<'d32;i=i+1) begin
     $fdisplay(mt_fileno,"| \t %5d \t | \t %5d (%1d) \t |", i, pipeline_0.rob_connect_0.maptable_0.mt_reg[i][6:1], pipeline_0.rob_connect_0.maptable_0.mt_reg[i][0]);
   end
   $fdisplay(mt_fileno,"------------------------------------------\n");

   //execute pipeline-writing
   $fdisplay(ex_fileno, "CC %0d:  opa+opb_1:%h    opa+opb_2:%h ", clocks,
    pipeline_0.ex_pipeline_0.aluA.opa_mux_out+pipeline_0.ex_pipeline_0.aluA.opb_mux_out,
    pipeline_0.ex_pipeline_0.aluB.opa_mux_out+pipeline_0.ex_pipeline_0.aluB.opb_mux_out);
   $fdisplay(ex_fileno, "==================================================================================================================================");
   $fdisplay(ex_fileno, "| \t Result ALUa (PC Reg) \t | \t Result ALUb (PC Reg) \t | \t Result MultA (PC Reg) \t | Result MultB (PC Reg) \t |");
   $fdisplay(ex_fileno, "==================================================================================================================================");
   $fdisplay(ex_fileno, "|%d(%d) \t |%d(%d) \t |%d(%d) \t |%d(%d) \t |", 
    pipeline_commit_wr_dataA,
    pipeline_commit_wr_idxA,
    pipeline_commit_wr_dataB,
    pipeline_commit_wr_idxB,
    pipeline_commit_wr_dataC,
    pipeline_commit_wr_idxC,
    pipeline_commit_wr_dataD,
    pipeline_commit_wr_idxD);
   $fdisplay(ex_fileno, "==================================================================================================================================\n");

   //physical register-writing
   if (pipeline_0.pr_0.wr_cdbAIdx_en==0 || pipeline_0.pr_0.wr_cdbAIdx_en==1) 
      num_write = num_write + pipeline_0.pr_0.wr_cdbAIdx_en + pipeline_0.pr_0.wr_cdbBIdx_en + pipeline_0.pr_0.wr_cdbCIdx_en + pipeline_0.pr_0.wr_cdbDIdx_en;
   $fdisplay(pr_fileno, "CC %0d: \t wr_enABCD:%1b %1b %1b %1b \t num_write:%0d" , clocks, 
    pipeline_0.pr_0.wr_cdbAIdx_en, pipeline_0.pr_0.wr_cdbBIdx_en, pipeline_0.pr_0.wr_cdbCIdx_en, pipeline_0.pr_0.wr_cdbDIdx_en,
    num_write);
   $fdisplay(pr_fileno, "==================================================================================================");
   $fdisplay(pr_fileno, "| \t PR#1A\t \t | \t PR#2A\t \t | \t PR#1B\t \t  | \t PR#2B\t \t |");
   $fdisplay(pr_fileno, "==================================================================================================");
   $fdisplay(pr_fileno, "|%d \t |%d \t |%d \t |%d \t |",
    pipeline_0.pr_0.pr_T1A_out,
    pipeline_0.pr_0.pr_T2A_out,
    pipeline_0.pr_0.pr_T1B_out,
    pipeline_0.pr_0.pr_T2B_out);   
   $fdisplay(pr_fileno, "==================================================================================================\n");

   $fdisplay(pr_fileno, "==========================================================");
   $fdisplay(pr_fileno, "| \t PR# \t\t | \t\t Value \t\t |");
   $fdisplay(pr_fileno, "==========================================================");
   for (i=0;i<'d64;i=i+1) begin
      $fdisplay(pr_fileno, "| \t %d \t | \t %h \t |",
        i, pipeline_0.pr_0.registers[i]);
   end
   $fdisplay(pr_fileno, "==========================================================\n");

   //arch table register-wrigin
   $fdisplay(ar_fileno, "CC %0d:", clocks);
   $fdisplay(ar_fileno, "===========================================");
   $fdisplay(ar_fileno, "| \t Arch Entry \t | AR->PR mapping |");
   $fdisplay(ar_fileno, "===========================================");
   for (i=0;i<'d32;i=i+1) begin
    $fdisplay(ar_fileno, "| \t %d \t | \t %d \t  |", i, pipeline_0.rob_connect_0.archtable_0.at_reg[i]);
   end
   $fdisplay(ar_fileno, "===========================================\n");

   //BTB-writing
   $fdisplay(btb_fileno, "CC %0d: deleteHitA=%1b deleteHitB=%1b, delete0_en=%1b, delete1_en=%1b",
    clocks,
    pipeline_0.if_id_0.if_0.BTB_1.delete_hitA,
    pipeline_0.if_id_0.if_0.BTB_1.delete_hitB,
    pipeline_0.if_id_0.if_0.BTB_1.delete0_en,
    pipeline_0.if_id_0.if_0.BTB_1.delete1_en);
   $fdisplay(btb_fileno, "==================================================================================================");
   $fdisplay(btb_fileno,"| \t Index \t | \t TargPC(decimal) \t | \t\t tags \t\t | \t valid \t |");
   $fdisplay(btb_fileno, "==================================================================================================");
   for (i=0;i<'d16;i=i+1) begin
    $fdisplay(btb_fileno, "| \t %5d \t | %d \t | \t %h \t | \t %b \t |",
      i,
      pipeline_0.if_id_0.if_0.BTB_1.data[i],
      pipeline_0.if_id_0.if_0.BTB_1.tags[i],
      pipeline_0.if_id_0.if_0.BTB_1.valids[i]);
   end
   $fdisplay(btb_fileno, "==================================================================================================");

   //bs-writing
   $fdisplay(bs_fileno, "CC %0d: rob_broadcast_in:%5d", clocks, pipeline_0.rob_connect_0.bs_0.rob_broadcastA_in);
   $fdisplay(bs_fileno, "==================================");
   $fdisplay(bs_fileno, "| \t Index \t | fl_head \t | ");
   $fdisplay(bs_fileno, "==================================");
   for (i=0; i<'d32;i=i+1) begin
    $fdisplay(bs_fileno,"| \t %5d \t | \t %5d \t |",
      i,
      pipeline_0.rob_connect_0.bs_0.fl_head[i]);
   end
   $fdisplay(bs_fileno, "==================================\n");

   //sq writing
   if ((pipeline_0.stq_0.next_head == pipeline_0.stq_0.head)==1 || (pipeline_0.stq_0.next_head == pipeline_0.stq_0.head)==0)
      num_save = num_save + pipeline_0.stq_0.ROB2SQ_retire_en;
   $fdisplay(sq_fileno, "CC %0d: Num_saves:%0d", clocks, num_save);
   $fdisplay(sq_fileno, "AlmostFull:%1b \t Full:%1b \t Recover: %1b", pipeline_0.stq_0.SQ_almost_full, pipeline_0.stq_0.SQ_full, pipeline_0.stq_0.branch_recovery);
   $fdisplay(sq_fileno, "==========================================================================================================================================");
   $fdisplay(sq_fileno, "|  ht pos (Index) \t | \t Store Addr \t\t | \t Store data \t\t | \t Busy \t | Addr_valid \t | data_valid \t |");
   $fdisplay(sq_fileno, "==========================================================================================================================================");
   for (i=0; i<'d8; i=i+1) begin
      if (pipeline_0.stq_0.head==i && pipeline_0.stq_0.tail==i) begin
       $fdisplay(sq_fileno,"| ht \t\t(%2d)\t | \t %h \t | \t %h \t | \t %b \t | \t %b \t | \t %b \t |",
           i, pipeline_0.stq_0.store_addr[i], pipeline_0.stq_0.store_data[i], pipeline_0.stq_0.busy[i],pipeline_0.stq_0.addr_valid[i],pipeline_0.stq_0.data_valid[i]);
       end
       else if (pipeline_0.stq_0.head==i) begin
       $fdisplay(sq_fileno,"| h \t\t(%2d) \t | \t %h \t | \t %h \t | \t %b \t | \t %b \t | \t %b \t |",
           i, pipeline_0.stq_0.store_addr[i], pipeline_0.stq_0.store_data[i], pipeline_0.stq_0.busy[i],pipeline_0.stq_0.addr_valid[i],pipeline_0.stq_0.data_valid[i]);
       end
       else if (pipeline_0.stq_0.tail==i) begin
       $fdisplay(sq_fileno,"| t \t\t(%2d) \t | \t %h \t | \t %h \t | \t %b \t | \t %b \t | \t %b \t |",
           i, pipeline_0.stq_0.store_addr[i], pipeline_0.stq_0.store_data[i], pipeline_0.stq_0.busy[i],pipeline_0.stq_0.addr_valid[i],pipeline_0.stq_0.data_valid[i]);
       end
       else begin
       $fdisplay(sq_fileno,"| \t\t(%2d) \t | \t %h \t | \t %h \t | \t %b \t | \t %b \t | \t %b \t |",
           i, pipeline_0.stq_0.store_addr[i], pipeline_0.stq_0.store_data[i], pipeline_0.stq_0.busy[i],pipeline_0.stq_0.addr_valid[i],pipeline_0.stq_0.data_valid[i]);
       end
   end
   $fdisplay(sq_fileno, "==========================================================================================================================================\n");
  
   //lq writing
   $fdisplay(lq_fileno, "CC %0d:   RetireHead:%1b", clocks, pipeline_0.ldq_0.retire_head_en);
   $fdisplay(lq_fileno, "AlmostFull:%1b \t Full:%1b", pipeline_0.ldq_0.ldq_almostfull_out, pipeline_0.ldq_0.ldq_full_out);
   $fdisplay(lq_fileno, "==========================================================================================================================================================");
   $fdisplay(lq_fileno, "|  ht pos (Index) \t | \t Load Addr \t\t | \t Load data \t\t | \t Ready \t | stq_pend \t | alr_req \t | mem_valid \t | ");
   $fdisplay(lq_fileno, "==========================================================================================================================================================");
   for (i=0; i<'d8; i=i+1) begin
      if (pipeline_0.ldq_0.head==i && pipeline_0.ldq_0.tail==i) begin
       $fdisplay(lq_fileno,"| ht(%2d) \t\t | \t %h \t | \t %d \t | \t %1b \t | \t %1b \t | \t %1b \t | \t %1b \t |",
           i, pipeline_0.ldq_0.ldq_addr[i], pipeline_0.ldq_0.ldq_data[i], pipeline_0.ldq_0.ready[i],
           pipeline_0.ldq_0.stq_pending_rdy[i],
           pipeline_0.ldq_0.already_req[i],
           pipeline_0.ldq_0.mem_valid[i],
           );
       end
       else if (pipeline_0.ldq_0.head==i) begin
       $fdisplay(lq_fileno,"| \t h(%2d) \t\t | \t %h \t | \t %d \t | \t %1b \t | \t %1b \t | \t %1b \t | \t %1b \t |",
           i, pipeline_0.ldq_0.ldq_addr[i], pipeline_0.ldq_0.ldq_data[i], pipeline_0.ldq_0.ready[i],
           pipeline_0.ldq_0.stq_pending_rdy[i],
           pipeline_0.ldq_0.already_req[i],
           pipeline_0.ldq_0.mem_valid[i],
           );
       end
       else if (pipeline_0.ldq_0.tail==i) begin
       $fdisplay(lq_fileno,"| \t t(%2d) \t\t | \t %h \t | \t %d \t | \t %1b \t | \t %1b \t | \t %1b \t | \t %1b \t |",
           i, pipeline_0.ldq_0.ldq_addr[i], pipeline_0.ldq_0.ldq_data[i], pipeline_0.ldq_0.ready[i],
           pipeline_0.ldq_0.stq_pending_rdy[i],
           pipeline_0.ldq_0.already_req[i],
           pipeline_0.ldq_0.mem_valid[i],
           );
       end
       else begin
       $fdisplay(lq_fileno,"| \t (%2d) \t\t | \t %h \t | \t %d \t | \t %1b \t | \t %1b \t | \t %1b \t | \t %1b \t |",
           i, pipeline_0.ldq_0.ldq_addr[i], pipeline_0.ldq_0.ldq_data[i], pipeline_0.ldq_0.ready[i],
           pipeline_0.ldq_0.stq_pending_rdy[i],
           pipeline_0.ldq_0.already_req[i],
           pipeline_0.ldq_0.mem_valid[i],
           );
       end
   end
   $fdisplay(lq_fileno, "==========================================================================================================================================================\n");

   //ras writing

   //mem writing
   if (proc2mem_command==`BUS_LOAD | proc2mem_command==`BUS_STORE) begin
      if (proc2mem_command==`BUS_LOAD)
        $fdisplay(mem_fileno, "BUS_LOAD MEM[%0d] accepted %1d", proc2mem_addr, mem2proc_response);
      if (proc2mem_command==`BUS_STORE)
        $fdisplay(mem_fileno, "BUS_STORE MEM[%0d] = %0d accepted %1d", proc2mem_addr, proc2mem_data, mem2proc_response);

   end
   if (pipeline_0.ex_pipeline_0.exA_branch_mistaken_out == 1 || pipeline_0.ex_pipeline_0.exA_branch_mistaken_out == 0 ) begin
      mispredict_count <= mispredict_count + 
         (pipeline_0.ex_pipeline_0.exA_branch_mistaken_out ||
           pipeline_0.ex_pipeline_0.exA_branch_still_taken_out ||
           pipeline_0.ex_pipeline_0.exA_mispredicted_out) +
         (pipeline_0.ex_pipeline_0.exB_branch_mistaken_out ||
           pipeline_0.ex_pipeline_0.exB_branch_still_taken_out ||
           pipeline_0.ex_pipeline_0.exB_mispredicted_out);
    end

   if (pipeline_0.ex_pipeline_0.exA_cond_branch_out ==1 || pipeline_0.ex_pipeline_0.exA_cond_branch_out ==0) begin
      total_branch_count <= total_branch_count + 
         (pipeline_0.ex_pipeline_0.exA_cond_branch_out | pipeline_0.ex_pipeline_0.exA_uncond_branch_out) +
         (pipeline_0.ex_pipeline_0.exB_cond_branch_out | pipeline_0.ex_pipeline_0.exB_uncond_branch_out);
    end
	if (pipeline_0.rob_connect_0.rob_0.rob_one_inst_out==0 || pipeline_0.rob_connect_0.rob_0.rob_one_inst_out==1'b1)
		robfull_count <= robfull_count + 
			(pipeline_0.rob_connect_0.rob_0.rob_one_inst_out | pipeline_0.rob_connect_0.rob_0.rob_none_inst_out);
	if (pipeline_0.rs_0.rs_busy_out==0 || pipeline_0.rs_0.rs_busy_out==1'b1)
		rsfull_count <= rsfull_count + 	
			(pipeline_0.rs_0.rs_busy_out | pipeline_0.rs_0.rs_almostFull_out);
	if (pipeline_0.ldq_0.ldq_full_out==0 || pipeline_0.ldq_0.ldq_full_out==1'b1)
		lqfull_count <= lqfull_count + 	
			(pipeline_0.ldq_0.ldq_almostfull_out | pipeline_0.ldq_0.ldq_full_out);
	if (pipeline_0.stq_0.SQ_full==0 || pipeline_0.stq_0.SQ_full==1'b1)
		sqfull_count <= sqfull_count + 	
			(pipeline_0.stq_0.SQ_almost_full | pipeline_0.stq_0.SQ_full);
   
	if (pipeline_0.if_id_0.if_0.stall==0 || pipeline_0.if_id_0.if_0.stall==1'b1)
		ifstall_count <= ifstall_count + pipeline_0.if_id_0.if_0.stall;
          // print_membus({30'b0,proc2mem_command}, {28'b0,mem2proc_response},
          //           proc2mem_addr[63:32], proc2mem_addr[31:0],
          //           proc2mem_data[63:32], proc2mem_data[31:0]);
   

`endif
end

`ifdef DEBUG_OUT
  always @(posedge clock) begin
    if ($past(pipeline_0.rob_connect_0.rob_0.head_incr_one_en) && ~$past(pipeline_0.rob_connect_0.rob_0.head_incr_two_en))
      retire_count <= retire_count + 1;
    else if ($past(pipeline_0.rob_connect_0.rob_0.head_incr_two_en))
      retire_count <= retire_count + 2;

  end
`ifdef TIMEOUT  
  always @(negedge clock) begin

    if (retire_count > 'd20001) begin
      force pipeline_error_status = `HALTED_ON_HALT;
      prediction_accuracy = (total_branch_count-mispredict_count + 0.0) / total_branch_count;
      $fdisplay(analysis_fileno,"Prediction accuracy = %0d/%0d = %f", total_branch_count-mispredict_count, total_branch_count,
        prediction_accuracy);
	robfull_ratio = (robfull_count + 0.0) / clocks;
	$fdisplay(analysis_fileno,"Rob is full for this fraction of the test: = %0d/%0d = %f",robfull_count,clocks,robfull_ratio );
	rsfull_ratio = (rsfull_count + 0.0) / clocks;
	$fdisplay(analysis_fileno,"RS is full for this fraction of the test: = %0d/%0d = %f",rsfull_count,clocks,rsfull_ratio );
	lqfull_ratio = (lqfull_count + 0.0) / clocks;
	$fdisplay(analysis_fileno,"LQ is full for this fraction of the test: = %0d/%0d = %f",lqfull_count,clocks,lqfull_ratio );
	sqfull_ratio = (sqfull_count + 0.0) / clocks;
	$fdisplay(analysis_fileno,"SQ is full for this fraction of the test: = %0d/%0d = %f",sqfull_count,clocks,sqfull_ratio );
	ifstall_ratio = (ifstall_count + 0.0) / clocks;
	$fdisplay(analysis_fileno,"IF stalls for this fraction of the test: = %0d/%0d = %f",ifstall_count,clocks,ifstall_ratio );
      #100  $finish;
    end
  end
`endif
`endif
always @(negedge clock)
begin
  if(reset)
    $display("@@\n@@  %t : System STILL at reset, can't show anything\n@@",
             $realtime);
  else
  begin
    `SD;
    `SD;
    //done later when X actually gives right stuff.
    //writeback information--print if anything has completed
`ifdef DEBUG_OUT
    if ((pipeline_completed_instA | pipeline_completed_instB | pipeline_completed_instC | pipeline_completed_instD)>0) begin
      if (pipeline_commit_wr_enA) $fdisplay(wb_fileno, "PC=%x, REG[%d]=%x CC:%0d", pipeline_0.exA_NPC_out -4, pipeline_commit_wr_idxA, pipeline_commit_wr_dataA, clocks);
      if (pipeline_commit_wr_enB) $fdisplay(wb_fileno, "PC=%x, REG[%d]=%x CC:%0d", pipeline_0.exB_NPC_out -4, pipeline_commit_wr_idxB, pipeline_commit_wr_dataB, clocks);
      if (pipeline_commit_wr_enC) $fdisplay(wb_fileno, "PC=%x, REG[%d]=%x CC:%0d", pipeline_0.exC_NPC_out - 4, pipeline_commit_wr_idxC, pipeline_commit_wr_dataC, clocks);
      if (pipeline_commit_wr_enD) $fdisplay(wb_fileno, "PC=%x, REG[%d]=%x CC:%0d", pipeline_0.exD_NPC_out - 4, pipeline_commit_wr_idxD, pipeline_commit_wr_dataD, clocks);
      if (~pipeline_commit_wr_enA & ~pipeline_commit_wr_enB & ~pipeline_commit_wr_enC & ~pipeline_commit_wr_enD) begin // didn't write anything
        if (~pipeline_commit_wr_enA) $fdisplay(wb_fileno, "PC=%x, --- CC:%0d", pipeline_0.exA_NPC_out -4 , clocks);
        if (~pipeline_commit_wr_enB) $fdisplay(wb_fileno, "PC=%x, --- CC:%0d", pipeline_0.exB_NPC_out -4 , clocks);
        if (~pipeline_commit_wr_enC) $fdisplay(wb_fileno, "PC=%x, --- CC:%0d", pipeline_0.exC_NPC_out - 4, clocks);
        if (~pipeline_commit_wr_enD) $fdisplay(wb_fileno, "PC=%x, --- CC:%0d", pipeline_0.exD_NPC_out - 4, clocks);
      end
    end
`endif

    //memory-writing
    if(pipeline_error_status!=`NO_ERROR)
    begin
      $display("@@@ Unified Memory contents hex on left, decimal on right: ");
      show_mem_with_decimal(0,`MEM_64BIT_LINES - 1); 
        // 8Bytes per line, 16kB total
  
        $display("@@  %t : System halted\n@@", $realtime);
  
        case(pipeline_error_status)
          `HALTED_ON_MEMORY_ERROR:  
              $display("@@@ System halted on memory error");
          `HALTED_ON_HALT:          
              $display("@@@ System halted on HALT instruction");
          `HALTED_ON_ILLEGAL:
              $display("@@@ System halted on illegal instruction");
          default: 
              $display("@@@ System halted on unknown error code %x",
                       pipeline_error_status);
        endcase
        $display("@@@\n@@");
        show_clk_count;
        $fclose(rob_fileno);
        $fclose(rs_fileno);
        $fclose(fl_fileno);
        $fclose(mt_fileno);
        $fclose(wb_fileno);
        $fclose(ex_fileno);
        $fclose(pr_fileno);
        $fclose(ar_fileno);
        $fclose(btb_fileno);
        $fclose(bs_fileno);
        $fclose(monitor_fileno);
        $fclose(sq_fileno);
        $fclose(lq_fileno);
        $fclose(mem_fileno);
        $fclose(ras_fileno);
        $fclose(commit_fileno);
        $fclose(commitTime_fileno);
        $fclose(pcplus4_fileno);
        $fclose(pcplus4time_fileno);

        prediction_accuracy = (total_branch_count-mispredict_count + 0.0) / total_branch_count;
        $fdisplay(analysis_fileno,"Prediction accuracy = %0d/%0d = %f", total_branch_count-mispredict_count, total_branch_count,
           prediction_accuracy);
	robfull_ratio = (robfull_count + 0.0) / clocks;
	$fdisplay(analysis_fileno,"Rob is full for this fraction of the test: = %0d/%0d = %f",robfull_count,clocks,robfull_ratio );
	rsfull_ratio = (rsfull_count + 0.0) / clocks;
	$fdisplay(analysis_fileno,"RS is full for this fraction of the test: = %0d/%0d = %f",rsfull_count,clocks,rsfull_ratio );
	lqfull_ratio = (lqfull_count + 0.0) / clocks;
	$fdisplay(analysis_fileno,"LQ is full for this fraction of the test: = %0d/%0d = %f",lqfull_count,clocks,lqfull_ratio );
	sqfull_ratio = (sqfull_count + 0.0) / clocks;
	$fdisplay(analysis_fileno,"SQ is full for this fraction of the test: = %0d/%0d = %f",sqfull_count,clocks,sqfull_ratio );
	ifstall_ratio = (ifstall_count + 0.0) / clocks;
	$fdisplay(analysis_fileno,"IF stalls for this fraction of the test: = %0d/%0d = %f",ifstall_count,clocks,ifstall_ratio );
        $fclose(analysis_fileno);
        $finish;
    end
  end //reset
end //always negedge

task show_mem_with_decimal;
        input [31:0] start_addr;
        input [31:0] end_addr;
        integer k;
        integer showing_data;
        begin
        $display("@@@");
        showing_data=0;
        for(k=start_addr;k<=end_addr; k=k+1)
        if (memory.unified_memory[k] != 0)
        begin
        $display("@@@ mem[%5d] = %x : %0d", k*8, memory.unified_memory[k],
                                              memory.unified_memory[k]);
        showing_data=1;
        end
        else if(showing_data!=0)
        begin
        $display("@@@");
        showing_data=0;
        end
        $display("@@@");
        end
 endtask


task show_clk_count;
  real cpi;
  begin
`ifdef DEBUG_OUT
  retire_count = retire_count + (pipeline_error_status==`HALTED_ON_HALT);
  cpi = (clocks + 1.0) / retire_count;
    $display("@@  %0d cycles / %0d instrs = %f CPI\n@@",
      clocks+1, retire_count, cpi);
         $display("@@  %4.2f ns total time to execute\n@@\n",
                  clocks*`VIRTUAL_CLOCK_PERIOD);
`else
  instr_count = instr_count + (pipeline_error_status==`HALTED_ON_HALT);
  cpi = (clocks + 1.0) / instr_count;
    $display("@@  %0d cycles / %0d instrs = %f CPI\n@@",
      clocks+1, instr_count, cpi);
         $display("@@  %4.2f ns total time to execute\n@@\n",
                  clocks*`VIRTUAL_CLOCK_PERIOD);
`endif 
  end


endtask



function [8*21:0] check_opcode;
input [31:0] inst;

reg [31:0] opcode;
reg [31:0] check;
begin
    opcode = (inst >> 26) & 32'h0000003f;
    check = (inst>>5) & 32'h0000007f;
    case (opcode)
      32'h00: check_opcode = (inst == 32'h555) ? "halt" : "call_pal"; 
      32'h08: check_opcode = "lda"; 
      32'h09: check_opcode = "ldah"; 
      32'h0a: check_opcode = "ldbu"; 
      32'h0b: check_opcode = "ldqu"; 
      32'h0c: check_opcode = "ldwu"; 
      32'h0d: check_opcode = "stw"; 
      32'h0e: check_opcode = "stb"; 
      32'h0f: check_opcode = "stqu"; 

      32'h10: // INTA_GRP
         case(check)
           32'h00: check_opcode = "addl"; 
           32'h02: check_opcode = "s4addl"; 
           32'h09: check_opcode = "subl"; 
           32'h0b: check_opcode = "s4subl"; 
           32'h0f: check_opcode = "cmpbge"; 
           32'h12: check_opcode = "s8addl"; 
           32'h1b: check_opcode = "s8subl"; 
           32'h1d: check_opcode = "cmpult"; 
           32'h20: check_opcode = "addq"; 
           32'h22: check_opcode = "s4addq"; 
           32'h29: check_opcode = "subq"; 
           32'h2b: check_opcode = "s4subq"; 
           32'h2d: check_opcode = "cmpeq"; 
           32'h32: check_opcode = "s8addq"; 
           32'h3b: check_opcode = "s8subq"; 
           32'h3d: check_opcode = "cmpule"; 
           32'h40: check_opcode = "addlv"; 
           32'h49: check_opcode = "sublv"; 
           32'h4d: check_opcode = "cmplt"; 
           32'h60: check_opcode = "addqv"; 
           32'h69: check_opcode = "subqv"; 
           32'h6d: check_opcode = "cmple"; 
           default: check_opcode = "invalid"; 
         endcase
         
      32'h11: // INTL_GRP
         case(check)
           32'h00: check_opcode = "and"; 
           32'h08: check_opcode = "bic"; 
           32'h14: check_opcode = "cmovlbs"; 
           32'h16: check_opcode = "cmovlbc"; 
           32'h20: check_opcode = "bis"; 
           32'h24: check_opcode = "cmoveq"; 
           32'h26: check_opcode = "cmovne"; 
           32'h28: check_opcode = "ornot"; 
           32'h40: check_opcode = "xor"; 
           32'h44: check_opcode = "cmovlt"; 
           32'h46: check_opcode = "cmovge"; 
           32'h48: check_opcode = "eqv"; 
           32'h61: check_opcode = "amask"; 
           32'h64: check_opcode = "cmovle"; 
           32'h66: check_opcode = "cmovgt"; 
           32'h6c: check_opcode = "implver"; 
           default: check_opcode = "invalid"; 
         endcase
         
      32'h12: // INTS_GRP
         case(check)
           32'h02: check_opcode = "mskbl"; 
           32'h06: check_opcode = "extbl"; 
           32'h0b: check_opcode = "insbl"; 
           32'h12: check_opcode = "mskwl"; 
           32'h16: check_opcode = "extwl"; 
           32'h1b: check_opcode = "inswl"; 
           32'h22: check_opcode = "mskll"; 
           32'h26: check_opcode = "extll"; 
           32'h2b: check_opcode = "insll"; 
           32'h30: check_opcode = "zap"; 
           32'h31: check_opcode = "zapnot"; 
           32'h32: check_opcode = "mskql"; 
           32'h34: check_opcode = "srl"; 
           32'h36: check_opcode = "extql"; 
           32'h39: check_opcode = "sll"; 
           32'h3b: check_opcode = "insql"; 
           32'h3c: check_opcode = "sra"; 
           32'h52: check_opcode = "mskwh"; 
           32'h57: check_opcode = "inswh"; 
           32'h5a: check_opcode = "extwh"; 
           32'h62: check_opcode = "msklh"; 
           32'h67: check_opcode = "inslh"; 
           32'h6a: check_opcode = "extlh"; 
           32'h72: check_opcode = "mskqh"; 
           32'h77: check_opcode = "insqh"; 
           32'h7a: check_opcode = "extqh"; 
           default: check_opcode = "invalid"; 
         endcase
         
      32'h13: // INTM_GRP
         case(check)
           32'h00: check_opcode = "mull"; 
           32'h20: check_opcode = "mulq"; 
           32'h30: check_opcode = "umulh"; 
           32'h40: check_opcode = "mullv"; 
           32'h60: check_opcode = "mulqv"; 
           default: check_opcode = "invalid"; 
         endcase
         
      32'h14: check_opcode = "itfp";  // unimplemented
      32'h15: check_opcode = "fltv";  // unimplemented
      32'h16: check_opcode = "flti";  // unimplemented
      32'h17: check_opcode = "fltl";  // unimplemented
      32'h1a: check_opcode = "jsr"; 
      32'h1c: check_opcode = "ftpi"; 
      32'h20: check_opcode = "ldf"; 
      32'h21: check_opcode = "ldg"; 
      32'h22: check_opcode = "lds"; 
      32'h23: check_opcode = "ldt"; 
      32'h24: check_opcode = "stf"; 
      32'h25: check_opcode = "stg"; 
      32'h26: check_opcode = "sts"; 
      32'h27: check_opcode = "stt"; 
      32'h28: check_opcode = "ldl"; 
      32'h29: check_opcode = "ldq"; 
      32'h2a: check_opcode = "ldll"; 
      32'h2b: check_opcode = "ldql"; 
      32'h2c: check_opcode = "stl"; 
      32'h2d: check_opcode = "stq"; 
      32'h2e: check_opcode = "stlc"; 
      32'h2f: check_opcode = "stqc"; 
      32'h30: check_opcode = "br"; 
      32'h31: check_opcode = "fbeq"; 
      32'h32: check_opcode = "fblt"; 
      32'h33: check_opcode = "fble"; 
      32'h34: check_opcode = "bsr"; 
      32'h35: check_opcode = "fbne"; 
      32'h36: check_opcode = "fbge"; 
      32'h37: check_opcode = "fbgt"; 
      32'h38: check_opcode = "blbc"; 
      32'h39: check_opcode = "beq"; 
      32'h3a: check_opcode = "blt"; 
      32'h3b: check_opcode = "ble"; 
      32'h3c: check_opcode = "blbs"; 
      32'h3d: check_opcode = "bne"; 
      32'h3e: check_opcode = "bge"; 
      32'h3f: check_opcode = "bgt"; 
      default: check_opcode = "invalid"; 
  endcase //opcode
end
endfunction //end check_opcode.
endmodule 

















