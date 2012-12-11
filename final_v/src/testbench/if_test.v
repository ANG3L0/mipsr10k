`timescale 1ns/100ps
module testbench;
///////// INPUTS //////////
reg clock;
reg	[63:0]	Imem2proc_data;
reg		non_ins_en_in;
reg		one_ins_en_in;
reg		reset;
///////// OUTPUTS //////////
wire	[31:0]	if_IRA_out;
wire	[31:0]	if_IRB_out;
wire		if_valid_instA_out;
wire		if_valid_instB_out;
wire	[63:0]	proc2Imem_addr;


if_stage   if_stage_0(
	//input ports
	.clock(clock),
	.Imem2proc_data(Imem2proc_data),
	.non_ins_en_in(non_ins_en_in),
	.one_ins_en_in(one_ins_en_in),
	.reset(reset),
	//output ports
	.if_IRA_out(if_IRA_out),
	.if_IRB_out(if_IRB_out),
	.if_valid_instA_out(if_valid_instA_out),
	.if_valid_instB_out(if_valid_instB_out),
	.proc2Imem_addr(proc2Imem_addr)
);


always
	begin
	#(`VERILOG_CLOCK_PERIOD/2);
	clock=~clock;
end

reg [19:0] clocks;
always @(posedge clock)
begin
	clocks=clocks+1;
	$display("POSEDGE %20d:", clocks);
`ifdef DEBUG_OUT
	$display("IRA_out:%32b \t IRB_out:%32b", if_stage_0.if_IRA_out , if_stage_0.if_IRB_out);
	$display("----------------------------------------------------------------------------------");
	$display("| \t fetch PC \t \t | \t next PC \t \t | valid_out A,B |");
	$display("----------------------------------------------------------------------------------");
	$display("| \t %64h \t | \t %64h \t | \t %1b , %1b \t |",
        if_stage_0.PC_reg, if_stage_0.next_PC, if_stage_0.if_valid_instA_out, if_stage_0.if_valid_instB_out);
	$display("----------------------------------------------------------------------------------");
`endif
end


initial
begin
clock=0;
clocks=0;
Imem2proc_data=64'hFFFF_FFFF_FFFF_FFFF;
non_ins_en_in=0;
one_ins_en_in=1;
reset=1;
@(negedge clock)  //end of clock 0 
reset=0;
@(negedge clock)  //end of clock 1 


$finish;
end //end initial
endmodule