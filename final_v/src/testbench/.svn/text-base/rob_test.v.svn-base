
`timescale 1ns/100ps


module testbench;
   // input 
   reg 		clock;
   reg 		reset;
   reg	        id_valid_instA;
   reg 		id_valid_instB;
   reg   [5:0]  mt_ToldA;
   reg   [5:0]  mt_ToldB;
   reg   [5:0]  fl_TA;
   reg   [5:0]  fl_TB;
   reg   [4:0]  ex_cm_robAIdx;
   reg   [4:0]  ex_cm_robBIdx;
   reg          ex_cm_cdbA_rdy;
   reg          ex_cm_cdbB_rdy;
   reg   [4:0]  id_logdestAIdx;
   reg   [4:0]  id_logdestBIdx;

   // output 
   wire  [5:0]  rob_ToldA_out;
   wire  [5:0]  rob_ToldB_out;
   wire         rob_retireA_out;
   wire         rob_retireB_out;
   wire         rob_one_inst_out;
   wire         rob_none_inst_out;  
   wire         rob_instA_en_out;
   wire         rob_instB_en_out;
   wire  [4:0]  rob_dispidxA_out;  
   wire  [4:0]  rob_dispidxB_out;
   wire  [4:0]  rob_logidxA_out;
   wire  [4:0]  rob_logidxB_out;
   wire  [5:0]  rob_TA_out;
   wire  [5:0]  rob_TB_out;

  rob rob_0(

  //   input
  .clock(clock),
  .reset(reset),
  .id_valid_instA(id_valid_instA),
  .id_valid_instB(id_valid_instB),
  .mt_ToldA(mt_ToldA),
  .mt_ToldB(mt_ToldB),
  .fl_TA(fl_TA),
  .fl_TB(fl_TB),
  .id_logdestAIdx(id_logdestAIdx),
  .id_logdestBIdx(id_logdestBIdx),
  .ex_cm_robAIdx(ex_cm_robAIdx),
  .ex_cm_robBIdx(ex_cm_robBIdx),
  .ex_cm_cdbA_rdy(ex_cm_cdbA_rdy),
  .ex_cm_cdbB_rdy(ex_cm_cdbB_rdy),

  // output

  .rob_ToldA_out(rob_ToldA_out),
  .rob_ToldB_out(rob_ToldB_out),
  .rob_retireA_out(rob_retireA_out),
  .rob_retireB_out(rob_retireB_out),
  .rob_one_inst_out(rob_one_inst_out),
  .rob_none_inst_out(rob_none_inst_out),
  .rob_instA_en_out(rob_instA_en_out),                                
  .rob_instB_en_out(rob_instB_en_out),
  .rob_dispidxA_out(rob_dispidxA_out),
  .rob_dispidxB_out(rob_dispidxB_out),
  .rob_logidxA_out(rob_logidxA_out),
  .rob_logidxB_out(rob_logidxB_out),

  .rob_TA_out(rob_TA_out),
  .rob_TB_out(rob_TB_out)

);


  always
  begin 
    #5;
  clock = ~clock;
  end 

reg [21:0]  clocks;
reg [10:0]   i;
always @(posedge clock)
begin
`ifdef DEBUG_OUT
  $display("POSEDGE #:%20d \t almostfull:%1b \t full:%1b", clocks, rob_0.rob_one_inst_out, rob_0.rob_none_inst_out);
  $display("--------------------------------------------------------------------------------------------------");
  $display("|    ht pos \t | \t    T \t \t | \t Told \t \t | LogReg \t |   complete\t |\n\
--------------------------------------------------------------------------------------------------");
  for (i=0;i<32;i=i+1) begin
    if (rob_0.head==i && rob_0.tail==i) begin
    $display("| \t ht \t | \t %6d \t | \t %6d \t | \t %5d \t | \t %1b \t |",
        rob_0.T[i], rob_0.T_old[i], rob_0.logdestIdx[i], rob_0.done[i]);
    end
    else if (rob_0.head==i) begin
    $display("| \t h \t | \t %6d \t | \t %6d \t | \t %5d \t | \t %1b \t |",
        rob_0.T[i], rob_0.T_old[i], rob_0.logdestIdx[i], rob_0.done[i]);
    end 
    else if (rob_0.tail==i) begin
    $display("| \t t \t | \t %6d \t | \t %6d \t | \t %5d \t | \t %1b \t |",
        rob_0.T[i], rob_0.T_old[i], rob_0.logdestIdx[i], rob_0.done[i]);
    end
    else begin
    $display("| \t   \t | \t %6d \t | \t %6d \t | \t %5d \t | \t %1b \t |",
        rob_0.T[i], rob_0.T_old[i], rob_0.logdestIdx[i], rob_0.done[i]);
    end
  end
  $display("--------------------------------------------------------------------------------------------------\n");
`endif

  clocks = clocks+1;
end

reg [7:0] k;
  initial 
  begin 
   clocks        = 0;
   clock         = 1'b0;
   reset         = 1'b0;
   id_valid_instA = 1'b0;
   id_valid_instB = 1'b0; 

   mt_ToldA      =  6'b0;
   mt_ToldB      =  6'd1;

   fl_TA         =  6'd32;         //t0
   fl_TB         =  6'd33;         // t1
  id_logdestAIdx =  5'd0;
  id_logdestBIdx =  5'd1;

   ex_cm_cdbA_rdy = 1'b0;
   ex_cm_cdbB_rdy = 1'b0;
   ex_cm_robAIdx   = 5'd0;
   ex_cm_robBIdx   = 5'd1;

  @(negedge clock);  
   reset = 1'b1;
   
  //fill up ROB
  for (k=0; k<8'd16; k=k+1)
  begin
  @(negedge clock);
   reset = 1'b0;
    id_valid_instA  = 1'b1;
    id_valid_instB  = 1'b1;
    ex_cm_cdbA_rdy = 1'b0;
    ex_cm_cdbB_rdy = 1'b0;
    ex_cm_robAIdx  = 5'd32+k;
    ex_cm_robBIdx  = 5'd34+k;
    mt_ToldA=6'd0+2*k;
    mt_ToldB=6'd1+2*k;
    fl_TA=6'd32+2*k;
    fl_TB=6'd32+2*k+1;
  end
  //free up ROB (reverse)
  for (k=0;k<8'd16;k=k+1) begin
  @(negedge clock);
    id_valid_instA  = 1'b0;
    id_valid_instB  = 1'b0;
    ex_cm_cdbA_rdy = 1'b1;
    ex_cm_cdbB_rdy = 1'b1;
    ex_cm_robAIdx  = 5'd31-2*k;
    ex_cm_robBIdx  = 5'd30-2*k;
    mt_ToldA=6'd0+k;
    mt_ToldB=6'd2+k;
    fl_TA=6'd32+k;
    fl_TB=6'd33+k;
  end
  @(negedge clock);
  ex_cm_cdbA_rdy = 1'b0;
  ex_cm_cdbB_rdy = 1'b0;
  for (k=0;k<'d16;k=k+1) begin
  @(negedge clock); //clear ROB
  end
  //fill up ROB
  //50
  for (k=0;k<'d16;k=k+1) begin
  @(negedge clock);
   reset = 1'b0;
    id_valid_instA  = 1'b1;
    id_valid_instB  = 1'b1;
    ex_cm_cdbA_rdy = 1'b0;
    ex_cm_cdbB_rdy = 1'b0;
    ex_cm_robAIdx  = 5'd32+k;
    ex_cm_robBIdx  = 5'd34+k;
    mt_ToldA=6'd31+2*k;
    mt_ToldB=6'd32+2*k;
    fl_TA=6'd0+2*k;
    fl_TB=6'd1+2*k;
  end
  //67
  //try to make ht move together halfway(retire/dispatch at same time)
  for (k=0;k<'d8;k=k+1)begin
  @(negedge clock)
    id_valid_instA  = 1'b1;
    id_valid_instB  = 1'b1;
    ex_cm_cdbA_rdy = 1'b1;
    ex_cm_cdbB_rdy = 1'b1;
    ex_cm_robAIdx  = 5'd0+2*k;
    ex_cm_robBIdx  = 5'd1+2*k;
    //do a switcharooski
    mt_ToldA=6'd0+2*k;
    mt_ToldB=6'd1+2*k;
    fl_TA=6'd31+2*k;
    fl_TB=6'd32+2*k;
  end

  //retire one at a time in conjunction.
  // for (k=8;k<'d16;k=k+1)begin
  // @(negedge clock)
  //   id_valid_instA  = 1'b1;
  //   id_valid_instB  = 1'b0;
  //   ex_cm_cdbA_rdy = 1'b1;
  //   ex_cm_cdbB_rdy = 1'b0;
  //   ex_cm_robAIdx  = 5'd16+k;
  //   ex_cm_robBIdx  = 5'd1+2*k;
  //   //do a switcharooski
  //   mt_ToldA=6'd16+k;
  //   mt_ToldB=6'd1+2*k;
  //   fl_TA=6'd47+k;
  //   fl_TB=6'd32+2*k;
  // end  

  //fill one, empty it, fill one, empty it

  //make head < tail and simul retire/dispatch

  //make tail > head and simul retire/dispatch
  $finish;

  end 

endmodule
