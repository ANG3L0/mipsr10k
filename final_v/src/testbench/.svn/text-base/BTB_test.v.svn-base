`timescale 1ns/100ps
module testbench;
///////// INPUTS //////////
reg clock;
reg		delete0_en;
reg		delete1_en;
reg	[63:0]	mispredicted_PCA;
reg	[63:0]	mispredicted_PCB;
reg	[3:0]	rd_PCA_idx;
reg	[57:0]	rd_PCA_tag;
reg	[3:0]	rd_PCB_idx;
reg	[57:0]	rd_PCB_tag;
reg		reset;
reg		wr0_en;
reg		wr1_en;
reg	[63:0]	wr_PCA_data;
reg	[3:0]	wr_PCA_idx;
reg	[57:0]	wr_PCA_tag;
reg	[63:0]	wr_PCB_data;
reg	[3:0]	wr_PCB_idx;
reg	[57:0]	wr_PCB_tag;
///////// OUTPUTS //////////
wire		hitA;
wire		hitB;
wire	[63:0]	target_PCA;
wire	[63:0]	target_PCB;


BTB   BTB_0(
	//input ports
	.clock(clock),
	.delete0_en(delete0_en),
	.delete1_en(delete1_en),
	.mispredicted_PCA(mispredicted_PCA),
	.mispredicted_PCB(mispredicted_PCB),
	.rd_PCA_idx(rd_PCA_idx),
	.rd_PCA_tag(rd_PCA_tag),
	.rd_PCB_idx(rd_PCB_idx),
	.rd_PCB_tag(rd_PCB_tag),
	.reset(reset),
	.wr0_en(wr0_en),
	.wr1_en(wr1_en),
	.wr_PCA_data(wr_PCA_data),
	.wr_PCA_idx(wr_PCA_idx),
	.wr_PCA_tag(wr_PCA_tag),
	.wr_PCB_data(wr_PCB_data),
	.wr_PCB_idx(wr_PCB_idx),
	.wr_PCB_tag(wr_PCB_tag),
	//output ports
	.hitA(hitA),
	.hitB(hitB),
	.target_PCA(target_PCA),
	.target_PCB(target_PCB)
);


always
	begin
	#(`VERILOG_CLOCK_PERIOD/2);
	clock=~clock;
end

reg [4:0] i;

always @(posedge clock)
begin


`ifdef DEBUG_OUT

  $display("==========================================================================================================");
  $display("|  \t \t  tag \t \t \t \t| \t  data \t \t \t \t | \t valid \t |\n\
==========================================================================================================");
  for (i=0;i<16;i=i+1) begin
    $display("| \t \t %58h \t \t| \t %64h \t  \t| \t %1b \t |",
        BTB_0.tags[i], BTB_0.data[i], BTB_0.valids[i]);    
  end
  $display("==========================================================================================================\n");
`endif
end








initial
begin
clock=0;
delete0_en=0;
delete1_en=0;
mispredicted_PCA=0;
mispredicted_PCB=0;
rd_PCA_idx=0;
rd_PCA_tag=0;
rd_PCB_idx=0;
rd_PCB_tag=0;
reset=1;
wr0_en=0;
wr1_en=0;
wr_PCA_data=0;
wr_PCA_idx=0;
wr_PCA_tag=0;
wr_PCB_data=0;
wr_PCB_idx=0;
wr_PCB_tag=0;

//write data

@(negedge clock) 
delete0_en=0;
delete1_en=0;
mispredicted_PCA=0;
mispredicted_PCB=0;
rd_PCA_idx=0;
rd_PCA_tag=0;
rd_PCB_idx=0;
rd_PCB_tag=0;
reset=0;
wr0_en=1;
wr1_en=0;
wr_PCA_data=64'h1111_1111_2222_2228;
wr_PCA_idx=4'd10;
wr_PCA_tag=58'h3333_3333_33;
wr_PCB_data=0;
wr_PCB_idx=0;
wr_PCB_tag=0;


@(negedge clock)  
delete0_en=0;
delete1_en=0;
mispredicted_PCA=0;
mispredicted_PCB=0;
rd_PCA_idx=0;
rd_PCA_tag=0;
rd_PCB_idx=0;
rd_PCB_tag=0;
reset=0;
wr0_en=1;
wr1_en=0;
wr_PCA_data=64'h4444_1111_2233_1124;
wr_PCA_idx=4'd15;
wr_PCA_tag=58'h1234_5678_90;
wr_PCB_data=0;
wr_PCB_idx=0;
wr_PCB_tag=0;

@(negedge clock)  
delete0_en=0;
delete1_en=0;
mispredicted_PCA=0;
mispredicted_PCB=0;
rd_PCA_idx=0;
rd_PCA_tag=0;
rd_PCB_idx=0;
rd_PCB_tag=0;
reset=0;
wr0_en=1;
wr1_en=1;
wr_PCA_data=64'h4554_1661_2773_1120;
wr_PCA_idx=4'd1;
wr_PCA_tag=58'h4;
wr_PCB_data=64'h4444_1881_2299_1550;
wr_PCB_idx=4'd2;
wr_PCB_tag=58'h2222_2222_2222_22;

@(negedge clock)  
delete0_en=0;
delete1_en=0;
mispredicted_PCA=0;
mispredicted_PCB=0;
rd_PCA_idx=0;
rd_PCA_tag=0;
rd_PCB_idx=0;
rd_PCB_tag=0;
reset=0;
wr0_en=1;
wr1_en=1;
wr_PCA_data=64'h3;
wr_PCA_idx=4'd3;
wr_PCA_tag=58'h3;
wr_PCB_data=64'h4;
wr_PCB_idx=4'd4;
wr_PCB_tag=58'h4;

// read data

@(negedge clock)  
delete0_en=0;
delete1_en=0;
mispredicted_PCA=0;
mispredicted_PCB=0;
rd_PCA_idx=4'd1;
rd_PCA_tag=58'h4;
rd_PCB_idx=0;
rd_PCB_tag=0;
reset=0;
wr0_en=0;
wr1_en=0;
wr_PCA_data=0;
wr_PCA_idx=0;
wr_PCA_tag=0;
wr_PCB_data=0;
wr_PCB_idx=0;
wr_PCB_tag=0;

//delete data

@(negedge clock)  
delete0_en=0;
delete1_en=1;
mispredicted_PCA=0;
mispredicted_PCB=64'h104;
rd_PCA_idx=0;
rd_PCA_tag=0;
rd_PCB_idx=0;
rd_PCB_tag=0;
reset=0;
wr0_en=0;
wr1_en=0;
wr_PCA_data=0;
wr_PCA_idx=0;
wr_PCA_tag=0;
wr_PCB_data=0;
wr_PCB_idx=0;
wr_PCB_tag=0;

// read the deleted data

@(negedge clock)  
delete0_en=0;
delete1_en=0;
mispredicted_PCA=0;
mispredicted_PCB=0;
rd_PCA_idx=4'd1;
rd_PCA_tag=58'h4;
rd_PCB_idx=0;
rd_PCB_tag=0;
reset=0;
wr0_en=0;
wr1_en=0;
wr_PCA_data=0;
wr_PCA_idx=0;
wr_PCA_tag=0;
wr_PCB_data=0;
wr_PCB_idx=0;
wr_PCB_tag=0;

// read one data and not hit

@(negedge clock)  
delete0_en=0;
delete1_en=0;
mispredicted_PCA=0;
mispredicted_PCB=0;
rd_PCA_idx=0;
rd_PCA_tag=0;
rd_PCB_idx=4'd2;
rd_PCB_tag=58'h17;
reset=0;
wr0_en=0;
wr1_en=0;
wr_PCA_data=0;
wr_PCA_idx=0;
wr_PCA_tag=0;
wr_PCB_data=0;
wr_PCB_idx=0;
wr_PCB_tag=0;

//replace one entry
@(negedge clock)  
delete0_en=0;
delete1_en=0;
mispredicted_PCA=0;
mispredicted_PCB=0;
rd_PCA_idx=0;
rd_PCA_tag=0;
rd_PCB_idx=0;
rd_PCB_tag=0;
reset=0;
wr0_en=0;
wr1_en=1;
wr_PCA_data=0;
wr_PCA_idx=0;
wr_PCA_tag=0;
wr_PCB_data=64'h5;
wr_PCB_idx=4'h3;
wr_PCB_tag=58'h17;

//replace the invalid entry, write without enable
@(negedge clock)  
delete0_en=0;
delete1_en=0;
mispredicted_PCA=0;
mispredicted_PCB=0;
rd_PCA_idx=0;
rd_PCA_tag=0;
rd_PCB_idx=0;
rd_PCB_tag=0;
reset=0;
wr0_en=0;
wr1_en=1;
wr_PCA_data=64'h55;
wr_PCA_idx=4'h6;
wr_PCA_tag=58'h12;
wr_PCB_data=64'h5;
wr_PCB_idx=4'h1;
wr_PCB_tag=58'h19;

@(negedge clock)  
delete0_en=0;
delete1_en=0;
mispredicted_PCA=0;
mispredicted_PCB=0;
rd_PCA_idx=0;
rd_PCA_tag=0;
rd_PCB_idx=0;
rd_PCB_tag=0;
reset=0;
wr0_en=1;
wr1_en=0;
wr_PCA_data=64'h55;
wr_PCA_idx=4'h6;
wr_PCA_tag=58'h12;
wr_PCB_data=0;
wr_PCB_idx=4'h1;
wr_PCB_tag=58'h19;


#20

$finish;
end //end initial
endmodule
