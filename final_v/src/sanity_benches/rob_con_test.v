


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



  initial 
  begin 
   clocks       =  0 ;
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

  @(negedge clock);
   reset = 1'b0;
   id_valid_instA  = 1'b1;
   id_valid_instB  = 1'b1;

  @(negedge clock);
   mt_ToldA      =  6'd2;
   mt_ToldB      =  6'd3;   
   fl_TA         =  6'd34;   // t2
   fl_TB         =  6'd35;   // t3

  @(negedge clock);

   mt_ToldA     =  6'd4;
   mt_ToldB     =  6'd5;
   fl_TA        =  6'd36;     // t4
   fl_TB        =  6'd37;     // t5

   
  @(negedge clock);
   
   mt_ToldA     =  6'd6;
   mt_ToldB     =  6'd7;
   fl_TA        =  6'd38;          // t6
   fl_TB        =  6'd39;          // t7



  @(negedge clock);
   mt_ToldA      =  6'd8;
   mt_ToldB      =  6'd9;
   fl_TA         =  6'd40;       // t8
   fl_TB         =  6'd41;       // t9

  @(negedge clock);

   mt_ToldA      =  6'd10;
   mt_ToldB      =  6'd11;
   fl_TA         =  6'd42;       // t10   
   fl_TB         =  6'd43;       // t11    


  @(negedge clock);
   mt_ToldA      =  6'd12;
   mt_ToldB      =  6'd13;
   fl_TA         =  6'd44;   // t12
   fl_TB         =  6'd45;   // t13

  @(negedge clock);

   mt_ToldA     =  6'd14;
   mt_ToldB     =  6'd15;
   fl_TA        =  6'd46;     // t14
   fl_TB        =  6'd47;     // t15


  @(negedge clock);

   mt_ToldA     =  6'd16;
   mt_ToldB     =  6'd17;
   fl_TA        =  6'd48;          // t16
   fl_TB        =  6'd49;          // t17



  @(negedge clock);
   mt_ToldA      =  6'd18;
   mt_ToldB      =  6'd19;
   fl_TA         =  6'd50;       // t18
   fl_TB         =  6'd51;       // t19

  @(negedge clock);

   mt_ToldA      =  6'd20;
   mt_ToldB      =  6'd21;
   fl_TA         =  6'd52;       // t20   
   fl_TB         =  6'd53;       // t21    

  @(negedge clock);
   mt_ToldA      =  6'd22;
   mt_ToldB      =  6'd23;
   fl_TA         =  6'd54;   // t22
   fl_TB         =  6'd55;   // t23

  @(negedge clock);

   mt_ToldA     =  6'd24;
   mt_ToldB     =  6'd25;
   fl_TA        =  6'd56;     // t24
   fl_TB        =  6'd57;     // t25


  @(negedge clock);

   mt_ToldA     =  6'd26;
   mt_ToldB     =  6'd27;
   fl_TA        =  6'd58;          // t26
   fl_TB        =  6'd59;          // t27



  @(negedge clock);
   mt_ToldA      =  6'd28;
   mt_ToldB      =  6'd29;
   fl_TA         =  6'd60;       // t28
   fl_TB         =  6'd61;       // t29

  @(negedge clock);
  id_valid_instA = 1'b1;
  id_valid_instB = 1'b0;

   mt_ToldA      =  6'd30;
   mt_ToldB      =  6'd31;
   fl_TA         =  6'd62;       // t30   
   fl_TB         =  6'd63;       // t31    

  @(negedge clock);
   id_valid_instA = 1'b0;
   id_valid_instB = 1'b1;
   mt_ToldA      =  6'd30;
   mt_ToldB      =  6'd31;
   fl_TA         =  6'd62;       // t30   
   fl_TB         =  6'd63;       // t31  


  @(negedge clock);
   id_valid_instA = 1'b0;
   id_valid_instB = 1'b0;


  @(posedge clock);
  ex_cm_cdbA_rdy = 1'b1;
  ex_cm_cdbB_rdy = 1'b1;
  ex_cm_robAIdx  = 5'd0;    // head0 and head1 should retire
  ex_cm_robBIdx  = 5'd1;


  @(posedge clock);
  ex_cm_cdbA_rdy = 1'b1;
  ex_cm_cdbB_rdy = 1'b1;
  ex_cm_robAIdx  = 5'd3;  // head 3 and head4 should not retire because head 2 is not retired
  ex_cm_robBIdx  = 5'd4;

  @(posedge clock);
  ex_cm_cdbA_rdy = 1'b1;
  ex_cm_cdbB_rdy = 1'b1;
  ex_cm_robAIdx  = 5'd2;  // head2 and head3 should retire
  ex_cm_robBIdx  = 5'd5;

  @(posedge clock);           // in this clock cycle, head 4 and head6 should retire
  ex_cm_cdbA_rdy = 1'b0;
  ex_cm_cdbB_rdy = 1'b0;



  @(posedge clock);
  ex_cm_cdbA_rdy = 1'b1;
  ex_cm_cdbB_rdy = 1'b0;
  ex_cm_robAIdx  = 5'd6;  // head6 should be written but head 7 should not
  ex_cm_robBIdx  = 5'd7;


  @(posedge clock);
  ex_cm_cdbA_rdy = 1'b0;
  ex_cm_cdbB_rdy = 1'b1;
  ex_cm_robAIdx  = 5'd8;  // head7 should be written but head 8 should not
  ex_cm_robBIdx  = 5'd7;

  @(posedge clock);
  ex_cm_cdbA_rdy = 1'b1;
  ex_cm_cdbB_rdy = 1'b1;
  ex_cm_robAIdx  = 5'd8;
  ex_cm_robBIdx  = 5'd9;   // head8 and head9 need to retire


  @(posedge clock);
  ex_cm_cdbA_rdy = 1'b1;
  ex_cm_cdbB_rdy = 1'b1;
  ex_cm_robAIdx  = 5'd10;
  ex_cm_robBIdx  = 5'd11;  // head 10 and head11 need to retire


  @(posedge clock);
  ex_cm_cdbA_rdy = 1'b1;
  ex_cm_cdbB_rdy = 1'b1;
  ex_cm_robAIdx  = 5'd12;
  ex_cm_robBIdx  = 5'd13;


  @(posedge clock);
  ex_cm_cdbA_rdy = 1'b1;
  ex_cm_cdbB_rdy = 1'b1;
  ex_cm_robAIdx  = 5'd14;
  ex_cm_robBIdx  = 5'd15;


  @(posedge clock);
  ex_cm_cdbA_rdy = 1'b1;
  ex_cm_cdbB_rdy = 1'b1;
  ex_cm_robAIdx  = 5'd16;
  ex_cm_robBIdx  = 5'd17;


  @(posedge clock);
  ex_cm_cdbA_rdy = 1'b1;
  ex_cm_cdbB_rdy = 1'b1;
  ex_cm_robAIdx  = 5'd18;
  ex_cm_robBIdx  = 5'd19;

  @(posedge clock);
  ex_cm_cdbA_rdy = 1'b1;
  ex_cm_cdbB_rdy = 1'b1;
  ex_cm_robAIdx  = 5'd20;
  ex_cm_robBIdx  = 5'd21;

  @(posedge clock);
  ex_cm_cdbA_rdy = 1'b1;
  ex_cm_cdbB_rdy = 1'b1;
  ex_cm_robAIdx  = 5'd22;
  ex_cm_robBIdx  = 5'd23;

  @(posedge clock);
  ex_cm_cdbA_rdy = 1'b1;
  ex_cm_cdbB_rdy = 1'b1;
  ex_cm_robAIdx  = 5'd24;
  ex_cm_robBIdx  = 5'd25;

  @(posedge clock);
  ex_cm_cdbA_rdy = 1'b1;
  ex_cm_cdbB_rdy = 1'b1;
  ex_cm_robAIdx  = 5'd26;
  ex_cm_robBIdx  = 5'd27;

  @(posedge clock);
  ex_cm_cdbA_rdy = 1'b1;
  ex_cm_cdbB_rdy = 1'b1;
  ex_cm_robAIdx  = 5'd28;
  ex_cm_robBIdx  = 5'd29;

  @(posedge clock);
  ex_cm_cdbA_rdy = 1'b1;
  ex_cm_cdbB_rdy = 1'b1;
  ex_cm_robAIdx  = 5'd30;
  ex_cm_robBIdx  = 5'd31;

  @(posedge clock);
  ex_cm_cdbA_rdy = 1'b0;
  ex_cm_cdbB_rdy = 1'b0;

  
  @(negedge clock);
  @(negedge clock);
  @(negedge clock);
  @(negedge clock);

  $finish;

  end 

endmodule
