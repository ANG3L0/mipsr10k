

  module if_id ( //inputs
                   clock,
                   reset, 
                   one_ins_en_in, 
                   non_ins_en_in,
                   Imem2proc_dataA,                     
                   Imem2proc_dataB,  
                                     
                   branch_target_PCA,
                   branch_target_PCB,
                  
                   //access_memory,
                   ex_PCA,
                   ex_PCB,
                   ex_take_branchA,
                   ex_take_branchB,
                   need_take_branchA,
                   need_take_branchB,
                   mispredict_branchA,
                   mispredict_branchB,
                   rob_recover,
                   rs_almost_full,
                   rs_full,
                   IR_validA,
                   IR_validB,
                   fetch_grant,

                   Icache2prefetch_grant,
                   lq_full,
                   lq_almost_full,
                   sq_full,
                   sq_almost_full,
                   
                   load_request,
                   store_request,

                   Icache2proc_addr_outB,
		   rob_retire_enA,
		   rob_retire_enB,

                    // outputs
                   proc2Imem_addr,
                   fetch_request,
           

                   prefetch2Icache_request,
                   prefetch2Icache_addr,
                  
                   id_opa_select_outA_reg,
                   id_opb_select_outA_reg,
                   id_opa_select_outB_reg, 
                   id_opb_select_outB_reg,
                   id_rdaAidx_reg,
                   id_rdbAidx_reg,
                   id_rdaBidx_reg,
                   id_rdbBidx_reg,
                   id_dest_reg_idx_outA_reg,
                   id_dest_reg_idx_outB_reg,
                   id_alu_func_outA_reg,
                   id_alu_func_outB_reg,
                   id_IRA_out_reg,
                   id_IRB_out_reg,
                   id_PCA_out_reg,
                   id_NPCA_out_reg,
                   id_PCB_out_reg,
                   id_NPCB_out_reg,
                   id_IRA_valid_out_reg,
                   id_IRB_valid_out_reg,
                   id_illegal_outA_reg,
                   id_illegal_outB_reg,
                   id_halt_outA_reg,
                   id_halt_outB_reg,
                   id_rd_mem_outA_reg,
                   id_wr_mem_outA_reg,
                   id_cond_branch_outA_reg,
                   id_uncond_branch_outA_reg,
                   id_rd_mem_outB_reg,
                   id_wr_mem_outB_reg,
                   id_cond_branch_outB_reg,
                   id_uncond_branch_outB_reg,
                   id_branch_predictionA_reg,
                   id_branch_predictionB_reg,
		               id_predicted_PCA_reg,
		               id_predicted_PCB_reg
);
    //  inputs
     input  [63:0]      Icache2proc_addr_outB;

     input 		clock;
     input		reset;
     input		one_ins_en_in;
     input		non_ins_en_in;

     input     [63:0]   Imem2proc_dataA;
     input     [63:0]   Imem2proc_dataB;
   

     input     [63:0]   branch_target_PCA;
     input     [63:0]   branch_target_PCB;
    // input              access_memory;
     input     [63:0]   ex_PCA;
     input     [63:0]   ex_PCB;
     input              ex_take_branchA;
     input              ex_take_branchB;
     input              need_take_branchA;
     input              need_take_branchB;
     input              mispredict_branchA;
     input              mispredict_branchB;
     input              rob_recover;
     input              rs_almost_full;
     input              rs_full;
     input              IR_validA;
     input		IR_validB;
     input              fetch_grant;
     input		Icache2prefetch_grant;
     input    lq_full;
     input    lq_almost_full;
     input    sq_full;
     input    sq_almost_full;
     input              load_request;
     input              store_request;
     input		rob_retire_enA;
     input		rob_retire_enB;




     //  outputs
     output    [63:0]   proc2Imem_addr;
     output             fetch_request;
     output reg    [63:0]   id_PCA_out_reg;
     output reg    [63:0]   id_PCB_out_reg;
     output reg    [63:0]   id_NPCA_out_reg;    
     output reg    [63:0]   id_NPCB_out_reg;
     output reg             id_branch_predictionA_reg;
     output reg             id_branch_predictionB_reg;
     output reg    [63:0]   id_predicted_PCA_reg;
     output reg    [63:0]   id_predicted_PCB_reg;
     output reg [1:0] id_opa_select_outA_reg;
     output reg [1:0] id_opb_select_outA_reg;
     output reg [1:0] id_opa_select_outB_reg;
     output reg [1:0] id_opb_select_outB_reg;
     output reg [4:0] id_rdaAidx_reg;
     output reg [4:0] id_rdbAidx_reg;
     output reg [4:0] id_rdaBidx_reg;
     output reg [4:0] id_rdbBidx_reg;
     output reg [4:0] id_dest_reg_idx_outA_reg;
     output reg [4:0] id_dest_reg_idx_outB_reg;
     output reg [4:0] id_alu_func_outA_reg;
     output reg [4:0] id_alu_func_outB_reg;
     output reg [31:0] id_IRA_out_reg;
     output reg [31:0] id_IRB_out_reg;
     output reg id_IRA_valid_out_reg;
     output reg id_IRB_valid_out_reg;
     output reg id_illegal_outA_reg;
     output reg id_illegal_outB_reg;
     output reg id_halt_outA_reg;
     output reg id_halt_outB_reg;
     output reg id_rd_mem_outA_reg;
     output reg id_wr_mem_outA_reg;
     output reg id_cond_branch_outA_reg;
     output reg id_uncond_branch_outA_reg;
     output reg id_rd_mem_outB_reg;
     output reg id_wr_mem_outB_reg;
     output reg id_cond_branch_outB_reg;
     output reg id_uncond_branch_outB_reg;
     output		     prefetch2Icache_request;
     output [63:0]           prefetch2Icache_addr;






     wire    [63:0]   next_PC;  //to prefetch       
     wire     [1:0]   id_opa_select_outA;
     wire     [1:0]   id_opb_select_outA;
     wire     [1:0]   id_opa_select_outB;
     wire     [1:0]   id_opb_select_outB;
     wire     [4:0]   id_rdaAidx;
     wire     [4:0]   id_rdbAidx;
     wire     [4:0]   id_rdaBidx;
     wire     [4:0]   id_rdbBidx;
     wire     [4:0]   id_dest_reg_idx_outA;
     wire     [4:0]   id_dest_reg_idx_outB;
     wire     [4:0]   id_alu_func_outA;
     wire     [4:0]   id_alu_func_outB;
     wire    [31:0]   id_IRA_out;
     wire    [31:0]   id_IRB_out;
     wire             id_IRA_valid_out;
     wire             id_IRB_valid_out;
     wire             id_rd_mem_outA;
     wire             id_wr_mem_outA;
     wire             id_cond_branch_outA;
     wire             id_uncond_branch_outA;
     wire             id_rd_mem_outB;
     wire             id_wr_mem_outB;
     wire             id_cond_branch_outB;
     wire             id_uncond_branch_outB;
     wire	      if_valid_instA_out;
     wire	      if_valid_instB_out;







   // internal signals 
     wire      [31:0]   if_IRA_out; 
     wire      [31:0]   if_IRB_out;     
     wire      [63:0]   if_PCA_out;
     wire      [63:0]   if_PCB_out;
     wire      [63:0]   if_NPCA_out;
     wire      [63:0]   if_NPCB_out;
     wire               branch_predictionA;
     wire               branch_predictionB;
     wire      [63:0]   predicted_PCA;
     wire      [63:0]   predicted_PCB;
     wire               if_stall;

     reg       [31:0]   id_IRA_in;
     reg       [31:0]   id_IRB_in;
     reg                id_valid_instA_in;
     reg                id_valid_instB_in;
     reg       [63:0]   id_PCA_out;
     reg       [63:0]   id_PCB_out; 
     reg       [63:0]   id_NPCA_out;
     reg       [63:0]   id_NPCB_out;
     reg                id_illegal_outA;
     reg                id_illegal_outB;
     reg                id_halt_outA;
     reg                id_halt_outB;

     reg                id_branch_predictionA;
     reg                id_branch_predictionB;
     reg       [63:0]   id_predicted_PCA;
     reg       [63:0]   id_predicted_PCB;

  if_stage if_0 (   // inputs
                 .clock(clock),
                 .reset(reset),
                 .Imem2proc_dataA(Imem2proc_dataA),
                 .Imem2proc_dataB(Imem2proc_dataB),
                 .one_ins_en_in(one_ins_en_in),
                 .non_ins_en_in(non_ins_en_in),
                 .rs_almost_full(rs_almost_full),
                 .rs_full(rs_full),
                 .branch_target_PCA(branch_target_PCA),
                 .branch_target_PCB(branch_target_PCB),
                 .ex_PCA(ex_PCA),
                 .ex_PCB(ex_PCB),
                 .ex_take_branchA(ex_take_branchA),
                 .ex_take_branchB(ex_take_branchB),
                 .need_take_branchA(need_take_branchA),
                 .need_take_branchB(need_take_branchB),
                 .mispredict_branchA(mispredict_branchA),
                 .mispredict_branchB(mispredict_branchB),
                 .rob_recover(rob_recover),
                 .IR_validA(IR_validA),
                 .IR_validB(IR_validB),
                 .fetch_grant(fetch_grant),
                 .lq_full(lq_full),
                 .lq_almost_full(lq_almost_full),
                 .sq_full(sq_full),
                 .sq_almost_full(sq_almost_full),
                 .Icache2proc_addr_outB(Icache2proc_addr_outB),
		 .rob_retire_enA(rob_retire_enA),
		 .rob_retire_enB(rob_retire_enB),

                   // outputs
                 .if_IRA_out(if_IRA_out),
                 .if_IRB_out(if_IRB_out),
                 .if_PCA_out(if_PCA_out),  
                 .if_PCB_out(if_PCB_out),
                 .if_NPCA_out(if_NPCA_out),                
                 .if_NPCB_out(if_NPCB_out),

                 .proc2Imem_addr(proc2Imem_addr),
                 .if_valid_instA_out(if_valid_instA_out),
                 .if_valid_instB_out(if_valid_instB_out),
                 .branch_predictionA(branch_predictionA),
                 .branch_predictionB(branch_predictionB),
                 .predicted_PCA(predicted_PCA),
                 .predicted_PCB(predicted_PCB),
                 .fetch_request(fetch_request),
                 .next_PC(next_PC),
                 .if_stall_out(if_stall)
                 );

   prefetch prefetch_0(
			.clock(clock),
			.reset(reset),
			.grant(Icache2prefetch_grant),
			.PC_reg(if_PCA_out),
			.next_PC(next_PC),
                        .load_request(load_request),
                        .store_request(store_request),
			.request(prefetch2Icache_request),
			.prefetch2Imem_addr(prefetch2Icache_addr)
		   );	

   id_stage id_0 ( // inputs
                  .if_id_IRA(id_IRA_in),
                  .if_id_IRB(id_IRB_in),
                  .if_id_valid_instA(id_valid_instA_in),
                  .if_id_valid_instB(id_valid_instB_in),
                  .almost_full(one_ins_en_in),
                  .full(non_ins_en_in),
                  .rs_full(rs_full),
                  .rs_almost_full(rs_almost_full),
                   // outputs
                  .id_opa_select_outA(id_opa_select_outA),
                  .id_opb_select_outA(id_opb_select_outA),
                  .id_opa_select_outB(id_opa_select_outB),
                  .id_opb_select_outB(id_opb_select_outB),
                  .id_rdaAidx(id_rdaAidx), 
                  .id_rdbAidx(id_rdbAidx),
                  .id_rdaBidx(id_rdaBidx),
                  .id_rdbBidx(id_rdbBidx),
                  .id_dest_reg_idx_outA(id_dest_reg_idx_outA),
                  .id_dest_reg_idx_outB(id_dest_reg_idx_outB),
                  .id_alu_func_outA(id_alu_func_outA),
                  .id_alu_func_outB(id_alu_func_outB),
                  .id_IRA_out(id_IRA_out),
                  .id_IRB_out(id_IRB_out),
                  .id_IRA_valid_out(id_IRA_valid_out),
                  .id_IRB_valid_out(id_IRB_valid_out),
                  .id_illegal_outA(id_illegal_outA),
                  .id_illegal_outB(id_illegal_outB),
                  .id_halt_outA(id_halt_outA),
                  .id_halt_outB(id_halt_outB),
                  .id_rd_mem_outA(id_rd_mem_outA),
                  .id_wr_mem_outA(id_wr_mem_outA),
                  .id_cond_branch_outA(id_cond_branch_outA),
                  .id_uncond_branch_outA(id_uncond_branch_outA),
                  .id_rd_mem_outB(id_rd_mem_outB),
                  .id_wr_mem_outB(id_wr_mem_outB),
                  .id_cond_branch_outB(id_cond_branch_outB),
                  .id_uncond_branch_outB(id_uncond_branch_outB)
); 

//IF/ID register
  always @(posedge clock)
   begin
   if (reset | rob_recover)
   begin
   id_IRA_in 		 <= `SD 32'd0;
   id_IRB_in		 <= `SD 32'd0;
   id_valid_instA_in     <= `SD  1'b0;
   id_valid_instB_in     <= `SD  1'b0;
   id_PCA_out            <= `SD 64'd0;
   id_PCB_out            <= `SD 64'd0;
   id_NPCA_out           <= `SD 64'd0;
   id_NPCB_out           <= `SD 64'd0;
   id_branch_predictionA <= `SD  1'b0;
   id_branch_predictionB <= `SD  1'b0;
   id_predicted_PCA      <= `SD 64'd0;
   id_predicted_PCB      <= `SD 64'd0;

   end 
   else if (~rs_full & ~rs_almost_full & ~one_ins_en_in & ~non_ins_en_in & ~(lq_full || lq_almost_full || sq_full || sq_almost_full))
   begin 
   id_IRA_in             <= `SD if_IRA_out;
   id_IRB_in             <= `SD if_IRB_out;
   id_valid_instA_in     <= `SD if_valid_instA_out;
   id_valid_instB_in     <= `SD if_valid_instB_out;
   id_PCA_out            <= `SD if_PCA_out;
   id_PCB_out            <= `SD if_PCB_out;
   id_NPCA_out           <= `SD if_NPCA_out;
   id_NPCB_out           <= `SD if_NPCB_out;
   id_branch_predictionA <= `SD branch_predictionA;
   id_branch_predictionB <= `SD branch_predictionB;
   id_predicted_PCA      <= `SD predicted_PCA;
   id_predicted_PCB      <= `SD predicted_PCB;
   end
   end 
//ID/Dispatch register
  always @(posedge clock) begin
   if (reset | rob_recover) begin
   id_PCA_out_reg <= `SD 64'd0;
   id_PCB_out_reg <= `SD 64'd0;
   id_NPCA_out_reg <= `SD 64'd0;    
   id_NPCB_out_reg <= `SD 64'd0;
   id_branch_predictionA_reg <= `SD 1'b0;
   id_branch_predictionB_reg <= `SD 1'b0;
   id_predicted_PCA_reg <= `SD 64'd0;
   id_predicted_PCB_reg <= `SD 64'd0;
   id_opa_select_outA_reg <= `SD 0;
   id_opb_select_outA_reg <= `SD 0;
   id_opa_select_outB_reg <= `SD 0;
   id_opb_select_outB_reg <= `SD 0;
   id_rdaAidx_reg <= `SD `ZERO_REG;
   id_rdbAidx_reg <= `SD `ZERO_REG;
   id_rdaBidx_reg <= `SD `ZERO_REG;
   id_rdbBidx_reg <= `SD `ZERO_REG;
   id_dest_reg_idx_outA_reg <= `SD `ZERO_REG;
   id_dest_reg_idx_outB_reg <= `SD `ZERO_REG;
   id_alu_func_outA_reg <= `SD 0;
   id_alu_func_outB_reg <= `SD 0;
   id_IRA_out_reg <= `SD 0;
   id_IRB_out_reg <= `SD 0;
   id_IRA_valid_out_reg <= `SD 0;
   id_IRB_valid_out_reg <= `SD 0;
   id_illegal_outA_reg <= `SD 0;
   id_illegal_outB_reg <= `SD 0;
   id_halt_outA_reg <= `SD 0;
   id_halt_outB_reg <= `SD 0;
   id_rd_mem_outA_reg <= `SD 0;
   id_wr_mem_outA_reg <= `SD 0;
   id_cond_branch_outA_reg <= `SD 0;
   id_uncond_branch_outA_reg <= `SD 0;
   id_rd_mem_outB_reg <= `SD 0;
   id_wr_mem_outB_reg <= `SD 0;
   id_cond_branch_outB_reg <= `SD 0;
   id_uncond_branch_outB_reg <= `SD 0;
   end 
   else if (~rs_full & ~rs_almost_full & ~one_ins_en_in & ~non_ins_en_in & ~(lq_full || lq_almost_full || sq_full || sq_almost_full) ) begin
   id_PCA_out_reg <= `SD id_PCA_out;
   id_PCB_out_reg <= `SD id_PCB_out;
   id_NPCA_out_reg <= `SD id_NPCA_out;    
   id_NPCB_out_reg <= `SD id_NPCB_out;
   id_branch_predictionA_reg <= `SD id_branch_predictionA;
   id_branch_predictionB_reg <= `SD id_branch_predictionB;
   id_predicted_PCA_reg <= `SD id_predicted_PCA;
   id_predicted_PCB_reg <= `SD id_predicted_PCB;
   id_opa_select_outA_reg <= `SD id_opa_select_outA;
   id_opb_select_outA_reg <= `SD id_opb_select_outA;
   id_opa_select_outB_reg <= `SD id_opa_select_outB;
   id_opb_select_outB_reg <= `SD id_opb_select_outB;
   id_rdaAidx_reg <= `SD id_rdaAidx;
   id_rdbAidx_reg <= `SD id_rdbAidx;
   id_rdaBidx_reg <= `SD id_rdaBidx;
   id_rdbBidx_reg <= `SD id_rdbBidx;
   id_dest_reg_idx_outA_reg <= `SD id_dest_reg_idx_outA;
   id_dest_reg_idx_outB_reg <= `SD id_dest_reg_idx_outB;
   id_alu_func_outA_reg <= `SD id_alu_func_outA;
   id_alu_func_outB_reg <= `SD id_alu_func_outB;
   id_IRA_out_reg <= `SD id_IRA_out;
   id_IRB_out_reg <= `SD id_IRB_out;
   id_IRA_valid_out_reg <= `SD id_IRA_valid_out;
   id_IRB_valid_out_reg <= `SD id_IRB_valid_out;
   id_illegal_outA_reg <= `SD id_illegal_outA;
   id_illegal_outB_reg <= `SD id_illegal_outB;
   id_halt_outA_reg <= `SD id_halt_outA;
   id_halt_outB_reg <= `SD id_halt_outB;
   id_rd_mem_outA_reg <= `SD id_rd_mem_outA;
   id_wr_mem_outA_reg <= `SD id_wr_mem_outA;
   id_cond_branch_outA_reg <= `SD id_cond_branch_outA;
   id_uncond_branch_outA_reg <= `SD id_uncond_branch_outA;
   id_rd_mem_outB_reg <= `SD id_rd_mem_outB;
   id_wr_mem_outB_reg <= `SD id_wr_mem_outB;
   id_cond_branch_outB_reg <= `SD id_cond_branch_outB;
   id_uncond_branch_outB_reg <= `SD id_uncond_branch_outB;

   end else begin
   id_IRA_valid_out_reg <= `SD 0;
   id_IRB_valid_out_reg <= `SD 0;
   end
  end
   
endmodule
