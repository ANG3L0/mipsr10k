


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
   reg   [5:0]  ex_cm_cdbAIdx;
   reg   [5:0]  ex_cm_cdbBIdx;
   reg          ex_cm_cdbA_rdy;
   reg          ex_cm_cdbB_rdy;

   // output 
   wire  [5:0]  rob_ToldA_out;
   wire  [5:0]  rob_ToldB_out;
   wire         rob_retireA_out;
   wire         rob_retireB_out;
   wire         rob_one_inst_out;
   wire         rob_none_inst_out;  


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
  .ex_cm_cdbAIdx(ex_cm_cdbAIdx),
  .ex_cm_cdbBIdx(ex_cm_cdbBIdx),
  .ex_cm_cdbA_rdy(ex_cm_cdbA_rdy),
  .ex_cm_cdbB_rdy(ex_cm_cdbB_rdy),

  // output

  .rob_ToldA_out(rob_ToldA_out),
  .rob_ToldB_out(rob_ToldB_out),
  .rob_retireA_out(rob_retireA_out),
  .rob_retireB_out(rob_retireB_out),
  .rob_one_inst_out(rob_one_inst_out),
  .rob_none_inst_out(rob_none_inst_out)

);


  always
  begin 
    #5;
  clock = ~clock;
  end 

  initial 
  begin 
   
   clock         = 1'b0;
   reset         = 1'b0;
   id_valid_instA = 1'b0;
   id_valid_instB = 1'b0; 

   mt_ToldA      =  6'b0;
   mt_ToldB      =  6'd1;

   fl_TA         =  6'd32;         //t0
   fl_TB         =  6'd33;         // t1

   ex_cm_cdbA_rdy = 1'b0;
   ex_cm_cdbB_rdy = 1'b0;
   ex_cm_cdbAIdx   = 6'd0;
   ex_cm_cdbBIdx   = 6'd1;

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

   fl_TA        =  6'd36;      // t4
   fl_TB        =  6'd37;      // t5
   mt_ToldA     =  6'd4;
   mt_ToldB     =  6'd5;
   
  @(negedge clock);
   reset = 1'b0;
   id_valid_instA  = 1'b1;
   id_valid_instB  = 1'b1;
   
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
   id_valid_instA = 1'b1;
   id_valid_instB = 1'b0;

   mt_ToldA      =  6'd10;
   mt_ToldB      =  6'd11;
   fl_TA         =  6'd42;       // t10   
   fl_TB         =  6'd43;     

  ex_cm_cdbAIdx  = 6'd32;
  ex_cm_cdbBIdx  = 6'd33;
  ex_cm_cdbA_rdy = 1'b1;
  ex_cm_cdbB_rdy = 1'b1;


  @(negedge clock);

  ex_cm_cdbAIdx  = 6'd35;
  ex_cm_cdbBIdx  = 6'd34;

  id_valid_instA = 1'b0;
  id_valid_instB = 1'b1;

   fl_TB         = 6'd43;       // T11
   mt_ToldB      = 6'd11;

  @(negedge clock);

  id_valid_instA = 1'b0;
  id_valid_instB = 1'b0;


  ex_cm_cdbA_rdy = 1'b1;
  ex_cm_cdbAIdx  = 6'd36;
  
  ex_cm_cdbB_rdy = 1'b0;
  ex_cm_cdbBIdx  = 6'd37;

  @(negedge clock);
  ex_cm_cdbA_rdy = 1'b0;
  ex_cm_cdbAIdx  = 6'd38;

  ex_cm_cdbB_rdy = 1'b1;
  ex_cm_cdbBIdx  = 6'd37;

  @(negedge clock);                      //  FROM HERE TO TEST THE FULL AND ALMOST FULL CASES
  ex_cm_cdbA_rdy = 1'b0;
  ex_cm_cdbB_rdy = 1'b0;

  id_valid_instA = 1'b1;
  id_valid_instB = 1'b1;

   mt_ToldA      =  6'd12;               
   mt_ToldB      =  6'd13;
   fl_TA         =  6'd44;
   fl_TB         =  6'd45;


  @(negedge clock);
   mt_ToldA      =  6'd14;
   mt_ToldB      =  6'd15;
   fl_TA         =  6'd46;
   fl_TB         =  6'd47;

  @ (negedge clock);
   mt_ToldA      =  6'd16;
   mt_ToldB      =  6'd17;
   fl_TA         =  6'd48;
   fl_TB         =  6'd49;

  @(negedge clock);
   mt_ToldA      =  6'd18;
   mt_ToldB      =  6'd19;
   fl_TA         =  6'd50;
   fl_TB         =  6'd51;


  @(negedge clock);
   mt_ToldA      =  6'd20;
   mt_ToldB      =  6'd21;
   fl_TA         =  6'd52;
   fl_TB         =  6'd53;

  @ (negedge clock);
   mt_ToldA      =  6'd22;
   mt_ToldB      =  6'd23;
   fl_TA         =  6'd54;
   fl_TB         =  6'd55;

  @(negedge clock);
   mt_ToldA      =  6'd24;
   mt_ToldB      =  6'd25;
   fl_TA         =  6'd56;
   fl_TB         =  6'd57;

  @ (negedge clock);
   mt_ToldA      =  6'd26;
   mt_ToldB      =  6'd27;
   fl_TA         =  6'd58;
   fl_TB         =  6'd59;

  @(negedge clock);
   mt_ToldA      =  6'd28;
   mt_ToldB      =  6'd29;
   fl_TA         =  6'd60;
   fl_TB         =  6'd61;

  @(negedge clock);
   mt_ToldA      =  6'd30;
   mt_ToldB      =  6'd31;
   fl_TA         =  6'd62;
   fl_TB         =  6'd63;




/*
  @(negedge clock);
  id_valid_instB = 1'b1;
  id_valid_instA = 1'b0;

   mt_ToldA      =  6'd30;
   mt_ToldB      =  6'd31;
   fl_TA         =  6'd62;
   fl_TB         =  6'd63;
*/


  @ (negedge clock);            // retire for some trial

  ex_cm_cdbA_rdy = 1'b1;
  ex_cm_cdbAIdx  = 6'd38;

  ex_cm_cdbB_rdy = 1'b1;
  ex_cm_cdbBIdx  = 6'd39;
  
  id_valid_instA = 1'b1;
  id_valid_instB = 1'b1;


   mt_ToldA      =  6'd32;
   mt_ToldB      =  6'd33;
   fl_TA         =  6'd0;
   fl_TB         =  6'd1;

  @ (negedge clock);
   mt_ToldA      =  6'd34;
   mt_ToldB      =  6'd35;
   fl_TA         =  6'd2;
   fl_TB         =  6'd3;

  ex_cm_cdbBIdx  = 6'd40;
  ex_cm_cdbAIdx  = 6'd41;

  @(negedge clock);
   mt_ToldA      =  6'd36;
   mt_ToldB      =  6'd37;
   fl_TA         =  6'd4;
   fl_TB         =  6'd5;

  id_valid_instA = 1'b0;
  id_valid_instB = 1'b0;


  ex_cm_cdbAIdx  = 6'd42;
  ex_cm_cdbBIdx  = 6'd43;



  @(negedge clock);
   mt_ToldA      =  6'd38;
   mt_ToldB      =  6'd39;
   fl_TA         =  6'd6;
   fl_TB         =  6'd7;

  ex_cm_cdbAIdx  = 6'd44;
  ex_cm_cdbBIdx  = 6'd45;


  @ (negedge clock);
   ex_cm_cdbAIdx  = 6'd46;
   ex_cm_cdbBIdx  = 6'd47;


  @(negedge clock);
  ex_cm_cdbAIdx  = 6'd48;
  ex_cm_cdbBIdx  = 6'd49;



  @(negedge clock);
  ex_cm_cdbAIdx  = 6'd50;
  ex_cm_cdbBIdx  = 6'd51;


  @ (negedge clock);
   ex_cm_cdbAIdx  = 6'd52;
   ex_cm_cdbBIdx  = 6'd53;



  @ (negedge clock);
   ex_cm_cdbAIdx  = 6'd54;
   ex_cm_cdbBIdx  = 6'd55;


  @(negedge clock);
  ex_cm_cdbAIdx  = 6'd56;
  ex_cm_cdbBIdx  = 6'd57;



  @(negedge clock);
  ex_cm_cdbAIdx  = 6'd58;
  ex_cm_cdbBIdx  = 6'd59;


  @ (negedge clock);
   ex_cm_cdbAIdx  = 6'd60;
   ex_cm_cdbBIdx  = 6'd61;

  @(negedge clock);
  ex_cm_cdbAIdx  = 6'd62;
  ex_cm_cdbBIdx  = 6'd63;
  


  @(negedge clock);
  ex_cm_cdbAIdx  = 6'd0;
  ex_cm_cdbBIdx  = 6'd1;


  @ (negedge clock);
   ex_cm_cdbAIdx  = 6'd2;
   ex_cm_cdbBIdx  = 6'd3;







  @(negedge clock);
  @(negedge clock);

  @(negedge clock);
  @(negedge clock);


  $finish;

 end 


endmodule 








 
   





  




   


