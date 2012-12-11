/////////////////////////////////////////////////////////////////////////
//                                                                     //
//   Modulename :  pr.v	                                               //
//                                                                     //
//  Description :  This module creates the Regfile used by the ID and  // 
//                 WB Stages of the Pipeline.                          //
//                                                                     //
/////////////////////////////////////////////////////////////////////////


//`timescale 1ns/100ps

//`define CDBWIDTH 6
//`define SD       #1
//`define ZERO_REG 6'd31

module pr(
	//inputs
	wr_clk,
	reset,
	rs_T1A,
	rs_T1B,
	rs_T2A,
	rs_T2B,

	ex_cm_cdbAIdx,
	ex_cm_resultA,
	ex_cm_cdbBIdx,
	ex_cm_resultB,
  ex_cm_cdbCIdx,
  ex_cm_cdbDIdx,
  ex_cm_resultC,
  ex_cm_resultD,

  exA_NPC_out,
  exB_NPC_out,
  exA_cond_branch_out,
  exB_cond_branch_out,
  exA_uncond_branch_out,
  exB_uncond_branch_out,

	wr_cdbAIdx_en,
	wr_cdbBIdx_en,
	wr_cdbCIdx_en,
        wr_cdbDIdx_en,

	//outputs
	pr_T1A_out,
	pr_T2A_out,
	pr_T1B_out,
	pr_T2B_out
);


//inputs
input wr_clk;
input reset;
//read idx
input [5:0]	rs_T1A; //reservation station tells physical register what source operands (indices) to read
input [5:0]	rs_T1B;
input [5:0]	rs_T2A;
input [5:0]	rs_T2B;

//write idx & data
input [`CDBWIDTH-1:0]	ex_cm_cdbAIdx; //index to write into at complete
input [63:0]		ex_cm_resultA; //value to write at complete
input [`CDBWIDTH-1:0]	ex_cm_cdbBIdx; //second index to write into at complete
input [63:0]		ex_cm_resultB; //second index to write into at complete
input [`CDBWIDTH-1:0]   ex_cm_cdbCIdx;
input [63:0]            ex_cm_resultC;
input [`CDBWIDTH-1:0]   ex_cm_cdbDIdx;
input [63:0]            ex_cm_resultD;



//enable writing
input			wr_cdbAIdx_en; //enable signal for "A" writing
input			wr_cdbBIdx_en; //enable signal for "B" writing
input                   wr_cdbCIdx_en;
input                   wr_cdbDIdx_en;

//unconditional jumps - > $r26 return addr instead of targetPC
input  [63:0]   exA_NPC_out;
input  [63:0]   exB_NPC_out;
input           exA_cond_branch_out;
input           exB_cond_branch_out;
input           exA_uncond_branch_out;
input           exB_uncond_branch_out;
//read outputs
output reg [63:0]	pr_T1A_out; //Possible source operands for execution
output reg [63:0]	pr_T2A_out;
output reg [63:0]	pr_T1B_out;
output reg [63:0]	pr_T2B_out;

reg    [63:0] registers[63:0];
reg    [6:0]  i;

wire   [63:0] rd1A_reg = registers[rs_T1A];
wire   [63:0] rd2A_reg = registers[rs_T2A];
wire   [63:0] rd1B_reg = registers[rs_T1B];
wire   [63:0] rd2B_reg = registers[rs_T2B];

//
//Read instruction A
//

always @*
begin
  //else ifs are all internal forwarding.
  if (rs_T1A == `ZERO_REG)
    pr_T1A_out=0;
  else if (wr_cdbAIdx_en && (ex_cm_cdbAIdx==rs_T1A))
    if (exA_cond_branch_out | exA_uncond_branch_out) pr_T1A_out=exA_NPC_out; 
    else                                             pr_T1A_out=ex_cm_resultA; 
  else if(wr_cdbBIdx_en &&(ex_cm_cdbBIdx==rs_T1A))
    if (exB_cond_branch_out | exB_uncond_branch_out) pr_T1A_out=exB_NPC_out; 
    else                                             pr_T1A_out=ex_cm_resultB; 
  else if (wr_cdbCIdx_en && (ex_cm_cdbCIdx == rs_T1A))
    pr_T1A_out = ex_cm_resultC;
  else if (wr_cdbDIdx_en && (ex_cm_cdbDIdx == rs_T1A))
    pr_T1A_out = ex_cm_resultD;
  else
    pr_T1A_out=rd1A_reg; //grab value from regfile.
end


always @*
begin
  if (rs_T2A == `ZERO_REG)
    pr_T2A_out=0;
  else if (wr_cdbAIdx_en && (ex_cm_cdbAIdx==rs_T2A))
    if (exA_cond_branch_out | exA_uncond_branch_out) pr_T2A_out=exA_NPC_out; 
    else                                             pr_T2A_out=ex_cm_resultA; 
  else if(wr_cdbBIdx_en && (ex_cm_cdbBIdx==rs_T2A))
    if (exB_cond_branch_out | exB_uncond_branch_out) pr_T2A_out=exB_NPC_out; 
    else                                             pr_T2A_out=ex_cm_resultB;
  else if(wr_cdbCIdx_en && (ex_cm_cdbCIdx==rs_T2A))
    pr_T2A_out=ex_cm_resultC;
  else if (wr_cdbDIdx_en &&(ex_cm_cdbDIdx==rs_T2A))
    pr_T2A_out= ex_cm_resultD;
  else
    pr_T2A_out=rd2A_reg; //grab value from regfile.
end


//
//Read instruction B
//
always @*
begin
  if (rs_T1B == `ZERO_REG)
    pr_T1B_out=0;
    else if(wr_cdbAIdx_en && (ex_cm_cdbAIdx==rs_T1B))
      if (exA_cond_branch_out | exA_uncond_branch_out) pr_T1B_out=exA_NPC_out; 
      else                                             pr_T1B_out=ex_cm_resultA;
    else if (wr_cdbBIdx_en && (ex_cm_cdbBIdx==rs_T1B))
      if (exB_cond_branch_out | exB_uncond_branch_out) pr_T1B_out=exB_NPC_out; 
      else                                             pr_T1B_out=ex_cm_resultB;  
    else if (wr_cdbCIdx_en && (ex_cm_cdbCIdx==rs_T1B))
                 pr_T1B_out = ex_cm_resultC;
    else if (wr_cdbDIdx_en && (ex_cm_cdbDIdx==rs_T1B))
                 pr_T1B_out = ex_cm_resultD;
  else
    pr_T1B_out=rd1B_reg; //grab value from regfile.
end
always @*
begin
  if (rs_T2B == `ZERO_REG)
    pr_T2B_out=0;
  else if (wr_cdbAIdx_en && (ex_cm_cdbAIdx==rs_T2B))
      if (exA_cond_branch_out | exA_uncond_branch_out) pr_T2B_out=exA_NPC_out; 
      else                                             pr_T2B_out=ex_cm_resultA;  
  else if (wr_cdbBIdx_en && (ex_cm_cdbBIdx==rs_T2B))
      if (exB_cond_branch_out | exB_uncond_branch_out) pr_T2B_out=exB_NPC_out; 
      else                                             pr_T2B_out=ex_cm_resultB;  
  else if (wr_cdbCIdx_en && (ex_cm_cdbCIdx==rs_T2B))
    pr_T2B_out= ex_cm_resultC;
  else if (wr_cdbDIdx_en && (ex_cm_cdbDIdx== rs_T2B))
    pr_T2B_out = ex_cm_resultD;
  else
    pr_T2B_out=rd2B_reg; //grab value from regfile.
end

//
//Write PR
//
always @(posedge wr_clk)
begin
  if(reset)
      registers[31] <= `SD 0;
  else
  begin
    if (wr_cdbAIdx_en)
    begin
      if (~(ex_cm_cdbAIdx == `ZERO_REG)) begin
        if (exA_cond_branch_out | exA_uncond_branch_out)  registers[ex_cm_cdbAIdx] <= `SD exA_NPC_out;
        else                                              registers[ex_cm_cdbAIdx] <= `SD ex_cm_resultA; //should come before ex_cm
      end else begin
        registers[ex_cm_cdbAIdx] <= `SD 0;
      end
    end
    if (wr_cdbBIdx_en)
    begin
      if(~(ex_cm_cdbBIdx == `ZERO_REG)) begin
        if (exB_cond_branch_out | exB_uncond_branch_out)  registers[ex_cm_cdbBIdx] <= `SD exB_NPC_out;
        else                                              registers[ex_cm_cdbBIdx] <= `SD ex_cm_resultB; //should come before ex_cm
      end else begin
        registers[ex_cm_cdbBIdx] <= `SD 0;
      end
    end
    if (wr_cdbCIdx_en)
    begin
      if(ex_cm_cdbCIdx == `ZERO_REG)
        registers[ex_cm_cdbCIdx] <= `SD 0;
      else
        registers[ex_cm_cdbCIdx] <= `SD ex_cm_resultC;
    end
    if (wr_cdbDIdx_en)
    begin
      if(ex_cm_cdbDIdx == `ZERO_REG)
        registers[ex_cm_cdbDIdx] <= `SD 0;
      else
        registers[ex_cm_cdbDIdx] <= `SD ex_cm_resultD;
    end
  end


end
endmodule // pr
