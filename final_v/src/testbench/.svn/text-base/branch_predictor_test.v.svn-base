`timescale 1ns/100ps
module testbench;
///////// INPUTS //////////
reg 		clock;
reg		reset;
reg		Gshare_update_enA;
reg		Gshare_update_enB;
reg	[63:0]	branch_PCA;
reg	[63:0]	branch_PCB;
reg	[3:0]	branch_PHT_idxA;
reg	[3:0]	branch_PHT_idxB;
reg	[63:0]	branch_target_PCA;
reg	[63:0]	branch_target_PCB;
reg	[63:0]	inst_PCA;
reg	[63:0]	inst_PCB;
reg		mispredict_branchA;
reg		mispredict_branchB;
reg		need_take_branchA;
reg		need_take_branchB;
reg		previous_predict_resultA;
reg		previous_predict_resultB;
reg		previous_true_resultA;
reg		previous_true_resultB;

///////// OUTPUTS //////////
wire		branch_predictionA;
wire		branch_predictionB;
wire	[63:0]	predicted_PCA;
wire	[63:0]	predicted_PCB;
wire	[3:0]	predicted_PHT_idxA;
wire	[3:0]	predicted_PHT_idxB;



branch_predictor   branch_predictor_0(
	//input ports
	.clock(clock),
	.reset(reset),
	.Gshare_update_enA(Gshare_update_enA),
	.Gshare_update_enB(Gshare_update_enB),
	.branch_PCA(branch_PCA),
	.branch_PCB(branch_PCB),
	.branch_PHT_idxA(branch_PHT_idxA),
	.branch_PHT_idxB(branch_PHT_idxB),
	.branch_target_PCA(branch_target_PCA),
	.branch_target_PCB(branch_target_PCB),
	.inst_PCA(inst_PCA),
	.inst_PCB(inst_PCB),
	.mispredict_branchA(mispredict_branchA),
	.mispredict_branchB(mispredict_branchB),
	.need_take_branchA(need_take_branchA),
	.need_take_branchB(need_take_branchB),
	.previous_predict_resultA(previous_predict_resultA),
	.previous_predict_resultB(previous_predict_resultB),
	.previous_true_resultA(previous_true_resultA),
	.previous_true_resultB(previous_true_resultB),
	
	//output ports
	.branch_predictionA(branch_predictionA),
	.branch_predictionB(branch_predictionB),
	.predicted_PCA(predicted_PCA),
	.predicted_PCB(predicted_PCB),
	.predicted_PHT_idxA(predicted_PHT_idxA),
	.predicted_PHT_idxB(predicted_PHT_idxB)
);





always
	begin
	#(`VERILOG_CLOCK_PERIOD/2);
	clock=~clock;
end

reg [4:0] i;

always @(posedge clock)
begin
#1

`ifdef DEBUG_OUT

  $display("==========================================================================================================");
  $display("|  \t \t  tag \t \t \t \t| \t  data \t \t \t \t | \t valid \t |\n\
==========================================================================================================");
  for (i=0;i<16;i=i+1) begin
    $display("| \t \t %58h \t \t| \t %64h \t  \t| \t %1b \t |",
        branch_predictor_0.BTB_1.tags[i], branch_predictor_0.BTB_1.data[i], branch_predictor_0.BTB_1.valids[i]);    
  end
  $display("==========================================================================================================\n");
  $display(" Global BHR is %4b , next Global BHR is %4b , predicted_PHT_idxA is %4b, predicted_PHT_idxB is %4b, predictor_resultA is %1b, predictor_resultB is %1b \n", branch_predictor_0.global_BHR,branch_predictor_0.next_global_BHR,branch_predictor_0.predicted_PHT_idxA, branch_predictor_0.predicted_PHT_idxB , branch_predictor_0.predictor_resultA, branch_predictor_0.predictor_resultB);
  $display("===================================");
  $display("| \t index \t | \t valid \t |\n\
===================================");
  for (i=0;i<16;i=i+1) begin
    $display("| \t  %2d  \t | \t %2b \t |",
        i, branch_predictor_0.pattern_table[i]);    
  end
  $display("===================================\n");
`endif
end




initial
begin
clock=0;
reset=1;
Gshare_update_enA=0;
Gshare_update_enB=0;
branch_PCA=0;
branch_PCB=0;
branch_PHT_idxA=0;
branch_PHT_idxB=0;
branch_target_PCA=0;
branch_target_PCB=0;
inst_PCA=0;
inst_PCB=0;
mispredict_branchA=0;
mispredict_branchB=0;
need_take_branchA=0;
need_take_branchB=0;
previous_predict_resultA=0;
previous_predict_resultB=0;
previous_true_resultA=0;
previous_true_resultB=0;

//test the update of the global_BHR

@(negedge clock)  //end of clock 0 
reset=0;
Gshare_update_enA=1;
Gshare_update_enB=0;
branch_PCA=0;
branch_PCB=0;
branch_PHT_idxA=0;
branch_PHT_idxB=0;
branch_target_PCA=0;
branch_target_PCB=0;
inst_PCA=0;
inst_PCB=0;
mispredict_branchA=0;
mispredict_branchB=0;
need_take_branchA=0;
need_take_branchB=0;
previous_predict_resultA=0;
previous_predict_resultB=0;
previous_true_resultA=1;
previous_true_resultB=0;
$display (" test the update of the global_BHR");
$display (" the first instruction is branch and taken");

// the first instruction is branch and not taken
@(negedge clock)  //end of clock 1 
Gshare_update_enA=1;
Gshare_update_enB=0;
branch_PCA=0;
branch_PCB=0;
branch_PHT_idxA=0;
branch_PHT_idxB=0;
branch_target_PCA=0;
branch_target_PCB=0;
inst_PCA=0;
inst_PCB=0;
mispredict_branchA=0;
mispredict_branchB=0;
need_take_branchA=0;
need_take_branchB=0;
previous_predict_resultA=0;
previous_predict_resultB=0;
previous_true_resultA=0;
previous_true_resultB=0;
$display (" the first instruction is branch and not taken");

// the two instruction is branch and both take
@(negedge clock)  //end of clock 1 
Gshare_update_enA=1;
Gshare_update_enB=1;
branch_PCA=64'b100_0001_00;//64'h104
//branch_PCB=64'b1100_0010_00;
branch_PCB=64'h0;
branch_PHT_idxA=4'b1111;
branch_PHT_idxB=4'd3;
branch_target_PCA=64'h1111_1111_2222_2222;
branch_target_PCB=64'h2222_2222_3333_3333;
inst_PCA=0;
inst_PCB=0;
mispredict_branchA=0;
mispredict_branchB=0;
need_take_branchA=1;
need_take_branchB=1;
previous_predict_resultA=0;
previous_predict_resultB=0;
previous_true_resultA=1;
previous_true_resultB=1;
$display (" the two instruction is branch and both take");
$display (" test the update of the pattern history table");
$display (" update the first instruction,predict not taken but take, PHT 2,3 should change from 00 to 01, write to the BTB, entry 1, tag 4, entry 0, tag 0");


@(negedge clock)  //end of clock 1 
Gshare_update_enA=1;
Gshare_update_enB=1;
branch_PCA=64'b100_0001_00;//64'h104
//branch_PCB=64'b1100_0010_00;
branch_PCB=64'h0;
branch_PHT_idxA=4'b1111;
branch_PHT_idxB=4'd3;
branch_target_PCA=64'h1111_1111_2222_2222;
branch_target_PCB=64'h2222_2222_3333_3333;
inst_PCA=0;
inst_PCB=0;
mispredict_branchA=0;
mispredict_branchB=0;
need_take_branchA=1;
need_take_branchB=1;
previous_predict_resultA=0;
previous_predict_resultB=0;
previous_true_resultA=1;
previous_true_resultB=1;
$display (" the two instruction is branch and both take");
$display (" test the update of the pattern history table");
$display (" update the first instruction,predict not taken but take, PHT 2,3 should change from 01 to 10, write to the BTB, entry 1, tag 4, entry 0, tag 0");


@(negedge clock)  //end of clock 1 
Gshare_update_enA=1;
Gshare_update_enB=1;
branch_PCA=64'b100_0001_00;//64'h104
//branch_PCB=64'b1100_0010_00;
branch_PCB=64'h0;
branch_PHT_idxA=4'b1111;
branch_PHT_idxB=4'd3;
branch_target_PCA=64'h1111_1111_2222_2222;
branch_target_PCB=64'h2222_2222_3333_3333;
inst_PCA=0;
inst_PCB=0;
mispredict_branchA=0;
mispredict_branchB=0;
need_take_branchA=0;
need_take_branchB=0;
previous_predict_resultA=1;
previous_predict_resultB=1;
previous_true_resultA=1;
previous_true_resultB=1;
$display (" the two instruction is branch and both take");
$display (" test the update of the pattern history table");
$display (" predicted right, PHT 2,3 should change from 10 to 11, write to the BTB, entry 1, tag 4, entry 0, tag 0");


@(negedge clock)  //end of clock 1 
Gshare_update_enA=0;
Gshare_update_enB=0;
branch_PCA=64'h0;//64'h104
//branch_PCB=64'b1100_0010_00;
branch_PCB=64'h0;
branch_PHT_idxA=4'b1111;
branch_PHT_idxB=4'd3;
branch_target_PCA=64'h1111_1111_2222_2222;
branch_target_PCB=64'h2222_2222_3333_3333;
inst_PCA=0;
inst_PCB=0;
mispredict_branchA=0;
mispredict_branchB=0;
need_take_branchA=0;
need_take_branchB=0;
previous_predict_resultA=1;
previous_predict_resultB=1;
previous_true_resultA=1;
previous_true_resultB=1;
//$display (" the two instruction is branch and both take");
$display (" test the prediction result");
$display (" data existed in the BTB, predictor result is 1, pc target should be ");


@(negedge clock)  //end of clock 1 
Gshare_update_enA=1;
Gshare_update_enB=1;
branch_PCA=64'b100_0001_00;//64'h104
//branch_PCB=64'b1100_0010_00;
branch_PCB=64'h0;
branch_PHT_idxA=4'b1111;
branch_PHT_idxB=4'd3;
branch_target_PCA=64'h1111_1111_2222_2222;
branch_target_PCB=64'h2222_2222_3333_3333;
inst_PCA=0;
inst_PCB=0;
mispredict_branchA=0;
mispredict_branchB=0;
need_take_branchA=0;
need_take_branchB=0;
previous_predict_resultA=1;
previous_predict_resultB=1;
previous_true_resultA=1;
previous_true_resultB=1;
$display (" the two instruction is branch and both take");
$display (" test the update of the pattern history table");
$display (" predicted right, PHT 2,3 should not change, write to the BTB, entry 1, tag 4, entry 0, tag 0");

@(negedge clock)  //end of clock 1 
Gshare_update_enA=1;
Gshare_update_enB=1;
branch_PCA=64'b100_0001_00;//64'h104
//branch_PCB=64'b1100_0010_00;
branch_PCB=64'h0;
branch_PHT_idxA=4'b1111;
branch_PHT_idxB=4'd3;
branch_target_PCA=64'h1111_1111_2222_2222;
branch_target_PCB=64'h2222_2222_3333_3333;
inst_PCA=0;
inst_PCB=0;
mispredict_branchA=0;
mispredict_branchB=0;
need_take_branchA=0;
need_take_branchB=0;
previous_predict_resultA=1;
previous_predict_resultB=1;
previous_true_resultA=0;
previous_true_resultB=0;
$display (" the two instruction is branch and both take");
$display (" test the update of the pattern history table");
$display (" predicted right, PHT 2,3 should change from 11 to 10, write to the BTB, entry 1, tag 4, entry 0, tag 0");
@(negedge clock)  //end of clock 1 
Gshare_update_enA=1;
Gshare_update_enB=1;
branch_PCA=64'b100_0001_00;//64'h104
//branch_PCB=64'b1100_0010_00;
branch_PCB=64'h0;
branch_PHT_idxA=4'b1111;
branch_PHT_idxB=4'd3;
branch_target_PCA=64'h1111_1111_2222_2222;
branch_target_PCB=64'h2222_2222_3333_3333;
inst_PCA=0;
inst_PCB=0;
mispredict_branchA=0;
mispredict_branchB=0;
need_take_branchA=0;
need_take_branchB=0;
previous_predict_resultA=1;
previous_predict_resultB=1;
previous_true_resultA=0;
previous_true_resultB=0;
$display (" the two instruction is branch and both take");
$display (" test the update of the pattern history table");
$display (" predicted right, PHT 2,3 should change from 10 to 01, write to the BTB, entry 1, tag 4, entry 0, tag 0");

@(negedge clock)  //end of clock 1 
Gshare_update_enA=1;
Gshare_update_enB=1;
branch_PCA=64'b100_0001_00;//64'h104
//branch_PCB=64'b1100_0010_00;
branch_PCB=64'h0;
branch_PHT_idxA=4'b1111;
branch_PHT_idxB=4'd3;
branch_target_PCA=64'h1111_1111_2222_2222;
branch_target_PCB=64'h2222_2222_3333_3333;
inst_PCA=0;
inst_PCB=0;
mispredict_branchA=0;
mispredict_branchB=0;
need_take_branchA=0;
need_take_branchB=0;
previous_predict_resultA=0;
previous_predict_resultB=0;
previous_true_resultA=0;
previous_true_resultB=0;
$display (" the two instruction is branch and both take");
$display (" test the update of the pattern history table");
$display (" predicted right, PHT 2,3 should change from 01 to 00, write to the BTB, entry 1, tag 4, entry 0, tag 0");
@(negedge clock)  //end of clock 1 
Gshare_update_enA=1;
Gshare_update_enB=1;
branch_PCA=64'b100_0001_00;//64'h104
//branch_PCB=64'b1100_0010_00;
branch_PCB=64'h0;
branch_PHT_idxA=4'b1111;
branch_PHT_idxB=4'd3;
branch_target_PCA=64'h1111_1111_2222_2222;
branch_target_PCB=64'h2222_2222_3333_3333;
inst_PCA=0;
inst_PCB=0;
mispredict_branchA=0;
mispredict_branchB=0;
need_take_branchA=0;
need_take_branchB=0;
previous_predict_resultA=0;
previous_predict_resultB=0;
previous_true_resultA=0;
previous_true_resultB=0;
$display (" the two instruction is branch and both take");
$display (" test the update of the pattern history table");
$display (" predicted right, PHT 2,3 should not change, write to the BTB, entry 1, tag 4, entry 0, tag 0");


@(negedge clock)
Gshare_update_enA=0;
Gshare_update_enB=0;
branch_PCA=0;
branch_PCB=0;
branch_PHT_idxA=0;
branch_PHT_idxB=0;
branch_target_PCA=0;
branch_target_PCB=0;
inst_PCA=0;
inst_PCB=0;
mispredict_branchA=0;
mispredict_branchB=0;
need_take_branchA=0;
need_take_branchB=0;
previous_predict_resultA=0;
previous_predict_resultB=0;
previous_true_resultA=0;
previous_true_resultB=0;


@(negedge clock)
@(negedge clock)
$finish;
end //end initial
endmodule
