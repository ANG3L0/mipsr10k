//////////////////////////////////////////////////////////////////////////
//                                                                      //
//   Modulename :  ex_stage.v                                           //
//                                                                      //
//  Description :  instruction execute (EX) stage of the pipeline;      //
//                 given the instruction command code CMD, select the   //
//                 proper input A and B for the ALU, compute the result,// 
//                 and compute the condition for branches, and pass all //
//                 the results down the pipeline. MWB                   // 
//                                                                      //
//                                                                      //
//////////////////////////////////////////////////////////////////////////

//
// The ALU
//
// given the command code CMD and proper operands A and B, compute the
// result of the instruction
//
// This module is purely combinational
//
module alu(//Inputs
           opa,
           opb,
           func,
           
           // Output
           result
);

  input  [63:0] opa;
  input  [63:0] opb;
  input   [4:0] func;
  output [63:0] result;
  reg    [63:0] result;

    // This function computes a signed less-than operation
  function signed_lt;
    input [63:0] a, b;
    
    if (a[63] == b[63]) 
      signed_lt = (a < b); // signs match: signed compare same as unsigned
    else
      signed_lt = a[63];   // signs differ: a is smaller if neg, larger if pos
  endfunction

  always @*
  begin
    case (func)
      `ALU_ADDQ:   result = opa + opb;
      `ALU_SUBQ:   result = opa - opb;
      `ALU_AND:    result = opa & opb;
      `ALU_BIC:    result = opa & ~opb;
      `ALU_BIS:    result = opa | opb;
      `ALU_ORNOT:  result = opa | ~opb;
      `ALU_XOR:    result = opa ^ opb;
      `ALU_EQV:    result = opa ^ ~opb;
      `ALU_SRL:    result = opa >> opb[5:0];
      `ALU_SLL:    result = opa << opb[5:0];
      `ALU_SRA:    result = (opa >> opb[5:0]) | ({64{opa[63]}} << (64 -
                             opb[5:0])); // arithmetic from logical shift
      `ALU_CMPULT: result = { 63'd0, (opa < opb) };
      `ALU_CMPEQ:  result = { 63'd0, (opa == opb) };
      `ALU_CMPULE: result = { 63'd0, (opa <= opb) };
      `ALU_CMPLT:  result = { 63'd0, signed_lt(opa, opb) };
      `ALU_CMPLE:  result = { 63'd0, (signed_lt(opa, opb) || (opa == opb)) };
      default:     result = 64'h0; // here only to force
                                                  // a combinational solution
                                                  // a casex would be better
    endcase
  end
endmodule // alu

//
// BrCond module
//
// Given the instruction code, compute the proper condition for the
// instruction; for branches this condition will indicate whether the
// target is taken.
//
// This module is purely combinational
//
module brcond(// Inputs
              opa,        // Value to check against condition
              func,       // Specifies which condition to check

              // Output
              cond        // 0/1 condition result (False/True)
             );

  input   [2:0] func;
  input  [63:0] opa;
  output        cond;
  
  reg           cond;

  always @*
  begin
    case (func[1:0]) // 'full-case'  All cases covered, no need for a default
      2'b00: cond = (opa[0] == 0);  // LBC: (lsb(opa) == 0) ?
      2'b01: cond = (opa == 0);     // EQ: (opa == 0) ?
      2'b10: cond = (opa[63] == 1); // LT: (signed(opa) < 0) : check sign bit
      2'b11: cond = (opa[63] == 1) || (opa == 0); // LE: (signed(opa) <= 0)
    endcase
  
     // negate cond if func[2] is set
    if (func[2])
      cond = ~cond;
  end
endmodule // brcond


module alu_all (// Inputs
                clock,
                reset,
                id_ex_NPC,
		id_ex_predicted_PC,
                id_ex_valid_in,
                id_ex_IR,
                id_ex_rega,
                id_ex_regb,
                id_ex_opa_select,
                id_ex_opb_select,
                id_ex_alu_func,
                id_ex_cond_branch,
                id_ex_uncond_branch,
		id_ex_predict_take_branch,
		id_ex_pr_idx,
		id_ex_mt_idx,
		id_ex_rob_idx,
		id_ex_halt,
		id_ex_illegal,
                
                // Outputs
                ex_alu_result_out,
                ex_valid_out,
                ex_take_branch_out,
		ex_pr_idx_out,
		ex_mt_idx_out,
		ex_rob_idx_out,
		ex_branch_mistaken_out,
		ex_branch_still_taken_out
               );

  input         clock;               // system clock
  input         reset;               // system reset
  input  [63:0] id_ex_NPC;           // incoming instruction PC+4
  input  [63:0] id_ex_predicted_PC;
  input         id_ex_valid_in;

  input  [31:0] id_ex_IR;            // incoming instruction
  input  [63:0] id_ex_rega;          // register A value from reg file
  input  [63:0] id_ex_regb;          // register B value from reg file
  input   [1:0] id_ex_opa_select;    // opA mux select from decoder
  input   [1:0] id_ex_opb_select;    // opB mux select from decoder
  input   [4:0] id_ex_alu_func;      // ALU function select from decoder
  input         id_ex_cond_branch;   // is this a cond br? from decoder
  input         id_ex_uncond_branch; // is this an uncond br? from decoder
  input		id_ex_predict_take_branch;
  input	  [5:0]	id_ex_pr_idx;
  input	  [4:0]	id_ex_mt_idx;
  input	  [4:0]	id_ex_rob_idx;
  input		id_ex_halt;
  input		id_ex_illegal;

  output        ex_valid_out;
  output [63:0] ex_alu_result_out;   // ALU result
  output        ex_take_branch_out;  // is this a taken branch?
  output  [5:0]	ex_pr_idx_out;
  output  [4:0]	ex_mt_idx_out;
  output  [4:0]	ex_rob_idx_out;
  output	ex_branch_mistaken_out;
  output	ex_branch_still_taken_out;

  reg    [63:0] opa_mux_out, opb_mux_out;
  reg           alu_valid;
  reg	  [5:0]	pr_idx;
  reg	  [4:0]	mt_idx;
  reg	  [4:0]	rob_idx;  
  wire          brcond_result;
   
   // set up possible immediates:
   //   mem_disp: sign-extended 16-bit immediate for memory format
   //   br_disp: sign-extended 21-bit immediate * 4 for branch displacement
   //   alu_imm: zero-extended 8-bit immediate for ALU ops
  wire [63:0] mem_disp = { {48{id_ex_IR[15]}}, id_ex_IR[15:0] };
  wire [63:0] br_disp  = { {41{id_ex_IR[20]}}, id_ex_IR[20:0], 2'b00 };
  wire [63:0] alu_imm  = { 56'b0, id_ex_IR[20:13] };
 
  assign ex_pr_idx_out = pr_idx;
  assign ex_mt_idx_out = mt_idx;
  assign ex_rob_idx_out = rob_idx;
  assign ex_valid_out = alu_valid;
 
  always @*
  begin
	alu_valid = (id_ex_alu_func != `ALU_MULQ) && id_ex_valid_in && ~id_ex_illegal;
	pr_idx = id_ex_pr_idx;
	mt_idx = id_ex_mt_idx;
	rob_idx = id_ex_rob_idx;   
	if(~alu_valid)
	begin
		alu_valid = 1'b0;
		pr_idx = 6'd31;
		mt_idx = 5'd31;
		rob_idx = 5'd31; 
	end
  end

   //
   // ALU opA mux
   //
  always @*
  begin
   opa_mux_out = 64'h0;
    case (id_ex_opa_select)
      `ALU_OPA_IS_REGA:     opa_mux_out = id_ex_rega;
      `ALU_OPA_IS_MEM_DISP: opa_mux_out = mem_disp;
      `ALU_OPA_IS_NPC:      opa_mux_out = id_ex_NPC;
      `ALU_OPA_IS_NOT3:     opa_mux_out = ~64'h3;
    endcase
  end

   //
   // ALU opB mux
   //
  always @*
  begin
     // Default value, Set only because the case isnt full.  If you see this
     // value on the output of the mux you have an invalid opb_select
    opb_mux_out = 64'h0;
    case (id_ex_opb_select)
      `ALU_OPB_IS_REGB:    opb_mux_out = id_ex_regb;
      `ALU_OPB_IS_ALU_IMM: opb_mux_out = alu_imm;
      `ALU_OPB_IS_BR_DISP: opb_mux_out = br_disp;
    endcase 
  end

   //
   // instantiate the ALU
   //
  alu alu_0 (// Inputs
             .opa(opa_mux_out),
             .opb(opb_mux_out),
             .func(id_ex_alu_func),

             // Output
             .result(ex_alu_result_out)
            );

   //
   // instantiate the branch condition tester
   //
  brcond brcond (// Inputs
                .opa(id_ex_rega),       // always check regA value
                .func(id_ex_IR[28:26]), // inst bits to determine check

                // Output
                .cond(brcond_result)
               );

   // ultimate "take branch" signal:
   //    unconditional, or conditional and the condition is true
  assign ex_take_branch_out = id_ex_uncond_branch
                          | (id_ex_cond_branch & brcond_result) && (alu_valid) ;

  assign ex_branch_mistaken_out = (id_ex_predict_take_branch && ~ex_take_branch_out) && (alu_valid);

  assign ex_branch_still_taken_out = ( (~id_ex_predict_take_branch && ex_take_branch_out) |
				       (id_ex_predict_take_branch && ex_take_branch_out && (id_ex_predicted_PC != (ex_alu_result_out) ) ) )
					&& (alu_valid);

endmodule // module ex_stage

