`define SD #1

module stq(
        //input
        clock,
        reset,
        id_wr_mem_enA,
        id_wr_mem_enB, 
        id_valid_IRA,
        id_valid_IRB,

        ALU_SQ_idxA,
        ALU_SQ_idxB,
        ALU_store_dataA, //get from RS when issue
        ALU_store_dataB,        
        ALU_store_addrA,
        ALU_store_addrB,
//////////////////////////////////
        ALU_wr_mem_enA,            // in ex_stage, it is ready and the wr_stq signal is high is as a write_en signal for the stq
        ALU_wr_mem_enB,            // ALU_wr_mem_enA & ex_cdbA_rdy is like a write_en signal
        ex_cdbA_rdy,
        ex_cdbB_rdy,
///////////////////////////////////
        ROB2SQ_retire_en,
        branch_recovery,
        store_grant,
        mshr_full,
        //output
        store_request,
        store_retire_addr,
        store_retire_data,

        SQ2RS_idxA,
        SQ2RS_idxB,
//        SQ2RS_idxA_write_en,
//        SQ2RS_idxB_write_en,

        tail, 
        next_tail,
        SQ_full,
        SQ_almost_full,
        next_busy,
        busy,
        head,
        stq_retiring_out
);



///////////////////////////////////////////////////////////
//                                                       //
//                      Input                            //
//                                                       //
///////////////////////////////////////////////////////////
input        clock;
input        reset;
input        store_grant;

//Dispatch
input        id_wr_mem_enA;
input        id_wr_mem_enB; 
input        id_valid_IRA;
input        id_valid_IRB;

//execute:complete signal broadcast from ALU
input [2:0]  ALU_SQ_idxA;
input [2:0]  ALU_SQ_idxB;
input [63:0] ALU_store_dataA; //get from RS when issue
input [63:0] ALU_store_dataB;        
input [63:0] ALU_store_addrA;
input [63:0] ALU_store_addrB;
input        ALU_wr_mem_enA;
input        ALU_wr_mem_enB; 
input        ex_cdbA_rdy;
input        ex_cdbB_rdy;
//retire: from ROB
input        ROB2SQ_retire_en;

//from LQ
input        branch_recovery;
input        mshr_full;
///////////////////////////////////////////////////////////
//                                                       //
//                      Output                           //
//                                                       //      
///////////////////////////////////////////////////////////

//retire
output            store_request;
output [63:0]     store_retire_addr;
output [63:0]     store_retire_data;

//dispatch to RS
output [2:0]     SQ2RS_idxA;
output [2:0]     SQ2RS_idxB;  
//output           SQ2RS_idxA_write_en;
//output           SQ2RS_idxB_write_en;

// to LQ when LQ dispatch
output [2:0]     tail; 
output [2:0]     next_tail;

//inflight condition: LQ search result from SQ
//output [63:0]   SQ2LQ_data;
//output          SQ2LQ_write_en;
//output [2:0]    SQ2LQ_LQ_idx;

output          SQ_full;
output          SQ_almost_full;

//output [7:0]    ready;
output [7:0]    next_busy;
output [7:0]    busy;
output [2:0]    head;
output  reg       stq_retiring_out;

///////////////////////////////////////////////////////////
//                                                       //
//                     Inner Reg                         //
//                                                       //
///////////////////////////////////////////////////////////
reg           branch_recovery_reg;
reg   [63:0]  store_addr [7:0];
reg   [63:0]  next_store_addr [7:0];

reg   [63:0]  store_data [7:0];
reg   [63:0]  next_store_data [7:0];

//reg   [`ROBWIDTH-1:0]	robIdx [7:0];
//reg   [`ROBWIDTH-1:0]	next_robIdx [7:0];

reg   [2:0]   head, next_head;
reg   [2:0]   tail, next_tail;
reg   [7:0]   busy, next_busy;
reg   [7:0]  addr_valid, next_addr_valid;
reg   [7:0]  data_valid, next_data_valid;
reg   [3:0]   i;
   
reg   [2:0]   SQ2RS_idxA;
reg   [2:0]   SQ2RS_idxB;
reg           SQ2RS_idxA_write_en;
reg           SQ2RS_idxB_write_en;

//reg   [63:0]  SQ2LQ_data;
//reg           SQ2LQ_write_en;
 
wire  [2:0]   tail_add_one;
wire  [2:0]   tail_add_two;
wire  [2:0]   head_add_one;
wire  [2:0]   head_add_two;
wire          dispatch_storeA_en;
wire          dispatch_storeB_en;
wire  [2:0]   next_tail_plus_one;
wire  [2:0]   next_tail_plus_two;


wire  [2:0]  net_dis; 
        assign net_dis    = next_tail - next_head;
	assign tail_add_one = tail + 1;
	assign tail_add_two = tail + 2;
	assign head_add_one = head + 1;
	assign head_add_two = head + 2;  
        assign next_tail_plus_one = next_tail + 3'd1;
        assign next_tail_plus_two = next_tail + 3'd2;

	assign store_request = (ROB2SQ_retire_en && !mshr_full) ? 1'b1:0;
	assign store_retire_addr = (busy[head]==0 && busy[head+3'b1]==1) ? next_store_addr[head+1] : next_store_addr[head];
	assign store_retire_data = (busy[head]==0 && busy[head+3'b1]==1) ? next_store_data[head+1] : next_store_data[head];

	assign dispatch_storeA_en = id_valid_IRA && id_wr_mem_enA;
	assign dispatch_storeB_en = id_valid_IRA && id_valid_IRB && id_wr_mem_enB;

//	assign SQ2LQ_LQ_idx = LQ2SQ_LQ_idx;  

	// assign SQ_full = (next_head == next_tail_plus_one) ? 1:0;
	assign SQ_full = next_busy == 8'b11111111;
	// assign SQ_almost_full = ( next_head == next_tail_plus_two) ? 1:0;
	assign SQ_almost_full = (next_busy == 8'b11111110 |
								next_busy == 8'b11111101 |
								next_busy == 8'b11111011 |
								next_busy == 8'b11110111 |
								next_busy == 8'b11101111 |
								next_busy == 8'b11011111 |
								next_busy == 8'b10111111 |
								next_busy == 8'b01111111);
	

//	assign ready = addr_valid && data_valid;

	always @*
	begin
	  next_head = head;
	  next_tail = tail;
	  next_busy =busy;
	  next_addr_valid = addr_valid;
	  next_data_valid = data_valid;
          stq_retiring_out = 1'b0;         
 
	  SQ2RS_idxA = 0;
	  SQ2RS_idxB = 0;
	  SQ2RS_idxA_write_en = 0;
	  SQ2RS_idxB_write_en = 0;

//	  SQ2LQ_data = 0;
//	  SQ2LQ_write_en = 0;

		  for(i = 0 ; i< 8; i=i+1)
		  begin
		    next_store_addr[i] = store_addr[i];
		    next_store_data[i] = store_data[i];
		  end

//////////////////////////////////////////////////
//                                              //
//              Retire, head                    //
//                                              //
////////////////////////////////////////////////// 
	  if(ROB2SQ_retire_en && (store_grant == 1))
	  begin
	    next_busy[head] = 0; 
            stq_retiring_out = 1'b1;
	    next_addr_valid[head] = 0;
	    next_data_valid[head] = 0; 
	    if((head == tail) & (busy[head] == 1) &  (~dispatch_storeA_en) & (~dispatch_storeB_en)) begin
	      next_head = head;
	    end else if (head==tail && busy[head]==0 && busy[head+3'b1]==1) begin 
	    next_busy[head+1] = 0; 
            stq_retiring_out = 1'b1;
	    next_addr_valid[head+1] = 0;
	    next_data_valid[head+1] = 0; 
	    next_head = head + 2;
	    end else begin
	      next_head = head + 1;
	    end
	   
	    
	  end
////////////////////////////////////////////////////////////
//                                                        //
//                   Dispatch, tail                       //
//                                                        //
////////////////////////////////////////////////////////////
	
	 if(dispatch_storeA_en && dispatch_storeB_en)
	  begin

		    if( (head == tail) && (busy[head] == 0))
		    begin
		      next_tail = tail+1;
		      next_busy[tail] = 1;
		      next_busy[tail_add_one] = 1;
		      next_store_addr[tail_add_one] = 0;
			  next_store_data[tail_add_one] = 0;
			  // next_robIdx[tail] = robIdxA;
			  // next_robIdx[tail_add_one] = robIdxB;

		      SQ2RS_idxA = tail;
		      SQ2RS_idxA_write_en = 1;
		      SQ2RS_idxB = tail_add_one;
		      SQ2RS_idxB_write_en = 1;
		    end
		    else if (busy[tail]==0 && busy[tail+1]==0) begin //need to account for t->0, t+1->0, t+2=h->1 situation.
		    	//... or just t and t+1 both 0 in general.
		    	next_tail = tail + 1;
		    	next_busy[tail] = 1;
		    	next_busy[tail_add_one] = 1;
			  	next_store_addr[tail] = 0;
		    	next_store_addr[tail_add_one] = 0;
			  	next_store_data[tail] = 0;
			  	next_store_data[tail_add_one] = 0;

				// next_robIdx[tail] = robIdxA;
			  	// next_robIdx[tail_add_one] = robIdxB;

			  	SQ2RS_idxA = tail;
		      	SQ2RS_idxA_write_en = 1;
		      	SQ2RS_idxB = tail_add_one;
		      	SQ2RS_idxB_write_en = 1;
		    end else begin
		      next_tail = tail + 3'd2;
		      next_busy[tail_add_one] = 1;
		      next_busy[tail_add_two] = 1;
			  next_store_addr[tail_add_one] = 0;
			  next_store_addr[tail_add_two] = 0;
			  next_store_data[tail_add_one] = 0;
			  next_store_data[tail_add_two] = 0;

			  // next_robIdx[tail_add_one] = robIdxA;
			  // next_robIdx[tail_add_two] = robIdxB;			  

		      SQ2RS_idxA = tail_add_one;
		      SQ2RS_idxA_write_en = 1;
		      SQ2RS_idxB = tail_add_two;
		      SQ2RS_idxB_write_en = 1;
		    end
	    end

	  else if(dispatch_storeA_en && (~dispatch_storeB_en))
		  begin

		    if((head == tail) && (busy[head] == 0))
			    begin
	   		      	next_tail =tail;
	   		      	next_busy[tail] = 1;
	   		  	  	next_store_addr[tail] = 0;
	   		  	  	next_store_data[tail] = 0;			      
      
			  		// next_robIdx[tail] = robIdxA;

			      	SQ2RS_idxA =tail;
			      	SQ2RS_idxA_write_en = 1;
			    end
		    else

			    begin
			      	next_tail =tail+1;
			      	next_busy[tail_add_one] = 1;
			      	next_store_addr[tail_add_one] = 0;
			  	  	next_store_data[tail_add_one] = 0;
    
			  		// next_robIdx[tail_add_one] = robIdxA;

			      	SQ2RS_idxA = tail_add_one;
			      	SQ2RS_idxA_write_en = 1;   
			    end
		  end

	  else if((~dispatch_storeA_en) && dispatch_storeB_en)
		  begin

		    if((head == tail) && (busy[head] == 0))
			    begin
			      next_tail =tail;
			      next_busy[tail] = 1;      
         
		  		  // next_robIdx[tail_add_one] = robIdxA;

			      SQ2RS_idxB =tail;
			      SQ2RS_idxB_write_en =1;
			    end else begin
			      next_tail =tail+1;
			      next_busy[tail_add_one] = 1;    
			      next_store_addr[tail_add_one] = 0;
			  	  next_store_data[tail_add_one] = 0;
  
			      SQ2RS_idxB = tail_add_one;
			      SQ2RS_idxB_write_en = 1;
      
			    end  

		if (busy[head]==0 && busy[head+1]==1) next_head = head + 1;
		end

//////////////////////////////////////////////////
//                                              //
//                  Execute                     //
//                                              //
//////////////////////////////////////////////////

	  if(ALU_wr_mem_enA && ex_cdbA_rdy)
	  begin
	    next_store_addr[ALU_SQ_idxA] = ALU_store_addrA;
	    next_store_data[ALU_SQ_idxA] = ALU_store_dataA;
	    next_addr_valid[ALU_SQ_idxA] = 1;
	    next_data_valid[ALU_SQ_idxA] = 1;
	  end

	  if(ALU_wr_mem_enB && ex_cdbB_rdy)
	  begin
	    next_store_addr[ALU_SQ_idxB] = ALU_store_addrB;
	    next_store_data[ALU_SQ_idxB] = ALU_store_dataB;
	    next_addr_valid[ALU_SQ_idxB] = 1;
	    next_data_valid[ALU_SQ_idxB] = 1;
	  end


end //always @*

/////////////////////////////////////////////this is the sequential logic
	always @(posedge clock)
	begin
	  if(reset|branch_recovery)
	  begin
	          head <= `SD 0;
	          tail <= `SD 0;
	          busy <= `SD 0;
	    addr_valid <= `SD 0;
	    data_valid <= `SD 0;
            branch_recovery_reg <= `SD 0;
	  end
	  else
	  begin
                  branch_recovery_reg <= `SD branch_recovery;
	          head <= `SD next_head;
   	          tail <= `SD next_tail;
	          busy <= `SD next_busy;
	    addr_valid <= `SD next_addr_valid;
	    data_valid <= `SD next_data_valid;
	      for(i= 0 ; i<8;i=i+1)
	        begin
	        store_addr[i] <= `SD next_store_addr[i];
	        store_data[i] <= `SD next_store_data[i];
                end 
            end 
        end
endmodule
