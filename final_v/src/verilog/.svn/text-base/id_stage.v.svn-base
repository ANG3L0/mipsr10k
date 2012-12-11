/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  id_stage.v                                          //
//                                                                     //
//  Description :  instruction decode (ID) stage of the pipeline;      // 
//                 decode the instruction fetch register operands, and // 
//                 compute immediate operand (if applicable)           // 
//                                                                     //
/////////////////////////////////////////////////////////////////////////


//`timescale 1ns/100ps


  // Decode an instruction: given instruction bits IR produce the
  // appropriate datapath control signals.
  //
  // This is a *combinational* module (basically a PLA).
  //
module decoder(// Inputs
               inst,
               valid_inst_in,  // ignore inst when low, outputs will
               invalid,                // reflect noop (except valid_inst)

               // Outputs
               opa_select,
               opb_select,
               alu_func,
               dest_reg,
               rd_mem,
               wr_mem,
               cond_branch,
               uncond_branch,
               halt,           // non-zero on a halt
               illegal,        // non-zero on an illegal instruction 
               valid_inst      // for counting valid instructions executed
                               // and for making the fetch stage die on halts/
                               // keeping track of when to allow the next
                               // instruction out of fetch
                               // 0 for HALT and illegal instructions (die on halt)
              );

  input [31:0] inst;
  input valid_inst_in;
  input invalid;


  output [1:0] opa_select, opb_select, dest_reg; // mux selects
  output [4:0] alu_func;
  output rd_mem, wr_mem, cond_branch, uncond_branch, halt, illegal, valid_inst;

  reg [1:0] opa_select, opb_select, dest_reg; // mux selects
  reg [4:0] alu_func;
  reg rd_mem, wr_mem, cond_branch, uncond_branch, halt, illegal;

  assign valid_inst = valid_inst_in & ~illegal & !invalid;
  always @*
  begin
      // default control values:
      // - valid instructions must override these defaults as necessary.
      //   opa_select, opb_select, and alu_func should be set explicitly.
      // - invalid instructions should clear valid_inst.
      // - These defaults are equivalent to a noop
      // * see sys_defs.vh for the constants used here
    opa_select = 0;
    opb_select = 0;
    alu_func = 0;
    dest_reg = `DEST_NONE;
    rd_mem = `FALSE;
    wr_mem = `FALSE;
    cond_branch = `FALSE;
    uncond_branch = `FALSE;
    halt = `FALSE;
    illegal = `FALSE;
    if(valid_inst_in)
    begin
      case ({inst[31:29], 3'b0})
        6'h0:
          case (inst[31:26])
            `PAL_INST:
               if (inst[25:0] == 26'h0555)
                 halt = `TRUE;
               else
                 illegal = `TRUE;
            default: illegal = `TRUE;
          endcase // case(inst[31:26])
         
        6'h10:
          begin
            opa_select = `ALU_OPA_IS_REGA;
            opb_select = inst[12] ? `ALU_OPB_IS_ALU_IMM : `ALU_OPB_IS_REGB;
            dest_reg = `DEST_IS_REGC;
            case (inst[31:26])
              `INTA_GRP:
                 case (inst[11:5])
                   `CMPULT_INST:  alu_func = `ALU_CMPULT;
                   `ADDQ_INST:    alu_func = `ALU_ADDQ;
                   `SUBQ_INST:    alu_func = `ALU_SUBQ;
                   `CMPEQ_INST:   alu_func = `ALU_CMPEQ;
                   `CMPULE_INST:  alu_func = `ALU_CMPULE;
                   `CMPLT_INST:   alu_func = `ALU_CMPLT;
                   `CMPLE_INST:   alu_func = `ALU_CMPLE;
                    default:      illegal = `TRUE;
                  endcase // case(inst[11:5])
              `INTL_GRP:
                case (inst[11:5])
                  `AND_INST:    alu_func = `ALU_AND;
                  `BIC_INST:    alu_func = `ALU_BIC;
                  `BIS_INST:    alu_func = `ALU_BIS;
                  `ORNOT_INST:  alu_func = `ALU_ORNOT;
                  `XOR_INST:    alu_func = `ALU_XOR;
                  `EQV_INST:    alu_func = `ALU_EQV;
                  default:      illegal = `TRUE;
                endcase // case(inst[11:5])
              `INTS_GRP:
                case (inst[11:5])
                  `SRL_INST:  alu_func = `ALU_SRL;
                  `SLL_INST:  alu_func = `ALU_SLL;
                  `SRA_INST:  alu_func = `ALU_SRA;
                  default:    illegal = `TRUE;
                endcase // case(inst[11:5])
              `INTM_GRP:
                case (inst[11:5])
                  `MULQ_INST:       alu_func = `ALU_MULQ;
                  default:          illegal = `TRUE;
                endcase // case(inst[11:5])
              `ITFP_GRP:       illegal = `TRUE;       // unimplemented
              `FLTV_GRP:       illegal = `TRUE;       // unimplemented
              `FLTI_GRP:       illegal = `TRUE;       // unimplemented
              `FLTL_GRP:       illegal = `TRUE;       // unimplemented
            endcase // case(inst[31:26])
          end
           
        6'h18:
          case (inst[31:26])
            `MISC_GRP:       illegal = `TRUE; // unimplemented
            `JSR_GRP:
               begin
                 // JMP, JSR, RET, and JSR_CO have identical semantics
                 opa_select = `ALU_OPA_IS_NOT3;
                 opb_select = `ALU_OPB_IS_REGB;
                 alu_func = `ALU_AND; // clear low 2 bits (word-align)
                 dest_reg = `DEST_IS_REGA;
                 uncond_branch = `TRUE;
               end
            `FTPI_GRP:       illegal = `TRUE;       // unimplemented
           endcase // case(inst[31:26])
           
        6'h08, 6'h20, 6'h28:
          begin
            opa_select = `ALU_OPA_IS_MEM_DISP;
            opb_select = `ALU_OPB_IS_REGB;
            alu_func = `ALU_ADDQ;
            dest_reg = `DEST_IS_REGA;
            case (inst[31:26])
              `LDA_INST:  /* defaults are OK */;
              `LDQ_INST:
                begin
                  rd_mem = `TRUE;
                  dest_reg = `DEST_IS_REGA;
                end // case: `LDQ_INST
              `STQ_INST:
                begin
                  wr_mem = `TRUE;
                  dest_reg = `DEST_NONE;
                end // case: `STQ_INST
              default:       illegal = `TRUE;
            endcase // case(inst[31:26])
          end
           
        6'h30, 6'h38:
          begin
            opa_select = `ALU_OPA_IS_NPC;
            opb_select = `ALU_OPB_IS_BR_DISP;
            alu_func = `ALU_ADDQ;
            case (inst[31:26])
              `FBEQ_INST, `FBLT_INST, `FBLE_INST,
              `FBNE_INST, `FBGE_INST, `FBGT_INST:
                begin
                  // FP conditionals not implemented
                  illegal = `TRUE;
                end
              
            `BR_INST, `BSR_INST:
                begin
                  dest_reg = `DEST_IS_REGA;
                  uncond_branch = `TRUE;
                end
    /*
              `BR_INST:
               begin
                 dest_reg = `DEST_NONE;
                 uncond_branch = `TRUE;
               end


               `BSR_INST:
                begin
                  dest_reg = `DEST_IS_REGA;
                  uncond_branch = `TRUE;
                end
*/
              default:
                cond_branch = `TRUE; // all others are conditional
            endcase // case(inst[31:26])
          end
      endcase // case(inst[31:29] << 3)
    end // if(~valid_inst_in)
  end // always
   
endmodule // decoder

module id_stage(
              // Inputs
//              clock,
//              reset,
              if_id_IRA,
              if_id_IRB,
              if_id_valid_instA,
              if_id_valid_instB,
              almost_full,
              full,
              rs_almost_full,
              rs_full,

              // Outputs
              id_opa_select_outA,
              id_opb_select_outA,
              id_opa_select_outB,
              id_opb_select_outB,

              id_rdaAidx,
              id_rdbAidx,
              id_rdaBidx,
              id_rdbBidx,


              id_dest_reg_idx_outA,
              id_dest_reg_idx_outB,
              id_alu_func_outA,
              id_alu_func_outB,
              id_IRA_out,
              id_IRB_out,
              id_IRA_valid_out,
              id_IRB_valid_out,
              id_illegal_outA,
              id_illegal_outB,
              id_halt_outA,
              id_halt_outB,
              id_rd_mem_outA,
              id_wr_mem_outA,
              id_cond_branch_outA,
              id_uncond_branch_outA,
              id_rd_mem_outB,
              id_wr_mem_outB,
              id_cond_branch_outB,
              id_uncond_branch_outB

              );

 // input 
//  input         clock;                // system clock
//  input         reset;                // system reset
  input  [31:0] if_id_IRA;             // incoming instruction
  input  [31:0] if_id_IRB;
  input         if_id_valid_instA;
  input         if_id_valid_instB;
  input         almost_full;
  input         full;
  input         rs_almost_full;
  input         rs_full;

  // output 
  output  [1:0] id_opa_select_outA;    // ALU opa mux select (ALU_OPA_xxx *)
  output  [1:0] id_opb_select_outA;    // ALU opb mux select (ALU_OPB_xxx *)
  output  [1:0] id_opa_select_outB;    // ALU opa mux select (ALU_OPA_xxx *)
  output  [1:0] id_opb_select_outB;    // ALU opb mux select (ALU_OPB_xxx *)

  output  [4:0] id_rdaAidx;
  output  [4:0] id_rdbAidx;
  output  [4:0] id_rdaBidx;
  output  [4:0] id_rdbBidx;

  output  [4:0] id_dest_reg_idx_outA;  // destination (writeback) register index
  output  [4:0] id_dest_reg_idx_outB;                                    // (ZERO_REG if no writeback)
  output  [4:0] id_alu_func_outA;      // ALU function select (ALU_xxx *)
  output  [4:0] id_alu_func_outB;
  
  output  [31:0] id_IRA_out;
  output  [31:0] id_IRB_out;                                   // counted for CPI calculations?
  output         id_IRA_valid_out;
  output         id_IRB_valid_out;  
  output         id_illegal_outA;
  output         id_illegal_outB;
  output         id_halt_outA;
  output         id_halt_outB;
  output         id_rd_mem_outA;
  output         id_wr_mem_outA;
  output         id_cond_branch_outA;
  output         id_uncond_branch_outA;
  output         id_rd_mem_outB;
  output         id_wr_mem_outB;
  output         id_cond_branch_outB;
  output         id_uncond_branch_outB;

  wire    [1:0] dest_reg_selectA;
  wire    [1:0] dest_reg_selectB;
  reg     [4:0] id_dest_reg_idx_outA;     // not state: behavioral mux output
  reg     [4:0] id_dest_reg_idx_outB;
  reg  [31:0]    if_id_IRA_reg;
  reg            if_id_IRA_valid_reg;
  reg  [31:0]    if_id_IRB_reg;
  reg            if_id_IRB_valid_reg;


  wire          id_valid_inst_outA;
  wire          id_valid_inst_outB;
  
  wire           invalid;

  assign invalid    = almost_full | full | rs_almost_full | rs_full;

  assign id_IRA_out = ((if_id_IRA[31:29] == 0) && (if_id_IRA[31:26] == `PAL_INST) && (if_id_IRA[25:0] != 26'h0555)) ? if_id_IRB : if_id_IRA;
  assign id_IRB_out = ((if_id_IRA[31:29] == 0) && (if_id_IRA[31:26] == `PAL_INST) && (if_id_IRA[25:0] != 26'h0555)) ? if_id_IRA : if_id_IRB;
  assign id_IRA_valid_out = id_valid_inst_outA;
  assign id_IRB_valid_out = id_valid_inst_outB;

 
            // instruction fields read from IF/ID pipeline register 
  wire    [4:0] ra_idxA = if_id_IRA[25:21];   // inst operand A register index
  wire    [4:0] rb_idxA = if_id_IRA[20:16];   // inst operand B register index
  wire    [4:0] rc_idxA = if_id_IRA[4:0];     // inst operand C register index


  wire    [4:0] ra_idxB = if_id_IRB[25:21];   // inst operand A register index
  wire    [4:0] rb_idxB = if_id_IRB[20:16];   // inst operand B register index
  wire    [4:0] rc_idxB = if_id_IRB[4:0];     // inst operand C register index

        assign  id_rdaAidx = ra_idxA;
        assign  id_rdbAidx = rb_idxA;
        assign  id_rdaBidx = ra_idxB;
        assign  id_rdbBidx = rb_idxB;




//  wire id_valid_inst_outA;




//  wire id_valid_inst_outB;

/////////////////Lulu Ji/////////////11/25/2012/////

  always @*
  begin
    if_id_IRA_reg = if_id_IRA;
    if_id_IRA_valid_reg = if_id_valid_instA;
    if_id_IRB_reg = if_id_IRB;
    if_id_IRB_valid_reg = if_id_valid_instB;

    if((if_id_IRA[31:29] == 0) && (if_id_IRA[31:26] == `PAL_INST) && (if_id_IRA[25:0] != 26'h0555))
    begin
      if_id_IRA_reg = if_id_IRB;
      if_id_IRA_valid_reg = if_id_valid_instB;
      if_id_IRB_reg = if_id_IRA;
      if_id_IRB_valid_reg = if_id_valid_instA;
    end

  end


    // instantiate the instruction decoder
  decoder decoder_0 (  // input
                     .inst(if_id_IRA_reg),
                     .valid_inst_in(if_id_IRA_valid_reg),
                     .invalid(invalid),
                         
                       // outputs
                     .opa_select(id_opa_select_outA),
                     .opb_select(id_opb_select_outA),
                     .alu_func(id_alu_func_outA),
                     .dest_reg(dest_reg_selectA),
                     .rd_mem(id_rd_mem_outA),
                     .wr_mem(id_wr_mem_outA),
                     .cond_branch(id_cond_branch_outA),
                     .uncond_branch(id_uncond_branch_outA),
                     .halt(id_halt_outA),
                     .illegal(id_illegal_outA),
                     .valid_inst(id_valid_inst_outA)
                    );

  decoder decoder_1 ( // inputs
                     .inst(if_id_IRB_reg),
                     .valid_inst_in(if_id_IRB_valid_reg),
                     .invalid(invalid),

                      // outputs
                     .opa_select(id_opa_select_outB),
                     .opb_select(id_opb_select_outB),
                     .alu_func(id_alu_func_outB),
                     .dest_reg(dest_reg_selectB),
                     .rd_mem(id_rd_mem_outB),
                     .wr_mem(id_wr_mem_outB),
                     .cond_branch(id_cond_branch_outB),
                     .uncond_branch(id_uncond_branch_outB),
                     .halt(id_halt_outB),
                     .illegal(id_illegal_outB),
                     .valid_inst(id_valid_inst_outB)
                    );



     // mux to generate dest_reg_idx based pn
     // the dest_reg_select output from decoder



  always @*
    begin
      case (dest_reg_selectA)
        `DEST_IS_REGC: id_dest_reg_idx_outA = rc_idxA;
        `DEST_IS_REGA: id_dest_reg_idx_outA = ra_idxA;
        `DEST_NONE:    id_dest_reg_idx_outA = `ZERO_REG;
        default:       id_dest_reg_idx_outA = `ZERO_REG; 
      endcase
    end



  always @*
    begin
      case (dest_reg_selectB)
        `DEST_IS_REGC: id_dest_reg_idx_outB = rc_idxB;
        `DEST_IS_REGA: id_dest_reg_idx_outB = ra_idxB;
        `DEST_NONE:    id_dest_reg_idx_outB = `ZERO_REG;
        default:       id_dest_reg_idx_outB = `ZERO_REG;
      endcase
    end





   
endmodule // module id_stage
