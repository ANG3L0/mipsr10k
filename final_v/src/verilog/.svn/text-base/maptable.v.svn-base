`define CDBWIDTH        6
module maptable(
	//inputs
	clock,
	reset,
	id_destAidx,
	id_destBidx,
	id_valid_IRA,
        id_valid_IRB,	
	mt_indexA,
	mt_indexB,
        mt_indexC,
        mt_indexD,
	CDBvalueA,
	CDBvalueB,
        CDBvalueC,
        CDBvalueD,
	broadcastA,
	broadcastB,
        broadcastC,
        broadcastD,
	id_rdaAidx,  
	id_rdbAidx,  
	id_rdaBidx, 
	id_rdbBidx,  
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
	archtable_copy_31,
	recovery_en,
	//TODO: arch map port -> map table for recovery (32x6 bits?)
	fl_prNumA,
	fl_prNumB,
	//TODO: how to recover? (reversal from ROB or copy/paste from arch
	//map?)

	//outputs
	mt_ToldA_out,		
	mt_ToldB_out,	
	mt_T1A_out,	
	mt_T1B_out,	
	mt_T2A_out,	
	mt_T2B_out	
);
//inputs 
input clock;
input reset;
//input enableA; // enable bit to tell whether to update the maptable for the first instruction
//input enableB;
input        id_valid_IRA;
input        id_valid_IRB;

input  [4:0] id_destAidx; //logical register index (e.g. r1, r2, etc.)
input  [4:0] id_destBidx; //logical register index (e.g. r1, r2, etc.) for superscalar
input  [4:0] id_rdaAidx;  //logical register index for opa
input  [4:0] id_rdbAidx;  //logical register index for opb
input  [4:0] id_rdaBidx; 
input  [4:0] id_rdbBidx;  

/*/TODO: ASSIGN CDBWIDTH (6)
input  [11:0]	cm_cdbAIdx; //CDB outputs index after complete,CDB = {Broadcast_enable,PHYSICAL REGISTER, index of maptable}
input  [11:0]	cm_cdbBIdx; //CDB outputs index after complete
*/
///   from CDB   modified   ///////////////////////
input   [4:0] mt_indexA; //set the bit // the maptable index(logical register number) from CDB
input   [4:0] mt_indexB; //set the bit
input   [4:0] mt_indexC;
input   [4:0] mt_indexD;

input   [5:0] CDBvalueA; //the PR# from CDB
input   [5:0] CDBvalueB;
input   [5:0] CDBvalueC;
input   [5:0] CDBvalueD;


input         broadcastA; //whether broadcast or not
input         broadcastB; 
input         broadcastC;
input         broadcastD;


input  [`CDBWIDTH-1:0]	fl_prNumA; //Physical register number from freelist
input  [`CDBWIDTH-1:0]	fl_prNumB; //Physical register number from freelist (superscalar)

input  	[5:0]	archtable_copy_0;
input  	[5:0]	archtable_copy_1;
input  	[5:0]	archtable_copy_2;
input  	[5:0]	archtable_copy_3;
input  	[5:0]	archtable_copy_4;
input  	[5:0]	archtable_copy_5;
input  	[5:0]	archtable_copy_6;
input  	[5:0]	archtable_copy_7;
input  	[5:0]	archtable_copy_8;
input  	[5:0]	archtable_copy_9;
input  	[5:0]	archtable_copy_10;
input  	[5:0]	archtable_copy_11;
input  	[5:0]	archtable_copy_12;
input  	[5:0]	archtable_copy_13;
input  	[5:0]	archtable_copy_14;
input  	[5:0]	archtable_copy_15;
input  	[5:0]	archtable_copy_16;
input  	[5:0]	archtable_copy_17;
input  	[5:0]	archtable_copy_18;
input  	[5:0]	archtable_copy_19;
input  	[5:0]	archtable_copy_20;
input  	[5:0]	archtable_copy_21;
input  	[5:0]	archtable_copy_22;
input  	[5:0]	archtable_copy_23;
input  	[5:0]	archtable_copy_24;
input  	[5:0]	archtable_copy_25;
input  	[5:0]	archtable_copy_26;
input  	[5:0]	archtable_copy_27;
input  	[5:0]	archtable_copy_28;
input  	[5:0]	archtable_copy_29;
input  	[5:0]	archtable_copy_30;
input  	[5:0]	archtable_copy_31;
input  		recovery_en;

//output
output [`CDBWIDTH-1:0]	mt_ToldA_out; //Output to ROB so it can update its TOld value
output [`CDBWIDTH-1:0]	mt_ToldB_out; //Output to ROB so it can update its TOld value

output [`CDBWIDTH:0]	mt_T1A_out; //Physical register numbers to reservation station
output [`CDBWIDTH:0]	mt_T1B_out; //including plus bit (thus CDBWIDTH and not CDBWIDTH-1)
output [`CDBWIDTH:0]	mt_T2A_out;	
output [`CDBWIDTH:0]	mt_T2B_out;

reg    [`CDBWIDTH:0] 	next_mt_regA_CDB;
reg    [`CDBWIDTH:0] 	next_mt_regB_CDB;
reg    [`CDBWIDTH:0]    next_mt_regC_CDB;
reg    [`CDBWIDTH:0]    next_mt_regD_CDB;

reg    [`CDBWIDTH:0]    mt_reg[31:0]; //32,7-bit maptable,the least significant bit is the ready bit,(thus CDBWIDTH and not CDBWIDTH-1)


/*
wire   [4:0] mt_indexA = cm_cdbAIdx[4:0]; //set the bit // the maptable index(logical register number) from CDB
wire   [4:0] mt_indexB = cm_cdbBIdx[4:0]; //set the bit
wire   [5:0] CDBvalueA = cm_cdbAIdx[10:5]; //the PR# from CDB
wire   [5:0] CDBvalueB = cm_cdbBIdx[10:5];
wire         broadcastA = cm_cdbAIdx[11]; //whether broadcast or not
wire         broadcastB = cm_cdbBIdx[11];
*/
wire  [`CDBWIDTH:0]	update_valueA;	
wire  [`CDBWIDTH:0]	update_valueB;	

wire                    enableA;
wire                    enableB;

wire                    hitA_A;
wire			hitA_B;
wire			hitA_C;
wire			hitA_D;
wire			changeA;

wire                    hitB_A;
wire			hitB_B;
wire			hitB_C;
wire			hitB_D;
wire			changeB;

///////////////////////////////////////////////////////////////////////
//                                                                   //
//                             Dispatch                              //
//                                                                   //
///////////////////////////////////////////////////////////////////////

////Lulu Ji///////////////////11/10/2012/////////////////////////////////

////////////////Renew Maptable/////////////////////////////////////////////////
assign enableA = (id_destAidx == `ZERO_REG_5)? 1'b0:1'b1; //STORE and R31
assign enableB = (id_destBidx == `ZERO_REG_5)? 1'b0:1'b1;

assign hitA_A = broadcastA & (id_destAidx == mt_indexA)& (mt_reg[mt_indexA][`CDBWIDTH:1] == CDBvalueA);
assign hitA_B = broadcastB & (id_destAidx == mt_indexB)& (mt_reg[mt_indexB][`CDBWIDTH:1] == CDBvalueB);
assign hitA_C = broadcastC & (id_destAidx == mt_indexC)& (mt_reg[mt_indexC][`CDBWIDTH:1] == CDBvalueC);
assign hitA_D = broadcastD & (id_destAidx == mt_indexD)& (mt_reg[mt_indexD][`CDBWIDTH:1] == CDBvalueD); 
assign changeA = hitA_A | hitA_B | hitA_C | hitA_D;

assign hitB_A = broadcastA & (id_destBidx == mt_indexA)& (mt_reg[mt_indexA][`CDBWIDTH:1] == CDBvalueA);
assign hitB_B = broadcastB & (id_destBidx == mt_indexB)& (mt_reg[mt_indexB][`CDBWIDTH:1] == CDBvalueB);
assign hitB_C = broadcastC & (id_destBidx == mt_indexC)& (mt_reg[mt_indexC][`CDBWIDTH:1] == CDBvalueC);
assign hitB_D = broadcastD & (id_destBidx == mt_indexD)& (mt_reg[mt_indexD][`CDBWIDTH:1] == CDBvalueD); 

assign changeB = hitB_A | hitB_B | hitB_C | hitB_D;

assign update_valueA = id_valid_IRA ? (enableA ? {fl_prNumA,1'd0} : mt_reg[id_destAidx]) : changeA? {mt_reg[id_destAidx][`CDBWIDTH:1],1'b1} : mt_reg[id_destAidx] ;//update dest value with ready 0 
assign update_valueB = ( id_valid_IRA && id_valid_IRB ) ? 
                        (enableB ? {fl_prNumB,1'd0} :mt_reg[id_destBidx]) : changeB? {mt_reg[id_destBidx][`CDBWIDTH:1],1'b1} : mt_reg[id_destBidx];


//assign update_valueA = id_valid_IRA ? (enableA ? {fl_prNumA,1'd0} : mt_reg[id_destAidx]) : mt_reg[id_destAidx] ;//update
//assign update_valueB = ( id_valid_IRA && id_valid_IRB ) ? 
//                        (enableB ? {fl_prNumB,1'd0} :mt_reg[id_destBidx]) : mt_reg[id_destBidx];




//Pass T1,T2 to RS, be careful that this value may not be valid since ra_idx,
//rb_idx may not be valid
assign	mt_T1A_out = mt_reg[id_rdaAidx]; 
assign	mt_T2A_out = mt_reg[id_rdbAidx]; 

///Lulu Ji////////////////11/10/2012//////////////////////////////////////////
////////////////Data Dependancy//////////////////////////////////////////////
assign	mt_T1B_out = (id_destAidx == id_rdaBidx)?update_valueA: mt_reg[id_rdaBidx]; 
assign	mt_T2B_out = (id_destAidx == id_rdbBidx)?update_valueA: mt_reg[id_rdbBidx];


assign  mt_ToldA_out = mt_reg[id_destAidx][`CDBWIDTH:1];
assign  mt_ToldB_out = (id_destAidx == id_destBidx)? update_valueA[`CDBWIDTH:1]:mt_reg[id_destBidx][`CDBWIDTH:1]; //If the first instruction dest and second instruction dest is same, the ToldB = TA

//assign  mt_ToldA_out = enableA ? mt_reg[id_destAidx][`CDBWIDTH:1]: 0;
//assign  mt_ToldB_out = enableB ? mt_reg[id_destBidx][`CDBWIDTH:1]: 0;

//Set the ready bit in the complete stage

/*always @*
begin
	next_mt_regA_CDB = mt_reg[mt_indexA];
        next_mt_regB_CDB = mt_reg[mt_indexB];
        next_mt_regC_CDB = mt_reg[mt_indexC];
        next_mt_regD_CDB = mt_reg[mt_indexD];
	
//////////////////////////////////////////////////////////////
//                                                          //
//                      Complete                            //
//                                                          //
//////////////////////////////////////////////////////////////
//	next_mt_regA_CDB = {mt_reg[mt_indexA][`CDBWIDTH:1],1'b0};
	if(broadcastA)
		begin
			if (mt_reg[mt_indexA][`CDBWIDTH:1] == CDBvalueA)//Check to see if PR# is the same since the logical register may be overwritten by other instruction
						   next_mt_regA_CDB[0] = 1'b1;
		end

        if (broadcastB)
                begin
                if (mt_reg[mt_indexB][`CDBWIDTH:1] == CDBvalueB)
                           next_mt_regB_CDB[0] = 1'b1;
                end 

        if (broadcastC)
                begin
                if (mt_reg[mt_indexC][`CDBWIDTH:1] == CDBvalueC)
                           next_mt_regC_CDB[0] = 1'b1;
                end

        if (broadcastD)
                begin
                if (mt_reg[mt_indexD][`CDBWIDTH:1] == CDBvalueD)
                           next_mt_regD_CDB[0] = 1'b1;
                end
 end 
*/
// Map table update, pass Told to ROB
always @(posedge clock)
begin
	if (reset)
	begin
	// set the initial value of the maptable
	mt_reg[0] <= `SD {6'd0,1'd1};
	mt_reg[1] <= `SD {6'd1,1'd1};
	mt_reg[2] <= `SD {6'd2,1'd1};
	mt_reg[3] <= `SD {6'd3,1'd1};
	mt_reg[4] <= `SD {6'd4,1'd1};
	mt_reg[5] <= `SD {6'd5,1'd1};
	mt_reg[6] <= `SD {6'd6,1'd1};
	mt_reg[7] <= `SD {6'd7,1'd1};
	mt_reg[8] <= `SD {6'd8,1'd1};
	mt_reg[9] <= `SD {6'd9,1'd1};
	mt_reg[10] <= `SD {6'd10,1'd1};
	mt_reg[11] <= `SD {6'd11,1'd1};
	mt_reg[12] <= `SD {6'd12,1'd1};
	mt_reg[13] <= `SD {6'd13,1'd1};
	mt_reg[14] <= `SD {6'd14,1'd1};
	mt_reg[15] <= `SD {6'd15,1'd1};
	mt_reg[16] <= `SD {6'd16,1'd1};
	mt_reg[17] <= `SD {6'd17,1'd1};
	mt_reg[18] <= `SD {6'd18,1'd1};
	mt_reg[19] <= `SD {6'd19,1'd1};
	mt_reg[20] <= `SD {6'd20,1'd1};
	mt_reg[21] <= `SD {6'd21,1'd1};
	mt_reg[22] <= `SD {6'd22,1'd1};
	mt_reg[23] <= `SD {6'd23,1'd1};
	mt_reg[24] <= `SD {6'd24,1'd1};
	mt_reg[25] <= `SD {6'd25,1'd1};
	mt_reg[26] <= `SD {6'd26,1'd1};
	mt_reg[27] <= `SD {6'd27,1'd1};
	mt_reg[28] <= `SD {6'd28,1'd1};
	mt_reg[29] <= `SD {6'd29,1'd1};
	mt_reg[30] <= `SD {6'd30,1'd1};
	mt_reg[31] <= `SD {6'd31,1'd1};

	end
	else if (recovery_en)
	begin
	mt_reg[0] <= `SD {archtable_copy_0,1'd1};
	mt_reg[1] <= `SD {archtable_copy_1,1'd1};
	mt_reg[2] <= `SD {archtable_copy_2,1'd1};
	mt_reg[3] <= `SD {archtable_copy_3,1'd1};
	mt_reg[4] <= `SD {archtable_copy_4,1'd1};
	mt_reg[5] <= `SD {archtable_copy_5,1'd1};
	mt_reg[6] <= `SD {archtable_copy_6,1'd1};
	mt_reg[7] <= `SD {archtable_copy_7,1'd1};
	mt_reg[8] <= `SD {archtable_copy_8,1'd1};
	mt_reg[9] <= `SD {archtable_copy_9,1'd1};
	mt_reg[10] <= `SD {archtable_copy_10,1'd1};
	mt_reg[11] <= `SD {archtable_copy_11,1'd1};
	mt_reg[12] <= `SD {archtable_copy_12,1'd1};
	mt_reg[13] <= `SD {archtable_copy_13,1'd1};
	mt_reg[14] <= `SD {archtable_copy_14,1'd1};
	mt_reg[15] <= `SD {archtable_copy_15,1'd1};
	mt_reg[16] <= `SD {archtable_copy_16,1'd1};
	mt_reg[17] <= `SD {archtable_copy_17,1'd1};
	mt_reg[18] <= `SD {archtable_copy_18,1'd1};
	mt_reg[19] <= `SD {archtable_copy_19,1'd1};
	mt_reg[20] <= `SD {archtable_copy_20,1'd1};
	mt_reg[21] <= `SD {archtable_copy_21,1'd1};
	mt_reg[22] <= `SD {archtable_copy_22,1'd1};
	mt_reg[23] <= `SD {archtable_copy_23,1'd1};
	mt_reg[24] <= `SD {archtable_copy_24,1'd1};
	mt_reg[25] <= `SD {archtable_copy_25,1'd1};
	mt_reg[26] <= `SD {archtable_copy_26,1'd1};
	mt_reg[27] <= `SD {archtable_copy_27,1'd1};
	mt_reg[28] <= `SD {archtable_copy_28,1'd1};
	mt_reg[29] <= `SD {archtable_copy_29,1'd1};
	mt_reg[30] <= `SD {archtable_copy_30,1'd1};
	mt_reg[31] <= `SD {archtable_copy_31,1'd1};
	
	end
	else
	begin 

		if(broadcastA)
				begin
				if (mt_reg[mt_indexA][`CDBWIDTH:1] == CDBvalueA)//Check to see if PR# is the same since the logical register may be overwritten by other instruction
						   mt_reg[mt_indexA][0] <= 1'b1;
				end

        if (broadcastB)
                begin
                if (mt_reg[mt_indexB][`CDBWIDTH:1] == CDBvalueB)
                           mt_reg[mt_indexB][0] <= 1'b1;
                end 

        if (broadcastC)
                begin
                if (mt_reg[mt_indexC][`CDBWIDTH:1] == CDBvalueC)
                           mt_reg[mt_indexC][0] <= 1'b1;
                end

        if (broadcastD)
                begin
                if (mt_reg[mt_indexD][`CDBWIDTH:1] == CDBvalueD)
                           mt_reg[mt_indexD][0] <= 1'b1;
                end


	/*
           if(broadcastA)
		mt_reg[mt_indexA] <= `SD next_mt_regA_CDB;
           if(broadcastB)
		mt_reg[mt_indexB] <= `SD next_mt_regB_CDB;
           if(broadcastC)
                mt_reg[mt_indexC] <= `SD next_mt_regC_CDB;
           if(broadcastD)
                mt_reg[mt_indexD] <= `SD next_mt_regD_CDB;
     */         
		mt_reg[id_destAidx] <=  `SD update_valueA; // Allocate new preg from freelist to id_destAidx, set the ready bit to be 0
		mt_reg[id_destBidx] <=  `SD update_valueB;
	end
end	
endmodule
