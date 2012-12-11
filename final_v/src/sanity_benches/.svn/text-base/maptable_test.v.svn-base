`define CDBWIDTH        6
`define ZERO_REG        5'b11111
module maptable_testbench;
  reg                     clk;
  reg                     reset;
  reg                     enableA;
  reg                     enableB;
  reg  [4:0]              id_destAidx;
  reg  [4:0]              id_destBidx;
  reg  [4:0]              id_rdaAidx; 
  reg  [4:0]              id_rdbAidx;   
  reg  [4:0]              id_rdaBidx; 
  reg  [4:0]              id_rdbBidx;  
//  reg  [11:0]             cm_cdbAIdx;
//  reg  [11:0]             cm_cdbBIdx;
  reg	[4:0] mt_indexA;
  reg	[4:0] mt_indexB;
  reg   [4:0] mt_indexC;
  reg   [4:0] mt_indexD;

  reg	[4:0] CDBvalueA;
  reg	[4:0] CDBvalueB;
  reg   [4:0] CDBvalueC;
  reg   [4:0] CDBvalueD;

  reg	      broadcastA;
  reg	      broadcastB;
  reg         broadcastC;
  reg         broadcastD;

  reg  [`CDBWIDTH-1:0]    fl_prNumA;
  reg  [`CDBWIDTH-1:0]    fl_prNumB;

  reg  [`CDBWIDTH-1:0]    tb_mt_ToldA_out;		
  reg  [`CDBWIDTH-1:0]    tb_mt_ToldB_out;
  reg  [`CDBWIDTH:0]      tb_mt_T1A_out;
  reg  [`CDBWIDTH:0]      tb_mt_T1B_out;
  reg  [`CDBWIDTH:0]      tb_mt_T2A_out;
  reg  [`CDBWIDTH:0]      tb_mt_T2B_out;
  
  wire  [`CDBWIDTH-1:0]      mt_ToldA_out;		
  wire  [`CDBWIDTH-1:0]      mt_ToldB_out;
  wire  [`CDBWIDTH:0]      mt_T1A_out_full;
  wire  [`CDBWIDTH:0]      mt_T1B_out_full;
  wire  [`CDBWIDTH:0]      mt_T2A_out_full;
  wire  [`CDBWIDTH:0]      mt_T2B_out_full;
  reg                      correct;

  wire [5:0] mt_T1A_out;
  wire [5:0] mt_T1B_out;
  wire [5:0] mt_T2A_out;
  wire [5:0] mt_T2B_out;
  wire mt_T1A_out_rdy;
  wire mt_T1B_out_rdy;
  wire mt_T2A_out_rdy;
  wire mt_T2B_out_rdy;
//  wire cm_cdbAIdx_rdy;
//  wire cm_cdbBIdx_rdy;
//  wire [5:0] cm_cdbAIdx_value;
//  wire [5:0] cm_cdbBIdx_value;
//  wire [4:0] cm_cdbAIdx_idx;
//  wire [4:0] cm_cdbBIdx_idx;

maptable maptable
( .clk(clk),
  .reset(reset),
  .enableA(enableA),
  .enableB(enableB),
  .id_destAidx(id_destAidx),
  .id_destBidx(id_destBidx),
//  .cm_cdbAIdx(cm_cdbAIdx),
//  .cm_cdbBIdx(cm_cdbBIdx),
  .mt_indexA(mt_indexA),
  .mt_indexB(mt_indexB),
  .mt_indexC(mt_indexC),
  .mt_indexD(mt_indexD),
  .CDBvalueA(CDBvalueA),
  .CDBvalueB(CDBvalueB),
  .CDBvalueC(CDBvalueC),
  .CDBvalueD(CDBvalueD),
  .broadcastA(broadcastA),
  .broadcastB(broadcastB),
  .broadcastC(broadcastC),
  .broadcastD(broadcastD),
  .id_rdaAidx(id_rdaAidx),
  .id_rdbAidx(id_rdbAidx),
  .id_rdaBidx(id_rdaBidx),
  .id_rdbBidx(id_rdbBidx),
  .fl_prNumA(fl_prNumA),
  .fl_prNumB(fl_prNumB),
  .mt_ToldA_out(mt_ToldA_out),
  .mt_ToldB_out(mt_ToldB_out),
  .mt_T1A_out(mt_T1A_out_full),
  .mt_T1B_out(mt_T1B_out_full),
  .mt_T2A_out(mt_T2A_out_full),
  .mt_T2B_out(mt_T2B_out_full)
);


assign mt_T1A_out=mt_T1A_out_full[6:1];
assign mt_T1B_out=mt_T1B_out_full[6:1];
assign mt_T2A_out=mt_T2A_out_full[6:1];
assign mt_T2B_out=mt_T2B_out_full[6:1];
assign mt_T1A_out_rdy=mt_T1A_out_full[0];
assign mt_T1B_out_rdy=mt_T1B_out_full[0];
assign mt_T2A_out_rdy=mt_T2A_out_full[0];
assign mt_T2B_out_rdy=mt_T2B_out_full[0];
//assign cm_cdbAIdx_rdy=cm_cdbAIdx[11];
//assign cm_cdbBIdx_rdy=cm_cdbBIdx[11];
//assign cm_cdbAIdx_value=cm_cdbAIdx[10:5];
//assign cm_cdbBIdx_value=cm_cdbBIdx[10:5];
//assign cm_cdbAIdx_idx=cm_cdbAIdx[4:0];
//assign cm_cdbBIdx_idx=cm_cdbBIdx[4:0];

//assign decision = (tb_mt_ToldA_out == mt_ToldA_out) && (tb_mt_ToldB_out == mt_ToldB_out) && (tb_mt_T1A_out == mt_T1A_out_full) && (tb_mt_T1B_out == mt_T1B_out_full) && (tb_mt_T2A_out == mt_T2A_out_full) && (tb_mt_T2B_out == mt_T2B_out_full);

always @(correct)
	begin
	#2
	if(!correct)
	begin
		$display("@@@ Incorrect at time %4.0f", $time);
//		$finish;
	end
end
always
  #5 clk=~clk;

initial 
begin
 // $monitor("Time:%4.0f, WayA_en:%b, WayA_dest_idx:%d, WayA_rega_idx:%d, WayA_regb_idx:%d, WayA_CDB_broadcast:%b, WayA_CDB_pr_idx:%d, WayA_CDB_cm_idxs:%d \n",
 //                       mt_ToldA_out:%d, mt_T1A_out:%d, mt_T1A_out_rdy:%d, mt_T2A_out:%d, mt_T2A_out_rdy:%d \n",
 //                       WayB_en:%b, WayB_dest_idx:%d, WayB_rega_idx:%d, WayB_regb_idx:%d, WayB_CDB_broadcast:%b, WayB_CDB_pr_idx:%d, WayB_CDB_cm_idxs:%d \n",
 //                       mt_ToldB_out:%d, mt_T1B_out:%d, mt_T1B_out_rdy:%d, mt_T2B_out:%d, mt_T2B_out_rdy:%d \n",
  //                      $time, enableA, id_destAidx, id_rdaAidx, id_rdbAidx, cm_cdbAIdx[11], cm_cdbAIdx[10:5],cm_cdbAIdx[4:0] \n,
  //                      mt_ToldA_out, mt_T1A_out[`CDBWIDTH:1], mt_T1A_out[0],mt_T2A_out[`CDBWIDTH:1], mt_T2A_out[0] \n,
  //                      enableB, id_destBidx, id_rdaBidx, id_rdbBidx, cm_cdbBIdx[11], cm_cdbBIdx[10:5],cm_cdbBIdx[4:0] \n,
  //                      mt_ToldB_out, mt_T1B_out[`CDBWIDTH:1], mt_T1B_out[0],mt_T2B_out[`CDBWIDTH:1], mt_T2B_out[0]

                        
 //                       );
//  $monitor("Time:%4.0f, mt_ToldA_out:%d, mt_T1A_out:%d, mt_T1A_out_rdy:%d, mt_T2A_out:%d, mt_T2A_out_rdy:%d", $time, mt_ToldA_out, mt_T1A_out[`CDBWIDTH:1], mt_T1A_out[0],mt_T2A_out[`CDBWIDTH:1], mt_T2A_out[0]);
  clk = 0;
  reset = 1;
  @(negedge clk);
  reset = 0;
  enableA = 1;
  enableB = 1;
  //@(negedge clk);
  id_destAidx = 5'd14;
  id_destBidx = 5'd15;
  id_rdaAidx  = 5'd0;
  id_rdbAidx  = 5'd1;
  id_rdaBidx  = 5'd3;
  id_rdbBidx  = 5'd4;
  fl_prNumA   = 6'd32;
  fl_prNumB   = 6'd33;
  mt_indexA   = 5'd14;
  mt_indexB   = 5'd15;
  mt_indexC   = 5'd16;
  mt_indexD   = 5'd17;
  CDBvalueA   = 6'd32;
  CDBvalueB   = 6'd33;
  CDBvalueC   = 6'd34;
  CDBvalueD   = 6'd35;
  broadcastA  = 1'd0;
  broadcastB  = 1'd0;
  broadcastC  = 1'd0;
  broadcastD  = 1'd0; 
//  cm_cdbAIdx  = {1'd0,6'd0,5'd0};
//  cm_cdbBIdx  = {1'd0,6'd0,5'd0};
  @(negedge clk);
  id_destAidx = 5'd16;
  id_destBidx = 5'd17;
  id_rdaAidx  = 5'd0;
  id_rdbAidx  = 5'd14;
  id_rdaBidx  = 5'd15;
  id_rdbBidx  = 5'd4;
  fl_prNumA   = 6'd34;
  fl_prNumB   = 6'd35;
  mt_indexA   = 5'd14;
  mt_indexB   = 5'd15;
  mt_indexC   = 5'd16;
  mt_indexD   = 5'd17;
  CDBvalueA   = 6'd32;
  CDBvalueB   = 6'd33;
  CDBvalueC   = 6'd34;
  CDBvalueD   = 6'd35;
  broadcastA  = 1'd0;
  broadcastB  = 1'd1;
  broadcastC  = 1'd0;
  broadcastD  = 1'd0; 
//  cm_cdbAIdx  = {1'd0,6'd0,5'd0};
//  cm_cdbBIdx  = {1'd0,6'd0,5'd0};
  @(negedge clk);
  id_destAidx = 5'd18;
  id_destBidx = 5'd19;
  id_rdaAidx  = 5'd0;
  id_rdbAidx  = 5'd14;
  id_rdaBidx  = 5'd18;
  id_rdbBidx  = 5'd4;
  fl_prNumA   = 6'd36;
  fl_prNumB   = 6'd37;
  mt_indexA   = 5'd14;
  mt_indexB   = 5'd15;
  CDBvalueA   = 6'd32;
  CDBvalueB   = 6'd33;
  CDBvalueC   = 6'd34;
  CDBvalueD   = 6'd35;
  broadcastA  = 1'd1;
  broadcastB  = 1'd0;
  broadcastC  = 1'd1;
  broadcastD  = 1'd1; 
//  cm_cdbAIdx  = {1'd1,6'd35,5'd13};
//  cm_cdbBIdx  = {1'd1,6'd36,5'd22};
  @(negedge clk);
  @(negedge clk);
  $finish;
end
endmodule
