// EECS 470 - Winter 2009
// 128 line cache
//
// NOTE: this cache only looks at 32 bits for the index and tag (line size of
// 1).  This works because our while our addressable memory is 64 bits, the
// real size of our memory is 64k (check sys_defs.vh to verify).  You may wish
// to change this assumption.

`define SD #1

module Icache(clock, reset, 
			wrA_en, 
      wrA_idx, 
      wrA_tag, 
      wrA_data,
      wrB_en, 
      wrB_idx, 
      wrB_tag, 
      wrB_data,
      rd_idx, 
      rd_tag, 
      rd_data, 
      rd_valid);

/////////////////////////////////////////////////////////
//                                                     //
//                       Input                         //
//                                                     //
/////////////////////////////////////////////////////////

input clock; 
input reset;

//write from proc, Dcache write, than chech the conherency, write through
input        wrA_en;
input [6:0]  wrA_idx;
input [53:0] wrA_tag;
input [63:0] wrA_data;

//write from mem, because of load miss
input        wrB_en;
input [6:0]  wrB_idx;
input [53:0] wrB_tag;
input [63:0] wrB_data;

//read from processor (instruction fetch)

input [6:0]  rd_idx;
input [53:0] rd_tag;
 
//////////////////////////////////////////////////////
//                                                  //
//                   Output                         //
//                                                  //
//////////////////////////////////////////////////////

output [63:0] rd_data;
output        rd_valid;

//////////////////////////////////////////////////////
//                                                  //
//                    Inner Reg                     //
//                                                  //
//////////////////////////////////////////////////////

reg [63:0] data [127:0];
reg [53:0] tags [127:0]; 
reg [127:0] valids;

assign rd_data = data[rd_idx];
assign rd_valid = valids[rd_idx]&&(tags[rd_idx] == rd_tag);
//synopsys sync_set_reset "reset"
always @(posedge clock)
begin
  if(reset) valids <= `SD 128'b0;
  else 
  begin
  //	if(wrA_en) 
    	//	valids[wrA_idx] <= `SD 1;
  	if(wrB_en)
    		valids[wrB_idx] <= `SD 1;
	end
end
//synopsys sync_set_reset "reset"
always @(posedge clock)
begin
  //write from proc,has higher priority
  //if(wrA_en)
  //begin
    //data[wrA_idx] <= `SD wrA_data;
    //tags[wrA_idx] <= `SD wrA_tag;
  //end

  //write from mem, Icache miss
  if(wrB_en) //&&  (!wrA_en | (wrA_idx != wrB_idx) | (wrA_tag != wrB_tag)))
  begin
    data[wrB_idx] <= `SD wrB_data;
    tags[wrB_idx] <= `SD wrB_tag;
  end
end
endmodule

