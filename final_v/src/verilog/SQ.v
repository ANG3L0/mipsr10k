`define SD #1

module SQ(
        //input
        clock,
        reset,
 
        rob_idxA,
        rob_idxB,

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
        ALU_wr_mem_enA,
        ALU_wr_mem_enB, 

        ROB2SQ_retire_en,

        LQ2SQ_addr,
        LQ2SQ_tail,
        LQ2SQ_search_en,
        LQ2SQ_LQ_idx,

        branch_recovery,
        
        //output
        store_request,
        store_retire_addr,
        store_retire_data,

        SQ2RS_idxA,
        SQ2RS_idxB,
        SQ2RS_idxA_write_en,
        SQ2RS_idxB_write_en,

        tail, 
        next_tail,
  
        SQ2LQ_data,
        SQ2LQ_write_en,
        SQ2LQ_LQ_idx,

        SQ_full,
        SQ_almost_full
/////////////////
);



///////////////////////////////////////////////////////////
//                                                       //
//                      Input                            //
//                                                       //
///////////////////////////////////////////////////////////
input        clock;
input        reset;

//Dispatch
input [4:0]  rob_idxA;
input [4:0]  rob_idxB;
input        id_wr_mem_enA;
input        id_wr_mem_enB; 
input        id_valid_IRA;
input        id_valid_IRB;

//execute:complete signal broadcast from ALU
input [4:0]  ALU_SQ_idxA;
input [4:0]  ALU_SQ_idxB;
input [63:0] ALU_store_dataA; //get from RS when issue
input [63:0] ALU_store_dataB;        
input [63:0] ALU_store_addrA;
input [63:0] ALU_store_addrB;
input        ALU_wr_mem_enA;
input        ALU_wr_mem_enB; 

//retire: from ROB
input        ROB2SQ_retire_en;

//from LQ

input [63:0] LQ2SQ_addr;
input [4:0]  LQ2SQ_tail;
input        LQ2SQ_search_en;
input [4:0]  LQ2SQ_LQ_idx;
// from branch_recovery
input        branch_recovery;

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
output [4:0]     SQ2RS_idxA;
output [4:0]     SQ2RS_idxB;
output           SQ2RS_idxA_write_en;
output           SQ2RS_idxB_write_en;

// to LQ when LQ dispatch
output          tail; 
output          next_tail;

//inflight condition: LQ search result from SQ
output [63:0]   SQ2LQ_data;
output          SQ2LQ_write_en;
output [4:0]    SQ2LQ_LQ_idx;

output          SQ_full;
output          SQ_almost_full;

///////////////////////////////////////////////////////////
//                                                       //
//                     Inner Reg                         //
//                                                       //
///////////////////////////////////////////////////////////

//reg   [4:0]   SQ_rob_idx [15:0]; //age
//reg   [4:0]   next_SQ_rob_idx; [15:0]
reg   [63:0]  store_addr [15:0];
reg   [63:0]  next_store_addr [15:0];

reg   [63:0]  store_data [15:0];
reg   [63:0]  next_store_data [15:0];

reg   [15:0]  store_grant;

reg   [4:0]   head, next_head;
reg   [4:0]   tail, next_tail;
reg   [31:0]  busy, next_busy;
reg   [31:0]  addr_valid, next_addr_valid;
reg   [31:0]  data_valid, next_data_valid;
reg   [5:0]   i;
   
reg   [4:0]   SQ2RS_idxA;
reg   [4:0]   SQ2RS_idxB;
reg           SQ2RS_idxA_write_en;
reg           SQ2RS_idxB_write_en;

reg   [63:0]  SQ2LQ_data;
reg           SQ2LQ_write_en;
 
wire  [4:0]   tail_add_one;
wire  [4:0]   tail_add_two;
wire  [4:0]   head_add_one;
wire  [4:0]   head_add_two;
wire          dispatch_storeA_en;
wire          dispatch_storeB_en;

assign tail_add_one = tail+1;
assign tail_add_two = tail+2;
assign head_add_one = head+1;
assign head_add_two = head+2;  

assign store_request = ROB2SQ_retire_en;
assign store_retire_addr = store_addr[head];
assign store_retire_data = store_data[head];

assign dispatch_storeA_en = id_valid_IRA && id_wr_mem_enA;
assign dispatch_storeB_en = id_valid_IRA && id_valid_IRB && id_wr_mem_enB;

assign SQ2LQ_LQ_idx = LQ2SQ_LQ_idx;  

assign SQ_full = (head == tail_add_one)? 1:0;
assign SQ_almost_full = (head == tail_add_two)? 1:0;

always @*
begin
  next_head = head;
  next_tail = tail;
  next_busy = busy;
  next_addr_valid = addr_valid;
  next_data_valid = data_valid;
  
  SQ2RS_idxA = 0;
  SQ2RS_idxB = 0;
  SQ2RS_idxA_write_en = 0;
  SQ2RS_idxB_write_en = 0;

  SQ2LQ_data = 0;
  SQ2LQ_write_en = 0;

  for(i =0 ; i< 32; i=i+1)
  begin
    next_store_addr[i] = store_addr[i];
    next_store_data[i] = store_data[i];
  end

////////////////////////////////////////////////////////////
//                                                        //
//                   Dispatch, tail                       //
//                                                        //
////////////////////////////////////////////////////////////

  if(dispatch_storeA_en && dispatch_storeB_en)
  begin
    if(head == tail && busy[head] == 0)
    begin
      next_tail = tail+1;
      next_busy[tail] = 1;
      next_busy[tail_add_one] = 1;

      SQ2RS_idxA = tail;
      SQ2RS_idxA_write_en = 1;
      SQ2RS_idxB = tail_add_one;
      SQ2RS_idxB_write_en = 1;
    end
    else
    begin
      next_tail = tail+6'd2;
      next_busy[tail_add_one] = 1;
      next_busy[tail_add_two] = 1;

      SQ2RS_idxA = tail_add_one;
      SQ2RS_idxA_write_en = 1;
      SQ2RS_idxB = tail_add_two;
      SQ2RS_idxB_write_en = 1;
    end
  end

  else if(dispatch_storeA_en && (~dispatch_storeB_en))
  begin
    if(head == tail && busy[head] == 0)
    begin
      next_tail =tail;
      next_busy[tail] = 1;
      
      SQ2RS_idxA =tail;
      SQ2RS_idxA_write_en = 1;
    end
    else
    begin
      next_tail =tail+1;
      next_busy[tail_add_one] = 1;
    
      SQ2RS_idxA = tail_add_one;
      SQ2RS_idxA_write_en = 1;   
    end
  end

  else if((~dispatch_storeA_en) && dispatch_storeB_en)
  begin
    if(head == tail && busy[head] == 0)
    begin
      next_tail =tail;
      next_busy[tail] = 1;      
         
      SQ2RS_idxB =tail;
      SQ2RS_idxB_write_en =1;
    end
    else
    begin
      next_tail =tail+1;
      next_busy[tail_add_one] = 1;    
  
      SQ2RS_idxB = tail_add_one;
      SQ2RS_idxB_write_en = 1;
      
    end  
  end

//////////////////////////////////////////////////
//                                              //
//                  Execute                     //
//                                              //
//////////////////////////////////////////////////

  if(ALU_wr_mem_enA)
  begin
    next_store_addr[ALU_SQ_idxA] = ALU_store_addrA;
    next_store_data[ALU_SQ_idxA] = ALU_store_dataA;
    next_addr_valid[ALU_SQ_idxA] = 1;
    next_data_valid[ALU_SQ_idxA] = 1;
  end
  if(ALU_wr_mem_enB)
  begin
    next_store_addr[ALU_SQ_idxB] = ALU_store_addrB;
    next_store_data[ALU_SQ_idxB] = ALU_store_dataB;
    next_addr_valid[ALU_SQ_idxB] = 1;
    next_data_valid[ALU_SQ_idxB] = 1;
  end

//////////////////////////////////////////////////
//                                              //
//               LQ Search SQ                   //
//                                              //
//////////////////////////////////////////////////

  //if(LQ2SQ_search_en)
  //begin 
    for(i=0; i<32; i =i+1)
    begin
      //selection 1: head < tail
      if((head < tail) && (i <= LQ2SQ_tail) && (i>=head))
      begin
        if((store_addr[i] == LQ2SQ_addr) && addr_valid[i] == 1)
        begin
          SQ2LQ_data = store_data[i];
          SQ2LQ_write_en = 1;
        end
      end

      //selection 2: head > tail
      else if(head > tail)
      begin
        //selection 2-1: LQ2SQ_tail < tail
        if(LQ2SQ_tail <= tail && i<=LQ2SQ_tail)
        begin
          if((store_addr[i] == LQ2SQ_addr) && addr_valid[i] == 1)
          begin
            SQ2LQ_data = store_data[i];
            SQ2LQ_write_en = 1;
          end
        end
        //selection 2-2: LQ2SQ_tail > head
        else if(LQ2SQ_tail >= head)
        begin
          if((store_addr[i] == LQ2SQ_addr) && (addr_valid[i] == 1) && (i<=tail))
          begin
            SQ2LQ_data = store_data[i];
            SQ2LQ_write_en = 1;
          end
          else if((i >= head) && (SQ2LQ_write_en == 0) && (store_addr[i] == LQ2SQ_addr) && (addr_valid[i] == 1))
          begin
            SQ2LQ_data = store_data[i];
            SQ2LQ_write_en = 1;
          end  
        end         
      end 
    end 
  //end
//////////////////////////////////////////////////
//                                              //
//              Retire, head                    //
//                                              //
////////////////////////////////////////////////// 
  if(ROB2SQ_retire_en)
  begin
    next_head = head + 1;
    next_busy[head] = 0; 
    next_addr_valid[head] = 0;
    next_data_valid[head] = 0; 
  end

end


always @(posedge clock)
begin
  if(reset|branch_recovery)
  begin
    head <= `SD 0;
    tail <= `SD 0;
    busy <= `SD 0;
    addr_valid <= `SD 0;
    data_valid <= `SD 0;
  end
  else
  begin
    head <= `SD next_head;
    tail <= `SD next_tail;
    busy <= `SD next_busy;
    addr_valid <= `SD next_addr_valid;
    data_valid <= `SD next_data_valid;
    for(i=1; i<32;i=i+1)
    begin
      store_addr[i] <= `SD next_store_addr[i];
      store_data[i] <= `SD next_store_data[i];
    end 
  end
end
endmodule
