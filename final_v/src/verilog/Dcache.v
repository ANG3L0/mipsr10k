// EECS 470 - Fall 2012
// 128 line 2 way Dcache


`define SD #1

module Dcache(clock, reset,
                        wrA_en, wrA_tag, wrA_idx, wrA_data, 
			wrB_en, wrB_tag, wrB_idx, wrB_data,
			rd_tag, rd_idx, rd_data, rd_valid);

//////////////////////////////////////////////////////////////////////
//                                                                  //
//                          Input                                   //
//                                                                  //
//////////////////////////////////////////////////////////////////////
input        clock;
input        reset;

//write from processor
input        wrA_en;   //connect to current_Dcache_write_en in cache controller
input [5:0]  wrA_idx;  //connect to last_Dcache_idx in cache controller
input [54:0] wrA_tag;  //connect to last_Dcache_tag in cache controller 
input [63:0] wrA_data; //connect to mem2proc_data;

//write from memory. load miss
input        wrB_en;   //connect to last_Dcache_write_en in cache controller
input [5:0]  wrB_idx;
input [54:0] wrB_tag;
input [63:0] wrB_data;

//read from processor: 2 read ports
input [5:0]  rd_idx; 
input [54:0] rd_tag;
 
////////////////////////////////////////////////////////////////////
//                                                                //
//                        Output                                  //
//                                                                //
////////////////////////////////////////////////////////////////////
output [63:0] rd_data;
output        rd_valid; 

//output wr_back0_valid, wr_back1_valid;

//////////////////////////////////////////////////////////////////
//                                                              //
//                          Inner Reg                           //
//                                                              //
//////////////////////////////////////////////////////////////////

//2-way
reg [63:0] data0 [63:0];
reg [63:0] next_data0 [63:0];
reg [63:0] data1 [63:0];
reg [63:0] next_data1 [63:0];

reg [63:0] LRU; //LRU[i] = 0: Last Recently Use set 0, vice versa
reg [63:0] next_LRU;

reg [54:0] tag0 [63:0];
reg [54:0] next_tag0 [63:0];
reg [54:0] tag1 [63:0];
reg [54:0] next_tag1 [63:0];
 
reg [63:0] valid0, next_valid0;
reg [63:0] valid1, next_valid1;

reg [63:0] rd_data;

reg        rd_valid;

reg [6:0]  i;

/*
assign rd0_data = data[rd0_idx];
assign rd1_data = data[rd1_idx];

assign rd0_valid = valids[rd0_idx]&&(tags[rdo_idx] == rd0_tag);
assign rd1_valid = valids[rd1_idx]&&(tags[rd1_idx] == rd1_tag);
*/

always @*
begin
  for(i=0; i<64; i=i+1)
  begin
    next_data0[i] = data0[i];
    next_data1[i] = data1[i];
    next_tag0[i] = tag0[i];
    next_tag1[i] = tag1[i];
  end
  next_LRU = LRU;
  next_valid0 = valid0;
  next_valid1 = valid1;

///////////////////////////////////////////////////////
//                                                   //
//                  Read Dcache                      //
//                                                   //
///////////////////////////////////////////////////////
  
  rd_valid = 0;
  rd_data = 64'dx;

  //rd
  if((tag0[rd_idx] == rd_tag) && valid0[rd_idx] && (LRU[rd_idx] == 0))
  begin
    rd_data = data0[rd_idx];
    rd_valid = 1;
    next_LRU[rd_idx] = 0;
  end
  if((tag1[rd_idx] == rd_tag) && valid1[rd_idx] && (LRU[rd_idx] == 1))
  begin
    rd_data = data1[rd_idx];
    rd_valid = 1;
    next_LRU[rd_idx] = 1;
  end

  
/////////////////////////////////////////////////////////
//                                                     //
//                   Write Dcache                      //
//                                                     //
/////////////////////////////////////////////////////////

  //write from proc, have higher priority than write from mem, because the
  //write from proc is the latest instruction 
  if(wrA_en)
  begin
    if((valid0[wrA_idx] == 0)|((valid0[wrA_idx] == 1) && (LRU[wrA_idx] == 1)) | ((valid0[wrA_idx] == 1) && (tag0[wrA_idx] == wrA_tag)))
    begin
      next_data0[wrA_idx] = wrA_data;
      next_tag0[wrA_idx] = wrA_tag;
      next_valid0[wrA_idx] = 1;
      next_LRU[wrA_idx] = 0; //Last Recently Used set is set 0
    end
    else 
    begin
      next_data1[wrA_idx] = wrA_data;
      next_tag1[wrA_idx] = wrA_tag;
      next_valid1[wrA_idx] = 1;
      next_LRU[wrA_idx] = 1; //Last Recently Used set is set 1
    end
  end
  
  //write from mem when load miss
  if(wrB_en && (!wrA_en | ((wrA_idx != wrB_idx) | (wrA_tag != wrB_tag))))
  begin
    if((valid0[wrB_idx] == 0)|((valid0[wrB_idx] == 1) && (LRU[wrB_idx] == 1)))
    begin
      next_data0[wrB_idx] = wrB_data;
      next_tag0[wrB_idx] = wrB_tag;
      next_valid0[wrB_idx] = 1;
      next_LRU[wrB_idx] = 0; //Last Recently Used set is set 0
    end
  
    else 
    begin
      next_data1[wrB_idx] = wrB_data;
      next_tag1[wrB_idx] = wrB_tag;
      next_valid1[wrB_idx] = 1;
      next_LRU[wrB_idx] = 1; //Last Recently Used set is set 1
    end
  end
end
//synopsys sync_set_reset "reset"
always @(posedge clock)
begin
  if(reset)
  begin 
    valid0 <= `SD 64'b0;
    valid1 <= `SD 64'b0;
    LRU    <= `SD 64'b1;
  end
  else  
  begin
    valid0 <= `SD next_valid0;
    valid1 <= `SD next_valid1;
    LRU    <= `SD next_LRU;
    for(i=0; i<64; i=i+1)
    begin
      data0[i] <= `SD next_data0[i];
      data1[i] <= `SD next_data1[i];
      tag0[i]  <= `SD next_tag0[i];
      tag1[i]  <= `SD next_tag1[i];
    end
  end
end


endmodule

