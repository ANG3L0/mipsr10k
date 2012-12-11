module mult_decoder (
	// Inputs
	clock,
	reset,

	ex_en_inC,
	ex_IRC,
	ex_regaC,
	ex_regbC,
	ex_opa_selectC,
	ex_opb_selectC,
	ex_alu_funcC,
	ex_pr_idxC,
	ex_mt_idxC,
	ex_rob_idxC,
	ex_haltC,
	ex_illegalC,
	ex_NPCC,

	ex_en_inD,
	ex_IRD,
	ex_regaD,
	ex_regbD,
	ex_opa_selectD,
	ex_opb_selectD,
	ex_alu_funcD,
	ex_pr_idxD,
	ex_mt_idxD,
	ex_rob_idxD,
	ex_haltD,
	ex_illegalD,
	ex_NPCD,
               
	// Outputs
	mult_resultC_out,
	doneC_out,
	pr_idxC_out,
	mt_idxC_out,
 	rob_idxC_out,
	NPCC_out,
/*	mult_resultC_out_early,
	doneC_out_early,
 	pr_idxC_out_early,
	mt_idxC_out_early,
	rob_idxC_out_early,
	NPCC_out_early,*/

	mult_resultD_out,
	doneD_out,
	pr_idxD_out,
	mt_idxD_out,
 	rob_idxD_out,
	NPCD_out/*,
	mult_resultD_out_early,
	doneD_out_early,
 	pr_idxD_out_early,
	mt_idxD_out_early,
	rob_idxD_out_early,
	NPCD_out_early*/

);

  input         	clock;
  input	      		reset;

  input			ex_en_inC;
  input     [31:0]	ex_IRC;
  input     [63:0]	ex_regaC;
  input     [63:0]	ex_regbC;
  input      [1:0]  	ex_opa_selectC;
  input      [1:0]     	ex_opb_selectC;
  input      [4:0]     	ex_alu_funcC;
  input      [5:0]     	ex_pr_idxC;
  input      [4:0]     	ex_mt_idxC;
  input      [4:0]     	ex_rob_idxC;
  input			ex_haltC;
  input			ex_illegalC;
  input	    [63:0]      ex_NPCC;

  input                	ex_en_inD;
  input     [31:0]     	ex_IRD;    
  input     [63:0]     	ex_regaD;
  input     [63:0]     	ex_regbD;
  input      [1:0]     	ex_opa_selectD;
  input      [1:0]     	ex_opb_selectD;
  input      [4:0]     	ex_alu_funcD;
  input      [5:0]     	ex_pr_idxD;
  input      [4:0]     	ex_mt_idxD;
  input      [4:0]     	ex_rob_idxD;
  input			ex_haltD;
  input			ex_illegalD;
  input	    [63:0]      ex_NPCD;

  output        doneC_out;
  output [63:0] mult_resultC_out;
  output [5:0]  pr_idxC_out;
  output [4:0]  mt_idxC_out;
  output [4:0]  rob_idxC_out;
  output [63:0] NPCC_out;
/*  output        doneC_out_early;
  output [63:0] mult_resultC_out_early;
  output [5:0]  pr_idxC_out_early;
  output [4:0]  mt_idxC_out_early;
  output [4:0]  rob_idxC_out_early;
  output [63:0] NPCC_out_early;*/

  output        doneD_out;
  output [63:0] mult_resultD_out;
  output [5:0]  pr_idxD_out;
  output [4:0]  mt_idxD_out;
  output [4:0]  rob_idxD_out;
  output [63:0] NPCD_out;/*
  output        doneD_out_early;
  output [63:0] mult_resultD_out_early;
  output [5:0]  pr_idxD_out_early;
  output [4:0]  mt_idxD_out_early;
  output [4:0]  rob_idxD_out_early;
  output [63:0] NPCD_out_early;*/

  reg    	multC_en;
  reg    [5:0]  pr_idxC;
  reg    [4:0]  mt_idxC;
  reg    [4:0]  rob_idxC;
  reg	 [63:0] NPCC;
  reg    [63:0] opa_muxC_out;
  reg    [63:0] opb_muxC_out;

  reg    	multD_en;
  reg    [5:0]  pr_idxD;
  reg    [4:0]  mt_idxD;
  reg    [4:0]  rob_idxD;
  reg	 [63:0] NPCD;
  reg    [63:0] opa_muxD_out;
  reg    [63:0] opb_muxD_out; 
  reg		mult_validC;
  reg		mult_validD;
   // set up possible immediates:
   //   mem_disp: sign-extended 16-bit immediate for memory format
   //   br_disp: sign-extended 21-bit immediate * 4 for branch displacement
   //   alu_imm: zero-extended 8-bit immediate for ALU ops

  wire [63:0] multC_imm;
  wire [63:0] multD_imm;
  
  assign multC_imm = { 56'b0, ex_IRC[20:13] };
  assign multD_imm = { 56'b0, ex_IRD[20:13] };

  always @*
  begin
	mult_validC = (ex_alu_funcC == `ALU_MULQ) && ex_en_inC && ~ex_illegalC ;
  	if (mult_validC)
	begin
		multC_en = 1'b1;
		pr_idxC = ex_pr_idxC;
		mt_idxC = ex_mt_idxC;
		rob_idxC = ex_rob_idxC;
		NPCC = ex_NPCC;
	end
 	else 
	begin
		multC_en = 1'b0;
		pr_idxC = 6'd31;
		mt_idxC = 5'd31;
		rob_idxC = 5'd31;
		NPCC = 64'h0;
	end
  end

  always @*
  begin
	mult_validD = (ex_alu_funcD == `ALU_MULQ) && ex_en_inD && ~ex_illegalD ;
  	if (mult_validD)
	begin
		multD_en = 1'b1;
		pr_idxD = ex_pr_idxD;
		mt_idxD = ex_mt_idxD;
		rob_idxD = ex_rob_idxD;
		NPCD = ex_NPCD;
	end
 	else 
	begin
		multD_en = 1'b0;
		pr_idxD = 6'd31;
		mt_idxD = 5'd31;
		rob_idxD = 5'd31;
		NPCD = 64'h0;
	end
  end

   //
   // ALU opA mux
   //
  always @*
  begin
    opa_muxC_out = 64'h0;
    opa_muxD_out = 64'h0;
    if(ex_opa_selectC == `ALU_OPA_IS_REGA)
	opa_muxC_out = ex_regaC;
    if(ex_opa_selectD == `ALU_OPA_IS_REGA)
	opa_muxD_out = ex_regaD;
  end
   //
   // ALU opB mux
   //
  always @*
  begin
    opb_muxC_out = 64'h0;
    opb_muxD_out = 64'h0;
    if ((ex_opb_selectC == `ALU_OPB_IS_REGB) && (ex_alu_funcC == `ALU_MULQ) && ex_en_inC)
	opb_muxC_out = ex_regbC;
    else if ((ex_opb_selectC == `ALU_OPB_IS_ALU_IMM) && (ex_alu_funcC == `ALU_MULQ) && ex_en_inC)
	opb_muxC_out = multC_imm;

    if ((ex_opb_selectD == `ALU_OPB_IS_REGB) && (ex_alu_funcD == `ALU_MULQ) && ex_en_inD)
	opb_muxD_out = ex_regbD;
    else if ((ex_opb_selectD == `ALU_OPB_IS_ALU_IMM) && (ex_alu_funcD == `ALU_MULQ) && ex_en_inD)
	opb_muxD_out = multD_imm;
  end

pipe_mult pipe_mult_C(
	.clock(clock),
	.reset(reset),
	.pr_idx_in(pr_idxC),
	.mt_idx_in(mt_idxC),
	.rob_idx_in(rob_idxC),
	.mplier(opa_muxC_out),
	.mcand(opb_muxC_out),
	.start(multC_en),
	.NPC_in(NPCC),

	.product(mult_resultC_out),
	.done(doneC_out),
	.pr_idx_out(pr_idxC_out),
	.mt_idx_out(mt_idxC_out),
	.rob_idx_out(rob_idxC_out),
	.NPC_out(NPCC_out)/*,
        .done_early(doneC_out_early),
	.pr_idx_out_early(pr_idxC_out_early),
	.mt_idx_out_early(mt_idxC_out_early),
	.rob_idx_out_early(rob_idxC_out_early),
	.product_out_early(mult_resultC_out_early),
	.NPC_out_early(NPCC_out_early)*/
);

pipe_mult pipe_mult_D(
	.clock(clock),
	.reset(reset),
	.pr_idx_in(pr_idxD),
	.mt_idx_in(mt_idxD),
	.rob_idx_in(rob_idxD),
	.mplier(opa_muxD_out),
	.mcand(opb_muxD_out),
	.start(multD_en),
	.NPC_in(NPCD),

	.product(mult_resultD_out),
	.done(doneD_out),
	.pr_idx_out(pr_idxD_out),
	.mt_idx_out(mt_idxD_out),
	.rob_idx_out(rob_idxD_out),
	.NPC_out(NPCD_out)/*,
        .done_early(doneD_out_early),
	.pr_idx_out_early(pr_idxD_out_early),
	.mt_idx_out_early(mt_idxD_out_early),
	.rob_idx_out_early(rob_idxD_out_early),
	.product_out_early(mult_resultD_out_early),
	.NPC_out_early(NPCD_out_early)*/
);
endmodule
