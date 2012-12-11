`define CDBWIDTH 6
`define SD      #1
`define STQ_INST  6'h2d
//`define ZERO_REG   6'd31

`define  NORMAL  2'b00
`define  ALMOST_FULL  2'b01
`define  FULL    2'b10
`define  DEFAULT  2'b11
`define  HALT     32'h00000555

//`define  MEM_LATENCY_IN_CYCLES 10
/////vwerison right
module rob(
	//inputs
	clock,
	reset,
	
	mt_ToldA,
	mt_ToldB,
	
	fl_TA,
	fl_TB,

        id_IRA,
        id_IRB,

        id_opcodeA,
        id_opcodeB,

        id_PCA,
        id_PCB,

        id_valid_instA,
        id_valid_instB,
     
        id_logdestAIdx,
        id_logdestBIdx,

        id_uncond_branchA,
        id_cond_branchA,

        id_uncond_branchB,
        id_cond_branchB,
        id_wr_memA,
        id_wr_memB,
 
        stq_idxA,
        stq_idxB,

        ex_cm_cdbA_rdy,
        ex_cm_cdbB_rdy,
        ex_cm_cdbC_rdy,
        ex_cm_cdbD_rdy,


	ex_cm_robAIdx,
	ex_cm_robBIdx,
        ex_cm_robCIdx,
        ex_cm_robDIdx,
         
        ex_set_mispredictA,
        ex_set_mispredictB,
  
        ex_branch_mistakenA,
        ex_branch_mistakenB,
        ex_take_branchA,
        ex_take_branchB,
        ex_branch_still_takenA,
        ex_branch_still_takenB,
        ex_target_PCA,
        ex_target_PCB,
        mshr_full,
        ldq_rob_mem_req,
        mem_stq_idx,
        mem_grant,
//        ex_cm_cdbAIdx_lr,
//        ex_cm_cdbBIdx_lr,

	//TODO: decide if we need PC from decode
//	id_PC,
	//TODO: br_recover; recover branches later
	//TODO: recover ports to freelist?
	//outputs
	rob_ToldA_out,
	rob_ToldB_out,
        
	rob_retireA_out,
        rob_retireB_out,
        
        rob_one_inst_out,
        rob_none_inst_out,

        rob_instA_en_out,
        rob_instB_en_out,
        
        rob_dispidxA_out,        
        rob_dispidxB_out,
  
        rob_logidxA_out,
        rob_logidxB_out,

        rob_TA_out,
        rob_TB_out,

        rob_head,
        rob_branch_idxA,
        rob_branch_idxB,
        rob_retireIdxA_out,
        rob_branch_retire_out,

        rob_branch_mistakenA_out,
        rob_branch_mistakenB_out,
        rob_take_branchA_out,
        rob_take_branchB_out,
        rob_branch_still_takenA_out,
        rob_branch_still_takenB_out,
        rob_PCA_out,
        rob_PCB_out,
        rob_target_PCA_out,
        rob_target_PCB_out,
        rob_rs_halt_en,
        rob_stq_retire_en_out
                        
);
//inputs
   input                        clock;
   input                        reset;
   input                        id_uncond_branchA;  
   input                        id_cond_branchA;
   input                        id_uncond_branchB;
   input                        id_cond_branchB;
   input                        id_wr_memA;
   input                        id_wr_memB;
   input                        id_valid_instA;
   input                        id_valid_instB;

   input [`CDBWIDTH-1:0]	mt_ToldA; //update the Told field from map table during dispatch
   input [`CDBWIDTH-1:0]	mt_ToldB; //update the Told field from map table during dispatch (superscalar)
   input           [2:0]        stq_idxA;
   input           [2:0]        stq_idxB;

   input          [31:0]        id_IRA;
   input          [31:0]        id_IRB;

   input           [4:0]        id_opcodeA;
   input           [4:0]        id_opcodeB;

   input [`CDBWIDTH-1:0]	fl_TA; //update the T values from map table during dispatch 
   input [`CDBWIDTH-1:0]	fl_TB; //update the T values from map table during dispatch (superscalar)
   input [`CDBWIDTH-2:0]	ex_cm_robAIdx; //get CDB value from ex_complete register so I know to complete an instruction
   input [`CDBWIDTH-2:0]	ex_cm_robBIdx; //get CDB value from ex_complete register so I know to complete an instruction (suppa scalar)
   input [`CDBWIDTH-2:0]        ex_cm_robCIdx;
   input [`CDBWIDTH-2:0]        ex_cm_robDIdx;

   input                        ex_cm_cdbA_rdy;
   input                        ex_cm_cdbB_rdy;
   input                        ex_cm_cdbC_rdy;
   input                        ex_cm_cdbD_rdy;

   input          [63:0]        id_PCA;
   input          [63:0]        id_PCB;

   input [`CDBWIDTH-2:0]        id_logdestAIdx;
   input [`CDBWIDTH-2:0]        id_logdestBIdx;
   input                        ex_set_mispredictA;
   input                        ex_set_mispredictB;
  
   input                        ex_branch_mistakenA;
   input                        ex_branch_mistakenB;
   input                        ex_take_branchA;
   input                        ex_take_branchB;
   input                        ex_branch_still_takenA;
   input                        ex_branch_still_takenB;
   input         [63:0]         ex_target_PCA;
   input         [63:0]         ex_target_PCB;
   input                        mshr_full;
   input                        ldq_rob_mem_req;
   input           [2:0]        mem_stq_idx;
   input                        mem_grant;
//   input [`CDBWIDTH-2:0]        ex_cm_cdbAIdx_lr;
//   input [`CDBWIDTH-2:0]        ex_cm_cdbBIdx_lr;

//   input [63:0] id_PC; //Get instruction address from decode stage into ROB
//outputs

   output [`CDBWIDTH-1:0]	rob_ToldA_out; //return Told value(s) to free list during retirement
   output [`CDBWIDTH-1:0]	rob_ToldB_out; 
   output [`CDBWIDTH-1:0]       rob_TA_out;
   output [`CDBWIDTH-1:0]       rob_TB_out;


   output                       rob_retireA_out; //Tells freelist when a retirement party is going on so it can absorb PR values from TOld
   output                       rob_retireB_out;
   output                       rob_one_inst_out;
   output                       rob_none_inst_out;
   output                       rob_instA_en_out;
   output                       rob_instB_en_out;
   output          [4:0]        rob_dispidxA_out;
   output          [4:0]        rob_dispidxB_out;

   output           [4:0]       rob_logidxA_out;   //  this is for the archtable !!!!! remember!!!
   output           [4:0]       rob_logidxB_out;
   output           [4:0]       rob_head;
   output  reg      [4:0]       rob_branch_idxA; 
   output  reg      [4:0]       rob_branch_idxB;
   output  reg      [4:0]       rob_retireIdxA_out;

   output  reg                  rob_branch_retire_out;
   output  reg                  rob_branch_mistakenA_out;
   output  reg                  rob_branch_mistakenB_out;
   output  reg                  rob_take_branchA_out;
   output  reg                  rob_take_branchB_out;
   output  reg                  rob_branch_still_takenA_out;
   output  reg                  rob_branch_still_takenB_out;
   output  reg       [63:0]     rob_PCA_out;
   output  reg       [63:0]     rob_target_PCA_out;
   output  reg       [63:0]     rob_PCB_out;
   output  reg       [63:0]     rob_target_PCB_out;
   output  reg                  rob_rs_halt_en;
   output  reg                  rob_stq_retire_en_out;

    reg                         rob_retireA_out; 
    reg     	                rob_retireB_out;
    reg                         rob_one_inst_out;
    reg                         rob_none_inst_out;
    reg    [`CDBWIDTH-1:0]      rob_ToldA_out;
    reg    [`CDBWIDTH-1:0]      rob_ToldB_out;
    reg    [`CDBWIDTH-1:0]      rob_TA_out;
    reg    [`CDBWIDTH-1:0]      rob_TB_out;

    reg              [4:0]      rob_logidxA_out;
    reg              [4:0]      rob_logidxB_out;
    reg              [4:0]      rob_dispidxA_out;
    reg              [4:0]      rob_dispidxB_out;

//TODO:
//output [`CDBWIDTH-1:0]	rob_TA_out; //Throw result physical register PR into arch map
//output [`CDBWIDTH-1:0]	rob_TB_out;


 // interal signals reg
   reg   [`CDBWIDTH-2:0]        head;             
   reg   [`CDBWIDTH-2:0]        tail;
   reg   [5:0]      T      [31:0] ;
   reg   [5:0]      next_T [31:0] ;
   reg   [5:0]      T_old  [31:0] ;
   reg   [5:0]   next_Told [31:0] ;
   reg              done   [31:0] ;
   reg           next_done [31:0] ;
   reg           next_done_1[31:0];
   reg   [4:0]  logdestIdx [31:0] ;
   reg   [4:0] next_logdestIdx[31:0];
   reg   [2:0]       stq_idx    [31:0];
   reg   [2:0]   next_stq_idx    [31:0];

   reg    [4:0] opcode [31:0];
   reg    [4:0] next_opcode [31:0];
   reg   [31:0] IR      [31:0];
   reg   [31:0] next_IR [31:0];
   reg   [63:0] PC      [31:0];
   reg   [63:0] next_PC [31:0];
   reg          mispredict [31:0];
   reg          next_mispredict[31:0]; 
   reg          wr_mem [31:0];
   reg          next_wr_mem[31:0];
   
   reg          branch_mistaken     [31:0];
   reg     next_branch_mistaken     [31:0];
   reg          taken_branch        [31:0];
   reg     next_taken_branch        [31:0];
   reg          branch_still_taken  [31:0];
   reg     next_branch_still_taken  [31:0];
   reg   [63:0] target_PC           [31:0];
   reg   [63:0] next_target_PC      [31:0];
                  
  
     
   reg   [5:0] i;
   
   wire                         tail_incr_two_en;           // enable_for_tail become two_plus
   wire                         tail_incr_one_en;          // enable_for_tail_become one_plus
   wire  [4:0]                  tail_plus_one;              
   wire  [4:0]                  tail_plus_two;

   reg                          head_incr_two_en;        // enable for head plus two
   reg                          head_incr_one_en;        // enable for head plus one
   wire  [`CDBWIDTH-2:0]        head_plus_one;
   wire  [`CDBWIDTH-2:0]        head_plus_two;                   

   reg    [1:0] state;               // state machine, the state is normal, almost_full and full, since number of freelist is the same as rob, empty is not needed
   reg    [1:0] next_state; 

   reg    [4:0] net_dis;         // it calculate the this cycle, after the head and tail movement, the distance of it. This is used to calculate the full or almost_full
   reg          reverse;         // this is used to calculate the distance. if the tail goes behind head, the distance is not the normal tail-head case. 
   reg          next_reverse;    //  just for reverse is right

   reg    [`CDBWIDTH-2:0]     next_tail;   // next_tail position
   reg    [`CDBWIDTH-2:0]     next_head;   // next_head position
   reg          tail_recovery_en;
   reg    [4:0]      counter;
   reg    [4:0]      next_counter;

   reg    [31:0]     valid, next_valid;
   reg               rob_stq_retire_en_out1;
   
   wire   branchA ;
  assign   branchA           = id_uncond_branchA | id_cond_branchA;
   wire   branchB ;
  assign   branchB          =  id_uncond_branchB | id_cond_branchB;

  assign   tail_incr_two_en = id_valid_instA & id_valid_instB;             
  assign   tail_incr_one_en = (id_valid_instA & !id_valid_instB); //| (!id_valid_instA & id_valid_instB);

  assign   tail_plus_one    = tail + 5'd1;
  assign   tail_plus_two    = tail + 5'd2;
  
  wire     head_minus_one;
  wire     head_minus_two;

  assign   head_minus_one = head - 5'd1;
  assign   head_minus_two = head - 5'd2;

  assign   head_plus_one    = head + 5'd1;
  assign   head_plus_two    = head + 5'd2;
  
  assign   rob_instA_en_out = id_valid_instA;
  assign   rob_instB_en_out = id_valid_instB;

  wire     judgement_1;
  assign   judgement_1 = (next_head < head) ? 1'b1: 1'b0;
  wire     judgement_2;
  assign   judgement_2 = (next_tail < tail) ? 1'b1: 1'b0;
  wire     notretire_head_stq_en; 
  assign   notretire_head_stq_en = ( next_wr_mem[head] && !next_wr_mem[head_plus_one] && ( mshr_full)) ? 1'b1 : 1'b0; //| ldq_rob_mem_req )) ? 1'b1 : 1'b0;
  wire     retire_two_en; 
  assign   retire_two_en = (valid[head] & valid[head_plus_one] & next_done[head] & next_done[head_plus_one] & (!next_mispredict[head] | !next_mispredict[head_plus_one])) ? 1'b1 : 1'b0;
  wire     retire_one_en;
  assign   retire_one_en = (valid[head] & (next_done[head]) & !(next_done[head] & next_done[head_plus_one]) & !next_mispredict[head] ) ? 1'b1: 1'b0;
  wire     rs_halt_en;
  assign   rs_halt_en = (( next_IR[head] == `HALT) & (counter == 0) & (next_valid[head] == 1'b1) ) ? 1'b1 : 1'b0;

  wire  judgement6;
  assign judgement6 = (next_wr_mem[head] == 1'b1) && (next_wr_mem[head_plus_one] == 1'b1) && !mshr_full  ; //&& !ldq_rob_mem_req; 
 
//  reg    [1:0]  flag;
  wire    [4:0] COUNTER_NUMBER ;

  assign    COUNTER_NUMBER = `MEM_LATENCY_IN_CYCLES + 5'd2;

  // determine reverse signal 
 
  always @*
  begin 
     next_reverse = reverse;
     if ( judgement_2 )
	   begin
	   next_reverse = 1'b1;
	   end 
	   else  if ((next_reverse == 1'b1) && judgement_1 )
	         begin
	         next_reverse = 1'b0;
  	         end
    if (tail_recovery_en)
      next_reverse = 1'b0;
 
   end 


  // determine about the distance signal
  always @* 
   begin
   net_dis =  5'b0;            // default value
   if (reverse == 1'b0)
   net_dis = next_tail - next_head;
   else  if ( reverse == 1'b1)
   net_dis = 5'b1111_1 - next_head + next_tail + 5'b0000_1; 
   end 


   // determine about next tail and next head logic

   always @*
   begin 
   next_tail = tail;
   next_head = head;

   if(tail_incr_two_en)
   next_tail = tail_plus_two;
   else if (tail_incr_one_en)
   next_tail = tail_plus_one;

   if (head_incr_two_en)
   next_head = head_plus_two;
   else if (head_incr_one_en)
   next_head = head_plus_one;
   
   if (tail_recovery_en)
   next_tail = next_head;

   end    

// determine the main state machine and the tail movement to give out the pointer postions. 
    always @*
    begin   

	  head_incr_two_en = 1'b0;
	  head_incr_one_en = 1'b0;
	  rob_retireA_out  = 1'b0;
	  rob_retireB_out  = 1'b0; 
            rob_ToldB_out  = 6'b0000_00;       
            rob_ToldA_out  = 6'b0000_00;
            rob_TA_out     = 6'b0000_00;
            rob_TB_out     = 6'b0000_00;
          rob_logidxA_out  = 5'd0;
          rob_logidxB_out  = 5'd0;           
          rob_branch_idxA  = 5'd0;
          rob_branch_idxB  = 5'd0;
       rob_retireIdxA_out  = 5'd0;  
    rob_branch_retire_out  = 1'b0;
        tail_recovery_en   = 1'b0;
          rob_rs_halt_en   = 1'b0;
       rob_stq_retire_en_out1   = 1'b0;

    rob_branch_mistakenA_out = 1'b0;
     rob_branch_mistakenB_out = 1'b0;
     rob_take_branchA_out  = 1'b0;
     rob_take_branchB_out  = 1'b0;
     rob_branch_still_takenA_out = 1'b0;
     rob_branch_still_takenB_out = 1'b0;
     rob_PCA_out           = 64'd0;
     rob_PCB_out           = 64'd0;
     rob_target_PCA_out    = 64'd0;
     rob_target_PCB_out    = 64'd0;
           next_counter    = counter - 5'b1;
            next_valid = valid;

   for (i = 0; i < 'd32; i = i+1)
   begin 
	        next_done[i] = done[i];
              next_done_1[i] = done[i];
	  next_mispredict[i] = mispredict[i];
     next_branch_mistaken[i] = branch_mistaken[i];
        next_taken_branch[i] = taken_branch[i];  
  next_branch_still_taken[i] = branch_still_taken[i];
           next_target_PC[i] = target_PC[i];
                  next_PC[i] = PC[i];
   end 

    for (i=0; i< 'd32; i = i+1)
    begin
             next_T[i]      = T[i];
          next_Told[i]      = T_old[i];
    next_logdestIdx[i]      = logdestIdx[i];
        next_opcode[i]      = opcode[i];
            next_IR[i]      = IR[i];
        next_wr_mem[i]      = wr_mem[i];
       next_stq_idx[i]      = stq_idx[i];
    end

      if (ex_cm_cdbA_rdy)
        begin
               next_done[ex_cm_robAIdx] = 1'b1;
    next_branch_mistaken[ex_cm_robAIdx] = ex_branch_mistakenA;    
       next_taken_branch[ex_cm_robAIdx] = ex_take_branchA; 
 next_branch_still_taken[ex_cm_robAIdx] = ex_branch_still_takenA;
          next_target_PC[ex_cm_robAIdx] = ex_target_PCA;         

          if (ex_set_mispredictA)
        next_mispredict[ex_cm_robAIdx]  = 1'b1;
         end 
      
      if (ex_cm_cdbB_rdy)
        begin
               next_done[ex_cm_robBIdx] = 1'b1;
    next_branch_mistaken[ex_cm_robBIdx] = ex_branch_mistakenB;
       next_taken_branch[ex_cm_robBIdx] = ex_take_branchB;   
 next_branch_still_taken[ex_cm_robBIdx] = ex_branch_still_takenB;
          next_target_PC[ex_cm_robBIdx] = ex_target_PCB;

      if (ex_set_mispredictB)
        next_mispredict[ex_cm_robBIdx] = 1'b1;
        end 
    
      if (ex_cm_cdbC_rdy)
        next_done[ex_cm_robCIdx] = 1'b1;

      if (ex_cm_cdbD_rdy)
        next_done[ex_cm_robDIdx] = 1'b1;

           
//             if (next_done[head] & next_done[head_plus_one] & (!next_mispredict[head] | !next_mispredict[head_plus_one]))
               if (retire_two_en)
 		  begin
                          next_valid[head] = 0;
                          next_valid[head_plus_one] = 0;
			  head_incr_two_en = 1'b1;
      			  head_incr_one_en = 1'b0;
		       	   rob_retireA_out = 1'b1;
	      		   rob_retireB_out = 1'b1;
			     rob_ToldA_out = T_old[head];
			     rob_ToldB_out = T_old[head_plus_one];
	                        rob_TA_out = T[head];
	                        rob_TB_out = T[head_plus_one];

	          rob_branch_mistakenA_out = branch_mistaken[head];
	          rob_branch_mistakenB_out = branch_mistaken[head_plus_one];
	              rob_take_branchA_out = taken_branch[head];
	              rob_take_branchB_out = taken_branch[head_plus_one];
	       rob_branch_still_takenA_out = branch_still_taken[head];
	       rob_branch_still_takenB_out = branch_still_taken[head_plus_one];
	       rob_target_PCA_out          = target_PC[head];      
	       rob_target_PCB_out          = target_PC[head_plus_one];
	       rob_PCA_out                 = PC [head];
	       rob_PCB_out                 = PC [head_plus_one];
	                   rob_logidxA_out = logdestIdx[head];
	                   rob_logidxB_out = logdestIdx[head_plus_one];    

                       if (next_wr_mem[head] | next_wr_mem[head_plus_one])  
                            begin
                            rob_stq_retire_en_out1 = 1'b1;
                            end 

                    // if ((next_wr_mem[head] == 1'b1) & (next_wr_mem[head_plus_one] == 1'b1) & !mshr_full & !ldq_rob_mem_req  )
                       if(judgement6)    // this is the case where two stq is there
                            begin

                              if ((mem_stq_idx == next_stq_idx[head]) & mem_grant & !mshr_full)
                               begin
                              head_incr_two_en = 1'b0;
                              head_incr_one_en = 1'b1;
                              next_valid[head] = 0;
                              next_valid[head_plus_one] = 1;
                              rob_retireA_out  = 1'b1;
                               rob_retireB_out = 1'b0;
                                 rob_ToldA_out = T_old[head];
                                    rob_TA_out = T[head];
                             rob_logidxA_out   = logdestIdx[head];

                          rob_branch_mistakenA_out = branch_mistaken[head];
                          rob_branch_mistakenB_out = branch_mistaken[head_plus_one];
                              rob_take_branchA_out = taken_branch[head];
                              rob_take_branchB_out = taken_branch[head_plus_one];
                       rob_branch_still_takenA_out = branch_still_taken[head];
                       rob_branch_still_takenB_out = branch_still_taken[head_plus_one];
                       rob_target_PCA_out          = target_PC[head];
                       rob_target_PCB_out          = target_PC[head_plus_one];
                       rob_PCA_out                 = PC [head];
                       rob_PCB_out                 = PC [head_plus_one];
                                   rob_logidxA_out = logdestIdx[head];
                             rob_stq_retire_en_out1 = 1'b0;
                               end
                              else begin
                                   head_incr_two_en = 1'b0;
                                   head_incr_one_en = 1'b0;
                                   next_valid[head] = 1'b1;
                          next_valid[head_plus_one] = 1'b1;
                                  rob_retireA_out   = 1'b0;
                                  rob_retireB_out   = 1'b0;
                             rob_stq_retire_en_out1 = 1'b1;
                                   end 
                             end 

                            else if (next_wr_mem[head] && next_wr_mem[head_plus_one] && mshr_full)
                                   begin
                                   head_incr_two_en = 1'b0;
                                   head_incr_one_en = 1'b0;
                                   next_valid[head] = 1'b1;
                          next_valid[head_plus_one] = 1'b1;
                                  rob_retireA_out   = 1'b0;
                                  rob_retireB_out   = 1'b0;
                             rob_stq_retire_en_out1 = 1'b0;
                                   end 

                            else if ( next_wr_mem[head] && !next_wr_mem[head_plus_one] && !mshr_full )        // this is the case where the first is the stq
                                     begin 
                                        if ((mem_stq_idx == next_stq_idx[head]) & mem_grant)        
                                           begin                                           
		                              head_incr_two_en = 1'b0;	
			                      head_incr_one_en = 1'b1;
		                              next_valid[head] = 0;
		                              next_valid[head_plus_one] = 1;
		                              rob_retireA_out  = 1'b1;
		                              rob_retireB_out  = 1'b0;
                                       rob_stq_retire_en_out1  = 1'b0;
                                            end 
                                         else begin
                                              head_incr_two_en = 1'b0;
                                              head_incr_one_en = 1'b0;
                                              next_valid[head] = 1;
                                              next_valid[head_plus_one] = 1;
                                              rob_retireA_out  = 1'b0;
                                              rob_retireB_out  = 1'b0;
                                       rob_stq_retire_en_out1  = 1'b1;
                                              end 
                                      end 
                             else if ( !next_wr_mem[head] && next_wr_mem[head_plus_one] && !mshr_full)       // this is the case where the second is the stq
                                       begin
                                           if ((mem_stq_idx == next_stq_idx[head_plus_one]) & mem_grant) 
                                              begin
                                              head_incr_two_en = 1'b1;                         
                                              head_incr_one_en = 1'b0;
                                              next_valid[head] = 0;
                                              next_valid[head_plus_one] = 0;
                                              rob_retireA_out  = 1'b1;
                                              rob_retireB_out  = 1'b1;
                                       rob_stq_retire_en_out1  = 1'b0;
                                              end
                                         else begin
                                              head_incr_two_en = 1'b0;
                                              head_incr_one_en = 1'b1;
                                              next_valid[head] = 0;
                                              next_valid[head_plus_one] = 1;
                                              rob_retireA_out  = 1'b1;
                                              rob_retireB_out  = 1'b0;
                                       rob_stq_retire_en_out1  = 1'b1;
                                              end
                                        end 

                         if ( notretire_head_stq_en)                 ///   this is for the situation that head = stall and is not premitted
                              begin
                              head_incr_two_en = 1'b0;
                              head_incr_one_en = 1'b0;
                              next_valid[head] = 1;
                              next_valid[head_plus_one] = 1;
                              rob_retireA_out  = 1'b0;
                               rob_retireB_out = 1'b0;
                                 rob_ToldA_out = T_old[head];
                                    rob_TA_out = T[head];
                             rob_logidxA_out   = logdestIdx[head];

		          rob_branch_mistakenA_out = branch_mistaken[head];
		          rob_branch_mistakenB_out = branch_mistaken[head_plus_one];
		              rob_take_branchA_out = taken_branch[head];
		              rob_take_branchB_out = taken_branch[head_plus_one];
		       rob_branch_still_takenA_out = branch_still_taken[head];
		       rob_branch_still_takenB_out = branch_still_taken[head_plus_one];
		       rob_target_PCA_out          = target_PC[head];
		       rob_target_PCB_out          = target_PC[head_plus_one];
		       rob_PCA_out                 = PC [head];
		       rob_PCB_out                 = PC [head_plus_one];
                                   rob_logidxA_out = logdestIdx[head];  
                             rob_stq_retire_en_out1 = 1'b0;  
                               end

                         else     if ( !next_wr_mem[head] &&  next_wr_mem[head_plus_one] &&  mshr_full )
	                              begin
	                              head_incr_two_en = 1'b0;
	                              head_incr_one_en = 1'b1;   
                                      next_valid[head] = 1'b0;
                                     next_valid[head_plus_one] = 1;
	                              rob_retireA_out  = 1'b1;
	                               rob_retireB_out = 1'b0;
	                                 rob_ToldA_out = T_old[head];
	                                    rob_TA_out = T[head];
	                             rob_logidxA_out   = logdestIdx[head];

			          rob_branch_mistakenA_out = branch_mistaken[head];
			          rob_branch_mistakenB_out = branch_mistaken[head_plus_one];
			              rob_take_branchA_out = taken_branch[head];
			              rob_take_branchB_out = taken_branch[head_plus_one];
	                       rob_branch_still_takenA_out = branch_still_taken[head];
			       rob_branch_still_takenB_out = branch_still_taken[head_plus_one];
			       rob_target_PCA_out          = target_PC[head];
			       rob_target_PCB_out          = target_PC[head_plus_one];
	         	       rob_PCA_out                 = PC [head];
			       rob_PCB_out                 = PC [head_plus_one];
	                                   rob_logidxA_out = logdestIdx[head];
	                            rob_stq_retire_en_out1 = 1'b0;
	                               end 
  		  end 

//                 else   if ((next_done[head]) & !(next_done[head] & next_done[head_plus_one]) & !next_mispredict[head] )
	                   else   if (retire_one_en)
            		          begin
				          head_incr_one_en = 1'b1;
		    		          head_incr_two_en = 1'b0;
		                         next_valid[head] = 0;
		                         next_valid[head_plus_one] = 1;
		 		           rob_retireA_out = 1'b1;
		  		           rob_retireB_out = 1'b0;
		       		             rob_ToldA_out = T_old[head];
		                                rob_TA_out = T[head];
		                         rob_logidxA_out   = logdestIdx[head];
	
			          rob_branch_mistakenA_out = branch_mistaken[head];
			          rob_branch_mistakenB_out = branch_mistaken[head_plus_one];
			              rob_take_branchA_out = taken_branch[head];
			              rob_take_branchB_out = taken_branch[head_plus_one];
			       rob_branch_still_takenA_out = branch_still_taken[head];
			       rob_branch_still_takenB_out = branch_still_taken[head_plus_one];
			       rob_target_PCA_out          = target_PC[head];    
			       rob_target_PCB_out          = target_PC[head_plus_one];
			       rob_PCA_out                 = PC [head];
			       rob_PCB_out                 = PC [head_plus_one];
                            //rob_stq_retire_en_out = 1'b1;


	                         if ((next_wr_mem[head] == 1'b1) & !mshr_full )
	                               begin
	                               rob_stq_retire_en_out1 = 1'b1;

	                               if ((mem_stq_idx == next_stq_idx[head]) & mem_grant)
	                                  begin
	                                  rob_stq_retire_en_out1 = 1'b0;
	                                  end 
	                               else    begin
			                          head_incr_one_en = 1'b0;
			                          head_incr_two_en = 1'b0;
			                          next_valid[head] = 1;
			                         next_valid[head_plus_one] = 1;
			                           rob_retireA_out = 1'b0;
			                           rob_retireB_out = 1'b0;
	                                       end 
	                               end 
                         

	                         if ((next_wr_mem[head] == 1'b1) & ( mshr_full ))
	                               begin
	                              head_incr_two_en = 1'b0;
	                              head_incr_one_en = 1'b0;
	                              next_valid[head] = 1;
	                              next_valid[head_plus_one] = 1;
	                              rob_retireA_out  = 1'b0;
	                               rob_retireB_out = 1'b0;
	                                 rob_ToldA_out = T_old[head];
	                                    rob_TA_out = T[head];
	                             rob_logidxA_out   = logdestIdx[head];
	
			          rob_branch_mistakenA_out = branch_mistaken[head];
			          rob_branch_mistakenB_out = branch_mistaken[head_plus_one];
			              rob_take_branchA_out = taken_branch[head];
			              rob_take_branchB_out = taken_branch[head_plus_one];
			       rob_branch_still_takenA_out = branch_still_taken[head];
			       rob_branch_still_takenB_out = branch_still_taken[head_plus_one];
			       rob_target_PCA_out          = target_PC[head];
			       rob_target_PCB_out          = target_PC[head_plus_one];
			       rob_PCA_out                 = PC [head];
			       rob_PCB_out                 = PC [head_plus_one];

	                                       rob_logidxA_out = logdestIdx[head];
	                                 rob_stq_retire_en_out1 = 1'b0;
                                      end

              	      end 
                  
                                  if (rs_halt_en)
                                   rob_rs_halt_en = 1'b1;                              
      
       ////////////////////////////////////////////////////this following is
       //the case then branch is retired 
       ////////////////////////////////////////////////////////
              if ( valid[head] & next_done[head] & !(next_done[head] & next_done[head_plus_one]) & next_mispredict[head] )  //  this is the case there the head is a branch
 //             if (  next_done[head] & !(next_done[head] & next_done[head_plus_one]) & next_mispredict[head] )
                       begin 
                          head_incr_one_en = 1'b1;
                          head_incr_two_en = 1'b0;
                          next_valid[head] = 0;
                          next_valid[head_plus_one] = 1;
                           rob_retireA_out = 1'b1;
                           rob_retireB_out = 1'b0;
                             rob_ToldA_out = T_old[head];
                                rob_TA_out = T[head];
                         rob_logidxA_out   = logdestIdx[head];
                        rob_retireIdxA_out = head;                          
                     rob_branch_retire_out = 1'b1;
                        tail_recovery_en   = 1'b1;

          rob_branch_mistakenA_out = next_branch_mistaken[head];
          rob_branch_mistakenB_out = next_branch_mistaken[head_plus_one];
              rob_take_branchA_out = next_taken_branch[head];
              rob_take_branchB_out = next_taken_branch[head_plus_one];
       rob_branch_still_takenA_out = next_branch_still_taken[head];
       rob_branch_still_takenB_out = next_branch_still_taken[head_plus_one];
       rob_target_PCA_out          = next_target_PC[head];    
       rob_target_PCB_out          = next_target_PC[head_plus_one];
       rob_PCA_out                 = PC [head];
       rob_PCB_out                 = PC [head_plus_one];

                        end

              if ( valid[head] & valid[head_plus_one] & next_done[head] & next_done[head_plus_one] & next_mispredict[head]) 
//              if (  next_done[head] & next_done[head_plus_one] & next_mispredict[head])    // this is like the head is a branch and the head_plus_one is a halt 
                        begin
                          head_incr_one_en = 1'b1;
                          head_incr_two_en = 1'b0;
                          next_valid[head] = 0;
                          next_valid[head_plus_one] = 1; 
                           rob_retireA_out = 1'b1;
                           rob_retireB_out = 1'b0;
                             rob_ToldA_out = T_old[head];
                                rob_TA_out = T[head];
                         rob_logidxA_out   = logdestIdx[head];
                        rob_retireIdxA_out = head;
                     rob_branch_retire_out = 1'b1;
                       tail_recovery_en    = 1'b1;

          rob_branch_mistakenA_out = next_branch_mistaken[head];
          rob_branch_mistakenB_out = next_branch_mistaken[head_plus_one];
              rob_take_branchA_out = next_taken_branch[head];
              rob_take_branchB_out = next_taken_branch[head_plus_one];
       rob_branch_still_takenA_out = next_branch_still_taken[head];
       rob_branch_still_takenB_out = next_branch_still_taken[head_plus_one];
       rob_target_PCA_out          = next_target_PC[head];    
       rob_target_PCB_out          = next_target_PC[head_plus_one];
       rob_PCA_out                 = PC [head];
       rob_PCB_out                 = PC [head_plus_one];


                        end

          if ( valid[head] & valid[head_plus_one] & next_done[head] & next_done[head_plus_one] & (!next_mispredict[head] & next_mispredict[head_plus_one]) )
//          if (  next_done[head] & next_done[head_plus_one] & (!next_mispredict[head] & next_mispredict[head_plus_one]) )
                        begin
                          head_incr_one_en = 1'b0;
                          head_incr_two_en = 1'b1;
                          next_valid[head] = 0;
                          next_valid[head_plus_one] = 0;

                           rob_retireA_out = 1'b1;
                           rob_retireB_out = 1'b1;
                             rob_ToldA_out = T_old[head];
                             rob_ToldB_out = T_old[head_plus_one];
                                rob_TA_out = T[head];
                                rob_TB_out = T[head_plus_one];
                         rob_logidxA_out   = logdestIdx[head];
                         rob_logidxB_out   = logdestIdx[head_plus_one];
                        rob_retireIdxA_out = head_plus_one;
                     rob_branch_retire_out = 1'b1;
                      tail_recovery_en     = 1'b1;

          rob_branch_mistakenA_out = next_branch_mistaken[head];
          rob_branch_mistakenB_out = next_branch_mistaken[head_plus_one];
              rob_take_branchA_out = next_taken_branch[head];
              rob_take_branchB_out = next_taken_branch[head_plus_one];
       rob_branch_still_takenA_out = next_branch_still_taken[head];
       rob_branch_still_takenB_out = next_branch_still_taken[head_plus_one];
       rob_target_PCA_out          = next_target_PC[head];    
       rob_target_PCB_out          = next_target_PC[head_plus_one];
       rob_PCA_out                 = PC [head];
       rob_PCB_out                 = PC [head_plus_one];

                         end 

            if (valid[head] & valid[head_plus_one] & next_done[head] & next_done[head_plus_one] & (!next_mispredict[head] & next_mispredict[head_plus_one]) & next_wr_mem[head] & (!mem_grant | (mem_stq_idx != next_stq_idx[head])))
                             begin
                                                 head_incr_one_en = 1'b0;
                                                  head_incr_two_en = 1'b0;
                                                  next_valid[head] = 1;
                                                 next_valid[head_plus_one] = 1;
                                                   rob_retireA_out = 1'b0;
                                                   rob_retireB_out = 1'b0;
                                                 rob_branch_retire_out = 1'b0;
                                                 tail_recovery_en      = 1'b0;
                              end 
                                 
   else         if ( valid[head] & valid[head_plus_one] & next_done[head] & next_done[head_plus_one] & (!next_mispredict[head] & next_mispredict[head_plus_one]) & mem_grant & (mem_stq_idx == next_stq_idx[head]) & next_wr_mem[head])
                        begin
                          head_incr_one_en = 1'b1;
                          head_incr_two_en = 1'b0;
                          next_valid[head] = 0;
                          next_valid[head_plus_one] = 1;
                           rob_retireA_out = 1'b1;
                           rob_retireB_out = 1'b0;
                             rob_ToldA_out = T_old[head];
                                rob_TA_out = T[head];
                         rob_logidxA_out   = logdestIdx[head];
                     rob_branch_retire_out = 1'b0;
                       tail_recovery_en    = 1'b0;

          rob_branch_mistakenA_out = next_branch_mistaken[head];
          rob_branch_mistakenB_out = next_branch_mistaken[head_plus_one];
              rob_take_branchA_out = next_taken_branch[head];
              rob_take_branchB_out = next_taken_branch[head_plus_one];
       rob_branch_still_takenA_out = next_branch_still_taken[head];
       rob_branch_still_takenB_out = next_branch_still_taken[head_plus_one];
       rob_target_PCA_out          = next_target_PC[head];
       rob_target_PCB_out          = next_target_PC[head_plus_one];
       rob_PCA_out                 = PC [head];
       rob_PCB_out                 = PC [head_plus_one];


                        end

           /// ////////////////main state machine and the tail movement 
           //
		                  next_T[tail]  = T[tail];
		         next_logdestIdx[tail]  = logdestIdx[tail];
		  next_logdestIdx[tail_plus_one] = logdestIdx[tail_plus_one];
		         next_T[tail_plus_one]  = T[tail_plus_one];
		              rob_dispidxA_out  = 5'b0000_0;
		              rob_dispidxB_out  = 5'b0000_0;


		            rob_none_inst_out = 1'b0;
		            rob_one_inst_out  = 1'b0;

		              if (tail_incr_two_en)
		                 begin  
		                     next_valid[tail] = 1;
		                    next_valid[tail_plus_one] = 1;

		                     next_T[tail]  = fl_TA;
		                  next_Told[tail]  = mt_ToldA;
		            next_T[tail_plus_one]  = fl_TB;
		         next_Told[tail_plus_one]  = mt_ToldB;
		            next_logdestIdx[tail]  = id_logdestAIdx;
		   next_logdestIdx[tail_plus_one]  = id_logdestBIdx;
		                next_opcode[tail]  = id_opcodeA;
		       next_opcode[tail_plus_one]  = id_opcodeB;
		                    next_IR[tail]  = id_IRA;
		           next_IR[tail_plus_one]  = id_IRB;
		                next_wr_mem[tail]  = id_wr_memA;
		       next_wr_mem[tail_plus_one]  = id_wr_memB;
		                    next_PC[tail]  = id_PCA;
		           next_PC[tail_plus_one]  = id_PCB;
		                  next_done[tail]  = 1'b0;
		         next_done[tail_plus_one]  = 1'b0;
		            next_mispredict[tail]  = 1'b0;
		   next_mispredict[tail_plus_one]  = 1'b0;
		               next_stq_idx[tail]  = stq_idxA;
		      next_stq_idx[tail_plus_one]  = stq_idxB;

		       next_branch_mistaken[tail]  = 1'b0;
		  next_branch_mistaken[tail_plus_one] = 1'b0;
		           next_taken_branch[tail]  = 1'b0;
		  next_taken_branch[tail_plus_one]  = 1'b0;
		    next_branch_still_taken[tail]  = 1'b0;
		  next_branch_still_taken[tail_plus_one] = 1'b0;

		                 rob_dispidxA_out  = tail;
		                 rob_dispidxB_out  = tail_plus_one; 

		                 if (branchA)
		                 rob_branch_idxA   = tail;
		                 if (branchA & branchB)
		                 rob_branch_idxB   = tail_plus_one;
		                 if (!branchA & branchB)
		                 rob_branch_idxB   = tail_plus_one;        
		               end 
		            else if (tail_incr_one_en)
		                  begin
		                  next_valid[tail] = 1;

		                 next_T[tail]   =  fl_TA;
		              next_Told[tail]   =  mt_ToldA;
		        next_logdestIdx[tail]   =  id_logdestAIdx;      
		            next_opcode[tail]   =  id_opcodeA;
		                next_IR[tail]   =  id_IRA;
		            next_wr_mem[tail]   =  id_wr_memA;
		                next_PC[tail]   =  id_PCA;
		              next_done[tail]   =  1'b0;
		             rob_dispidxA_out   =  tail;
		        next_mispredict[tail]   =  1'b0;

		               next_stq_idx[tail]  = stq_idxA;
		       next_branch_mistaken[tail]  = 1'b0;
		          next_taken_branch[tail]  = 1'b0;
		    next_branch_still_taken[tail]  = 1'b0;


		                 if (branchA)
		                 rob_branch_idxA = tail;
                 
		                  end                   

		            if ((net_dis == 5'b0000_0) & next_reverse)
		                   begin
		                   rob_none_inst_out = 1'b1;
		                   rob_one_inst_out  = 1'b0;
		                   end 
		                   else if (net_dis == 5'b1111__1)
		                   begin
		                   rob_one_inst_out  = 1'b1;
		                   rob_none_inst_out = 1'b0;  
		                   end               
          end 
 
//////////////////////////////////////////sequential logic


  always @(posedge clock)                    // sequential logic
    begin 
	     if (reset)
             begin 
    		 for(i=0; i < 'd32; i=i+1)
    		 begin
    		   done[i] <= `SD 1'b0;
             mispredict[i] <= `SD 1'b0;
        branch_mistaken[i] <= `SD 1'b0;
           taken_branch[i] <= `SD 1'b0;
     branch_still_taken[i] <= `SD 1'b0;
          wr_mem[i]	   <= `SD 0;
         rob_stq_retire_en_out <= `SD 0;
    		 end 
                    valid <= `SD 0;
	    	    head   <=  `SD 5'b0000_0;
	 	    tail   <=  `SD 5'b0000_0;     
	 	    state  <=  `SD `NORMAL; 
      		 reverse   <=  `SD 1'b0;
                    end 
     else 
          begin  
//       rob_stq_retire_en_out <=  `SD rob_stq_retire_en_out1;
 		    head     <=  `SD next_head;
		    tail     <=  `SD next_tail;
//       	            state    <=  `SD next_state;
	      	  	    T[tail]  <=  `SD next_T[tail];
	      	   T[tail_plus_one]  <=  `SD next_T[tail_plus_one];  
	                T_old[tail]  <=  `SD next_Told[tail];
	       T_old[tail_plus_one]  <=  `SD next_Told[tail_plus_one];
	           logdestIdx[tail]  <=  `SD next_logdestIdx[tail];
	  logdestIdx[tail_plus_one]  <=  `SD next_logdestIdx[tail_plus_one];
	               opcode[tail]  <=  `SD next_opcode[tail];
	      opcode[tail_plus_one]  <=  `SD next_opcode[tail_plus_one];      
	                   IR[tail]  <=  `SD next_IR[tail];
	          IR[tail_plus_one]  <=  `SD next_IR[tail_plus_one];
	               wr_mem[tail]  <=  `SD next_wr_mem[tail];
	      wr_mem[tail_plus_one]  <=  `SD next_wr_mem[tail_plus_one];
	                   PC[tail]  <=  `SD next_PC[tail];
	          PC[tail_plus_one]  <=  `SD next_PC[tail_plus_one];
	              stq_idx[tail]  <=  `SD next_stq_idx[tail];
             stq_idx[tail_plus_one]  <=  `SD next_stq_idx[tail_plus_one];
             
              if (tail_recovery_en)
              begin
                 for (i=0; i < 'd32;i=i+1)
                   begin
                   done[i] <= `SD 1'b0;
             mispredict[i] <= `SD 1'b0;
//                   valid   <= `SD 32'b0;
                    end 
                        valid <= `SD 32'd0;
        rob_stq_retire_en_out <= `SD 1'b0;
               end 
              else                 
               begin
                 for (i=0; i < 'd32;i=i+1)
                   begin
                   done[i] <= `SD next_done[i];
             mispredict[i] <= `SD next_mispredict[i];
        rob_stq_retire_en_out <= rob_stq_retire_en_out1;
//                   valid   <= `SD next_valid;
                   end 
                  valid    <= `SD next_valid;
                end 

               for(i=0; i<'d32; i=i+1)
       	       begin
//	       		   done[i] <= `SD next_done[i]; 
//	             mispredict[i] <= `SD next_mispredict[i];
	        branch_mistaken[i] <= `SD next_branch_mistaken[i];            
                   taken_branch[i] <= `SD next_taken_branch[i];
             branch_still_taken[i] <= `SD next_branch_still_taken[i];
                      target_PC[i] <= `SD next_target_PC[i];
               end 
      	   	   reverse <= `SD next_reverse;
       end 
    end 

  always @(posedge clock)
  begin
    if(reset | rob_stq_retire_en_out1 )
    begin
      counter <= `SD COUNTER_NUMBER;
    end
    else if (( IR[head] == `HALT) & (wr_mem[head_minus_one] != 1'b1 ))
         begin
         counter <= `SD 5'b0;
         end 
    else
    begin
     counter <= `SD next_counter;
    end
  end
endmodule
