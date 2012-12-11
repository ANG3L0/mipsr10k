module ex_pipeline(
	//input
	clock,
	reset,

	rs_en_in_1,
	rs_IR_1,
	rs_NPC_1,
	rs_predicted_PC_1,
	rs_rega_1,
	rs_regb_1,
	rs_opa_select_1,
	rs_opb_select_1,
	rs_alu_func_1,
	rs_cond_branch_1,
	rs_uncond_branch_1,
	rs_pr_idx_1,
	rs_mt_idx_1,
	rs_rob_idx_1,
	rs_rd_mem_1,
	rs_wr_mem_1, 
	rs_halt_1,
	rs_illegal_1,
	rs_lq_idx_1,
	rs_sq_idx_1,
	rs_branch_predict_taken_1,


	rs_en_in_2,
	rs_IR_2,
	rs_NPC_2,
	rs_predicted_PC_2,
	rs_rega_2,
	rs_regb_2,
	rs_opa_select_2,
	rs_opb_select_2,
	rs_alu_func_2,
	rs_cond_branch_2,
	rs_uncond_branch_2,
	rs_pr_idx_2,
	rs_mt_idx_2,
	rs_rob_idx_2,
	rs_rd_mem_2,
	rs_wr_mem_2, 
	rs_halt_2,
	rs_illegal_2,
	rs_lq_idx_2,
	rs_sq_idx_2,
	rs_branch_predict_taken_2,


	rob_recovery,
	ldq_en,
	ldq_data,
	ldq_pr_idx,
	ldq_mt_idx,
	ldq_rob_idx,
	ldq_NPC,
	ldq_illegal,
	ldq_halt,
	

	//output A
	//alu output after priority selector
	exA_en_out,
	exA_result_out,
	exA_pr_idx_out,
	exA_mt_idx_out,
	exA_rob_idx_out,
	//branch output
	exA_take_branch_out,
	exA_branch_mistaken_out,//if_stage predicts YES taken, but actually ex_stage finds it does NOT take
	exA_branch_still_taken_out,//if_stage predicts NOT taken, but actually ex_stage finds it DOES taken
	exA_mispredicted_out,
	exA_if_predicted_taken_out,
	exA_predicted_PC_out,
	exA_cond_branch_out,
	exA_uncond_branch_out,
	//other flag signals
	exA_NPC_out,
	exA_halt_out,
	exA_illegal_out,
	//stq, ldq
	exA_wr_mem_out,
	exA_rd_mem_out,
	exA_lq_idx_out,
	exA_lq_pr_idx_out,
	exA_lq_mt_idx_out,
	exA_lq_rob_idx_out,
	exA_lq_data_rdy_out,
	exA_sq_idx_out,
	exA_sq_data_rdy_out,
	exA_lsq_NPC_out,
	exA_lsq_data_out,
	exA_lsq_addr_out,
	exA_lsq_halt_out,
	exA_lsq_illegal_out,

	//output B
	//aluB output after priority selector
	exB_en_out,
	exB_result_out,
	exB_pr_idx_out,
	exB_mt_idx_out,
	exB_rob_idx_out,
	//branch output
	exB_take_branch_out,
	exB_branch_mistaken_out,//if_stage predicts YES taken, but actually ex_stage finds it does NOT take
	exB_branch_still_taken_out,//if_stage predicts NOT taken, but actually ex_stage finds it DOES taken
	exB_mispredicted_out,
	exB_if_predicted_taken_out,
	exB_predicted_PC_out,
	exB_cond_branch_out,
	exB_uncond_branch_out,
	//other flag signals
	exB_NPC_out,
	exB_halt_out,
	exB_illegal_out,
	//stq, ldq
	exB_wr_mem_out,
	exB_rd_mem_out,
	exB_lq_idx_out,
	exB_lq_pr_idx_out,
	exB_lq_mt_idx_out,
	exB_lq_rob_idx_out,
	exB_lq_data_rdy_out,
	exB_sq_data_rdy_out,
	exB_sq_idx_out,
	exB_lsq_NPC_out,
	exB_lsq_data_out,
	exB_lsq_addr_out,
	exB_lsq_halt_out,
	exB_lsq_illegal_out,

	//output C  mult
	exC_mult_valid_out,
	exC_mult_result_out,
	exC_pr_idx_out,
	exC_mt_idx_out,
	exC_rob_idx_out,
	exC_NPC_out,
/*	exC_mult_valid_out_early,
	exC_mult_result_out_early,
	exC_pr_idx_early,
	exC_mt_idx_early,
	exC_rob_idx_early,
	exC_NPC_early,*/
	//output D  mult
	exD_mult_valid_out,
	exD_mult_result_out,
	exD_pr_idx_out,
	exD_mt_idx_out,
	exD_rob_idx_out,
	exD_NPC_out/*,
	exD_mult_valid_out_early,
	exD_mult_result_out_early,
	exD_pr_idx_early,
	exD_mt_idx_early,
	exD_rob_idx_early,
	exD_NPC_early*/
);

	input         		clock;
	input	      		reset;
	input			rs_en_in_1;
	input     [31:0]	rs_IR_1;
	input	  [63:0]	rs_NPC_1;
	input	  [63:0]	rs_predicted_PC_1;
	input     [63:0]	rs_rega_1;
	input     [63:0]	rs_regb_1;
	input      [1:0]  	rs_opa_select_1;
	input      [1:0]     	rs_opb_select_1;
	input      [4:0]     	rs_alu_func_1;
	input			rs_cond_branch_1;
	input			rs_uncond_branch_1;
	input      [5:0]     	rs_pr_idx_1;
	input      [4:0]     	rs_mt_idx_1;
	input      [4:0]     	rs_rob_idx_1;
	input			rs_rd_mem_1;
	input			rs_wr_mem_1; 
	input                	rs_halt_1;
	input                	rs_illegal_1;
	input	[`LQWIDTH-1:0]	rs_lq_idx_1;
	input	[`SQWIDTH-1:0]	rs_sq_idx_1;
	input			rs_branch_predict_taken_1;


	input                	rs_en_in_2;
	input     [31:0]     	rs_IR_2;
	input	  [63:0]	rs_NPC_2;   
	input	  [63:0]	rs_predicted_PC_2;
	input     [63:0]     	rs_rega_2;
	input     [63:0]     	rs_regb_2;
	input      [1:0]     	rs_opa_select_2;
	input      [1:0]     	rs_opb_select_2;
	input      [4:0]     	rs_alu_func_2;
	input			rs_cond_branch_2;
	input			rs_uncond_branch_2;
	input      [5:0]     	rs_pr_idx_2;
	input      [4:0]     	rs_mt_idx_2;
	input      [4:0]     	rs_rob_idx_2;
	input			rs_rd_mem_2;
	input			rs_wr_mem_2; 
	input                	rs_halt_2;
	input                	rs_illegal_2;
	input	[`LQWIDTH-1:0]	rs_lq_idx_2;
	input	[`SQWIDTH-1:0]	rs_sq_idx_2;
	input			rs_branch_predict_taken_2;

	input                   rob_recovery;
	input			ldq_en;
	input	[63:0]		ldq_data;
	input	 [5:0]		ldq_pr_idx;
	input	 [4:0]		ldq_mt_idx;
	input	 [4:0]		ldq_rob_idx;
	input	[63:0]		ldq_NPC;
	input			ldq_illegal;
	input			ldq_halt;

	output		exA_en_out;
	output	[63:0]	exA_result_out;
	output	 [5:0]	exA_pr_idx_out;
	output	 [4:0]	exA_mt_idx_out;
	output	 [4:0]	exA_rob_idx_out;

	output		exA_take_branch_out;
	output		exA_branch_mistaken_out;
	output		exA_branch_still_taken_out;
	output		exA_mispredicted_out;
	output		exA_if_predicted_taken_out;
	output	[63:0]	exA_predicted_PC_out;
	output		exA_cond_branch_out;
	output		exA_uncond_branch_out;

	output	[63:0]	exA_NPC_out;
	output		exA_halt_out;
	output		exA_illegal_out;

	output		exA_wr_mem_out;
	output		exA_rd_mem_out;
	output	 [`LQWIDTH-1:0]	exA_lq_idx_out;
	output	 [5:0]	exA_lq_pr_idx_out;
	output	 [4:0]	exA_lq_mt_idx_out;
	output	 [4:0]	exA_lq_rob_idx_out;
	output		exA_lq_data_rdy_out;
	output		exA_sq_data_rdy_out;
	output	 [`SQWIDTH-1:0]	exA_sq_idx_out;
	output	[63:0]	exA_lsq_NPC_out;
	output	[63:0]	exA_lsq_data_out;
	output	[63:0]	exA_lsq_addr_out;
	output		exA_lsq_halt_out;
	output		exA_lsq_illegal_out;


	output		exB_en_out;
	output	[63:0]	exB_result_out;
	output	 [5:0]	exB_pr_idx_out;
	output	 [4:0]	exB_mt_idx_out;
	output	 [4:0]	exB_rob_idx_out;

	output		exB_take_branch_out;
	output		exB_branch_mistaken_out;
	output		exB_branch_still_taken_out;
	output		exB_mispredicted_out;
	output		exB_if_predicted_taken_out;
	output	[63:0]	exB_predicted_PC_out;
	output		exB_cond_branch_out;
	output		exB_uncond_branch_out;

	output	[63:0]	exB_NPC_out;
	output		exB_halt_out;
	output		exB_illegal_out;

	output		exB_wr_mem_out;
	output		exB_rd_mem_out;
	output	 [`LQWIDTH-1:0]	exB_lq_idx_out;
	output	 [5:0]	exB_lq_pr_idx_out;
	output	 [4:0]	exB_lq_mt_idx_out;
	output	 [4:0]	exB_lq_rob_idx_out;
	output		exB_lq_data_rdy_out;
	output		exB_sq_data_rdy_out;
	output	 [`SQWIDTH-1:0]	exB_sq_idx_out;
	output	[63:0]	exB_lsq_NPC_out;
	output	[63:0]	exB_lsq_data_out;
	output	[63:0]	exB_lsq_addr_out;
	output		exB_lsq_halt_out;
	output		exB_lsq_illegal_out;

	output		exC_mult_valid_out;
	output	[63:0]	exC_mult_result_out;
	output	 [5:0] 	exC_pr_idx_out;
	output	 [4:0]	exC_mt_idx_out;
	output	 [4:0]	exC_rob_idx_out;
	output  [63:0]  exC_NPC_out;
/*	output		exC_mult_valid_out_early;
	output	[63:0]	exC_mult_result_out_early;
	output	 [5:0] 	exC_pr_idx_early;
	output	 [4:0]	exC_mt_idx_early;
	output	 [4:0]	exC_rob_idx_early;
	output  [63:0]  exC_NPC_early;*/

	output		exD_mult_valid_out;
	output	[63:0]	exD_mult_result_out;
	output	 [5:0] 	exD_pr_idx_out;
	output	 [4:0]	exD_mt_idx_out;
	output	 [4:0]	exD_rob_idx_out;
	output  [63:0]  exD_NPC_out;
/*	output		exD_mult_valid_out_early;
	output	[63:0]	exD_mult_result_out_early;
	output	 [5:0] 	exD_pr_idx_early;
	output	 [4:0]	exD_mt_idx_early;
	output	 [4:0]	exD_rob_idx_early;
	output  [63:0]  exD_NPC_early;*/
	//output regs
	reg		exA_en_out;
	reg	[63:0]	exA_result_out;
	reg	 [5:0]	exA_pr_idx_out;
	reg	 [4:0]	exA_mt_idx_out;
	reg	 [4:0]	exA_rob_idx_out;

	reg		exA_take_branch_out;
	reg		exA_branch_mistaken_out;
	reg		exA_branch_still_taken_out;
	reg		exA_mispredicted_out;
	reg		exA_if_predicted_taken_out;
	reg	[63:0]	exA_predicted_PC_out;
	reg		exA_cond_branch_out;
	reg		exA_uncond_branch_out;

	reg	[63:0]	exA_NPC_out;
	reg		exA_halt_out;
	reg		exA_illegal_out;

	reg		exA_wr_mem_out;
	reg		exA_rd_mem_out;
	reg	 [`LQWIDTH-1:0]	exA_lq_idx_out;
	reg	 [5:0]	exA_lq_pr_idx_out;
	reg	 [4:0]	exA_lq_mt_idx_out;
	reg	 [4:0]	exA_lq_rob_idx_out;
	reg		exA_lq_data_rdy_out;
	reg		exA_sq_data_rdy_out;
	reg	 [`SQWIDTH-1:0]	exA_sq_idx_out;
	reg	[63:0]	exA_lsq_NPC_out;
	reg	[63:0]	exA_lsq_data_out;
	reg	[63:0]	exA_lsq_addr_out;
	reg		exA_lsq_halt_out;
	reg		exA_lsq_illegal_out;


	reg		exB_en_out;
	reg	[63:0]	exB_result_out;
	reg	 [5:0]	exB_pr_idx_out;
	reg	 [4:0]	exB_mt_idx_out;
	reg	 [4:0]	exB_rob_idx_out;

	reg		exB_take_branch_out;
	reg		exB_branch_mistaken_out;
	reg		exB_branch_still_taken_out;
	reg		exB_mispredicted_out;
	reg		exB_if_predicted_taken_out;
	reg		exB_cond_branch_out;
	reg		exB_uncond_branch_out;

	reg	[63:0]	exB_NPC_out;
	reg		exB_halt_out;
	reg		exB_illegal_out;

	reg		exB_wr_mem_out;
	reg		exB_rd_mem_out;
	reg	 [`LQWIDTH-1:0]	exB_lq_idx_out;
	reg	 [5:0]	exB_lq_pr_idx_out;
	reg	 [4:0]	exB_lq_mt_idx_out;
	reg	 [4:0]	exB_lq_rob_idx_out;
	reg		exB_lq_data_rdy_out;
	reg		exB_sq_data_rdy_out;
	reg	 [`SQWIDTH-1:0]	exB_sq_idx_out;
	reg	[63:0]	exB_lsq_NPC_out;
	reg	[63:0]	exB_lsq_data_out;
	reg	[63:0]	exB_lsq_addr_out;
	reg		exB_lsq_halt_out;
	reg		exB_lsq_illegal_out;
	//regs of rs-ex-Pipeline Register
	reg			rs_ex_en_in_1;
	reg		[31:0]	rs_ex_IR_1;
	reg		[63:0]	rs_ex_NPC_1;
	reg		[63:0]	rs_ex_predicted_PC_1;
	reg		[63:0]	rs_ex_rega_1;
	reg		[63:0]	rs_ex_regb_1;
	reg		 [1:0]	rs_ex_opa_select_1;
	reg		 [1:0]	rs_ex_opb_select_1;
	reg		 [4:0]	rs_ex_alu_func_1;
	reg			rs_ex_cond_branch_1;
	reg			rs_ex_uncond_branch_1;
	reg		 [5:0]	rs_ex_pr_idx_1;
	reg		 [4:0]	rs_ex_mt_idx_1;
	reg		 [4:0]	rs_ex_rob_idx_1;
	reg			rs_ex_rd_mem_1;
	reg			rs_ex_wr_mem_1;
	reg			rs_ex_halt_1;
	reg			rs_ex_illegal_1;
	reg	[`LQWIDTH-1:0]	rs_ex_lq_idx_1;
	reg	[`SQWIDTH-1:0]	rs_ex_sq_idx_1;
	reg			rs_ex_branch_predict_taken_1;

	reg			rs_ex_en_in_2;
	reg		[31:0]	rs_ex_IR_2;
	reg		[63:0]	rs_ex_NPC_2;
	reg		[63:0]	rs_ex_predicted_PC_2;
	reg		[63:0]	rs_ex_rega_2;
	reg		[63:0]	rs_ex_regb_2;
	reg		 [1:0]	rs_ex_opa_select_2;
	reg		 [1:0]	rs_ex_opb_select_2;
	reg		 [4:0]	rs_ex_alu_func_2;
	reg			rs_ex_cond_branch_2;
	reg			rs_ex_uncond_branch_2;
	reg		 [5:0]	rs_ex_pr_idx_2;
	reg		 [4:0]	rs_ex_mt_idx_2;
	reg		 [4:0]	rs_ex_rob_idx_2;
	reg			rs_ex_rd_mem_2;
	reg			rs_ex_wr_mem_2;
	reg			rs_ex_halt_2;
	reg			rs_ex_illegal_2;
	reg	[`LQWIDTH-1:0]	rs_ex_lq_idx_2;
	reg	[`SQWIDTH-1:0]	rs_ex_sq_idx_2;
	reg			rs_ex_branch_predict_taken_2;

	reg			ldq_ex_en;
	reg	[63:0]		ldq_ex_data;
	reg	 [5:0]		ldq_ex_pr_idx;
	reg	 [4:0]		ldq_ex_mt_idx;
	reg	 [4:0]		ldq_ex_rob_idx;
	reg	[63:0]		ldq_ex_NPC;
	reg			ldq_ex_illegal;
	reg			ldq_ex_halt;
	//output from alu
	wire	[63:0]		exA_result;
	wire			exA_en;
	wire			exA_take_branch;
	wire	 [5:0]		exA_pr_idx;
	wire	 [4:0]		exA_mt_idx;
	wire	 [4:0]		exA_rob_idx;
	wire			exA_branch_mistaken;
	wire			exA_branch_still_taken;
	wire	[63:0]		exB_result;
	wire			exB_en;
	wire			exB_take_branch;
	wire	 [5:0]		exB_pr_idx;
	wire	 [4:0]		exB_mt_idx;
	wire	 [4:0]		exB_rob_idx;
	wire			exB_branch_mistaken;
	wire			exB_branch_still_taken;
	wire			access_memory;

	wire			exA_mispredicted;
	wire			exB_mispredicted;

////////////////////////////////////////////////
//assign  exA_PC_out = rs_ex_PC_1;
//assign  exA_NPC_out = rs_ex_NPC_1;
//assign  exA_halt_out = rs_ex_halt_1;
//assign  exA_illegal_out = rs_ex_illegal_1;
//assign  exA_cond_branch_out = rs_ex_cond_branch_1;
//assign  exA_uncond_branch_out = rs_ex_uncond_branch_1;
//assign  exA_rd_mem_out = rs_ex_rd_mem_1;
//assign  exA_wr_mem_out = rs_ex_wr_mem_1;
//assign  exA_lq_idx_out = rs_ex_lq_idx_1;
//assign  exA_sq_idx_out = rs_ex_sq_idx_1;
//assign  exA_sq_data_out = rs_ex_rega_1;
//assign  exA_if_predicted_taken_out = rs_ex_branch_predict_taken_1;

//assign  exB_PC_out = rs_ex_PC_2;
//assign  exB_NPC_out = rs_ex_NPC_2;
//assign  exB_halt_out = rs_ex_halt_2;
//assign  exB_illegal_out = rs_ex_illegal_2;
//assign  exB_cond_branch_out = rs_ex_cond_branch_2;
//assign  exB_uncond_branch_out = rs_ex_uncond_branch_2;
//assign  exB_rd_mem_out = rs_ex_rd_mem_2;
//assign  exB_wr_mem_out = rs_ex_wr_mem_2;
//assign  exB_lq_idx_out = rs_ex_lq_idx_2;
//assign  exB_sq_idx_out = rs_ex_sq_idx_2;
//assign  exB_sq_data_out = rs_ex_rega_2;
//assign  exB_if_predicted_taken_out = rs_ex_branch_predict_taken_2;

//assign  exA_branch_mistaken_out = exA_branch_mistaken;
//assign  exB_branch_mistaken_out = exB_branch_mistaken;
//assign  exA_branch_still_taken_out = exA_branch_still_taken;
//assign  exB_branch_still_taken_out = exB_branch_still_taken;
assign  exA_mispredicted = exA_branch_mistaken | exA_branch_still_taken;
assign  exB_mispredicted = exB_branch_mistaken | exB_branch_still_taken;
assign  access_memory = rs_ex_rd_mem_1 | rs_ex_rd_mem_2 | rs_ex_wr_mem_1 | rs_ex_wr_mem_2;

////////////////////////////////////////////////////
  //                                              //
  //          rs-ex-Pipeline Register             //
  //                                              //
  //////////////////////////////////////////////////
always @(posedge clock)
begin
	if(reset | rob_recovery)
	begin
	rs_ex_en_in_1		<= `SD 1'b0;
	rs_ex_IR_1		<= `SD 32'h0;
	rs_ex_NPC_1		<= `SD 64'h0;
	rs_ex_predicted_PC_1	<= `SD 64'h0;
	rs_ex_rega_1		<= `SD 64'd0;
	rs_ex_regb_1		<= `SD 64'd0;
	rs_ex_opa_select_1	<= `SD `ALU_OPA_IS_REGA;
	rs_ex_opb_select_1	<= `SD `ALU_OPB_IS_REGB;
	rs_ex_alu_func_1	<= `SD 5'd0;
	rs_ex_cond_branch_1	<= `SD 1'b0;
	rs_ex_uncond_branch_1	<= `SD 1'b0;
	rs_ex_pr_idx_1		<= `SD 6'd31;
	rs_ex_mt_idx_1		<= `SD 5'd31;
	rs_ex_rob_idx_1		<= `SD 5'd31;
	rs_ex_rd_mem_1		<= `SD 1'b0;
	rs_ex_wr_mem_1		<= `SD 1'b0;
	rs_ex_halt_1		<= `SD 1'b0;
	rs_ex_illegal_1		<= `SD 1'b0;
	rs_ex_lq_idx_1		<= `SD 3'b0;
	rs_ex_sq_idx_1		<= `SD 3'b0;
	rs_ex_branch_predict_taken_1	<= `SD 1'b0;

	rs_ex_en_in_2		<= `SD 1'b0;
	rs_ex_IR_2		<= `SD 32'h0;
	rs_ex_NPC_2		<= `SD 64'h0;
	rs_ex_predicted_PC_2	<= `SD 64'h0;
	rs_ex_rega_2		<= `SD 64'd0;
	rs_ex_regb_2		<= `SD 64'd0;
	rs_ex_opa_select_2	<= `SD `ALU_OPA_IS_REGA;
	rs_ex_opb_select_2	<= `SD `ALU_OPB_IS_REGB;
	rs_ex_alu_func_2	<= `SD 5'd0;
	rs_ex_cond_branch_2	<= `SD 1'b0;
	rs_ex_uncond_branch_2	<= `SD 1'b0;
	rs_ex_pr_idx_2		<= `SD 6'd31;
	rs_ex_mt_idx_2		<= `SD 5'd31;
	rs_ex_rob_idx_2		<= `SD 5'd31;
	rs_ex_rd_mem_2		<= `SD 1'b0;
	rs_ex_wr_mem_2		<= `SD 1'b0; 
	rs_ex_halt_2		<= `SD 1'b0;
	rs_ex_illegal_2		<= `SD 1'b0;
	rs_ex_lq_idx_2		<= `SD 3'b0;
	rs_ex_sq_idx_2		<= `SD 3'b0;
	rs_ex_branch_predict_taken_2	<= `SD 1'b0;

	end
	else if (~ldq_en) 
	begin
	rs_ex_en_in_1		<= `SD rs_en_in_1;
	rs_ex_IR_1		<= `SD rs_IR_1;
	rs_ex_NPC_1		<= `SD rs_NPC_1;
	rs_ex_predicted_PC_1	<= `SD rs_predicted_PC_1;
	rs_ex_rega_1		<= `SD rs_rega_1;
	rs_ex_regb_1		<= `SD rs_regb_1;
	rs_ex_opa_select_1	<= `SD rs_opa_select_1;
	rs_ex_opb_select_1	<= `SD rs_opb_select_1;
	rs_ex_alu_func_1	<= `SD rs_alu_func_1;
	rs_ex_cond_branch_1	<= `SD rs_cond_branch_1;
	rs_ex_uncond_branch_1	<= `SD rs_uncond_branch_1;
	rs_ex_pr_idx_1		<= `SD rs_pr_idx_1;
	rs_ex_mt_idx_1		<= `SD rs_mt_idx_1;
	rs_ex_rob_idx_1		<= `SD rs_rob_idx_1;
	rs_ex_rd_mem_1		<= `SD rs_rd_mem_1;
	rs_ex_wr_mem_1		<= `SD rs_wr_mem_1;
	rs_ex_halt_1		<= `SD rs_halt_1;
	rs_ex_illegal_1		<= `SD rs_illegal_1;
	rs_ex_lq_idx_1		<= `SD rs_lq_idx_1;
	rs_ex_sq_idx_1		<= `SD rs_sq_idx_1;
	rs_ex_branch_predict_taken_1	<= `SD rs_branch_predict_taken_1;

	rs_ex_en_in_2		<= `SD rs_en_in_2;
	rs_ex_IR_2		<= `SD rs_IR_2;
	rs_ex_NPC_2		<= `SD rs_NPC_2;
	rs_ex_predicted_PC_2	<= `SD rs_predicted_PC_2;
	rs_ex_rega_2		<= `SD rs_rega_2;
	rs_ex_regb_2		<= `SD rs_regb_2;
	rs_ex_opa_select_2	<= `SD rs_opa_select_2;
	rs_ex_opb_select_2	<= `SD rs_opb_select_2;
	rs_ex_alu_func_2	<= `SD rs_alu_func_2;
	rs_ex_cond_branch_2	<= `SD rs_cond_branch_2;
	rs_ex_uncond_branch_2	<= `SD rs_uncond_branch_2;
	rs_ex_pr_idx_2		<= `SD rs_pr_idx_2;
	rs_ex_mt_idx_2		<= `SD rs_mt_idx_2;
	rs_ex_rob_idx_2		<= `SD rs_rob_idx_2;
	rs_ex_rd_mem_2		<= `SD rs_rd_mem_2;
	rs_ex_wr_mem_2		<= `SD rs_wr_mem_2; 
	rs_ex_halt_2		<= `SD rs_halt_2;
	rs_ex_illegal_2		<= `SD rs_illegal_2;
	rs_ex_lq_idx_2		<= `SD rs_lq_idx_2;
	rs_ex_sq_idx_2		<= `SD rs_sq_idx_2;
	rs_ex_branch_predict_taken_2	<= `SD rs_branch_predict_taken_2;
	end
end
////////////////////////////////////////////////////
  //                                              //
  //          ldq-ex-Pipeline Register            //
  //                                              //
  //////////////////////////////////////////////////
always @(posedge clock)
begin
	if(reset | rob_recovery)
	begin
	ldq_ex_en	<= `SD 1'b0;
	ldq_ex_data	<= `SD 64'd0;
	ldq_ex_pr_idx	<= `SD 6'd0;
	ldq_ex_mt_idx	<= `SD 5'd0;
	ldq_ex_rob_idx	<= `SD 5'd0;
	ldq_ex_NPC	<= `SD 64'd0;
	ldq_ex_illegal	<= `SD 1'b0;
	ldq_ex_halt	<= `SD 1'b0;
	end
	else
	begin
	ldq_ex_en	<= `SD ldq_en;
	ldq_ex_data	<= `SD ldq_data;
	ldq_ex_pr_idx	<= `SD ldq_pr_idx;
	ldq_ex_mt_idx	<= `SD ldq_mt_idx;
	ldq_ex_rob_idx	<= `SD ldq_rob_idx;
	ldq_ex_NPC	<= `SD ldq_NPC;
	ldq_ex_illegal	<= `SD ldq_illegal;
	ldq_ex_halt	<= `SD ldq_halt;
	end
end
////////////////////////////////////////////////////
  //                                              //
  //               cdb output selector            //
  //                                              //
  //////////////////////////////////////////////////
always @*
begin
	//aluA result
	exA_en_out	= exA_en;
	exA_result_out	= exA_result;
	exA_pr_idx_out	= rs_ex_pr_idx_1;
	exA_mt_idx_out	= rs_ex_mt_idx_1;
	exA_rob_idx_out	= rs_ex_rob_idx_1;
	//branch output
	exA_take_branch_out		= exA_take_branch;
	exA_branch_mistaken_out		= exA_branch_mistaken;
	exA_branch_still_taken_out	= exA_branch_still_taken;
	exA_mispredicted_out		= exA_mispredicted;
	exA_if_predicted_taken_out	= rs_ex_branch_predict_taken_1;
	exA_cond_branch_out		= rs_ex_cond_branch_1;
	exA_uncond_branch_out		= rs_ex_uncond_branch_1;
	//other flag signals
	exA_NPC_out	= rs_ex_NPC_1;		
	exA_halt_out	= rs_ex_halt_1;
	exA_illegal_out	= rs_ex_illegal_1;
	//stq, ldq
	exA_wr_mem_out		= 1'b0;
	exA_rd_mem_out		= 1'b0;
	exA_lq_idx_out		= 3'b0;
	exA_lq_pr_idx_out	= 6'd31;
	exA_lq_mt_idx_out	= 5'd31;
	exA_lq_rob_idx_out	= 5'd31;
	exA_lq_data_rdy_out	= 1'b0;
	exA_sq_data_rdy_out	= 1'b0;
	exA_sq_idx_out		= 3'b0;
	exA_lsq_NPC_out		= 64'd0;
	exA_lsq_data_out	= 64'd0;
	exA_lsq_addr_out	= 64'd0;
	exA_lsq_halt_out	= 1'b0;
	exA_lsq_illegal_out	= 1'b0;
	//aluB result
	exB_en_out	= exB_en;
	exB_result_out	= exB_result;
	exB_pr_idx_out	= rs_ex_pr_idx_2;
	exB_mt_idx_out	= rs_ex_mt_idx_2;
	exB_rob_idx_out	= rs_ex_rob_idx_2;
	//branch output
	exB_take_branch_out		= exB_take_branch;
	exB_branch_mistaken_out		= exB_branch_mistaken;
	exB_branch_still_taken_out	= exB_branch_still_taken;
	exB_mispredicted_out		= exB_mispredicted;
	exB_if_predicted_taken_out	= rs_ex_branch_predict_taken_2;
	exB_cond_branch_out		= rs_ex_cond_branch_2;
	exB_uncond_branch_out		= rs_ex_uncond_branch_2;
	//other flag signals
	exB_NPC_out	= rs_ex_NPC_2;		
	exB_halt_out	= rs_ex_halt_2;
	exB_illegal_out	= rs_ex_illegal_2;
	//stq, ldq
	exB_wr_mem_out		= 1'b0;
	exB_rd_mem_out		= 1'b0;
	exB_lq_idx_out		= 3'b0;
	exB_lq_pr_idx_out	= 6'd31;
	exB_lq_mt_idx_out	= 5'd31;
	exB_lq_rob_idx_out	= 5'd31;
	exB_lq_data_rdy_out	= 1'b0;
	exB_sq_data_rdy_out	= 1'b0;
	exB_sq_idx_out		= 3'b0;
	exB_lsq_NPC_out		= 64'd0;
	exB_lsq_data_out	= 64'd0;
	exB_lsq_addr_out	= 64'd0;
	exB_lsq_halt_out	= 1'b0;
	exB_lsq_illegal_out	= 1'b0;

	if(ldq_ex_en)
	begin
	//aluA result
	exA_en_out	= ldq_ex_en;
	exA_result_out	= ldq_ex_data;
	exA_pr_idx_out	= ldq_ex_pr_idx;
	exA_mt_idx_out	= ldq_ex_mt_idx;
	exA_rob_idx_out	= ldq_ex_rob_idx;
	//branch output
	exA_take_branch_out		= 1'b0;
	exA_branch_mistaken_out		= 1'b0;
	exA_branch_still_taken_out	= 1'b0;
	exA_mispredicted_out		= 1'b0;
	exA_if_predicted_taken_out	= 1'b0;
	exA_cond_branch_out		= 1'b0;
	exA_uncond_branch_out		= 1'b0;
	//other flag signals
	exA_NPC_out	= ldq_ex_NPC;		
	exA_halt_out	=  ldq_ex_halt;
	exA_illegal_out	=  ldq_ex_illegal;
	//stq, ldq
	exA_wr_mem_out		= 1'b0;
	exA_rd_mem_out		= 1'b0;
	exA_lq_idx_out		= 3'b0;
	exA_lq_pr_idx_out	= 6'd31;
	exA_lq_mt_idx_out	= 5'd31;
	exA_lq_rob_idx_out	= 5'd31;
	exA_lq_data_rdy_out	= 1'b0;
	exA_sq_data_rdy_out	= 1'b0;
	exA_sq_idx_out		= 3'b0;
	exA_lsq_NPC_out		= 64'd0;
	exA_lsq_data_out	= 64'd0;
	exA_lsq_addr_out	= 64'd0;
	exA_lsq_halt_out	= 1'b0;
	exA_lsq_illegal_out	= 1'b0;
	//aluB result
	exB_en_out	= 1'b0;
	exB_result_out	= 64'd0;
	exB_pr_idx_out	= 6'd31;
	exB_mt_idx_out	= 5'd31;
	exB_rob_idx_out	= 5'd31;
	//branch output
	exB_take_branch_out		= 1'b0;
	exB_branch_mistaken_out		= 1'b0;
	exB_branch_still_taken_out	= 1'b0;
	exB_mispredicted_out		= 1'b0;
	exB_if_predicted_taken_out	= 1'b0;
	exB_cond_branch_out		= 1'b0;
	exB_uncond_branch_out		= 1'b0;
	//other flag signals
	exB_NPC_out	= 64'd0;		
	exB_halt_out	=  1'b0;
	exB_illegal_out	=  1'b0;
	//stq, ldq
	exB_wr_mem_out		= 1'b0;
	exB_rd_mem_out		= 1'b0;
	exB_lq_idx_out		= 3'b0;
	exB_lq_pr_idx_out	= 6'd31;
	exB_lq_mt_idx_out	= 5'd31;
	exB_lq_rob_idx_out	= 5'd31;
	exB_lq_data_rdy_out	= 1'b0;
	exB_sq_data_rdy_out	= 1'b0;
	exB_sq_idx_out		= 3'b0;
	exB_lsq_NPC_out		= 64'd0;
	exB_lsq_data_out	= 64'd0;
	exB_lsq_addr_out	= 64'd0;
	exB_lsq_halt_out	= 1'b0;
	exB_lsq_illegal_out	= 1'b0;
	end
	
	else if(access_memory)
	begin
		if(rs_ex_rd_mem_1)
		begin
		//aluA result
		exA_en_out	= 1'b0;
		exA_result_out	= 64'd0;
		exA_pr_idx_out	= 6'd31;
		exA_mt_idx_out	= 5'd31;
		exA_rob_idx_out	= 5'd31;
		//branch output
		exA_take_branch_out		= 1'b0;
		exA_branch_mistaken_out		= 1'b0;
		exA_branch_still_taken_out	= 1'b0;
		exA_mispredicted_out		= 1'b0;
		exA_if_predicted_taken_out	= 1'b0;
		exA_cond_branch_out		= 1'b0;
		exA_uncond_branch_out		= 1'b0;
		//other flag signals
		exA_NPC_out	= 64'd0;		
		exA_halt_out	=  1'b0;
		exA_illegal_out	=  1'b0;
		//stq, ldq
		exA_wr_mem_out		= 1'b0;
		exA_rd_mem_out		= 1'b1;
		exA_lq_idx_out		= rs_ex_lq_idx_1;
		exA_lq_pr_idx_out	= rs_ex_pr_idx_1;
		exA_lq_mt_idx_out	= rs_ex_mt_idx_1;
		exA_lq_rob_idx_out	= rs_ex_rob_idx_1;
		exA_lq_data_rdy_out	= exA_en;
		exA_sq_data_rdy_out	= 1'b0;
		exA_sq_idx_out		= rs_ex_sq_idx_1;
		exA_lsq_NPC_out		= rs_ex_NPC_1;
		exA_lsq_data_out	= rs_ex_rega_1;
		exA_lsq_addr_out	= exA_result;
		exA_lsq_halt_out	= rs_ex_halt_1;
		exA_lsq_illegal_out	= rs_ex_illegal_1;
		end
		if(rs_ex_rd_mem_2)
		begin
		//aluB result
		exB_en_out	= 1'b0;
		exB_result_out	= 64'd0;
		exB_pr_idx_out	= 6'd31;
		exB_mt_idx_out	= 5'd31;
		exB_rob_idx_out	= 5'd31;
		//branch output
		exB_take_branch_out		= 1'b0;
		exB_branch_mistaken_out		= 1'b0;
		exB_branch_still_taken_out	= 1'b0;
		exB_mispredicted_out		= 1'b0;
		exB_if_predicted_taken_out	= 1'b0;
		exB_cond_branch_out		= 1'b0;
		exB_uncond_branch_out		= 1'b0;
		//other flag signals
		exB_NPC_out	= 64'd0;		
		exB_halt_out	=  1'b0;
		exB_illegal_out	=  1'b0;
		//stq, ldq
		exB_wr_mem_out		= 1'b0;
		exB_rd_mem_out		= 1'b1;
		exB_lq_idx_out		= rs_ex_lq_idx_2;
		exB_lq_pr_idx_out	= rs_ex_pr_idx_2;
		exB_lq_mt_idx_out	= rs_ex_mt_idx_2;
		exB_lq_rob_idx_out	= rs_ex_rob_idx_2;
		exB_lq_data_rdy_out	= exB_en;
		exB_sq_data_rdy_out	= 1'b0;
		exB_sq_idx_out		= rs_ex_sq_idx_2;
		exB_lsq_NPC_out		= rs_ex_NPC_2;
		exB_lsq_data_out	= rs_ex_rega_2;
		exB_lsq_addr_out	= exB_result;
		exB_lsq_halt_out	= rs_ex_halt_2;
		exB_lsq_illegal_out	= rs_ex_illegal_2;
		end
		if(rs_ex_wr_mem_1)
		begin
		//branch output
		exA_take_branch_out		= 1'b0;
		exA_branch_mistaken_out		= 1'b0;
		exA_branch_still_taken_out	= 1'b0;
		exA_mispredicted_out		= 1'b0;
		exA_if_predicted_taken_out	= 1'b0;
		exA_cond_branch_out		= 1'b0;
		exA_uncond_branch_out		= 1'b0;
		//stq, ldq
		exA_wr_mem_out		= 1'b1;
		exA_rd_mem_out		= 1'b0;
		exA_lq_data_rdy_out	= 1'b0;
		exA_sq_data_rdy_out	= exA_en;
		exA_sq_idx_out		= rs_ex_sq_idx_1;
		exA_lsq_NPC_out		= rs_ex_NPC_1;
		exA_lsq_data_out	= rs_ex_rega_1;
		exA_lsq_addr_out	= exA_result;
		exA_lsq_halt_out	= rs_ex_halt_1;
		exA_lsq_illegal_out	= rs_ex_illegal_1;
		end		
		if(rs_ex_wr_mem_2)
		begin
		//branch output
		exB_take_branch_out		= 1'b0;
		exB_branch_mistaken_out		= 1'b0;
		exB_branch_still_taken_out	= 1'b0;
		exB_mispredicted_out		= 1'b0;
		exB_if_predicted_taken_out	= 1'b0;
		exB_cond_branch_out		= 1'b0;
		exB_uncond_branch_out		= 1'b0;
		//stq, ldq
		exB_wr_mem_out		= 1'b1;
		exB_rd_mem_out		= 1'b0;
		exB_lq_data_rdy_out	= 1'b0;
		exB_sq_data_rdy_out	= exB_en;
		exB_sq_idx_out		= rs_ex_sq_idx_2;
		exB_lsq_NPC_out		= rs_ex_NPC_2;
		exB_lsq_data_out	= rs_ex_rega_2;
		exB_lsq_addr_out	= exB_result;
		exB_lsq_halt_out	= rs_ex_halt_2;
		exB_lsq_illegal_out	= rs_ex_illegal_2;
		end
	end
end
  //////////////////////////////////////////////////
  //                                              //
  //                  mult-stage                  //
  //                                              //
  //////////////////////////////////////////////////
mult_decoder mult_decoder_0(
	.clock(clock),
	.reset(reset),

	.ex_en_inC(rs_ex_en_in_1),
	.ex_IRC(rs_ex_IR_1),
	.ex_regaC(rs_ex_rega_1),
	.ex_regbC(rs_ex_regb_1),
	.ex_opa_selectC(rs_ex_opa_select_1),
	.ex_opb_selectC(rs_ex_opb_select_1),
	.ex_alu_funcC(rs_ex_alu_func_1),
	.ex_pr_idxC(rs_ex_pr_idx_1),
	.ex_mt_idxC(rs_ex_mt_idx_1),
	.ex_rob_idxC(rs_ex_rob_idx_1),
	.ex_haltC(rs_ex_halt_1),
	.ex_illegalC(rs_ex_illegal_1),
	.ex_NPCC(rs_ex_NPC_1),

	.ex_en_inD(rs_ex_en_in_2),
	.ex_IRD(rs_ex_IR_2),
	.ex_regaD(rs_ex_rega_2),
	.ex_regbD(rs_ex_regb_2),
	.ex_opa_selectD(rs_ex_opa_select_2),
	.ex_opb_selectD(rs_ex_opb_select_2),
	.ex_alu_funcD(rs_ex_alu_func_2),
	.ex_pr_idxD(rs_ex_pr_idx_2),
	.ex_mt_idxD(rs_ex_mt_idx_2),
	.ex_rob_idxD(rs_ex_rob_idx_2),
	.ex_haltD(rs_ex_halt_2),
	.ex_illegalD(rs_ex_illegal_2),
	.ex_NPCD(rs_ex_NPC_2),
               
	// Outputs
	.mult_resultC_out(exC_mult_result_out),
	.doneC_out(exC_mult_valid_out),
	.pr_idxC_out(exC_pr_idx_out),
	.mt_idxC_out(exC_mt_idx_out),
 	.rob_idxC_out(exC_rob_idx_out),
	.NPCC_out(exC_NPC_out),/*
	.mult_resultC_out_early(exC_mult_result_out_early),
	.doneC_out_early(exC_mult_valid_out_early),
 	.pr_idxC_out_early(exC_pr_idx_early),
	.mt_idxC_out_early(exC_mt_idx_early),
	.rob_idxC_out_early(exC_rob_idx_early),
	.NPCC_out_early(exC_NPC_early),*/

	.mult_resultD_out(exD_mult_result_out),
	.doneD_out(exD_mult_valid_out),
	.pr_idxD_out(exD_pr_idx_out),
	.mt_idxD_out(exD_mt_idx_out),
 	.rob_idxD_out(exD_rob_idx_out),
	.NPCD_out(exD_NPC_out)/*,
	.mult_resultD_out_early(exD_mult_result_out_early),
	.doneD_out_early(exD_mult_valid_out_early),
 	.pr_idxD_out_early(exD_pr_idx_early),
	.mt_idxD_out_early(exD_mt_idx_early),
	.rob_idxD_out_early(exD_rob_idx_early),
	.NPCD_out_early(exD_NPC_early)*/
);

  //////////////////////////////////////////////////
  //                                              //
  //                  ex-stage                    //
  //                                              //
  //////////////////////////////////////////////////
alu_all aluA(// Inputs
                .clock(clock),
                .reset(reset),
                .id_ex_NPC(rs_ex_NPC_1),
		.id_ex_predicted_PC(rs_ex_predicted_PC_1),
                .id_ex_valid_in(rs_ex_en_in_1),
                .id_ex_IR(rs_ex_IR_1),
                .id_ex_rega(rs_ex_rega_1),
                .id_ex_regb(rs_ex_regb_1),
                .id_ex_opa_select(rs_ex_opa_select_1),
                .id_ex_opb_select(rs_ex_opb_select_1),
                .id_ex_alu_func(rs_ex_alu_func_1),
                .id_ex_cond_branch(rs_ex_cond_branch_1),
                .id_ex_uncond_branch(rs_ex_uncond_branch_1),
		.id_ex_predict_take_branch(rs_ex_branch_predict_taken_1),
		.id_ex_pr_idx(rs_ex_pr_idx_1),
		.id_ex_mt_idx(rs_ex_mt_idx_1),
		.id_ex_rob_idx(rs_ex_rob_idx_1),
		.id_ex_halt(rs_ex_halt_1),
		.id_ex_illegal(rs_ex_illegal_1),		
                
                // Outputs
                .ex_alu_result_out(exA_result),
                .ex_valid_out(exA_en),
                .ex_take_branch_out(exA_take_branch),
		.ex_pr_idx_out(exA_pr_idx),
		.ex_mt_idx_out(exA_mt_idx),
		.ex_rob_idx_out(exA_rob_idx),
		.ex_branch_mistaken_out(exA_branch_mistaken),
		.ex_branch_still_taken_out(exA_branch_still_taken)
);

alu_all aluB(// Inputs
                .clock(clock),
                .reset(reset),
                .id_ex_NPC(rs_ex_NPC_2),
		.id_ex_predicted_PC(rs_ex_predicted_PC_2),
                .id_ex_valid_in(rs_ex_en_in_2),
                .id_ex_IR(rs_ex_IR_2),
                .id_ex_rega(rs_ex_rega_2),
                .id_ex_regb(rs_ex_regb_2),
                .id_ex_opa_select(rs_ex_opa_select_2),
                .id_ex_opb_select(rs_ex_opb_select_2),
                .id_ex_alu_func(rs_ex_alu_func_2),
                .id_ex_cond_branch(rs_ex_cond_branch_2),
                .id_ex_uncond_branch(rs_ex_uncond_branch_2),
		.id_ex_predict_take_branch(rs_ex_branch_predict_taken_2),
		.id_ex_pr_idx(rs_ex_pr_idx_2),
		.id_ex_mt_idx(rs_ex_mt_idx_2),
		.id_ex_rob_idx(rs_ex_rob_idx_2),
		.id_ex_halt(rs_ex_halt_2),
		.id_ex_illegal(rs_ex_illegal_2),		
                
                // Outputs
                .ex_alu_result_out(exB_result),
                .ex_valid_out(exB_en),
                .ex_take_branch_out(exB_take_branch),
		.ex_pr_idx_out(exB_pr_idx),
		.ex_mt_idx_out(exB_mt_idx),
		.ex_rob_idx_out(exB_rob_idx),
		.ex_branch_mistaken_out(exB_branch_mistaken),
		.ex_branch_still_taken_out(exB_branch_still_taken)
);

endmodule
