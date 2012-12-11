/////////////////////////////////////////////////////////////////////////////
//                                                                         //
//                                                                         //
//                          freelist.v                                     //
//                                                                         //
//                                                                         //
/////////////////////////////////////////////////////////////////////////////

module freelist(
	//inputs
	clock,
	reset,
	id_valid_IRA,
	id_valid_IRB,

	rob_retire_enA,
	rob_retire_enB,

	rob_ToldA,
	rob_ToldB,
//	id_IRA,
//	id_IRB,
        id_destA,
        id_destB,

	branch_recovery_en,
	branch_recovery_head,

	//outputs
	fl_TA,
	fl_TB,
        empty,
	head_at_branch_signal,
	head_add_one_at_branch_signal,
	next_head_at_branch_signal,
	next_head_add_one_at_branch_signal
);

//////////////////////////////////////////////////////////////////////////
//                                                                      //
//                              inputs                                  //
//                                                                      //
//////////////////////////////////////////////////////////////////////////
                              
input 			clock;
input 			reset;

input 			id_valid_IRA;   //whether to prepare a freelist valid for next cycle
input 			id_valid_IRB;

input 			rob_retire_enA; //Retirement signal so we know when to throw Told value(s) back into free list.
input 			rob_retire_enB; 

input [`CDBWIDTH-1:0]	rob_ToldA; //Told value(s) in ROB to throw back into free list during retirement.
input [`CDBWIDTH-1:0]	rob_ToldB;

input [4:0]		id_destA;
input [4:0]		id_destB;

//input [31:0]            id_IRA;
//input [31:0]		id_IRB;

//////////////////// added for branch recovery//////////////////////////

input			branch_recovery_en;
input [4:0]		branch_recovery_head;

////////////////////////////////////////////////////////////////////////////
//                                                                        //
//                           outputs                                      //
//                                                                        //
////////////////////////////////////////////////////////////////////////////

output [`CDBWIDTH-1:0]	fl_TA; //outputs value(s) to ROB, Map Table, and Reservation Station (AKA Issue Queue) so they know which physical register the destination is mapped to.
output [`CDBWIDTH-1:0]	fl_TB;
output                  empty;

//////////////////// added for branch recovery//////////////////////////
output [4:0]		head_at_branch_signal;
output [4:0]		head_add_one_at_branch_signal;
output [4:0]		next_head_at_branch_signal;
output [4:0]		next_head_add_one_at_branch_signal;
////////////////////////////////////////////////////////////////////////////
//                                                                        //
//                            innner reg                                  //
//                                                                        //
////////////////////////////////////////////////////////////////////////////

reg	       		full,next_full; //tell whether the freelist is full
reg            		empty,next_empty; //tell whether the freelist is empty
reg            		almost_empty,next_almost_empty;

reg  [4:0]   		head, next_head; 
reg  [4:0]   		tail, next_tail; 

reg [`CDBWIDTH-1:0]  	freelist[31:0]; //64 entry, 6-bit freelist, one entry to determind whether it is full or not
reg [`CDBWIDTH-1:0]  	next_freelist[31:0];

reg [31:0] 		valid;   //show whether the tag in freelist can be used
reg [31:0] 		next_valid;
reg  [5:0] 		i;
reg  [5:0]		j;

wire opcodeA_invalid;
wire opcodeB_invalid;

wire retireA_en;
wire retireB_en;

wire [4:0] tail_add_one;
wire [4:0] tail_add_two;
wire [4:0] head_add_one;
wire [4:0] next_tail_add_one;
wire [4:0] next_tail_add_two;
wire [4:0] next_head_add_one;

assign head_at_branch_signal = head;
assign next_head_at_branch_signal = next_head;
assign head_add_one_at_branch_signal = head_add_one;
assign next_head_add_one_at_branch_signal = next_head+1'b1;

assign opcodeA_invalid = (id_destA == `ZERO_REG_5) | (~id_valid_IRA) ;// to be added | (opcodeA == `UNCOND_BRANCH );
assign opcodeB_invalid = (id_destB == `ZERO_REG_5) | (~id_valid_IRA) | (~id_valid_IRB);// to be added | (opcodeB == `UNCOND_BRANCH );

assign fl_TA = (id_destA == `ZERO_REG_5)? `ZERO_REG : freelist[head];
assign fl_TB = (~opcodeA_invalid) ? //opcodeA valid, consider opcodeB
	((id_destB == `ZERO_REG_5) ? `ZERO_REG : freelist[head_add_one]) :  //opcodeB valid
	((id_destB == `ZERO_REG_5) ? `ZERO_REG : freelist[head]);

assign retireA_en = rob_retire_enA && (rob_ToldA != `ZERO_REG);
assign retireB_en = rob_retire_enB && (rob_ToldB != `ZERO_REG);


assign tail_add_one = tail + 1;
assign tail_add_two = tail + 2;
assign head_add_one = head + 1;
assign next_tail_add_one = next_tail + 1;
assign next_tail_add_two = next_tail + 2;
assign next_head_add_one = next_head + 1;

//////////////////////////////////////////////////////////////////
//                                                              //
//             empty, almost_empty and full                     //
//                                                              //
//////////////////////////////////////////////////////////////////

always @*
begin

  full = (head == tail_add_one )? 1'b1 : 1'b0;
  almost_empty = ((head == tail) && (valid[head]==1)) ? 1'b1 : 1'b0;
  empty = ((head == tail)&&(valid[head]==0))? 1'b1 : 1'b0;
  next_full = (next_head == next_tail_add_one )? 1'b1 : 1'b0;
  next_almost_empty = ((next_head == next_tail) && (next_valid[next_head]==1)) ? 1'b1 : 1'b0;
  next_empty = ((next_head == next_tail)&&(next_valid[next_head]==0))? 1'b1 : 1'b0;

end
//give the free PR to the output


always @*
begin
	for(i=0; i<32; i=i+1)
	begin	
	  next_freelist[i] = freelist[i];
	end
	next_valid = valid;
	next_tail = tail;
	next_head = head;
 
////////////////////////////////////////////////////////////////
//                                                            //
//                    Dispatch, head                          //
//                                                            //
////////////////////////////////////////////////////////////////       


	//recovery
    if(branch_recovery_en) begin
        next_head = branch_recovery_head;
		if(branch_recovery_head > head)  begin
			for(j= 0; j <= 5'd31; j=j+1) begin
				if((j >= branch_recovery_head) | (j<=head)) next_valid[j] = 1'b1;
			end
		end	else if(branch_recovery_head <= head)	begin
			for(j= 0; j<= 5'd31; j=j+1 ) begin
          	 	 if((j<= head) && (j>=branch_recovery_head)) next_valid[j] = 1'b1;
			end
		end
	end else begin
		if ((~opcodeA_invalid)&&(~opcodeB_invalid))	begin
			//send out two T to ROB and RS, when the operation is not STORE and the dest reg is not R31.
    	      next_head = head + 6'd2;
    	      next_valid[head] = 0; 
    	      next_valid[head_add_one] = 0;
    	      if(head_add_one == tail) next_head = head+1;
		end else if ((~opcodeA_invalid) && opcodeB_invalid)	begin
    	      next_head = head + 6'd1;
    	      next_valid[head] = 0;
    	      if(head == tail) next_head = head;
		end else if (opcodeA_invalid && (~opcodeB_invalid))   begin
    	    next_head = head + 6'd1;
		    next_valid[head] = 0;
   			if(head == tail) next_head = head;	
		end
	end

///////////////////////////////////////////////////////////////////
//                                                               //
//                      Retire, tail                             //
//                                                               //
///////////////////////////////////////////////////////////////////

	if (retireA_en && retireB_en)
	begin
          next_freelist[tail_add_one] = rob_ToldA;
	  next_freelist[tail_add_two] = rob_ToldB;
	  next_tail = tail + 6'd2;
	  next_valid[tail_add_one] = 1;
	  next_valid[tail_add_two] = 1;
          if((head == tail) && (valid[head]==0))
	  begin
            next_freelist[tail] = rob_ToldA;
	    next_freelist[tail_add_one] = rob_ToldB;
	    next_tail = tail + 6'd1;
	    next_valid[tail] = 1;
	    next_valid[tail_add_one] = 1;
	  end
        end

     	else if (retireA_en && (~retireB_en))
	begin
	  if((head == tail)&&(valid[head]==0))
	  begin
            next_freelist[tail] = rob_ToldA;
	    next_tail = tail;
	    next_valid[tail] = 1;
	  end
	  else
	  begin
	    next_freelist[tail_add_one] = rob_ToldA;
	    next_tail = tail + 6'd1;
            next_valid[tail_add_one] = 1;
	  end
	end
 
        else if ((~retireA_en) && retireB_en)
	begin
	  if((head == tail)&&(valid[head]==0))
	  begin
            next_freelist[tail] = rob_ToldB;
	    next_tail = tail;
	    next_valid[tail] = 1;
	  end
	  else
	  begin
	    next_freelist[tail_add_one] = rob_ToldB;
	    next_tail = tail + 6'd1;
            next_valid[tail_add_one] = 1;
	  end
	end



end


///////////////////////////////////////////////////////////////////
//                                                               //
//                    Clock edge things                          //
//                                                               //
///////////////////////////////////////////////////////////////////
always@(posedge clock)
begin
	if(reset)
	begin
		head         <= `SD 5'd0; // record the head of useful freelist
		tail         <= `SD 5'd31; // recore the tail of useful freelist
		freelist[0]  <= `SD 6'd32;
		freelist[1]  <= `SD 6'd33;		
		freelist[2]  <= `SD 6'd34;
		freelist[3]  <= `SD 6'd35;
 		freelist[4]  <= `SD 6'd36;  
		freelist[5]  <= `SD 6'd37;
		freelist[6]  <= `SD 6'd38;
		freelist[7]  <= `SD 6'd39;
		freelist[8]  <= `SD 6'd40;
		freelist[9]  <= `SD 6'd41;
		freelist[10] <= `SD 6'd42;
		freelist[11] <= `SD 6'd43;
		freelist[12] <= `SD 6'd44;
		freelist[13] <= `SD 6'd45;		
		freelist[14] <= `SD 6'd46;
		freelist[15] <= `SD 6'd47;
 		freelist[16] <= `SD 6'd48;  
		freelist[17] <= `SD 6'd49;
		freelist[18] <= `SD 6'd50;
		freelist[19] <= `SD 6'd51;
		freelist[20] <= `SD 6'd52;
		freelist[21] <= `SD 6'd53;
		freelist[22] <= `SD 6'd54;
		freelist[23] <= `SD 6'd55;
		freelist[24] <= `SD 6'd56;
		freelist[25] <= `SD 6'd57;		
		freelist[26] <= `SD 6'd58;
		freelist[27] <= `SD 6'd59;
 		freelist[28] <= `SD 6'd60;  
		freelist[29] <= `SD 6'd61;
		freelist[30] <= `SD 6'd62;
		freelist[31] <= `SD 6'd63;
		valid        <= `SD 32'hffff_ffff;
	end
	
	else
           begin
		head         <= `SD next_head;
		tail 	     <= `SD next_tail;
		valid        <= `SD next_valid;
	        for(i=0; i<32; i=i+1)
		begin	
                  freelist[i] <= `SD next_freelist[i]; 		
		end
           end
end
`ifdef DEBUG_OUT
	RECOVER_HEAD_MOVEMENT: assert property(@(posedge clock)
		branch_recovery_en |-> (head>tail) ? (next_head<=head & next_head>next_tail) : (next_head<=head | next_head>tail) )
	else $error("MORE entries being allocated on recovery instead of less!");
	// TAIL_MOVEMENT: assert property(@(posedge clock)
	// 	retireA_en && retireB_en |-> (rob_ToldA==`ZERO_REG_5 ^ rob_ToldB==`ZERO_REG_5) ? (next_tail==tail+1'b1) : (next_tail==tail+2'b10 | next_tail==tail)
	// 	)
	// else $error ("tail movement mismatch");
	// HEAD_MOVEMENT: assert property(@(posedge clock)
	// 	id_valid_IRA && id_valid_IRB |-> (id_destA==`ZERO_REG_5 ^ id_destB==`ZERO_REG_5) ? (next_head==head+1'b1) : (next_head==head+2'b10 | next_head==head)
	// 	)
	// else $error ("head movement mismatch");

`endif
endmodule
