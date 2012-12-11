// readme: make dve to see and check the result
`define CDBWIDTH        6
module freelist_testbench;
  reg                     clk;
  reg                     reset;
  reg                     valid_instA;
  reg                     valid_instB;
  reg                     rob_retire_enA;
  reg                     rob_retire_enB;
  reg   [`CDBWIDTH-1:0]   rob_ToldA;
  reg   [`CDBWIDTH-1:0]   rob_ToldB;
  reg	[4:0]             opcodeA;
  reg	[4:0]             opcodeB; 
  
  wire  [`CDBWIDTH-1:0]	  fl_TA;		
  wire  [`CDBWIDTH-1:0]	  fl_TB;
  wire                    full;
  wire                    empty;
  wire			  almost_empty;

freelist freelist_0
( .clk(clk),
  .reset(reset),
  .valid_instA(valid_instA),
  .valid_instB(valid_instB),
  .rob_retire_enA(rob_retire_enA),
  .rob_retire_enB(rob_retire_enB),
  .rob_ToldA(rob_ToldA),
  .rob_ToldB(rob_ToldB),
  .opcodeA(opcodeA),
  .opcodeB(opcodeB),
  .fl_TA(fl_TA),
  .fl_TB(fl_TB),
  .full(full),
  .empty(empty),
  .almost_empty(almost_empty)
);


//always @(correct)
//	begin
//	#2
//	if(!correct)
//	begin
//		$display("@@@ Incorrect at time %4.0f", $time);
//		$finish;
//	end
//end

reg [5:0] i;
reg [10:0] clocks;
always
  #5 clk=~clk;

always @(posedge clk)
begin
	clocks=clocks+1;
	$display("POSEDGE %20d:", clocks);
$display("freelist_TA:%6d \t freelist_TB:%6d \t full:%1b \t empty:%1b \t almost_empty:%1b", fl_TA,fl_TB,full,empty,almost_empty);
`ifdef DEBUG_OUT
  $display("------------------------------------------");
  $display("|    ht pos \t | \t PR# \t \t |\n\
------------------------------------------");
  for (i=0;i<32;i=i+1) begin
    if (freelist_0.head==i && freelist_0.tail==i) begin
    $display("| \t ht \t | \t %6d \t |",
        freelist_0.freelist[i]);
    end
    else if (freelist_0.head==i) begin
    $display("| \t h \t | \t %6d \t |",
        freelist_0.freelist[i]);
    end
    else if (freelist_0.tail==i) begin
    $display("| \t t \t | \t %6d \t |",
        freelist_0.freelist[i]);
    end
    else begin
    $display("| \t   \t | \t %6d \t |",
        freelist_0.freelist[i]);
    end
  end
  $display("------------------------------------------\n");
`endif
end
initial 
begin
 // $monitor("Time:%4.0f, fl_TA:%b, fl_TB:%d, full:%d, empty:%d, WayA_CDB_broadcast:%b, WayA_CDB_pr_idx:%d, WayA_CDB_cm_idxs:%d 
  clk = 0;
  clocks=0;
  @(negedge clk);
  reset = 1;
  rob_retire_enA = 0;
  rob_retire_enB = 0;
  valid_instA = 0;
  valid_instB = 0;
  opcodeA = 5'b0000_1;
  opcodeB = 5'b0001_0;

  @(negedge clk);
  reset = 0;
  valid_instA = 1;//#free_31
  valid_instB = 1;//#free_30
  @(negedge clk);//#free_28
  @(negedge clk);//#free_26
  @(negedge clk);//#free_24
  @(negedge clk);//#free_22
  opcodeA = 5'b0000_0;
  opcodeB = 5'b0000_0;
  @(negedge clk);//#free_21
  opcodeA = 5'b0000_1;
  opcodeB = 5'b0000_0;
  @(negedge clk);//#free_20
  opcodeA = 5'b0000_0;
  opcodeB = 5'b0000_1;
  @(negedge clk);//#free_20
  opcodeA = 5'b0000_1;
  opcodeB = 5'b0000_1;
  @(negedge clk);//#free_18
  @(negedge clk);//#free_16
  @(negedge clk);//#free_14
  @(negedge clk);//#free_12
  @(negedge clk);//#free_10
  @(negedge clk);//#free_8
  @(negedge clk);//#free_6
  @(negedge clk);//#free_4
  @(negedge clk);//#free_2
  @(negedge clk);//#free_0
  @(negedge clk);
  valid_instA = 0;//empty so input valid signal is meant to be 0
  valid_instB = 0;//#free_0
  @(negedge clk);//#free_1
  rob_retire_enA = 1;
  rob_ToldA = 6'd0;
  @(negedge clk);//#free_2
  rob_retire_enA = 1;
  rob_ToldA = 6'd1;
  @(negedge clk);
  rob_retire_enA = 0;
  valid_instA = 1;//#free_1
  valid_instB = 1;//#free_0
  @(negedge clk);
  valid_instA = 0;//#free_1
  valid_instB = 0;//#free_0
  @(negedge clk);
  rob_retire_enA = 1;
  rob_ToldA = 6'd2;
  rob_retire_enB = 1;
  rob_ToldB = 6'd3;//#free_2
  @(negedge clk);
  rob_retire_enA = 1;
  rob_ToldA = 6'd4;
  rob_retire_enB = 1;
  rob_ToldB = 6'd5;//#free_4
  @(negedge clk);
  rob_retire_enA = 1;
  rob_ToldA = 6'd6;
  rob_retire_enB = 1;
  rob_ToldB = 6'd7;//#free_6
  @(negedge clk);
  rob_retire_enA = 0;
  rob_ToldA = 6'd7;
  rob_retire_enB = 1;
  rob_ToldB = 6'd8;//#free_7
  @(negedge clk);
  rob_retire_enA = 1;
  rob_ToldA = 6'd9;
  rob_retire_enB = 0;
  rob_ToldB = 6'd9;//#free_8
  @(negedge clk);
  rob_retire_enA = 1;
  rob_ToldA = 6'd10;
  rob_retire_enB = 1;
  rob_ToldB = 6'd11;//#free_10
  @(negedge clk);
  rob_retire_enA = 1;
  rob_ToldA = 6'd12;
  rob_retire_enB = 1;
  rob_ToldB = 6'd13;//#free_12  
  @(negedge clk);
  rob_retire_enA = 1;
  rob_ToldA = 6'd14;
  rob_retire_enB = 1;
  rob_ToldB = 6'd15;//#free_14  
  @(negedge clk);
  rob_retire_enA = 1;
  rob_ToldA = 6'd16;
  rob_retire_enB = 1;
  rob_ToldB = 6'd17;//#free_16  
  @(negedge clk);
  rob_retire_enA = 1;
  rob_ToldA = 6'd18;
  rob_retire_enB = 1;
  rob_ToldB = 6'd19;//#free_18  
  @(negedge clk);
  rob_retire_enA = 1;
  rob_ToldA = 6'd20;
  rob_retire_enB = 1;
  rob_ToldB = 6'd21;//#free_20  
  @(negedge clk);
  rob_retire_enA = 1;
  rob_ToldA = 6'd22;
  rob_retire_enB = 1;
  rob_ToldB = 6'd23;//#free_22  
  @(negedge clk);
  rob_retire_enA = 1;
  rob_ToldA = 6'd24;
  rob_retire_enB = 1;
  rob_ToldB = 6'd25;//#free_24  
  @(negedge clk);
  rob_retire_enA = 1;
  rob_ToldA = 6'd26;
  rob_retire_enB = 1;
  rob_ToldB = 6'd27;//#free_26  
  @(negedge clk);
  rob_retire_enA = 1;
  rob_ToldA = 6'd28;
  rob_retire_enB = 1;
  rob_ToldB = 6'd29;//#free_28  
  @(negedge clk);
  rob_retire_enA = 1;
  rob_ToldA = 6'd30;
  rob_retire_enB = 1;
  rob_ToldB = 6'd30;//#free_30
  @(negedge clk);
  rob_retire_enA = 1;
  rob_ToldA = 6'd32;
  rob_retire_enB = 1;
  rob_ToldA = 6'd33;//#free_32
  @(negedge clk);
  rob_retire_enA = 1;
  rob_ToldA = 6'd34;//#free_32
  rob_retire_enB = 0;
  @(negedge clk);
  rob_retire_enA = 0;
  @(negedge clk);
  valid_instA = 1;
  valid_instB = 1;//#free_30 
  @(negedge clk);//#free_28 
  @(negedge clk);  
  $finish;
end
endmodule
  
  

