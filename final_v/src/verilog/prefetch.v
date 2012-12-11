module prefetch(
		clock,
		reset,
		grant,
		PC_reg,
		next_PC,
                load_request,
                store_request,
                
		//output
		request,
		prefetch2Imem_addr
		);

 input		clock;
 input		reset;
 input		grant;
 input [63:0]	PC_reg;		//input from if_stage
 input [63:0]	next_PC; 	//input from if_stage

 input          load_request;
 input          store_request;

 output	reg	request;
 output [63:0]  prefetch2Imem_addr;	

 reg    [63:0]  prefetch_PC_reg;
 wire   [63:0]  prefetch_PC_plus_8;
 wire   [63:0]  next_prefetch_PC_reg;
 wire		PC_take_branch;
 wire   [63:0]  next_PC_plus_8;
 wire   [63:0]  PC_plus_8;



 assign prefetch_PC_plus_8 = prefetch_PC_reg + 8;
 assign PC_plus_8 = PC_reg + 8;
 assign next_PC_plus_8 = next_PC + 8;
 assign PC_take_branch = ((next_PC == PC_reg)||(next_PC == PC_plus_8)) ? 1'b0 : 1'b1;// if the pc changes a lot, update the prefetch address baseline
 assign prefetch2Imem_addr = {prefetch_PC_reg[63:3], 3'b0}; 
 assign next_prefetch_PC_reg = PC_take_branch? next_PC_plus_8 : 
			       grant ? prefetch_PC_plus_8 : 
			       prefetch_PC_reg; 

 always @(posedge clock)
 begin
	if(reset)
	 request <= `SD 0;
	else 
	 request <= `SD 1;
 end



 always @(posedge clock)
 begin
	if(reset)
	  prefetch_PC_reg <= `SD 8;
	else 
	  prefetch_PC_reg <= `SD next_prefetch_PC_reg;
 end



endmodule	
