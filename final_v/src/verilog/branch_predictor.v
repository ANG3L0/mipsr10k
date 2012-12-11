`define SD #1
`define BHRWIDTH	4
`define PHTSIZE		16


module branch_predictor(
				//input
				clock,
				reset,
				need_take_branchA,
				need_take_branchB,
				mispredict_branchA,
				mispredict_branchB,
				branch_PCA,
				branch_PCB,
				branch_target_PCA,
				branch_target_PCB,
				inst_PCA,
				inst_PCB,
				branch_PHT_idxA,
				branch_PHT_idxB,
				previous_true_resultA,
				previous_true_resultB,
				previous_predict_resultA,
			        previous_predict_resultB,
				Gshare_update_enA,			
  				Gshare_update_enB,						

// for branch recovery
				recover_BHR_A,
				recover_BHR_B,
				rob_recover,

				//output
				predicted_PCA,
				predicted_PCB,
				branch_predictionA,
				branch_predictionB,
				predicted_PHT_idxA,
				predicted_PHT_idxB,
// for branch recovery
				global_BHR_A,
				global_BHR_B
		       );



//////////////////////////////////////////////////////////////////////////
//                                                                      //
//                              inputs                                  //
//                                                                      //
//////////////////////////////////////////////////////////////////////////
//
  input			clock;
  input			reset;

// signal need for update BTB and pattern history table
  input	 [63:0]			branch_target_PCA;  		// ex_alu_result
  input	 [63:0]			branch_target_PCB;
  input  [63:0] 		branch_PCA;         		// PC address of checked branch
  input  [63:0] 		branch_PCB;
  input 			need_take_branchA;  		// a)predict not take, but take.b)predict take, actually take, but the target address is wrong
  input 			need_take_branchB;
  input 			mispredict_branchA; 		// predict take, but not take
  input 			mispredict_branchB; 	
  input	 [`BHRWIDTH-1:0]  	branch_PHT_idxA;    		// the index of the pattern history table of checked branch	
  input  [`BHRWIDTH-1:0] 	branch_PHT_idxB;
  input				previous_true_resultA; 		// the true result of checked branch
  input				previous_true_resultB;
  input				previous_predict_resultA;	// the predict result of checked branch
  input				previous_predict_resultB;
  input				Gshare_update_enA;			// is a branch
  input				Gshare_update_enB;			// is a branch

// signal of the instruction need to be predicted in the fetch stage
  input	 [63:0]			inst_PCA;
  input	 [63:0]			inst_PCB;
  input  [`BHRWIDTH-1:0]	recover_BHR_A;
  input  [`BHRWIDTH-1:0]	recover_BHR_B;
  input				rob_recover;
//////////////////////////////////////////////////////////////////////////
//                                                                      //
//                              outputs                                 //
//                                                                      //
//////////////////////////////////////////////////////////////////////////
//
// the predict result
  output  [63:0] 		predicted_PCA;	
  output  [63:0] 		predicted_PCB;
  output        		branch_predictionA;	
  output        		branch_predictionB;	
  output  [`BHRWIDTH-1:0]	predicted_PHT_idxA;
  output  [`BHRWIDTH-1:0]	predicted_PHT_idxB;
  output reg  [`BHRWIDTH-1:0]	global_BHR_A;
  output reg  [`BHRWIDTH-1:0]	global_BHR_B;

//////////////////////////////////////////////////////////////////////////
//                                                                      //
//                              Gshare                                  //
//                                                                      //
//////////////////////////////////////////////////////////////////////////

  reg  [1:0]			pattern_table [`PHTSIZE-1:0];
  reg  [`BHRWIDTH-1:0]		next_global_BHR_A;
  reg  [`BHRWIDTH-1:0]		next_global_BHR_B;
  wire	 			predictor_resultA;
  wire				predictor_resultB; 
  wire  [1:0]			value_bufferA;  
  wire  [`BHRWIDTH-1:0]	  	global_BHR_shift_one_A;
  wire  [`BHRWIDTH-1:0]   	global_BHR_shift_two_A;
  wire  [`BHRWIDTH-1:0]	  	global_BHR_shift_one_B;
  wire  [`BHRWIDTH-1:0]   	global_BHR_shift_two_B;
  wire  [`BHRWIDTH-1:0]		recover_BHR_shift_one_A;
  wire  [`BHRWIDTH-1:0]		recover_BHR_shift_one_B;
  wire  [`BHRWIDTH-1:0]		update_recover_BHR;
  wire				hitA;
  wire				hitB;  
  wire				mispredictA;
  wire				mispredictB;

//update global_BHR
  assign 	recover_BHR_shift_one_A = recover_BHR_A << 1;
  assign 	recover_BHR_shift_one_B = recover_BHR_B << 1;
  assign 	mispredictA = (previous_true_resultA == previous_predict_resultA) ? 0 : 1;
  assign 	mispredictB = (previous_true_resultB == previous_predict_resultB) ? 0 : 1;  
  assign	predicted_PHT_idxA = global_BHR_A ^ inst_PCA[`BHRWIDTH + 1:2];
  assign	predicted_PHT_idxB = global_BHR_B ^ inst_PCB[`BHRWIDTH + 1:2]; 
  assign	predictor_resultA = pattern_table[predicted_PHT_idxA][1];
  assign	predictor_resultB = pattern_table[predicted_PHT_idxB][1];
  assign	value_bufferA = { predictor_resultA , 1'b0 };
  assign	update_recover_BHR = mispredictA ? (recover_BHR_shift_one_A + previous_true_resultA) : mispredictB ? (recover_BHR_shift_one_B + previous_true_resultB) : global_BHR_A; // recover BHR with right value
  assign 	global_BHR_shift_one_A = global_BHR_A << 1;
  assign 	global_BHR_shift_two_A = global_BHR_A << 2;
  assign	global_BHR_shift_one_B = global_BHR_B << 1;
  assign	global_BHR_shift_two_B = global_BHR_B << 2;


// update global_BHR corresponds to the correct value when there is no rob recovery    
  always @*
  begin
		next_global_BHR_A = global_BHR_A;
		next_global_BHR_B = global_BHR_B;

			if (hitA && hitB)// both of the inst is branch
			begin
				next_global_BHR_A =  global_BHR_shift_one_B + predictor_resultA;
				next_global_BHR_B =  global_BHR_shift_two_B + value_bufferA + predictor_resultB;
				//global_BHR[3] <= `SD previous_true_resultB;
				//global_BHR[2] <= `SD previous_true_resultA;
				//global_BHR[1] <= `SD global_BHR[3];
				//global_BHR[0] <= `SD global_BHR[2];
			end 
			else if (hitA && !hitB)
			begin
				next_global_BHR_A =  global_BHR_shift_one_B + predictor_resultA;
				next_global_BHR_B =  global_BHR_shift_one_B + predictor_resultA;

				//global_BHR[3] <= `SD previous_true_resultA;
				//global_BHR[2] <= `SD global_BHR[3];
				//global_BHR[1] <= `SD global_BHR[2];
				//global_BHR[0] <= `SD global_BHR[1];
			end
			else if (!hitA && hitB)
			begin
				next_global_BHR_A =  global_BHR_shift_one_B + predictor_resultB;
				next_global_BHR_B =  global_BHR_shift_one_B + predictor_resultB;

				//global_BHR[3] <= `SD previous_true_resultB;
				//global_BHR[2] <= `SD global_BHR[3];
				//global_BHR[1] <= `SD global_BHR[2];
				//global_BHR[0] <= `SD global_BHR[1];
			end	
		
  end 
 
  always @(posedge clock)
  begin
		if (reset)
			global_BHR_A <= `SD `BHRWIDTH'd0;
		else if (rob_recover)
			global_BHR_A <= `SD update_recover_BHR;
		else 
			global_BHR_A <= `SD next_global_BHR_A;


		if (reset)
			global_BHR_B <= `SD `BHRWIDTH'd0;
		else if (rob_recover)
			global_BHR_B <= `SD update_recover_BHR;
		else 
			global_BHR_B <= `SD next_global_BHR_B;			
  end





/*************************************************/
//Pattern history table:
// N:00, n:01, t:10 , T:11

  reg [1:0]	next_PHT_valueA;
  reg [1:0]	next_PHT_valueB;

  always @*
  begin
		next_PHT_valueA = pattern_table[branch_PHT_idxA];

		// predict = 0, actual = 1
		if(!previous_predict_resultA && previous_true_resultA && Gshare_update_enA) 
		begin
			next_PHT_valueA = pattern_table[branch_PHT_idxA] + 1;
		end

		// predict = 1, actual = 0
		else if(previous_predict_resultA && !previous_true_resultA && Gshare_update_enA ) 
		begin   
			next_PHT_valueA = pattern_table[branch_PHT_idxA] - 1;
		end

		// predict = 1, actual = 1
		else if(previous_true_resultA && previous_predict_resultA && Gshare_update_enA) 
		begin
			if (pattern_table[branch_PHT_idxA] == 2'b10) 
			begin
				next_PHT_valueA = pattern_table[branch_PHT_idxA] + 1;
			end 
		end

		// predict = 0, actual = 0
		else if(!previous_true_resultA && !previous_predict_resultA && Gshare_update_enA)
		begin
			if (pattern_table[branch_PHT_idxA] == 2'b01) 
			begin
				next_PHT_valueA = pattern_table[branch_PHT_idxA] - 1;
			end 
		end	
  end
  

  always @*
  begin
		next_PHT_valueB = pattern_table[branch_PHT_idxB];

		// predict = 0, actual = 1
		if(!previous_predict_resultB && previous_true_resultB && Gshare_update_enB) 
		begin
			next_PHT_valueB = pattern_table[branch_PHT_idxB] + 1;
		end

		// predict = 1, actual = 0
		else if(previous_predict_resultB && !previous_true_resultB && Gshare_update_enB) 
		begin   
			next_PHT_valueB = pattern_table[branch_PHT_idxB] - 1;
		end

		// predict = 1, actual = 1
		else if(previous_true_resultB && previous_predict_resultB && Gshare_update_enB) 

		begin
			if (pattern_table[branch_PHT_idxB] == 2'b10) 
			begin
				next_PHT_valueB = pattern_table[branch_PHT_idxB] + 1;
			end 
		end

		// predict = 0, actual = 0
		else if(!previous_true_resultB && !previous_predict_resultB && Gshare_update_enB)
		begin
			if (pattern_table[branch_PHT_idxB] == 2'b01) 
			begin
				next_PHT_valueB = pattern_table[branch_PHT_idxB] - 1;
			end 
		end	
  end
  

  reg [`BHRWIDTH : 0]	i;

  always @(posedge clock)
  begin
	if (reset)
	begin

		for (i= 0 ; i < `PHTSIZE ; i = i + 1)
		begin
			pattern_table[i] <= `SD 2'd0;
		end

	end

	else
	begin
		pattern_table[branch_PHT_idxA] <= `SD next_PHT_valueA; 
		pattern_table[branch_PHT_idxB] <= `SD next_PHT_valueB; 
	end
  end
/*************************************************/

//////////////////////////////////////////////////////////////////////////
//                                                                      //
//                              predict result                          //
//                                                                      //
//////////////////////////////////////////////////////////////////////////
//
//
BTB BTB_1 (		
		.clock(clock), 
		.reset(reset), 
		.wr0_en(need_take_branchA), 
		.wr1_en(need_take_branchB), 
		.wr_PCA_tag(branch_PCA[63:6]),
		.wr_PCB_tag(branch_PCB[63:6]), 
		.wr_PCA_idx(branch_PCA[5:2]),
		.wr_PCB_idx(branch_PCB[5:2]), 
		.wr_PCA_data(branch_target_PCA),
                .wr_PCB_data(branch_target_PCB),
		.rd_PCA_tag(inst_PCA[63:6]),
	        .rd_PCB_tag(inst_PCB[63:6]),
		.rd_PCA_idx(inst_PCA[5:2]),
		.rd_PCB_idx(inst_PCB[5:2]), 
		.target_PCA(predicted_PCA),
		.target_PCB(predicted_PCB),
		.hitA(hitA),
		.hitB(hitB)
	    );


  assign	branch_predictionA = hitA & predictor_resultA; // Gshare predict take and hit in BTB
  assign	branch_predictionB = hitB & predictor_resultB;




endmodule





// For this type of BTB, do not need to delete the entry if mispredicted

module BTB(
			clock, 
			reset, 
			wr0_en, 
			wr1_en, 
			wr_PCA_tag,
			wr_PCB_tag, 
			wr_PCA_idx,
			wr_PCB_idx, 
			wr_PCA_data,
                        wr_PCB_data,
			rd_PCA_tag,
	                rd_PCB_tag,
			rd_PCA_idx,
			rd_PCB_idx, 

//output
			target_PCA,
			target_PCB,
			hitA,
			hitB);
//16 lines, 64 bit data (PC address)
// 2 bit byte offset, 4 bit index (16), 58 bit tag

input clock;
input reset;
input wr0_en;
input wr1_en;
input [3:0] wr_PCA_idx;
input [3:0] rd_PCA_idx;
input [57:0] wr_PCA_tag;
input [57:0] rd_PCA_tag; //current PC address
input [63:0] wr_PCA_data; //
input [3:0] wr_PCB_idx;
input [3:0] rd_PCB_idx;
input [57:0] wr_PCB_tag;
input [57:0] rd_PCB_tag;
input [63:0] wr_PCB_data; 


output [63:0] target_PCA; // data read from the cache
output [63:0] target_PCB; // data read from the cache
output hitA; //hit!
output hitB; //hit!


reg [63:0] data [15:0];
reg [57:0] tags [15:0]; 
reg [15:0] valids;

assign target_PCA = data[rd_PCA_idx];
assign target_PCB = data[rd_PCB_idx];
assign hitA = valids[rd_PCA_idx] && (tags[rd_PCA_idx] == rd_PCA_tag);
assign hitB = valids[rd_PCB_idx] && (tags[rd_PCB_idx] == rd_PCB_tag);// there is data in this line and the tag matches (hit!)


always @(posedge clock)
begin
  if(reset) valids <= `SD 16'b0;
  else 
    begin
	if (wr0_en) 
    		valids[wr_PCA_idx] <= `SD 1; //this line is modified, set the valid bit to be one
	if (wr1_en)
    		valids[wr_PCB_idx] <= `SD 1; 
    end
end


always @(posedge clock)
begin
  if(wr0_en && !((wr_PCA_idx == wr_PCB_idx) && wr1_en) ) // will not write at the same time
  begin
    data[wr_PCA_idx] <= `SD wr_PCA_data;
    tags[wr_PCA_idx] <= `SD wr_PCA_tag;
  end
	
  if(wr1_en)
  begin
    data[wr_PCB_idx] <= `SD wr_PCB_data;
    tags[wr_PCB_idx] <= `SD wr_PCB_tag;
  end
end

endmodule

