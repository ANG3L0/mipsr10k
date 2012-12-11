
module  maptable_testbench;
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
reg [4:0] mt_indexA;
reg [4:0] mt_indexB;
reg [4:0] mt_indexC;
reg [4:0] mt_indexD;

reg [5:0] CDBvalueA;
reg [5:0] CDBvalueB;
reg [5:0] CDBvalueC;
reg [5:0] CDBvalueD;

reg       broadcastA;
reg       broadcastB;
reg       broadcastC;
reg       broadcastD;

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
wire  [`CDBWIDTH:0]      mt_T1A_out;
wire  [`CDBWIDTH:0]      mt_T1B_out;
wire  [`CDBWIDTH:0]      mt_T2A_out;
wire  [`CDBWIDTH:0]      mt_T2B_out;
reg                      correct;


maptable maptable_0(
  //inputs
.clk(clk),
.reset(reset),
//  enableA,
//  enableB,
.id_destAidx(id_destAidx),
.id_destBidx(id_destBidx),
.id_valid_IRA(enableA),
.id_valid_IRB(enableB), 
//  cm_cdbAIdx,
//  cm_cdbBIdx,
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
//TODO: arch map port -> map table for recovery (32x6 bits?)
.fl_prNumA(fl_prNumA),
.fl_prNumB(fl_prNumB),
//TODO: how to recover? (reversal from ROB or copy/paste from arch
//map?)

//outputs
.mt_ToldA_out(mt_ToldA_out),   
.mt_ToldB_out(mt_ToldB_out), 
.mt_T1A_out(mt_T1A_out), 
.mt_T1B_out(mt_T1B_out), 
.mt_T2A_out(mt_T2A_out), 
.mt_T2B_out(mt_T2B_out)  
);

reg [5:0] i;
reg [10:0] clocks;
always
  #5 clk=~clk;

always @(posedge clk)
begin
`ifdef DEBUG_OUT
	clocks=clocks+1;
	$display("POSEDGE %20d:", clocks);
  $display("==========================================");
  $display("|      LogReg \t |      Phys Reg (rdy) \t |");
  $display("==========================================");
  for (i=0;i<'d32;i=i+1) begin
    $display("| \t %5d \t | \t %5d (%1d) \t |", i, maptable_0.mt_reg[i][6:1], maptable_0.mt_reg[i][0]);
  end
  $display("==========================================\n");
`endif
end
reg [10:0] j;
initial 
begin
  clk = 0;
  clocks=0;
  
  reset = 1;
  @(negedge clk);
  //retire 
  //reset
  //grab all PR#s so ht aligned

  //retire and grab at same time (2-by-2)
  

  @(negedge clk);  //display lag
  $finish;
end
endmodule
  
  

