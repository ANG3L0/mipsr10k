`define SD #1

// Think: read and write at the same time? internal forwarding


module BTB(
			clock, 
			reset, 
			wr0_en, 
			wr1_en, 
			delete0_en,
			delete1_en,
			wr_PCA_tag,
			wr_PCB_tag, 
			wr_PCA_idx,
			wr_PCB_idx, 
			wr_PCA_data,
                        wr_PCB_data,
			rd_PCA_tag,
	                rd_PCB_tag,
			rd_PCA_idx,
			rd_PCB_idx, 
			mispredicted_PCA,
			mispredicted_PCB,

//output
			target_PCA,
			target_PCB,
			hitA,
			hitB);
//16 lines, 64 bit data (PC address)
// 2 bit byte offset, 4 bit index (16), 58 bit tag

input clock;
input reset;
input wr0_en;
input wr1_en;
input [3:0] wr_PCA_idx;
input [3:0] rd_PCA_idx;
input [57:0] wr_PCA_tag;
input [57:0] rd_PCA_tag; //current PC address
input [63:0] wr_PCA_data; //
input [3:0] wr_PCB_idx;
input [3:0] rd_PCB_idx;
input [57:0] wr_PCB_tag;
input [57:0] rd_PCB_tag;
input [63:0] wr_PCB_data; 
input [63:0] mispredicted_PCA; //delete the entry if mispredicted 
input [63:0] mispredicted_PCB;
input	     delete0_en;
input	     delete1_en;


output [63:0] target_PCA; // data read from the cache
output [63:0] target_PCB; // data read from the cache
output hitA; //hit!
output hitB; //hit!

wire delete_hitA;
wire delete_hitB;


reg [63:0] data [15:0];
reg [57:0] tags [15:0]; 
reg [15:0] valids;

assign target_PCA = data[rd_PCA_idx];
assign target_PCB = data[rd_PCB_idx];
assign hitA = valids[rd_PCA_idx] && (tags[rd_PCA_idx] == rd_PCA_tag);
assign hitB = valids[rd_PCB_idx] && (tags[rd_PCB_idx] == rd_PCB_tag);// there is data in this line and the tag matches (hit!)
assign delete_hitA = valids[mispredicted_PCA[5:2]] && (tags[mispredicted_PCA[5:2]] == mispredicted_PCA[63:6]);// see whether PC is still here
assign delete_hitB = valids[mispredicted_PCB[5:2]] && (tags[mispredicted_PCB[5:2]] == mispredicted_PCB[63:6]);


//reg	next_valid_wr_PCA;
//reg	next_valid_wr_PCB;
//reg	next_valid_delete_PCA;
//reg	next_valid_delete_PCB;


/*always @*
begin

	next_valid_wr_PCA = valids[wr_PCA_idx];
	next_valid_wr_PCB = valids[wr_PCB_idx];
	next_valid_delete_PCA = valids[mispredicted_PCA_idx];
	next_valid_delete_PCB = valids[mispredicted_PCB_idx];

	if (wr0_en)
		next_valid_wr_PCA = 1;
	if (wr1_en)
		next_valid_wr_PCB = 1;
	if (delete0_en)
		next_valid_delete_PCA = 0;
	if (delete1_en && next_valid_delete_PCB)
		next_valid_delete_PCB = 0; 

end
*/


always @(posedge clock)
begin
  if(reset) valids <= `SD 16'b0;
  else 
    begin
	if (wr0_en) 
    		valids[wr_PCA_idx] <= `SD 1; //this line is modified, set the valid bit to be one
	if (wr1_en)
    		valids[wr_PCB_idx] <= `SD 1; 
	if (delete0_en && delete_hitA)
    		valids[mispredicted_PCA[5:2]] <= `SD 0; // this line will be delete, set the valid bit to be zero
    	if (delete1_en && delete_hitB)
		valids[mispredicted_PCB[5:2]] <= `SD 0;
    end
end





/*always @(posedge clock)
begin
  if(reset) valids <= `SD 64'b0;
  else 
    begin
    if(wr0_en) 
    valids[wr_PCA_idx] <= `SD 1; //this line is modified, set the valid bit to be one
	
    if(wr1_en) 
    valids[wr_PCB_idx] <= `SD 1; 
    end
end
*/


always @(posedge clock)
begin
  if(wr0_en && !((wr_PCA_idx == wr_PCB_idx) && wr1_en) ) // will not write at the same time
  begin
    data[wr_PCA_idx] <= `SD wr_PCA_data;
    tags[wr_PCA_idx] <= `SD wr_PCA_tag;
  end
	
  if(wr1_en)
  begin
    data[wr_PCB_idx] <= `SD wr_PCB_data;
    tags[wr_PCB_idx] <= `SD wr_PCB_tag;
  end
end

endmodule

