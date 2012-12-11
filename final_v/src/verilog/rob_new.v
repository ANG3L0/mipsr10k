`define CDBWIDTH 6
`define SD      #1
`define  NORMAL  2'b00
`define  ALMOST_FULL  2'b01
`define  FULL    2'b10
`define  DEFAULT  2'b11
`define  NONE_READY   2'b00
`define  CDB_AREADY   2'b10
`define  CDB_BREADY   2'b01
`define  BOTH_READY   2'b11
`define  STORE        6'b000000
`timescale 1ns/100ps
module rob(
	//inputs
	clock,
	reset,
      
        if_id_NPCA,
        if_id_NPCB,

        if_id_IRA,
        if_id_IRB,
	
	mt_ToldA,
	mt_ToldB,
	mt_ToldA_idx,
        mt_ToldB_idx,

	fl_TA,
	fl_TB,
           
        id_valid_IRA,
        id_valid_IRB,
        id_opcodeA,
        id_opcodeB,

        ex_cdbA_rdy,
        ex_cdbB_rdy,
        ex_cdbC_rdy,
        ex_cdbD_rdy,

	ex_cdbAIdx,
	ex_cdbBIdx,
	ex_cdbCIdx,
	ex_cdbDIdx,
        //ex_ALU_rdy,
        //ex_LD_STR_rdy,
        //ex_Mult_rdy,

        //rs_idxA,
        //rs_idxB,
        //rs_full,
        //rs_almost_full,
        //rs_ready_A,
        //rs_ready_B,
        //rs_ready_Aidx,
        //rs_ready_Bidx,


//        ex_cm_cdbAIdx_lr,
//        ex_cm_cdbBIdx_lr,

	//TODO: br_recover; recover branches later
	//TODO: recover ports to freelist?

	//outputs
	rob_ToldA_out,
	rob_ToldB_out,
        
	rob_retireA_en_out,
        rob_retireB_en_out,
        
        //rob_one_inst_out,
        //rob_none_inst_out,

        rob_IRA_en_out,
        rob_IRB_en_out,
        
       // rob_idxA_out,        
        //rob_idxB_out,

        rob_idx_A,
        rob_idx_B,
        rob_full,
        rob_almost_full,
        rob_empty,
        rob_head,
        rob_tail 

	//rob_TA_out,
        //rob_TB_out

);
///////////////////////////////////////////////
//                                           //
//                  inputs                   //
//                                           //
///////////////////////////////////////////////                                           
   input                        clock;
   input                        reset;

//Inputs from IF/ID pipe
   input          [63:0]        if_id_NPCA;
   input          [63:0]        if_id_NPCB;  
   input          [31:0]        if_id_IRA;
   input          [31:0]        if_id_IRB;     
 
//Inputs from decoder  
   input                        id_valid_IRA;
   input                        id_valid_IRB;
   input          [4:0]         id_opcodeA; //The operation code of instruction A, check it when execute
   input          [4:0]         id_opcodeB; //The operation of instruction B

//Dispatch: inputs from Map Table
   input [`CDBWIDTH-1:0]	mt_ToldA; //update the Told field from map table during dispatch
   input [`CDBWIDTH-1:0]	mt_ToldB; //update the Told field from map table during dispatch (superscalar)
   input           [4:0]        mt_ToldA_idx;
   input           [4:0]        mt_ToldB_idx;

//Dispatch: inputs from freelist 
   input [`CDBWIDTH-1:0]	fl_TA; //update the T values from free list during dispatch 
   input [`CDBWIDTH-1:0]	fl_TB; //update the T values from free list during dispatch (superscalar)

//Dispatch: get the index signal 
//   input           [2:0]        rs_idxA;//the index of the Instruction A in RS, which will be output when execute  
//   input           [2:0]        rs_idxB;
//   input                        rs_full;
//   input                        rs_almost_full;        
   
//??Issue/Execute: get the ready signal from RS
//   input           [5:0]        rs_ready_Aidx; //If both source value are ready, send the rob_idx save in RS to ROB
//   input           [5:0]        rs_ready_Bidx;       
//   input                        rs_ready_A;    //the valid bit to show the instruction can be issued.
//   input                        rs_ready_B;

//between Issue & Execute: get done signal from execute stage, to find if the ALU, Load,
//Multiplier is available, if ready, then execute
//   input           [1:0]        ex_ALU_rdy;//signal to show whether the ALU is busy, ALU[1]=1 means ALU_A is ready
//   input           [1:0]        ex_LD_STR_rdy; 
//   input           [1:0]        ex_Mult_rdy;  

//Execute/Completement: get signal from CDB[4:0]: the done index                        
   input [`CDBWIDTH-2:0]	ex_cdbAIdx; //the index of the instruction of the ROB
   input [`CDBWIDTH-2:0]	ex_cdbBIdx; //get CDB value from ex_complete register so I know to complete an instruction (suppa scalar)
   input [`CDBWIDTH-2:0]	ex_cdbCIdx; //the index of the instruction of the ROB
   input [`CDBWIDTH-2:0]	ex_cdbDIdx; 

   input                        ex_cdbA_rdy;
   input                        ex_cdbB_rdy;
   input                        ex_cdbC_rdy;
   input                        ex_cdbD_rdy;

//   input [`CDBWIDTH-2:0]        ex_cm_cdbAIdx_lr;
//   input [`CDBWIDTH-2:0]        ex_cm_cdbBIdx_lr;

//////////////////////////////////////////////////////////
//                                                      //
//                     outputs                          //
//                                                      //
//////////////////////////////////////////////////////////                                                      

//Dispatch: output to RS, to do the priority selector and RS can send it back
//to ROB. so that ROB knows when to execute and which instruction will go to
//execute
   output       reg    [4:0]        rob_idx_A;
   output       reg    [4:0]        rob_idx_B;
   output              [4:0]        rob_head;
   output              [4:0]        rob_tail;

//output to PC
   output                           rob_full;
   output                           rob_almost_full;    
   output                           rob_empty;
   
//Retirement: output to free list
   output [`CDBWIDTH-1:0]	rob_ToldA_out;      //return Told value(s) to free list during retirement
   output [`CDBWIDTH-1:0]	rob_ToldB_out; 
   output                       rob_retireA_en_out; //Tells freelist when a retirement party is going on so it can absorb PR values from TOld
   output                       rob_retireB_en_out;


   output                       rob_IRA_en_out;
   output                       rob_IRB_en_out;

///////////////////////////////////////////////////////////////
//                                                           //
//                 Internal Registers                        //
//                                                           //
///////////////////////////////////////////////////////////////  
//valid reg
   reg            [31:0]        valid, next_valid; //next_valid1;//modified CYC

//PC Reg
   reg            [63:0]        rob_PC [31:0];
   reg            [63:0]        next_rob_PC [31:0];
//Instruction Reg
   reg            [31:0]        rob_IR [31:0];
   reg            [31:0]        next_rob_IR [31:0];
//Opcode Reg
   reg             [4:0]        rob_opcode[31:0];
   reg             [4:0]        next_rob_opcode [31:0];

//Execute
//   reg                          execute [31:0];
//   reg                          next_execute [31:0];

//Complete
   reg                          complete [31:0];
   reg                          next_complete [31:0];

//Reg for T and Told
   reg             [5:0]        T      [31:0] ;
   reg             [5:0]        next_T [31:0] ;
   reg             [5:0]        T_old  [31:0] ;
   reg             [5:0]        next_Told [31:0];

//Reg to store the index of the instructions in RS 
//   reg             [2:0]        rs_index [31:0];     

//Reg to store the archetecture register number
//   reg             [4:0]        AR_No [31:0];             

// Show if there is valid retirement
   reg                          rob_retireA_en_out; 
   reg     	                rob_retireB_en_out;
   reg    [`CDBWIDTH-1:0]       rob_ToldA_out;
   reg    [`CDBWIDTH-1:0]       rob_ToldB_out;

  // reg              [4:0]       rob_dispidxA_out;
  // reg              [4:0]       rob_dispidxB_out;

// head & tail pointer
   reg   [`CDBWIDTH-2:0]        head;             
   reg   [`CDBWIDTH-2:0]        tail;
   reg   [`CDBWIDTH-2:0]        next_tail;   // next_tail position
   reg   [`CDBWIDTH-2:0]        next_head;   // next_head position                           
   
  
   reg    [5:0] i;
   
   wire          full,next_full;
   wire          almost_full,next_almost_full;
   
   wire [4:0]   head_add_one;
   wire [4:0]   head_add_two;
   wire [4:0]   tail_add_one;
   wire [4:0]   tail_add_two;

   wire [4:0]   next_head_add_one;
   wire [4:0]   next_head_add_two;
   wire [4:0]   next_tail_add_one;
   wire [4:0]   next_tail_add_two;

/////////////////////////////////////////////////////////
//                                                     //
//          full, almost_full, empty                   //
//                                                     //
/////////////////////////////////////////////////////////

   assign head_add_one = head+1;
   assign head_add_two = head+2;
   assign tail_add_one = tail+1;
   assign tail_add_two = tail+2;

   assign next_head_add_one = next_head+1;
   assign next_head_add_two = next_head+2;
   assign next_tail_add_one = next_tail+1;
   assign next_tail_add_two = next_tail+2;

   assign   rob_IRA_en_out = id_valid_IRA;
   assign   rob_IRB_en_out = id_valid_IRB;


assign rob_full= full;
assign rob_almost_full = almost_full;
assign rob_empty = ((head == tail)&&(valid[head] == 0))?1:0;

//assign almost_full = (((head == tail_add_two) && next_valid[head]) | ((head == tail_add_one) && next_valid[head] && ~next_valid[head_add_one]))? 1:0;
//assign full = ((head == tail_add_one) && next_valid[head])?1:0;// && next_valid[head_add_one])?1:0;

assign almost_full =(head == tail_add_two)?1:0;
assign full = (head == tail_add_one)?1:0;// && next_valid[head_add_one])?1:0;


//assign next_almost_full = (((next_head == next_tail_add_two) && next_valid[next_head]) | ((next_head == next_tail_add_one) && next_valid[next_head] && ~next_valid[next_head_add_one]))? 1:0;
//assign next_full = ((next_head == next_tail_add_one) && next_valid[next_head])?1:0;// && next_valid[head_add_one])?1:0;

assign next_almost_full = (next_head == next_tail_add_two) ? 1:0;
assign next_full = (next_head == next_tail_add_one)?1:0;// && next_valid[head_add_one])?1:0;

assign rob_tail = tail;
assign rob_head = head;
//TODO: Dispatch as soon as the head retire
always @*
begin
  
  next_tail = tail;
  next_head = head;
  rob_retireA_en_out = 1'b0;
  rob_retireB_en_out = 1'b0;
  rob_ToldA_out = T_old[head];//???
  rob_ToldB_out = T_old[head_add_one];//????
  next_valid = valid;
 // full = 0;
 // almost_full = 0;
  
  for(i=0; i<32; i=i+1)
  begin
    next_T[i] = T[i];
    next_Told[i] = T_old[i];
    next_rob_PC[i] = rob_PC[i];
    next_rob_IR[i] = rob_IR[i];
    next_rob_opcode[i] = rob_opcode[i];
    next_complete[i] = complete[i];

  end
//  if((next_head == tail_add_one) && next_valid[head] && next_valid[head_add_one])
//  begin
    // full = 1;
  //end
 // if(((head == tail_add_two) && next_valid[head]) | ((head == tail_add_one) && next_valid[head] && ~next_valid[head_add_one]))
 //    almost_full = 1; 
 
/////////////////////////////////////////////////////////
//                                                     //
//           tail movement and dispatch                //
//                                                     //
/////////////////////////////////////////////////////////  

//Normal: Dispatch 2 instructions/ cycle
 // test =  id_valid_IRA && id_valid_IRB && (((~almost_full) && (~full)) | (almost_full && ~next_valid[head]) | (full && ~next_valid[head] && ~next_valid[head_add_one));
  if(id_valid_IRA && id_valid_IRB)// && (((~almost_full) && (~full)) | (almost_full && ~next_valid[head]) | (full && ~next_valid[head] && ~next_valid[head_add_one)))//modified CYC
  begin  
    next_tail = tail+2;
    next_valid[tail_add_one] = 1;
    next_valid[tail_add_two] = 1; 
    next_rob_PC [tail_add_one] = if_id_NPCA;
    next_rob_PC [tail_add_two] = if_id_NPCB;
    next_rob_IR [tail_add_one] = if_id_IRA;
    next_rob_IR [tail_add_two] = if_id_IRB;
    next_rob_opcode [tail_add_one] = id_opcodeA;
    next_rob_opcode [tail_add_two] = id_opcodeB; 
    rob_idx_A = tail_add_one;
    rob_idx_B = tail+2;
    if(id_opcodeA != `STORE)
    begin
      next_T[tail_add_one] = fl_TA;
      next_Told[tail_add_one] = mt_ToldA;
    end
    
    if(id_opcodeB != `STORE)
    begin
      next_T[tail_add_two] = fl_TB;
      next_Told[tail_add_two] = mt_ToldB;
    end  
    if((head==tail)&&(valid[tail]==0))
    begin
      next_tail = tail+1;
      next_valid[tail] = 1; 
      next_valid[tail_add_one] = 1;
      next_valid[tail_add_two] = 0;
      next_rob_PC [tail] = if_id_NPCA;
      next_rob_PC [tail_add_one] = if_id_NPCB;
      next_rob_IR [tail] = if_id_IRA;
      next_rob_IR [tail_add_one] = if_id_IRB;
      next_rob_opcode [tail] = id_opcodeA;
      next_rob_opcode [tail_add_one] = id_opcodeB; 
      rob_idx_A = tail;
      rob_idx_B = tail+1;
      next_T[tail] = fl_TA;
      next_Told[tail] = mt_ToldA;
      next_T[tail_add_one] = fl_TB;
      next_Told[tail_add_one] = mt_ToldB;
    end
  end

///////////////////////////////////////////////////////////
//                                                       //
//                  Complete Reg                         //
//                                                       //
///////////////////////////////////////////////////////////    
  casex ({ex_cdbA_rdy,ex_cdbB_rdy,ex_cdbC_rdy,ex_cdbD_rdy})
  4'b1xxx:  next_complete[ex_cdbAIdx] = 1'b1;
  4'bx1xx:  next_complete[ex_cdbBIdx] = 1'b1;
  4'bxx1x:  next_complete[ex_cdbCIdx] = 1'b1;
  4'bxxx1:  next_complete[ex_cdbDIdx] = 1'b1;
  endcase

   case({rob_retireA_en_out, rob_retireB_en_out})
   2'b11:
   begin 
     next_complete[head] = 1'b0;
     next_complete[head_add_one] = 1'b0;
   end
   2'b10: next_complete[head] = 1'b0;
   endcase


/////////////////////////////////////////////////////////
//                                                     //
//        head movement and retirement logic           //
//                                                     //
/////////////////////////////////////////////////////////

  case ({complete[head],complete[head_add_one]})
    2'b11: 
    begin 
      next_head = head_add_two;
      next_valid[head] = 0;
      next_valid[head_add_one] = 0;
      next_complete[head] = 0;
      next_complete[head_add_one] = 0;
      if(head_add_one == tail)
        next_head = head_add_one;
      if(rob_opcode[head]!= `STORE)
      begin
        rob_retireA_en_out = 1'b1;
       
        //rob_ToldA_out = T_old[head];
      end
      if(rob_opcode[head_add_one] != `STORE)
      begin
        rob_retireB_en_out = 1'b1;
        //rob_ToldB_out = T_old[head_add_one; 
      end
    end
    2'b10: 
    begin
      next_head = head_add_one;
      next_valid[head] = 0; 
      next_complete[head] = 0;
      if(rob_opcode[head]!= `STORE)
      begin
        rob_retireA_en_out = 1'b1;
        //rob_ToldA_out = T_old[head];
      end
    end
  endcase


end



always @(posedge clock)                    // sequential logic
  begin 
     if (reset)
     begin
         for(i=0; i<32; i=i+1)
           begin
             complete[i] <= `SD 0;   
             //T_old[i] <=  `SD 6'b0000_00;     // just for latch case 
           end
             head     <=  `SD 5'b0000_0;
             tail     <=  `SD 5'b0000_0; 
             valid    <=  `SD 32'h0000_0000;  
//             full     <=  `SD 0;
//             almost_full <= `SD 0;  
     end 

     else 
     begin
         head     <=  `SD next_head;
	 tail     <=  `SD next_tail;
         for(i=0; i<32; i=i+1)
         begin
           rob_PC[i]    <= `SD next_rob_PC[i];
           rob_IR[i]    <= `SD next_rob_IR[i];
           rob_opcode[i]<= `SD next_rob_opcode[i];
           complete[i]   <= `SD next_complete[i];
           T[i]         <= `SD next_T[i];
           T_old[i]     <= `SD next_Told[i];
         end
	// full         <= `SD next_full;
        // almost_full  <= `SD next_almost_full;
         valid        <= `SD next_valid;
     end
end   

endmodule
