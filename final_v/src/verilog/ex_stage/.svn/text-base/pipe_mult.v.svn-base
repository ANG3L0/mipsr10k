// This is an 8 stage (9 depending on how you look at it) pipelined 
// multiplier that multiplies 2 64-bit integers and returns the low 64 bits 
// of the result.  This is not an ideal multiplier but is sufficient to 
// allow a faster clock period than straight *
// This module instantiates 8 pipeline stages as an array of submodules.
module pipe_mult(
	clock,
	reset,
	start,
	mplier,
	mcand,
	pr_idx_in,
	mt_idx_in,
	rob_idx_in,
	NPC_in,

	product,
	done,
//	done_early,
	pr_idx_out,
	mt_idx_out,
	rob_idx_out,
	NPC_out/*,
	pr_idx_out_early,
	mt_idx_out_early,
	rob_idx_out_early,
	product_out_early,
	NPC_out_early*/
);

  input clock, reset, start;
  input [63:0] mcand, mplier;
  input [5:0]  pr_idx_in;
  input [4:0]  mt_idx_in;
  input [4:0]  rob_idx_in;
  input [63:0] NPC_in;

  output [63:0] product;
  output        done;
//  output        done_early;
  output [5:0]  pr_idx_out;
  output [4:0]  mt_idx_out;
  output [4:0]  rob_idx_out;
  output [63:0] NPC_out;
/*  output [5:0]  pr_idx_out_early;
  output [4:0]  mt_idx_out_early;
  output [4:0]  rob_idx_out_early;
  output [63:0] product_out_early;
  output [63:0] NPC_out_early;

  reg           done_early;
  reg    [5:0]  pr_idx_out_early;
  reg    [4:0]  mt_idx_out_early;
  reg    [4:0]  rob_idx_out_early;
  reg    [63:0] NPC_out_early;
*/
  wire [63:0] mcand_out, mplier_out;
  wire [(7*64)-1:0] internal_products, internal_mcands, internal_mpliers;

  wire [(7*6)-1:0] internal_pr_idx;
  wire [(7*5)-1:0] internal_mt_idx;
  wire [(7*5)-1:0] internal_rob_idx;
  wire [(7*64)-1:0] internal_NPC;
  wire  [6:0] internal_dones;
/*
  wire [63:0] product_in_early;
  wire [63:0] partial_product_early;
  wire [63:0] mplier_in_early;
  wire [63:0] mcand_in_early;


  assign mplier_in_early = {8'b0,internal_mpliers[(7*64)-1:(6*64)+8]};
  assign mcand_in_early = {internal_mcands[(7*64)-1-8:(6*64)],8'b0};
  assign product_in_early = internal_products[(64*7)-1:(64*6)];
  assign partial_product_early = mplier_in_early[7:0] * mcand_in_early;
  assign product_out_early = product_in_early + partial_product_early;

  always @(posedge clock)
  begin
    if(reset)
      begin
      done_early <= `SD 1'b0;
      pr_idx_out_early <= `SD 6'd31;
      mt_idx_out_early <= `SD 5'd31;
      rob_idx_out_early <= `SD 5'd31;
      NPC_out_early <= `SD 64'd0;
      end
    else
      begin
      done_early <= `SD internal_dones[5];
      pr_idx_out_early <= `SD internal_pr_idx[(6*6)-1:(5*6)];
      mt_idx_out_early <= `SD internal_mt_idx[(6*5)-1:(5*5)];
      rob_idx_out_early <= `SD internal_rob_idx[(6*5)-1:(5*5)]; 
      NPC_out_early <= `SD internal_NPC[(6*64)-1:(5*64)];
      end
  end
*/
  mult_stage mstage [7:0] 
    (.clock(clock),
     .reset(reset),
     .product_in({internal_products,64'h0}),
     .mplier_in({internal_mpliers,mplier}),
     .mcand_in({internal_mcands,mcand}),
     .start({internal_dones,start}),
     .pr_idx_in({internal_pr_idx,pr_idx_in}),
     .mt_idx_in({internal_mt_idx,mt_idx_in}),
     .rob_idx_in({internal_rob_idx,rob_idx_in}),
     .NPC_in({internal_NPC,NPC_in}),
     .product_out({product,internal_products}),
     .mplier_out({mplier_out,internal_mpliers}),
     .mcand_out({mcand_out,internal_mcands}),
     .done({done,internal_dones}),
     .pr_idx_out({pr_idx_out,internal_pr_idx}),
     .mt_idx_out({mt_idx_out,internal_mt_idx}),
     .rob_idx_out({rob_idx_out,internal_rob_idx}),
     .NPC_out({NPC_out,internal_NPC})
    );

endmodule
