`timescale 1ns/100ps
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

freelist freelist_0( 
  //inputs
  .clk(clk),
  .reset(reset),
  .valid_instA(valid_instA),
  .valid_instB(valid_instB),
  .rob_retire_enA(rob_retire_enA),
  .rob_retire_enB(rob_retire_enB),
  .rob_ToldA(rob_ToldA),
  .rob_ToldB(rob_ToldB),
  .opcodeA(opcodeA),
  .opcodeB(opcodeB),
  //outputs
  .fl_TA(fl_TA),
  .fl_TB(fl_TB),
  .full(full),
  .empty(empty),
  .almost_empty(almost_empty)
);


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
  $display("==========================================================");
  $display("|    ht pos \t | \t PR# \t \t | \t valid \t |\n\
==========================================================");
  for (i=0;i<32;i=i+1) begin
    if (freelist_0.head==i && freelist_0.tail==i) begin
    $display("| \t ht \t | \t %6d \t | \t %1b \t |",
        freelist_0.freelist[i], freelist_0.valid[i]);
    end
    else if (freelist_0.head==i) begin
    $display("| \t h \t | \t %6d \t | \t %1b \t |",
        freelist_0.freelist[i], freelist_0.valid[i]);
    end
    else if (freelist_0.tail==i) begin
    $display("| \t t \t | \t %6d \t | \t %1b \t |",
        freelist_0.freelist[i], freelist_0.valid[i]);
    end
    else begin
    $display("| \t   \t | \t %6d \t | \t %1b \t |",
        freelist_0.freelist[i], freelist_0.valid[i]);
    end
  end
  $display("----------------------------------------------------------\n");
`endif
end
reg [10:0] j;
initial 
begin
  clk = 0;
  clocks=0;
  
  reset = 1;
  rob_retire_enA = 0;
  rob_retire_enB = 0;
  rob_ToldA = 6'd0;
  rob_ToldB = 6'd0;
  valid_instA = 0;
  valid_instB = 0;
  opcodeA = 5'b0000_1;
  opcodeB = 5'b0001_0;
  @(negedge clk);
  //grab freelist PRs 1-by-1
  for (j=0; j<'d32; j=j+1) begin
  reset=0;
  rob_retire_enA = 0;
  rob_retire_enB = 0;
  rob_ToldA = 6'd0;
  rob_ToldB = 6'd0;
  valid_instA = 1;
  valid_instB = 0;
  opcodeA = 5'b0000_1;
  opcodeB = 5'b0001_0;
  @(negedge clk);
  end // 34
  //retire one by one
  for (j=0; j<'d32; j=j+1) begin
  reset=0;
  rob_retire_enA = 1;
  rob_retire_enB = 0;
  rob_ToldA = 6'd0+j;
  rob_ToldB = 6'd0;
  valid_instA = 0;
  valid_instB = 0;
  opcodeA = 5'b0000_1;
  opcodeB = 5'b0001_0;
  @(negedge clk);
  end
  //reset
  reset=1;
  @(negedge clk); //67
  //grab freelist PRs 1-by-1, retire last one.
  for (j=0; j<'d31; j=j+1) begin
  reset=0;
  rob_retire_enA = 0;
  rob_retire_enB = 0;
  rob_ToldA = 6'd0+j;
  rob_ToldB = 6'd0;
  valid_instA = 1;
  valid_instB = 0;
  opcodeA = 5'b0000_1;
  opcodeB = 5'b0001_0;
  @(negedge clk);
  end //98
  reset=0;
  rob_retire_enA = 1;
  rob_retire_enB = 0;
  rob_ToldA = 6'd1;
  rob_ToldB = 6'd0;
  valid_instA = 0;
  valid_instB = 0;
  opcodeA = 5'b0000_1;
  opcodeB = 5'b0001_0;
  @(negedge clk); //99
  //reset
  reset=1;
  @(negedge clk); //100
  //grab freelist PRs 2-by-2
  for (j=0; j<'d16; j=j+1) begin
  reset=0;
  rob_retire_enA = 0;
  rob_retire_enB = 0;
  rob_ToldA = 6'd0+j;
  rob_ToldB = 6'd0;
  valid_instA = 1;
  valid_instB = 1;
  opcodeA = 5'b0000_1;
  opcodeB = 5'b0001_0;
  @(negedge clk);
  end //116
  //retire freelist 2-by-2
  for (j=0; j<'d32; j=j+1) begin
  reset=0;
  rob_retire_enA = 1;
  rob_retire_enB = 0;
  rob_ToldA = 6'd0+2*j;
  rob_ToldB = 6'd1+2*j;
  valid_instA = 0;
  valid_instB = 0;
  opcodeA = 5'b0000_1;
  opcodeB = 5'b0001_0;
  @(negedge clk);
  end //148
  //free one, then retire one (FULL)
  for (j=0; j<'d32; j=j+1) begin
  reset=0;
  rob_retire_enA = 0;
  rob_retire_enB = 0;
  rob_ToldA = 6'd13+j;
  rob_ToldB = 6'd1+2*j;
  valid_instA = 1;
  valid_instB = 0;
  opcodeA = 5'b0000_1;
  opcodeB = 5'b0001_0;
  @(negedge clk);
  reset=0;
  rob_retire_enA = 1;
  rob_retire_enB = 0;
  rob_ToldA = 6'd13+j;
  rob_ToldB = 6'd14+j;
  valid_instA = 0;
  valid_instB = 0;
  opcodeA = 5'b0000_1;
  opcodeB = 5'b0001_0;
  @(negedge clk);
  end //212

  //free one and retire one at same time
  for(j=0;j<'d32;j=j+1) begin
  reset=0;
  rob_retire_enA = 1;
  rob_retire_enB = 0;
  rob_ToldA = 6'd0+j;
  rob_ToldB = 6'd1+j;
  valid_instA = 1;
  valid_instB = 0;
  opcodeA = 5'b0000_1;
  opcodeB = 5'b0001_0;
  @(negedge clk);
  end //244
  //free two, then retire two
  for(j=0;j<'d32;j=j+1) begin
  reset=0;
  rob_retire_enA = 0;
  rob_retire_enB = 0;
  rob_ToldA = 6'd13+2*j;
  rob_ToldB = 6'd14+2*j;
  valid_instA = 1;
  valid_instB = 1;
  opcodeA = 5'b0000_1;
  opcodeB = 5'b0001_0;
  @(negedge clk);
  reset=0;
  rob_retire_enA = 1;
  rob_retire_enB = 1;
  rob_ToldA = 6'd13+2*j;
  rob_ToldB = 6'd14+2*j;
  valid_instA = 0;
  valid_instB = 0;
  opcodeA = 5'b0000_1;
  opcodeB = 5'b0001_0;
  @(negedge clk);
  end // 308
  //free two and retire two at same time
  for(j=0;j<'d32;j=j+1) begin
  reset=0;
  rob_retire_enA = 1;
  rob_retire_enB = 1;
  rob_ToldA = 6'd13+2*j;
  rob_ToldB = 6'd14+2*j;
  valid_instA = 1;
  valid_instB = 1;
  opcodeA = 5'b0000_1;
  opcodeB = 5'b0001_0;
  @(negedge clk);
  end //  340
  //reset
  reset=1;
  @(negedge clk); //341
  //grab all PR#s so ht aligned
  for(j=0;j<'d16;j=j+1) begin
  reset=0;
  rob_retire_enA = 0;
  rob_retire_enB = 0;
  rob_ToldA = 6'd13+2*j;
  rob_ToldB = 6'd14+2*j;
  valid_instA = 1;
  valid_instB = 1;
  opcodeA = 5'b0000_1;
  opcodeB = 5'b0001_0;
  @(negedge clk);
  end //  357
  //retire and grab at the same time (1-by-1)
  for(j=0;j<'d16;j=j+1) begin
  reset=0;
  rob_retire_enA = 1;
  rob_retire_enB = 0;
  rob_ToldA = 6'd13+2*j;
  rob_ToldB = 6'd14+2*j;
  valid_instA = 1;
  valid_instB = 0;
  opcodeA = 5'b0000_1;
  opcodeB = 5'b0001_0;
  @(negedge clk);
  end //  342
  //retire 
  //reset
  //grab all PR#s so ht aligned

  //retire and grab at same time (2-by-2)
  

  @(negedge clk);  //display lag
  $finish;
end
endmodule
  
  

