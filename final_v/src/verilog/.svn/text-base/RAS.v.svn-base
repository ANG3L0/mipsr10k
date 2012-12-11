// call_en:  ( inst[31:26] == `BSR_INST ) || (( inst[31:26] == `JSR_GRP) && ((inst[15:14] == `JSR_INST)||(inst[15:14] == `JSR_CO_INST))
// return_en:  ( inst[31:26] == `JSR_GRP ) && (( inst[15:14]== `RET_INST) || (inst[15:14] == `JSR_CO_INST))

`define SD #1



module RAS(
		clock,
		reset,
		call_enA,
		call_enB,
		return_enA,
		return_enB,
		PCA_plus_4,
		PCB_plus_4,

//output
		return_addr,
		empty
	  ) ;


  input		clock;
  input		reset;
  input		call_enA;
  input		call_enB;
  input		return_enA;
  input		return_enB;
  input [63:0]	PCA_plus_4;
  input	[63:0]	PCB_plus_4;
  
//output
  output [63:0]	return_addr;
  output	empty;

  reg	[63:0]	stack [15:0];
  reg	 [3:0]	head;
  wire   [3:0]	head_add_one;
  wire	 [3:0]  head_add_two;
  reg    [3:0]  bottom;
  wire		full;

  assign	head_add_one = head + 1;
  assign	head_add_two = head + 2;
  assign	return_addr = (call_enA && return_enB) ? PCA_plus_4 : stack[head];
  assign	empty = (head == bottom)? 1 : 0;   
  assign	full = (bottom == head_add_one) ? 1 : 0;
  assign	almost_full = (bottom == head_add_two) ? 1 : 0;

  always @(posedge clock)
  begin

  	if (reset)  
  	begin
		bottom  <= `SD 4'd0;
		head	<= `SD 4'd0;	
  	end

	else if (return_enA)	// The first inst is return
	begin
		if(empty)
			head <= `SD head;
		else 
			head <= `SD head - 1;
	end

	else if (!call_enA && !return_enA && return_enB) //second inst is return
	begin
		if(empty)
			head <= `SD head;
		else
			head <= `SD head - 1;
	end
 

  	else if (call_enA && call_enB)   // both inst is call
  	begin
		head    		<= `SD head + 2;
		stack[head_add_one]	<= `SD PCA_plus_4;
		stack[head_add_two]	<= `SD PCB_plus_4; 
		if (full)
		bottom			<= `SD bottom + 2;
		else if (almost_full)
		bottom			<= `SD bottom + 1;

  	end

  	else if (call_enA && !call_enB) //first inst is function call, second is not
  	begin
		if (return_enB)        // first inst is call, second return
		begin
			head	<=  `SD head;
		end

		else
		begin
			head 	<=  `SD head + 1;
			stack[head_add_one] <= `SD PCA_plus_4;
			if (full)
				bottom	<= `SD bottom + 1;
		end	
  	end
 
  	else if (!call_enA && !return_enA && call_enB) //second inst is function call
  	begin
		head 	            <=  `SD head + 1;
		stack[head_add_one] <=  `SD PCB_plus_4;
		if (full)
			bottom  <= `SD bottom + 1;
  	end
  end
	

endmodule
  
