// This is one stage of an 8 stage (9 depending on how you look at it)
// pipelined multiplier that multiplies 2 64-bit integers and returns
// the low 64 bits of the result.  This is not an ideal multiplier but
// is sufficient to allow a faster clock period than straight *
module mult_stage(
	clock,
	reset, 
	product_in,
	mplier_in,
	mcand_in,
	start,
	pr_idx_in,
	mt_idx_in,
	rob_idx_in,
	NPC_in,
	product_out,
	mplier_out,
	mcand_out,
	done,
	pr_idx_out,
	mt_idx_out,
	rob_idx_out,
	NPC_out
);

  input clock, reset, start;
  input [63:0] product_in, mplier_in, mcand_in;
  input [5:0]  pr_idx_in;
  input [4:0]  mt_idx_in;
  input [4:0]  rob_idx_in;
  input [63:0] NPC_in;

  output [63:0] product_out, mplier_out, mcand_out;
  output        done;
  output [5:0]  pr_idx_out;
  output [4:0]  mt_idx_out;
  output [4:0]  rob_idx_out;
  output [63:0] NPC_out;

  reg  [63:0] prod_in_reg, partial_prod_reg;
  wire [63:0] partial_product, next_mplier, next_mcand;


  reg [63:0] mplier_out, mcand_out;
  reg [5:0]  pr_idx_out;
  reg [4:0]  mt_idx_out;
  reg [4:0]  rob_idx_out;
  reg [63:0] NPC_out;
  reg        done;
  
  assign product_out = prod_in_reg + partial_prod_reg;

  assign partial_product = mplier_in[7:0] * mcand_in;

  assign next_mplier = {8'b0,mplier_in[63:8]};
  assign next_mcand = {mcand_in[55:0],8'b0};

  always @(posedge clock)
  begin
    prod_in_reg      <= `SD product_in;
    partial_prod_reg <= `SD partial_product;
    mplier_out       <= `SD next_mplier;
    mcand_out        <= `SD next_mcand;
  end

  always @(posedge clock)
  begin
    if(reset)
      begin
      done <= `SD 1'b0;
      pr_idx_out <= `SD 6'd31;
      mt_idx_out <= `SD 5'd31;
      rob_idx_out <= `SD 5'd31; 
      NPC_out <= `SD 64'd0;
      end
    else
      begin
      done <= `SD start;
      pr_idx_out <= `SD pr_idx_in;
      mt_idx_out <= `SD mt_idx_in;
      rob_idx_out <= `SD rob_idx_in;
      NPC_out <= `SD NPC_in;
      end
  end
endmodule
