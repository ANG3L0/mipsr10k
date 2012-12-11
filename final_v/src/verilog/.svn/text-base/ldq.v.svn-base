`define LDQWIDTH 4
`define SD       #1
`define LDQ_NORMAL 2'b00
`define LDQ_ALMOST_FULL 2'b01
`define LDQ_FULL   2'b10
`define LDQ_DEFAULT 2'b11

      module ldq ( // inputs 
                   clock,
                   reset,
                   id_valid_instA,
                   id_valid_instB,
                   id_rd_memA,
                   id_rd_memB,
                   id_wr_memA,
//                   rob_dispidxA,
//                   rob_dispidxB,
                     
                   ex_rd_memA_en,
                   ex_rd_memB_en,
                   ex_cdbA_rdy,
                   ex_cdbB_rdy,
                   ex_rd_addrA,
                   ex_rd_addrB,        
                   ex_ldq_idxA,
                   ex_ldq_idxB,
                  
                   ex_ldq_prA_idx,
                   ex_ldq_mtA_idx,
                   ex_ldq_robA_idx,
                   ex_ldq_haltA,
                   ex_ldq_illegalA,
                   ex_ldq_NPCA,                   
 
                   ex_ldq_prB_idx,
                   ex_ldq_mtB_idx,
                   ex_ldq_robB_idx,
                   ex_ldq_haltB,
                   ex_ldq_illegalB,
                   ex_ldq_NPCB,
                   stq_current_tail,
                   stq_tail_minus_one,
                   rob_recovery_en,
                   stq_valid_graph,
                   stq_valid_graph_old,
 
                   stq_head,

                   mshr_full,
                   mem_back_validA,
                   mem_ldq_idxA,
                   mem_back_dataA,
                   mem_back_validB, 
                   mem_ldq_idxB,
                   mem_back_dataB,
                   mem_grantB,
                   rob_stq_retire_en,
                   stq_retiring,
//                   stq_valid_graph_old,
                   //outputs 
                   ldq_rs_stall_out,    //  this signal is to stall rs to have the CDB next postive edge
//                   ldq_rs_ldA_en_out,
//                   ldq_rs_ldB_en_out,
                   ldq_rs_ldqidxA_out,
                   ldq_rs_ldqidxB_out,
                   ldq_almostfull_out,
                   ldq_full_out,
                   ldq_mem_addr_out,
                   ldq_mem_req_out,
                   ldq_mem_idx_out,

                   ldq_ex_cdb_en_out,
                   ldq_ex_data_out,
                   ldq_ex_robidx_out,
                   ldq_ex_pridx_out,
                   ldq_ex_mtidx_out,
                   ldq_ex_illegal_out,
                   ldq_ex_halt_out,
                   ldq_ex_NPC

                   );

   input 			clock;
   input 			reset;
   input       	                id_valid_instA;
   input    	                id_valid_instB;
   input      	                id_rd_memA;
   input        	        id_rd_memB;
   input          	        id_wr_memA;
//   input    [4:0]     	        rob_dispidxA;
//   input    [4:0]     	        rob_dispidxB;
   input  	         	ex_rd_memA_en;
   input 	        	ex_rd_memB_en;
   input    [63:0]              ex_rd_addrA;
   input    [63:0]              ex_rd_addrB;
   input   [`LDQWIDTH-2:0]      ex_ldq_idxA;
   input   [`LDQWIDTH-2:0]      ex_ldq_idxB;
   input                        ex_cdbA_rdy;
   input                        ex_cdbB_rdy;

   input          [5:0]         ex_ldq_prA_idx;
   input          [4:0]         ex_ldq_mtA_idx;
   input          [4:0]         ex_ldq_robA_idx;
   input                        ex_ldq_haltA;
   input                        ex_ldq_illegalA;
   input          [5:0]         ex_ldq_prB_idx;
   input          [4:0]         ex_ldq_mtB_idx;
   input          [4:0]         ex_ldq_robB_idx;
   input                        ex_ldq_haltB;
   input                        ex_ldq_illegalB;
   input          [63:0]        ex_ldq_NPCA;
   input          [63:0]        ex_ldq_NPCB;

   input   [`LDQWIDTH-2:0]      stq_current_tail;
   input   [`LDQWIDTH-2:0]      stq_tail_minus_one;
   input                        rob_recovery_en;
   input    [7:0]               stq_valid_graph;
   input    [7:0]               stq_valid_graph_old;
   input                        mshr_full;
   input                        mem_back_validA;
   input     [2:0]              mem_ldq_idxA;
   input    [63:0]              mem_back_dataA;
   input                        mem_back_validB;
   input     [2:0]              mem_ldq_idxB;
   input    [63:0]              mem_back_dataB;
   input                        mem_grantB;   

   input     [2:0]              stq_head;
   input                        rob_stq_retire_en;
   input                        stq_retiring;
 ///////////////////output signals                                         
   output    reg            ldq_rs_stall_out;
   wire                     ldq_rs_ldA_en_out;
   wire                     ldq_rs_ldB_en_out;
   output    reg   [2:0]    ldq_rs_ldqidxA_out;
   output    reg   [2:0]    ldq_rs_ldqidxB_out;

   output    reg            ldq_almostfull_out;
   output    reg            ldq_full_out;
   output    reg   [2:0]    ldq_mem_idx_out;
//   output    reg            ldq_search_stq_en_out;
//   output    reg  [63:0]    ldq_search_stq_addr_out;
//   output    reg  [`LDQWIDTH-2:0]  ldq_search_stq_pending_out;
   output    reg            ldq_mem_req_out;
   output    reg            ldq_ex_cdb_en_out;
   output    reg  [63:0]    ldq_mem_addr_out;

   output    reg  [63:0]    ldq_ex_data_out;
   output    reg   [4:0]    ldq_ex_robidx_out;
   output    reg   [5:0]    ldq_ex_pridx_out;
   output    reg   [4:0]    ldq_ex_mtidx_out;
   output    reg            ldq_ex_illegal_out;
   output    reg            ldq_ex_halt_out;
   output    reg  [63:0]         ldq_ex_NPC;
///////////////////////internal reg
   reg      [`LDQWIDTH-2:0]     head;
   reg      [`LDQWIDTH-2:0]     tail;
   reg      [`LDQWIDTH-2:0]     next_head;
   reg      [`LDQWIDTH-2:0]     next_tail;

   reg               [63:0]     ldq_data        [7:0];
   reg               [63:0]     next_ldq_data   [7:0];
   reg                          mshr_full_reg;


//   reg               [63:0]     next_ldq_head_data;           


//   reg    [1:0]  state;
//   reg    [1:0]  next_state;
   reg           reverse;
   reg           next_reverse;

   reg              [63:0] ldq_addr             [7:0];
   reg              [63:0] next_ldq_addr        [7:0]; 
   reg                     ready                [7:0];
   reg                     next_ready           [7:0];
   reg               [4:0] ldq_robidx           [7:0];
   reg               [4:0] next_ldq_robidx      [7:0];
   reg               [5:0] ldq_pridx            [7:0];
   reg               [5:0] next_ldq_pridx       [7:0];  
   reg                     ldq_illegal          [7:0];
   reg                     next_ldq_illegal     [7:0];
   reg               [4:0] ldq_mtidx            [7:0];
   reg               [4:0] next_ldq_mtidx       [7:0];
   reg                     ldq_halt             [7:0];
   reg                     next_ldq_halt        [7:0];

   reg     [`LDQWIDTH-2:0] pending_stqidx       [7:0];
   reg     [`LDQWIDTH-2:0] next_pending_stqidx  [7:0];
   reg                          mem_valid       [7:0];
   reg                     next_mem_valid       [7:0];
   reg                     already_req          [7:0];
   reg                     next_already_req     [7:0];
   reg     [63:0]                 next_NPC            [7:0];
   reg     [63:0]                 NPC                 [7:0];



   reg                     stq_pending_rdy      [7:0];
   reg                     next_stq_pending_rdy [7:0];

   reg     [5:0]  i; 
   reg            mem_occupy;
   reg            occupy;
   reg            next_occupy;
   reg            head_req;
   reg            next_head_req;
   reg   [`LDQWIDTH-2:0] counter;

///////////////////////////////control signals
   wire      tail_incr_two_en;
   wire      tail_incr_one_en;
   wire    [`LDQWIDTH-2:0]  tail_plus_one;
   wire    [`LDQWIDTH-2:0]  tail_plus_two;
   reg       head_incr_one_en;
   wire    [`LDQWIDTH-2:0]  head_plus_one;
 
   wire      pending_current;
   assign    pending_current  = (id_wr_memA & id_rd_memB & id_valid_instA & id_valid_instB) ? 1'b1: 1'b0; 

   assign    tail_incr_two_en = (id_valid_instA & id_rd_memA  & id_valid_instB &  id_rd_memB)? 1'b1: 1'b0 ;
   assign    tail_incr_one_en = ((id_valid_instA & id_rd_memA) ^ (id_valid_instB & id_rd_memB)) ? 1'b1: 1'b0;
   assign    tail_plus_one    = tail + 1;
   assign    tail_plus_two    = tail + 3'd2;         // this needs to be changed
  
   assign    ldq_rs_ldA_en_out = (id_valid_instA & id_rd_memA) ? 1'b1 : 1'b0;
   assign    ldq_rs_ldB_en_out = (id_valid_instB & id_rd_memB) ? 1'b1 : 1'b0;

   assign    head_plus_one    = head + 1;
   wire      mem_grant;
   assign    mem_grant = mem_grantB | mem_back_validA; 
/////////////////////////////////////////////////////
   wire      judgement_1;
   assign    judgement_1 = (next_head < head) ? 1'b1: 1'b0;
   wire      judgement_2;
   assign    judgement_2 = (next_tail < tail) ? 1'b1: 1'b0;
   
   wire      ex_broadcast_enA;
   wire      ex_broadcast_enB;

   assign    ex_broadcast_enA = ex_rd_memA_en & ex_cdbA_rdy; 
   assign    ex_broadcast_enB = ex_rd_memB_en & ex_cdbB_rdy;
 


   wire   [`LDQWIDTH-2:0]   net_dis;
   assign      net_dis = next_tail - next_head;
   
   wire  retire_head_en;
   assign retire_head_en = (mem_valid[head] & ready[head] & stq_pending_rdy[head] & already_req[head]) ? 1'b1 : 1'b0;



////////////////////logic for reverse signal
   always @*
   begin
     next_reverse = reverse;
     if (judgement_2)
        begin
         next_reverse = 1'b1;
         end 
        else if ((next_reverse == 1'b1) && judgement_1)
               begin
               next_reverse = 1'b0;
               end 

     if (rob_recovery_en)
        next_reverse = 1'b0;

   end

////////////////////////////////////////////////
     always @*
      begin
       ldq_almostfull_out = 1'b0;
       ldq_full_out       = 1'b0;
       if ((net_dis == 5'd0) & next_reverse)
           begin
           ldq_almostfull_out = 1'b0;
           ldq_full_out        = 1'b1;
           end 
       else if (net_dis == 5'd7)
             begin
             ldq_almostfull_out = 1'b1;
             ldq_full_out        = 1'b0;
             end 
       end 

//////////////////////logic for next_tail and head movement
 
    always @*
     begin
      next_tail = tail;
      next_head = head;
      if (tail_incr_two_en)
      next_tail = tail_plus_two;
      else if (tail_incr_one_en)
           next_tail = tail_plus_one;

      if (head_incr_one_en)
      next_head  = head_plus_one;
     
      if (rob_recovery_en)
      begin
      next_head = 3'd0;
      next_tail = 3'd0;
      next_tail = next_head;
      end 
     end

//////////////////////////determine the main state machine

		    always @*
		       begin
		       head_incr_one_en       = 1'b0;
		       ldq_rs_stall_out       = 1'b0;
                       ldq_rs_ldqidxA_out     = 3'd0;
                       ldq_rs_ldqidxB_out     = 3'd0;
		       ldq_mem_req_out        = 1'b0;
		       ldq_mem_addr_out       = 64'd0;
		       ldq_ex_cdb_en_out      = 1'b0; 
		       ldq_ex_data_out        = 64'd0;
                       ldq_ex_robidx_out      = 5'd0;
                       ldq_ex_mtidx_out       = 5'd0;
                       ldq_ex_pridx_out       = 6'd0;
                       ldq_ex_illegal_out     = 1'b0;
                       ldq_ex_halt_out        = 1'b0;
                       ldq_ex_NPC             = 64'd0;
		        mem_occupy            = 1'b0;
		        next_occupy           = 1'b0;
		         occupy               = 1'b0;
		        next_head_req         = head_req;
		       ldq_mem_idx_out        = 3'b0;
		          counter             = 3'd7;

		        for (i = 0; i < 'd8 ; i = i + 1 )
		         begin
		                  next_ready[i] = ready[i];
		                  next_ldq_addr[i] = ldq_addr[i];
		            next_pending_stqidx[i] = pending_stqidx[i];
		           next_stq_pending_rdy[i] = stq_pending_rdy[i];
		                 next_mem_valid[i] = mem_valid[i];
 		               next_already_req[i] = already_req[i];
		                  next_ldq_data[i] = ldq_data[i];
                                next_ldq_robidx[i] = ldq_robidx[i];
                                 next_ldq_pridx[i] = ldq_pridx[i];
                                 next_ldq_mtidx[i] = ldq_mtidx[i];
                               next_ldq_illegal[i] = ldq_illegal[i];
                                  next_ldq_halt[i] = ldq_halt[i];
                       
//		                   if ( stq_valid_graph[stq_head] == 1'b0)
//		                   

                                      if ((pending_current == 1'b0) && (stq_valid_graph_old[stq_head] == 1'b0))
                                           begin
            //                                if ( stq_valid_graph)                                             
            //                                if (next_pending_stqidx[i] == stq_head )
            //                                begin
                                            next_stq_pending_rdy[i] = 1'b1;
           //                                 end
                                           end
		                   
                                    else   if (stq_retiring | !stq_valid_graph[stq_head])
		                            begin
		                              if (next_pending_stqidx[i] == stq_head )
		                                begin
		                                next_stq_pending_rdy[i] = 1'b1;
		                                end 
		                            end   
     
                          end 


		       if (ex_broadcast_enA)
		        begin
		           next_ldq_addr[ex_ldq_idxA] = ex_rd_addrA;            //   this is to set the ready bit and the address bits
		              next_ready[ex_ldq_idxA] = 1'b1;
                          next_ldq_pridx[ex_ldq_idxA] = ex_ldq_prA_idx;  
                          next_ldq_mtidx[ex_ldq_idxA] = ex_ldq_mtA_idx;
                           next_ldq_halt[ex_ldq_idxA] = ex_ldq_haltA; 
                        next_ldq_illegal[ex_ldq_idxA] = ex_ldq_illegalA;
                         next_ldq_robidx[ex_ldq_idxA] = ex_ldq_robA_idx;
                                next_NPC[ex_ldq_idxA] = ex_ldq_NPCA;
		        end 
      
		       if (ex_broadcast_enB)
		        begin
		           next_ldq_addr[ex_ldq_idxB] = ex_rd_addrB;
		              next_ready[ex_ldq_idxB] = 1'b1;
                          next_ldq_pridx[ex_ldq_idxB] = ex_ldq_prB_idx;
                          next_ldq_mtidx[ex_ldq_idxB] = ex_ldq_mtB_idx;
                           next_ldq_halt[ex_ldq_idxB] = ex_ldq_haltB;
                        next_ldq_illegal[ex_ldq_idxB] = ex_ldq_illegalB;
                         next_ldq_robidx[ex_ldq_idxB] = ex_ldq_robB_idx;
                                next_NPC[ex_ldq_idxB] = ex_ldq_NPCB;
		        end 



	                if ( mem_back_validA )                                  //  mem_back_valid to set the valid bit for broadcast
 	                 begin
	                   next_mem_valid[mem_ldq_idxA] = 1'b1;
	                    next_ldq_data[mem_ldq_idxA] = mem_back_dataA;
                     	 end 
     
                        if (mem_back_validB)
                          begin
                           next_mem_valid[mem_ldq_idxB] = 1'b1;                           
                            next_ldq_data[mem_ldq_idxB] = mem_back_dataB;
                           end 

    //  head retire logic is as follows/////////////////////
    ////////////////////////////////////////////////////
     
		              if (ready[head]  & stq_pending_rdy[head] & !head_req & !mem_valid[head] & !rob_stq_retire_en & !already_req[head] ) //logic garantee that the head will only broadcast once for mem
		              begin             

			                if ( !mshr_full_reg  )
		                        begin
//		                         ldq_rs_stall_out    = 1'b0;
		                         ldq_mem_addr_out    = next_ldq_addr[head];
		                         ldq_mem_req_out     = 1'b1;
		                         ldq_mem_idx_out     = head;
		                         mem_occupy          = 1'b1;               //edit by Yuzhang GAO
                                           if ( mem_grant)
                                           begin
		     	                   next_already_req[head]    = 1'b1;
	           	                   next_head_req       = 1'b1;
                                           end 
                                           else begin
                                                next_already_req[head] = 1'b0;
                                                next_head_req          = 1'b0;
                                                end 
		 		        end         

		                        if ( mshr_full_reg)
		                         begin
//		                          ldq_rs_stall_out = 1'b0;
		                          ldq_mem_req_out  = 1'b0;
                                    next_already_req[head] = 1'b0;
		                          end  
                               end 
 

//                    if ( next_mem_valid[head] & next_ready[head] & next_stq_pending_rdy[head])             //  this is for the retire logic , every time the ldq retire, set next_head_req
	                       if (retire_head_en)
	                       begin
	                          ldq_rs_stall_out    = 1'b1;
	                          ldq_ex_data_out     = next_ldq_data[head]; 
	                          head_incr_one_en    = 1'b1;
	                          ldq_ex_cdb_en_out   = 1'b1;
	                          next_head_req       = 1'b0;
                                  ldq_ex_robidx_out   = next_ldq_robidx[head];                                   
                                  ldq_ex_mtidx_out    = next_ldq_mtidx[head];
                                  ldq_ex_pridx_out    = next_ldq_pridx[head];
                                  ldq_ex_illegal_out  = next_ldq_illegal[head];
                                  ldq_ex_halt_out     = next_ldq_halt[head];
                                  ldq_ex_NPC          = next_NPC[head];
                                  next_ready[head]    = 1'b0;
                        next_stq_pending_rdy[head]    = 1'b0;
                             next_mem_valid[head]     = 1'b0;
                           next_already_req[head]     = 1'b0;

	                       end 

 
	                    if (!mem_occupy)
	                     begin
                                    for (i = 0; i < 'd8; i = i + 1)                     
                        	    begin
                                       
	                            	  if ( stq_pending_rdy[i] & !mshr_full_reg & ready[i] & !next_occupy & !already_req[i] & !rob_stq_retire_en)   //  if you broadcast for mem this cycle, you d
                                           begin   
//		         	                  ldq_rs_stall_out    = 1'b0;
		               	         	  ldq_mem_addr_out    = next_ldq_addr[i];
		                	          ldq_mem_req_out     = 1'b1;
		                                  ldq_mem_idx_out     = i;
                                                  occupy              = 1'b1;
                                                  counter             = i;
	                                   end   
/*                                        
                                          if (occupy  && mem_grant )                    // this is the point where the logic loop happens YUZHANGGAO
                                           begin
                                           next_already_req[counter]   = 1'b1;                                                
                                           next_occupy                 = 1'b1;                                            
                                           end  
*/

                                          if (occupy)
                                           begin
                                           next_occupy = 1'b1;
                                           end 
                                          
                                          if (mem_grant && occupy)                                          
                                           begin
                                           next_already_req[counter] = 1'b1;
                                           end 
                                     end                         
                              end

    ///////////////////////////////dispatch logic                  
	                     if (tail_incr_two_en)
	                      begin
//		                next_ldq_robidx[tail] 	 = rob_dispidxA;
//		                next_ldq_robidx[tail_plus_one] 	 = rob_dispidxB;
		                next_ready[tail]     	 = 1'b0;
		                next_ready[tail_plus_one] 	 = 1'b0;
		                next_stq_pending_rdy[tail]        = 1'b0;
		                next_stq_pending_rdy[tail_plus_one] = 1'b0;        // edit by Yuzhang GAO 1201

                                if (stq_valid_graph[stq_tail_minus_one] == 1'b0)
                                begin
                                 next_stq_pending_rdy[tail] = 1'b1;
                                 next_stq_pending_rdy[tail_plus_one] = 1'b1;
                                end 

		                next_pending_stqidx[tail]     = stq_tail_minus_one;
		                next_pending_stqidx[tail_plus_one]  = stq_tail_minus_one;
	                        ldq_rs_ldqidxA_out    = tail;
                                ldq_rs_ldqidxB_out    = tail_plus_one;

	                       end
	
	                      else if (tail_incr_one_en)
	                            begin
//	                            next_ldq_robidx[tail] = rob_dispidxA;
					    next_ready[tail] = 1'b0;
					    next_stq_pending_rdy[tail] = 1'b0;

                                            
                                              if (pending_current == 1'b0)                                   // added by Yuzhang GAO at 1208
                                               begin                                              
                                               if (stq_valid_graph_old[stq_tail_minus_one] == 1'b0) 
                                                  next_stq_pending_rdy[tail] = 1'b1;
                                               end 

                                              if (stq_valid_graph[stq_tail_minus_one] == 1'b0)
                                                begin
                                                 next_stq_pending_rdy[tail] = 1'b1;
                                               end 

						  if (ldq_rs_ldA_en_out)
						     ldq_rs_ldqidxA_out = tail;
						  else if (ldq_rs_ldB_en_out)
						     ldq_rs_ldqidxB_out = tail;


						  if (pending_current)
						  next_pending_stqidx[tail]  = stq_current_tail;
						  else 
						  next_pending_stqidx[tail] = stq_tail_minus_one;
					    end                        

				  if (rob_recovery_en)
				   begin
				      next_head_req         = 1'b0;

					 for (i = 0; i < 'd8; i = i + 1)
					 begin
					 next_pending_stqidx[i] = 3'd0;
	                         next_ready[i]          = 1'b0;
	                         next_stq_pending_rdy[i] = 1'b0;
	                         next_already_req[i] = 1'b0;
	                         next_mem_valid[i] = 1'b0;
	                         end 
                           end 

    end 

/////////////////////////////////////////the main sequential logic
     always @(posedge clock)
        begin
       if (reset)
          begin
           head     <= `SD 3'd0;
           tail     <= `SD 3'd0;
            for (i=0; i< 'd8; i = i + 1)
             begin
               ready[i] <= `SD 1'b0;
     stq_pending_rdy[i] <= `SD 1'b0; 
           mem_valid[i] <= `SD 1'b0;
         already_req[i] <= `SD 1'b0;
               head_req <= `SD 1'b0;
             end
             reverse  <= `SD 1'b0;
         mshr_full_reg <= `SD 1'b0;
           end
       else   begin
                       mshr_full_reg <= `SD mshr_full;
                           head     <= `SD next_head;
                           tail     <= `SD next_tail;
      	                 reverse    <= `SD next_reverse;
     	      pending_stqidx[tail]  <= `SD next_pending_stqidx[tail];
     pending_stqidx[tail_plus_one]  <= `SD next_pending_stqidx[tail_plus_one];   
                         head_req   <= `SD next_head_req;
         
	            for (i=0; i < 'd8; i = i + 1)
	               begin
		               ready[i] <= `SD next_ready[i];
		            ldq_addr[i] <= `SD next_ldq_addr[i];
		     stq_pending_rdy[i] <= `SD next_stq_pending_rdy[i];
		           mem_valid[i] <= `SD next_mem_valid[i];
		         already_req[i] <= `SD next_already_req[i];
		            ldq_data[i] <= `SD next_ldq_data[i];
		           ldq_pridx[i] <= `SD next_ldq_pridx[i];
		           ldq_mtidx[i] <= `SD next_ldq_mtidx[i];
		          ldq_robidx[i] <= `SD next_ldq_robidx[i];
                                 NPC[i] <= `SD next_NPC[i];
		            ldq_halt[i] <= `SD next_ldq_halt[i];
		         ldq_illegal[i] <= `SD next_ldq_illegal[i];
	               end

               end
        end 

  endmodule

