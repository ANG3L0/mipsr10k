`define CDBWIDTH 6
`define SD      #1
`define  NORMAL  2'b00
`define  ALMOST_FULL  2'b01
`define  FULL    2'b10
`define  DEFAULT  2'b11
`define  NONE_READY   2'b00
`define  CDB_AREADY   2'b10
`define  CDB_BREADY   2'b01
`define  BOTH_READY   2'b11
`define  STORE        6'b000000
`timescale 1ns/100ps

module testbench;
///////// INPUTS //////////
reg	[4:0]	ex_cdbAIdx;
reg		ex_cdbA_rdy;
reg	[4:0]	ex_cdbBIdx;
reg		ex_cdbB_rdy;
reg	[4:0]	ex_cdbCIdx;
reg		ex_cdbC_rdy;
reg	[4:0]	ex_cdbDIdx;
reg		ex_cdbD_rdy;

reg	[5:0]	fl_TA;
reg	[5:0]	fl_TB;
reg	[4:0]	id_opcodeA;
reg	[4:0]	id_opcodeB;
reg		id_valid_IRA;
reg		id_valid_IRB;
reg	[31:0]	if_id_IRA;
reg	[31:0]	if_id_IRB;
reg	[63:0]	if_id_NPCA;
reg	[63:0]	if_id_NPCB;
reg	[5:0]	mt_ToldA;
reg	[4:0]	mt_ToldA_idx;
reg	[5:0]	mt_ToldB;
reg	[4:0]	mt_ToldB_idx;
reg		reset;
reg             clock;

///////// OUTPUTS //////////
wire		rob_IRA_en_out;
wire		rob_IRB_en_out;
wire	[5:0]	rob_ToldA_out;
wire	[5:0]	rob_ToldB_out;
wire		rob_almost_full;
wire		rob_empty;
wire		rob_full;
wire	[4:0]	rob_head;
wire	[4:0]	rob_idx_A;
wire	[4:0]	rob_idx_B;
wire		rob_retireA_en_out;
wire		rob_retireB_en_out;
wire	[4:0]	rob_tail;


rob   rob(
	//input ports
	.clock(clock),//
	.ex_cdbAIdx(ex_cdbAIdx),//
	.ex_cdbA_rdy(ex_cdbA_rdy),//
	.ex_cdbBIdx(ex_cdbBIdx),//     
	.ex_cdbB_rdy(ex_cdbB_rdy),//
        .ex_cdbCIdx(ex_cdbAIdx),//
	.ex_cdbC_rdy(ex_cdbA_rdy),//
	.ex_cdbDIdx(ex_cdbBIdx),//     
	.ex_cdbD_rdy(ex_cdbB_rdy),//

	.fl_TA(fl_TA),//
	.fl_TB(fl_TB),//
	.id_opcodeA(id_opcodeA),//
	.id_opcodeB(id_opcodeB),//
	.id_valid_IRA(id_valid_IRA),//
	.id_valid_IRB(id_valid_IRB),//
	.if_id_IRA(if_id_IRA),//
	.if_id_IRB(if_id_IRB),//
	.if_id_NPCA(if_id_NPCA),//
	.if_id_NPCB(if_id_NPCB),//
	.mt_ToldA(mt_ToldA),//
	.mt_ToldA_idx(mt_ToldA_idx),//
	.mt_ToldB(mt_ToldB),//
	.mt_ToldB_idx(mt_ToldB_idx),//
	.reset(reset),//
	//output ports
	.rob_IRA_en_out(rob_IRA_en_out),//
	.rob_IRB_en_out(rob_IRB_en_out),//
	.rob_ToldA_out(rob_ToldA_out),//
	.rob_ToldB_out(rob_ToldB_out),//
	.rob_almost_full(rob_almost_full),//
	.rob_empty(rob_empty),//
	.rob_full(rob_full),//
	.rob_head(rob_head),//
	.rob_idx_A(rob_idx_A),//
	.rob_idx_B(rob_idx_B),//
	.rob_retireA_en_out(rob_retireA_en_out),//
	.rob_retireB_en_out(rob_retireB_en_out),//
	.rob_tail(rob_tail)//
);


always
  #5 clock=~clock;

initial 
  begin 
   
clock = 0;
reset = 1;

if_id_NPCA = 63'd0;        
if_id_NPCB = 63'd0;

id_valid_IRA = 0;
id_valid_IRB = 0;

ex_cdbAIdx=6'd0;
ex_cdbBIdx=6'd1;  
ex_cdbCIdx=6'd2;
ex_cdbDIdx=6'd3;  
       
ex_cdbA_rdy=0;
ex_cdbB_rdy=0;
ex_cdbC_rdy=0;
ex_cdbD_rdy=0;

id_opcodeA=5'd1;
id_opcodeB=5'd2;

//Test 1: make ROB full to test the rob_full signal

@(negedge clock);  //end of clock 0 

reset=0;

id_valid_IRA=1;
id_valid_IRB=1;

fl_TA=6'd32;
fl_TB=6'd33;

id_opcodeA=5'd1;
id_opcodeB=5'd2;

if_id_IRA=32'd1;
if_id_IRB=32'd2;

if_id_NPCA=64'd1;
if_id_NPCB=64'd1;

mt_ToldA=6'd0;
mt_ToldA_idx=5'd0;

mt_ToldB=6'd1;
mt_ToldB_idx=5'd1;

@(negedge clock); //end of clock 1 
id_valid_IRA=1;
id_valid_IRB=1;

fl_TA=6'd34;
fl_TB=6'd35;

id_opcodeA=5'd3;
id_opcodeB=5'd4;

if_id_IRA=32'd3;
if_id_IRB=32'd4;

if_id_NPCA=64'd3;
if_id_NPCB=64'd4;

mt_ToldA=6'd2;
mt_ToldA_idx=5'd2;

mt_ToldB=6'd3;
mt_ToldB_idx=5'd3;

@(negedge clock);  //end of clock 2 
id_valid_IRA=1;
id_valid_IRB=1;

fl_TA=6'd36;
fl_TB=6'd37;

id_opcodeA=5'd5;
id_opcodeB=5'd6;

if_id_IRA=32'd5;
if_id_IRB=32'd6;

if_id_NPCA=64'd5;
if_id_NPCB=64'd6;

mt_ToldA=6'd4;
mt_ToldA_idx=5'd4;

mt_ToldB=6'd5;
mt_ToldB_idx=5'd5;

@(negedge clock);  //end of clock 3 
id_valid_IRA=1;
id_valid_IRB=1;

fl_TA=6'd38;
fl_TB=6'd39;

id_opcodeA=5'd7;
id_opcodeB=5'd8;

if_id_IRA=32'd7;
if_id_IRB=32'd8;

if_id_NPCA=64'd7;
if_id_NPCB=64'd8;

mt_ToldA=6'd6;
mt_ToldA_idx=5'd6;

mt_ToldB=6'd7;
mt_ToldB_idx=5'd7;
@(negedge clock);  //end of clock 4 
id_valid_IRA=1;
id_valid_IRB=1;

fl_TA=6'd40;
fl_TB=6'd41;

id_opcodeA=5'd9;
id_opcodeB=5'd10;

if_id_IRA=32'd9;
if_id_IRB=32'd10;

if_id_NPCA=64'd9;
if_id_NPCB=64'd10;

mt_ToldA=6'd8;
mt_ToldA_idx=5'd8;

mt_ToldB=6'd9;
mt_ToldB_idx=5'd9;
@(negedge clock);  //end of clock 5 
id_valid_IRA=1;
id_valid_IRB=1;

fl_TA=6'd42;
fl_TB=6'd43;

id_opcodeA=5'd11;
id_opcodeB=5'd12;

if_id_IRA=32'd11;
if_id_IRB=32'd12;

if_id_NPCA=64'd11;
if_id_NPCB=64'd12;

mt_ToldA=6'd10;
mt_ToldA_idx=5'd10;

mt_ToldB=6'd11;
mt_ToldB_idx=5'd11;
@(negedge clock);  //end of clock 6 
id_valid_IRA=1;
id_valid_IRB=1;

fl_TA=6'd44;
fl_TB=6'd45;

id_opcodeA=5'd13;
id_opcodeB=5'd14;

if_id_IRA=32'd13;
if_id_IRB=32'd14;

if_id_NPCA=64'd13;
if_id_NPCB=64'd14;

mt_ToldA=6'd12;
mt_ToldA_idx=5'd12;

mt_ToldB=6'd13;
mt_ToldB_idx=5'd13;
@(negedge clock);  //end of clock 7 
id_valid_IRA=1;
id_valid_IRB=1;

fl_TA=6'd46;
fl_TB=6'd47;

id_opcodeA=5'd15;
id_opcodeB=5'd16;

if_id_IRA=32'd15;
if_id_IRB=32'd16;

if_id_NPCA=64'd15;
if_id_NPCB=64'd16;

mt_ToldA=6'd14;
mt_ToldA_idx=5'd14;

mt_ToldB=6'd15;
mt_ToldB_idx=5'd15;

@(negedge clock);  //end of clock 8 
id_valid_IRA=1;
id_valid_IRB=1;

fl_TA=6'd48;
fl_TB=6'd49;

id_opcodeA=5'd17;
id_opcodeB=5'd18;

if_id_IRA=32'd17;
if_id_IRB=32'd18;

if_id_NPCA=64'd17;
if_id_NPCB=64'd18;

mt_ToldA=6'd16;
mt_ToldA_idx=5'd16;

mt_ToldB=6'd17;
mt_ToldB_idx=5'd17;

@(negedge clock);  //end of clock 9 
id_valid_IRA=1;
id_valid_IRB=1;

fl_TA=6'd50;
fl_TB=6'd51;

id_opcodeA=5'd19;
id_opcodeB=5'd20;

if_id_IRA=32'd19;
if_id_IRB=32'd20;

if_id_NPCA=64'd19;
if_id_NPCB=64'd20;

mt_ToldA=6'd18;
mt_ToldA_idx=5'd18;

mt_ToldB=6'd19;
mt_ToldB_idx=5'd19;

@(negedge clock);  //end of clock 10 
id_valid_IRA=1;
id_valid_IRB=1;

fl_TA=6'd52;
fl_TB=6'd53;

id_opcodeA=5'd21;
id_opcodeB=5'd22;

if_id_IRA=32'd21;
if_id_IRB=32'd22;

if_id_NPCA=64'd21;
if_id_NPCB=64'd22;

mt_ToldA=6'd20;
mt_ToldA_idx=5'd20;

mt_ToldB=6'd21;
mt_ToldB_idx=5'd21;

@(negedge clock);  //end of clock 11
id_valid_IRA=1;
id_valid_IRB=1;

fl_TA=6'd54;
fl_TB=6'd55;

id_opcodeA=5'd23;
id_opcodeB=5'd24;

if_id_IRA=32'd23;
if_id_IRB=32'd24;

if_id_NPCA=64'd23;
if_id_NPCB=64'd24;

mt_ToldA=6'd22;
mt_ToldA_idx=5'd22;

mt_ToldB=6'd23;
mt_ToldB_idx=5'd23;

@(negedge clock);  //end of clock 12
id_valid_IRA=1;
id_valid_IRB=1;

fl_TA=6'd56;
fl_TB=6'd57;

id_opcodeA=5'd25;
id_opcodeB=5'd26;

if_id_IRA=32'd25;
if_id_IRB=32'd26;

if_id_NPCA=64'd25;
if_id_NPCB=64'd26;

mt_ToldA=6'd24;
mt_ToldA_idx=5'd24;

mt_ToldB=6'd25;
mt_ToldB_idx=5'd25;

@(negedge clock);  //end of clock 13
id_valid_IRA=1;
id_valid_IRB=1;

fl_TA=6'd58;
fl_TB=6'd59;

id_opcodeA=5'd27;
id_opcodeB=5'd28;

if_id_IRA=32'd27;
if_id_IRB=32'd28;

if_id_NPCA=64'd27;
if_id_NPCB=64'd28;

mt_ToldA=6'd26;
mt_ToldA_idx=5'd26;

mt_ToldB=6'd27;
mt_ToldB_idx=5'd27;

@(negedge clock);  //end of clock 14
id_valid_IRA=1;
id_valid_IRB=1;

fl_TA=6'd60;
fl_TB=6'd61;

id_opcodeA=5'd29;
id_opcodeB=5'd30;

if_id_IRA=32'd29;
if_id_IRB=32'd30;

if_id_NPCA=64'd29;
if_id_NPCB=64'd30;

mt_ToldA=6'd28;
mt_ToldA_idx=5'd28;

mt_ToldB=6'd29;
mt_ToldB_idx=5'd29;

@(negedge clock);  //end of clock 15
id_valid_IRA=1;
id_valid_IRB=1;

fl_TA=6'd62;
fl_TB=6'd63;

id_opcodeA=5'd31;
id_opcodeB=5'd1;

if_id_IRA=32'd31;
if_id_IRB=32'd32;

if_id_NPCA=64'd31;
if_id_NPCB=64'd32;

mt_ToldA=6'd30;
mt_ToldA_idx=5'd30;

mt_ToldB=6'd31;
mt_ToldB_idx=5'd31;

//Test 2: rob_almost_full signal

@(negedge clock); // end of clock 16
id_valid_IRA=0;   //When the ROB is full and no retire, the fetch will stall, and the id_valid_IR = 0;
id_valid_IRB=0;

ex_cdbA_rdy=1; //complete one instruction



@(negedge clock);
ex_cdbA_rdy=0;
@(negedge clock);


//Test 3: complete one instruction but not the head point to, it cannot be
//retired
id_valid_IRA=0;
id_valid_IRB=0;

ex_cdbAIdx=6'd2;
ex_cdbBIdx=6'd1;  

@(negedge clock);
@(negedge clock);


//Test 4: retire one instruction and dispatch two instruction at one clock
//cycle
id_valid_IRA=0;   //When the ROB is full and no retire, the fetch will stall, and the id_valid_IR = 0;
id_valid_IRB=0;

ex_cdbA_rdy=0; //complete one instruction
ex_cdbB_rdy=1;

@(negedge clock);
//id_valid_IRA = 1;
//id_valid_IRB = 1;

ex_cdbB_rdy=0;
@(negedge clock);

@(negedge clock);
//id_valid_IRA = 1;
//id_valid_IRB = 1;



$finish;
end //end initial
endmodule
