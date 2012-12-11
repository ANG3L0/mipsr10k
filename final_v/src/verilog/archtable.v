//`define CDBWIDTH            6
//`define SD               #1

module archtable(
	//inputs
	clock,
	reset,
	//rob_recover,
	retire_enA,
	retire_enB,
        retire_valueA,
	retire_valueB,
	retire_indexA,
	retire_indexB,
	//outputs
	archtable_copy_0,
	archtable_copy_1,
	archtable_copy_2,
	archtable_copy_3,
	archtable_copy_4,
	archtable_copy_5,
	archtable_copy_6,
	archtable_copy_7,
	archtable_copy_8,
	archtable_copy_9,
	archtable_copy_10,
	archtable_copy_11,
	archtable_copy_12,
	archtable_copy_13,
	archtable_copy_14,
	archtable_copy_15,
	archtable_copy_16,
	archtable_copy_17,
	archtable_copy_18,
	archtable_copy_19,
	archtable_copy_20,
	archtable_copy_21,
	archtable_copy_22,
	archtable_copy_23,
	archtable_copy_24,
	archtable_copy_25,
	archtable_copy_26,
	archtable_copy_27,
	archtable_copy_28,
	archtable_copy_29,
	archtable_copy_30,
	archtable_copy_31
	//TODO: find a way to shove everything into the map table.

);

//inputs
input	      clock;
input	      reset;
//input	rob_recover; //tell arch table whether or not to recover (copy/paste into map table)
input	      retire_enA;	//tells architecture table whether or not to accept values from ROB (should be 1 at retire).
input	      retire_enB;	//tells architecture table whether or not to accept values from ROB (should be 1 at retire).
input   [5:0] retire_valueA;
input   [5:0] retire_valueB;
input   [4:0] retire_indexA;//UNKNOWN
input   [4:0] retire_indexB;//UNKNOWN

//outputs
output  	[5:0]	archtable_copy_0;
output  	[5:0]	archtable_copy_1;
output  	[5:0]	archtable_copy_2;
output  	[5:0]	archtable_copy_3;
output  	[5:0]	archtable_copy_4;
output  	[5:0]	archtable_copy_5;
output  	[5:0]	archtable_copy_6;
output  	[5:0]	archtable_copy_7;
output  	[5:0]	archtable_copy_8;
output  	[5:0]	archtable_copy_9;
output  	[5:0]	archtable_copy_10;
output  	[5:0]	archtable_copy_11;
output  	[5:0]	archtable_copy_12;
output  	[5:0]	archtable_copy_13;
output  	[5:0]	archtable_copy_14;
output  	[5:0]	archtable_copy_15;
output  	[5:0]	archtable_copy_16;
output  	[5:0]	archtable_copy_17;
output  	[5:0]	archtable_copy_18;
output  	[5:0]	archtable_copy_19;
output  	[5:0]	archtable_copy_20;
output  	[5:0]	archtable_copy_21;
output  	[5:0]	archtable_copy_22;
output  	[5:0]	archtable_copy_23;
output  	[5:0]	archtable_copy_24;
output  	[5:0]	archtable_copy_25;
output  	[5:0]	archtable_copy_26;
output  	[5:0]	archtable_copy_27;
output  	[5:0]	archtable_copy_28;
output  	[5:0]	archtable_copy_29;
output  	[5:0]	archtable_copy_30;
output  	[5:0]	archtable_copy_31;
//TODO: ABOVE.
reg [`CDBWIDTH-1:0]   at_reg[31:0];//32,6-bit archtable
reg [`CDBWIDTH-1:0]   next_at_reg[31:0];//32,6-bit archtable

assign archtable_copy_0 = next_at_reg[0];
assign archtable_copy_1 = next_at_reg[1];
assign archtable_copy_2 = next_at_reg[2];
assign archtable_copy_3 = next_at_reg[3];
assign archtable_copy_4 = next_at_reg[4];
assign archtable_copy_5 = next_at_reg[5];
assign archtable_copy_6 = next_at_reg[6];
assign archtable_copy_7 = next_at_reg[7];
assign archtable_copy_8 = next_at_reg[8];
assign archtable_copy_9 = next_at_reg[9];
assign archtable_copy_10 = next_at_reg[10];
assign archtable_copy_11 = next_at_reg[11];
assign archtable_copy_12 = next_at_reg[12];
assign archtable_copy_13 = next_at_reg[13];
assign archtable_copy_14 = next_at_reg[14];
assign archtable_copy_15 = next_at_reg[15];
assign archtable_copy_16 = next_at_reg[16];
assign archtable_copy_17 = next_at_reg[17];
assign archtable_copy_18 = next_at_reg[18];
assign archtable_copy_19 = next_at_reg[19];
assign archtable_copy_20 = next_at_reg[20];
assign archtable_copy_21 = next_at_reg[21];
assign archtable_copy_22 = next_at_reg[22];
assign archtable_copy_23 = next_at_reg[23];
assign archtable_copy_24 = next_at_reg[24];
assign archtable_copy_25 = next_at_reg[25];
assign archtable_copy_26 = next_at_reg[26];
assign archtable_copy_27 = next_at_reg[27];
assign archtable_copy_28 = next_at_reg[28];
assign archtable_copy_29 = next_at_reg[29];
assign archtable_copy_30 = next_at_reg[30];
assign archtable_copy_31 = next_at_reg[31];

always @*
begin
	next_at_reg[0] = at_reg[0];
	next_at_reg[1] = at_reg[1];
	next_at_reg[2] = at_reg[2];
	next_at_reg[3] = at_reg[3];
	next_at_reg[4] = at_reg[4];
	next_at_reg[5] = at_reg[5];
	next_at_reg[6] = at_reg[6];
	next_at_reg[7] = at_reg[7];
	next_at_reg[8] = at_reg[8];
	next_at_reg[9] = at_reg[9];
	next_at_reg[10] = at_reg[10];
	next_at_reg[11] = at_reg[11];
	next_at_reg[12] = at_reg[12];
	next_at_reg[13] = at_reg[13];
	next_at_reg[14] = at_reg[14];
	next_at_reg[15] = at_reg[15];
	next_at_reg[16] = at_reg[16];
	next_at_reg[17] = at_reg[17];
	next_at_reg[18] = at_reg[18];
	next_at_reg[19] = at_reg[19];
	next_at_reg[20] = at_reg[20];
	next_at_reg[21] = at_reg[21];
	next_at_reg[22] = at_reg[22];
	next_at_reg[23] = at_reg[23];
	next_at_reg[24] = at_reg[24];
	next_at_reg[25] = at_reg[25];
	next_at_reg[26] = at_reg[26];
	next_at_reg[27] = at_reg[27];
	next_at_reg[28] = at_reg[28];
	next_at_reg[29] = at_reg[29];
	next_at_reg[30] = at_reg[30];
	next_at_reg[31] = at_reg[31];
	if (retire_enA)
		begin
			next_at_reg[retire_indexA] = retire_valueA; // Allocate new preg from freelist to id_destAidx, set the ready bit to be 0
		end
		//else
			//begin
			//end
	if (retire_enB)
		begin
			next_at_reg[retire_indexB] = retire_valueB;
		end
end

always @(posedge clock)
begin
	if (reset)
	begin
	// set the initial value of the maptable
	at_reg[0] <= `SD 6'd0;
	at_reg[1] <= `SD 6'd1;
	at_reg[2] <= `SD 6'd2;
	at_reg[3] <= `SD 6'd3;
	at_reg[4] <= `SD 6'd4;
	at_reg[5] <= `SD 6'd5;
	at_reg[6] <= `SD 6'd6;
	at_reg[7] <= `SD 6'd7;
	at_reg[8] <= `SD 6'd8;
	at_reg[9] <= `SD 6'd9;
	at_reg[10] <= `SD 6'd10;
	at_reg[11] <= `SD 6'd11;
	at_reg[12] <= `SD 6'd12;
	at_reg[13] <= `SD 6'd13;
	at_reg[14] <= `SD 6'd14;
	at_reg[15] <= `SD 6'd15;
	at_reg[16] <= `SD 6'd16;
	at_reg[17] <= `SD 6'd17;
	at_reg[18] <= `SD 6'd18;
	at_reg[19] <= `SD 6'd19;
	at_reg[20] <= `SD 6'd20;
	at_reg[21] <= `SD 6'd21;
	at_reg[22] <= `SD 6'd22;
	at_reg[23] <= `SD 6'd23;
	at_reg[24] <= `SD 6'd24;
	at_reg[25] <= `SD 6'd25;
	at_reg[26] <= `SD 6'd26;
	at_reg[27] <= `SD 6'd27;
	at_reg[28] <= `SD 6'd28;
	at_reg[29] <= `SD 6'd29;
	at_reg[30] <= `SD 6'd30;
	at_reg[31] <= `SD 6'd31;
	end

	else
	begin 
	at_reg[0] <= `SD next_at_reg[0];
	at_reg[1] <= `SD next_at_reg[1];
	at_reg[2] <= `SD next_at_reg[2];
	at_reg[3] <= `SD next_at_reg[3];
	at_reg[4] <= `SD next_at_reg[4];
	at_reg[5] <= `SD next_at_reg[5];
	at_reg[6] <= `SD next_at_reg[6];
	at_reg[7] <= `SD next_at_reg[7];
	at_reg[8] <= `SD next_at_reg[8];
	at_reg[9] <= `SD next_at_reg[9];
	at_reg[10] <= `SD next_at_reg[10];
	at_reg[11] <= `SD next_at_reg[11];
	at_reg[12] <= `SD next_at_reg[12];
	at_reg[13] <= `SD next_at_reg[13];
	at_reg[14] <= `SD next_at_reg[14];
	at_reg[15] <= `SD next_at_reg[15];
	at_reg[16] <= `SD next_at_reg[16];
	at_reg[17] <= `SD next_at_reg[17];
	at_reg[18] <= `SD next_at_reg[18];
	at_reg[19] <= `SD next_at_reg[19];
	at_reg[20] <= `SD next_at_reg[20];
	at_reg[21] <= `SD next_at_reg[21];
	at_reg[22] <= `SD next_at_reg[22];
	at_reg[23] <= `SD next_at_reg[23];
	at_reg[24] <= `SD next_at_reg[24];
	at_reg[25] <= `SD next_at_reg[25];
	at_reg[26] <= `SD next_at_reg[26];
	at_reg[27] <= `SD next_at_reg[27];
	at_reg[28] <= `SD next_at_reg[28];
	at_reg[29] <= `SD next_at_reg[29];
	at_reg[30] <= `SD next_at_reg[30];
	at_reg[31] <= `SD next_at_reg[31];
	end
end
endmodule
