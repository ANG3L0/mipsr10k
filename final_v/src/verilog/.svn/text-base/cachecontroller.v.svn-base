module cachecontroller(
                 //input
                 clock,
                 reset,

                 mem2proc_tag,
                 mem2proc_response,
                 mem2proc_data,
                 
                 proc2Icache_addr,
                 proc2Icache_request,

                 prefetch2Icache_addr,
                 prefetch2Icache_request,

 
                 Icache2controller_data,
                 Icache2controller_valid,

                 proc2Dcache_load_addr,
                 proc2Dcache_LQ_idx,                
                 proc2Dcache_load_request,

                 proc2Dcache_store_addr,
                 proc2Dcache_store_data,
                 proc2Dcache_store_write_en,                 
                 proc2Dcache_SQ_idx,

                 Dcache2controller_data,
                 Dcache2controller_valid,
              
                 branch_recovery,

                 //output
                 proc2mem_addr,
                 proc2mem_command,
                 proc2mem_data,

                 Icache_current_tag, 
                 Icache_current_idx,
                 
                 MSHR2Icache_last_tag,
                 MSHR2Icache_last_idx,
                 MSHR2Icache_last_data_write_en,
                 MSHR2Icache_last_data,
             
                 Dcache2Icache_coherence_tag,
                 Dcache2Icache_coherence_idx,
                 Dcache2Icache_coherence_data_write_en,
                 Dcache2Icache_coherence_data,

                 controller2Dcache_current_tag,
                 controller2Dcache_current_idx,

                 controller2Dcache_store_tag,
                 controller2Dcache_store_idx,
                 controller2Dcache_store_data,
                 controller2Dcache_store_write_en,

                 MSHR2Dcache_last_tag,
                 MSHR2Dcache_last_idx,
                 MSHR2Dcache_last_data_write_en,
                 MSHR2Dcache_last_data,

                 Icache2proc_data_outA,
                 Icache2proc_valid_outA,
                 //Icache2proc_prefetch_idxA,

                 Icache2proc_data_outB,
                 Icache2proc_valid_outB,
                 //Icache2proc_prefetch_idxB,

                 Dcache2proc_data_outA,
                 Dcache2proc_valid_outA, 
                 Dcache2proc_LQ_idxA,

                 Dcache2proc_data_outB,
                 Dcache2proc_valid_outB,
                 Dcache2proc_LQ_idxB,

                 MSHR_full,
                 Icache2proc_grant,
                 Icache2prefetch_grant,
                 Dcache2proc_load_grant,
                 Dcache2proc_store_grant,

                 Icache2proc_addr_outB                     
);

///////////////////////////////////////////////////////////////
//                                                           //
//                       input                               //
//                                                           //
///////////////////////////////////////////////////////////////
////TODO: request signal from STORE QUEUE

input            clock; 
input            reset;

//Input from memory
input   [3:0]    mem2proc_tag;
input   [3:0]    mem2proc_response;
input   [63:0]   mem2proc_data;

//Input from IF (fetch instruction)
input   [63:0]   proc2Icache_addr;
input            proc2Icache_request;

//Input from prefetch
input   [63:0]   prefetch2Icache_addr;
input		 prefetch2Icache_request;

//Input from Icache
input   [63:0]   Icache2controller_data;
input            Icache2controller_valid;

//Input from Processor for load
input   [63:0]   proc2Dcache_load_addr;
input   [2:0]         proc2Dcache_LQ_idx;
input            proc2Dcache_load_request;
 
//Input from Processor for store
input   [63:0]   proc2Dcache_store_addr;
input   [63:0]   proc2Dcache_store_data;
input            proc2Dcache_store_write_en;
input   [2:0]    proc2Dcache_SQ_idx;

//Input from Dcache for load
input   [63:0]   Dcache2controller_data;
input            Dcache2controller_valid;

//Branch Recovery
input            branch_recovery;
///////////////////////////////////////////////////////////////
//                                                           //
//                        output                             // 
//                                                           //
///////////////////////////////////////////////////////////////

//output to processor
output  [63:0]    proc2mem_addr;          
output  [1:0]     proc2mem_command;
output  [63:0]    proc2mem_data;

//output to Icache to load instruction
output  [53:0]    Icache_current_tag;
output  [6:0]     Icache_current_idx;

//Output to Icache to write from memory, because of load miss
output  [53:0]    MSHR2Icache_last_tag;
output  [6:0]     MSHR2Icache_last_idx;
output            MSHR2Icache_last_data_write_en;
output  [63:0]    MSHR2Icache_last_data;

//Output to Icache to write from processor,because of the store in Dcache,
//coherency,connect to Icache wrA;
output  [53:0]    Dcache2Icache_coherence_tag;
output  [6:0]     Dcache2Icache_coherence_idx;
output            Dcache2Icache_coherence_data_write_en;
output  [63:0]    Dcache2Icache_coherence_data;

//Output to Dcache for load Inst
output  [54:0]    controller2Dcache_current_tag;
output  [5:0]     controller2Dcache_current_idx;

//Output to Dcache for store Inst
output  [54:0]    controller2Dcache_store_tag;
output  [5:0]     controller2Dcache_store_idx;
output  [63:0]    controller2Dcache_store_data;
output            controller2Dcache_store_write_en;

//Output to Dcache for the load miss, connect to wrB  
output  [54:0]    MSHR2Dcache_last_tag;
output  [5:0]     MSHR2Dcache_last_idx;
output            MSHR2Dcache_last_data_write_en;
output  [63:0]    MSHR2Dcache_last_data;

//Output to IF prefetcher
output  [63:0]    Icache2proc_data_outA;  //from Icache
output            Icache2proc_valid_outA;
//output  [3:0]     Icache2proc_prefetch_idxA;


output  [63:0]    Icache2proc_data_outB;  //from mem
output            Icache2proc_valid_outB;
//output  [3:0]     Icache2proc_prefetch_idxB;

//Valid load from Dcache
output  [63:0]    Dcache2proc_data_outA; //from Dcache
output            Dcache2proc_valid_outA;
output  [2:0]     Dcache2proc_LQ_idxA;

output  [63:0]    Dcache2proc_data_outB;   //connect to Dcache_last_data
output            Dcache2proc_valid_outB;  //connect to Dcache_last_data write_en
output  [2:0]     Dcache2proc_LQ_idxB;  //read from MSHR

output            MSHR_full; //to prefetcher and LQ

output            Icache2proc_grant;
output            Icache2prefetch_grant;
output            Dcache2proc_load_grant;
output            Dcache2proc_store_grant;

output  [63:0]    Icache2proc_addr_outB;

///////////////////////////////////////////////////////////////
//                                                           //
//                     Inner   Reg                           //
//                                                           //
///////////////////////////////////////////////////////////////
reg     [63:0]    Icache2proc_addr_outB;

reg     [63:0]    MSHR_addr [15:1];
reg     [63:0]    next_MSHR_addr [15:1];

reg     [3:0]     MSHR_idx[15:1];
reg     [3:0]     next_MSHR_idx [15:1];

//reg     [15:1]    MSHR_LD_ST, next_MSHR_LD_ST; // MSHR_LD_ST[i] = 0: load; MSHR_LD_ST[i] = 1;

//??????????????????????
//reg     [3:0]     MSHR_counter [15:1];
//reg     [3:0]     next_MSHR_counter[15:1];
 
reg     [15:1]    MSHR_ID, next_MSHR_ID;  //MSHR_ID[i] = 0: Icache, MSHR_ID[i] = 1: Dcache
reg     [15:1]    MSHR_busy, next_MSHR_busy;
           

reg     [53:0]    MSHR2Icache_last_tag;
reg     [6:0]     MSHR2Icache_last_idx;
reg               MSHR2Icache_last_data_write_en;
reg     [63:0]    MSHR2Icache_last_data;

reg     [54:0]    MSHR2Dcache_last_tag;
reg     [5:0]     MSHR2Dcache_last_idx;
reg               MSHR2Dcache_last_data_write_en;
reg     [63:0]    MSHR2Dcache_last_data;


reg     [63:0]    proc2mem_addr;
reg      [1:0]    proc2mem_command;
reg     [63:0]    proc2mem_data;

reg      [4:0]    i;

reg     [63:0]    Icache2proc_data_outB;  //from mem
reg               Icache2proc_valid_outB;
//reg     [3:0]     Icache2proc_prefetch_idxB;


reg     [63:0]    Dcache2proc_data_outB;   //connect to Dcache_last_data
reg               Dcache2proc_valid_outB;  //connect to Dcache_last_data write_en
reg     [2:0]     Dcache2proc_LQ_idxB;  //read from MSHR

reg               Icache2proc_grant;
reg               Icache2prefetch_grant;
reg               Dcache2proc_load_grant;
reg               Dcache2proc_store_grant;

reg     [15:1]    MSHR_prefetch, next_MSHR_prefetch; //0: fetch, 1:prefetch  
reg     [15:1]    MSHR_idx_valid, next_MSHR_idx_valid;     
////////////////////////////////////////////////////////////////
//                                                            //
//                 Send request to Icache                     //
//                                                            //
////////////////////////////////////////////////////////////////
assign Icache_current_tag = proc2Icache_addr[63:10];
assign Icache_current_idx = proc2Icache_addr[9:3];

//Coherence

assign Dcache2Icache_coherence_tag = proc2Dcache_store_addr[63:10];
assign Dcache2Icache_coherence_idx = proc2Dcache_store_addr[9:3];
assign Dcache2Icache_coherence_data_write_en = proc2Dcache_store_write_en; //???  
assign Dcache2Icache_coherence_data = proc2Dcache_store_data;

////////////////////////////////////////////////////////////////
//                                                            //
//                 Send request to Dcache                     //
//                                                            //
////////////////////////////////////////////////////////////////

//load
assign controller2Dcache_current_tag = proc2Dcache_load_addr[63:9];
assign controller2Dcache_current_idx = proc2Dcache_load_addr[8:3];


//store
assign controller2Dcache_store_data = proc2Dcache_store_data;
assign controller2Dcache_store_write_en = proc2Dcache_store_write_en;
assign controller2Dcache_store_tag = proc2Dcache_store_addr[63:9];
assign controller2Dcache_store_idx = proc2Dcache_store_addr[8:3];

////////////////////////////////////////////////////////////////
//                                                            //
//             Response from Icache to fetch                  //
//                                                            //
////////////////////////////////////////////////////////////////

assign Icache2proc_data_outA = Icache2controller_data;
assign Icache2proc_valid_outA = (Icache2controller_valid) ? 1'b1:1'b0;
//assign Icache2proc_prefetch_idxA = proc2Icache_prefetch_idx;

////////////////////////////////////////////////////////////////
//                                                            //
//             Response from Dcache to LQ                     //
//                                                            //
////////////////////////////////////////////////////////////////

assign Dcache2proc_data_outA = Dcache2controller_data;
assign Dcache2proc_valid_outA = Dcache2controller_valid;
assign Dcache2proc_LQ_idxA = proc2Dcache_LQ_idx;

assign MSHR_full =  ((mem2proc_response == 4'd15) | (mem2proc_response == 0))? 1'b1:1'b0;

always@ *
begin
  next_MSHR_ID = MSHR_ID;
  next_MSHR_busy = MSHR_busy;
  next_MSHR_prefetch = MSHR_prefetch;

  proc2mem_addr = 0;
  proc2mem_command = `BUS_NONE;
  
  MSHR2Icache_last_tag = 0;
  MSHR2Icache_last_idx = 0;
  MSHR2Icache_last_data_write_en = 0;
  MSHR2Icache_last_data = 0;

  MSHR2Dcache_last_tag = 0;
  MSHR2Dcache_last_idx = 0;
  MSHR2Dcache_last_data_write_en = 0;
  MSHR2Dcache_last_data = 0;

  Icache2proc_valid_outB = 0;
  Icache2proc_data_outB = mem2proc_data;
  
  Dcache2proc_valid_outB = 0;
  Dcache2proc_data_outB = mem2proc_data;
  
  Icache2proc_grant = 0;
  Icache2prefetch_grant = 0;
  Dcache2proc_load_grant = 0;
  Dcache2proc_store_grant = 0;

  
  for (i = 1; i<= 15; i=i+1)
  begin  
    next_MSHR_addr[i] = MSHR_addr[i];
    next_MSHR_idx[i] = MSHR_idx[i];
    
    ////////////////////////////////////////////////
    //                                            //
    //            load miss then recovery         //
    //                                            //
    ////////////////////////////////////////////////
    if((i == mem2proc_tag) && (MSHR_busy[i] == 1))
    begin
      next_MSHR_busy[i] = 0;
      //next_MSHR_prefetch[i] = 0;
      //next_MSHR_idx_valid[i] = 0;

      if(MSHR_ID[i] ==0)
      begin
        //write into Icache
        MSHR2Icache_last_tag = MSHR_addr[i][63:10];
        MSHR2Icache_last_idx = MSHR_addr[i][9:3];
        MSHR2Icache_last_data_write_en = 1;

        //cachecontroller output
        if(MSHR_prefetch[i] == 0)
        begin
          Icache2proc_data_outB = mem2proc_data;
          Icache2proc_valid_outB = 1;
          Icache2proc_addr_outB = MSHR_addr[i];
         // Icache2proc_prefetch_idxB = MSHR_idx[i];
        end
      end

      else if(MSHR_ID[i] == 1) //&& (MSHR_idx_valid[i] == 1))
      begin
        //write into Dcache
        MSHR2Dcache_last_tag = MSHR_addr[i][63:9];
        MSHR2Dcache_last_idx = MSHR_addr[i][8:3];
        MSHR2Dcache_last_data_write_en = 1;
        
        //cachecontroller output
        Dcache2proc_data_outB = mem2proc_data; 
        Dcache2proc_valid_outB = 1;
        Dcache2proc_LQ_idxB = MSHR_idx[i];
      end//Dcache_outB
    end
  end

/*  if(Icache2controller_valid)
     Icache2proc_grant = 1;
  if(Dcache2controller_valid)
     Dcache2proc_load_grant = 1;
*/
  if((Dcache2controller_valid == 0)&&(proc2Dcache_load_request))
  begin
    proc2mem_addr = proc2Dcache_load_addr;
    next_MSHR_addr[mem2proc_response] = {proc2Dcache_load_addr[63:3], 3'd0};
    next_MSHR_idx[mem2proc_response] = proc2Dcache_LQ_idx;
    next_MSHR_idx_valid[mem2proc_response] = 1; 
    next_MSHR_busy[mem2proc_response] = 1;
    next_MSHR_ID[mem2proc_response] = 1;
    proc2mem_addr = {proc2Dcache_load_addr[63:3],3'd0};
    proc2mem_command = `BUS_LOAD;
     if(mem2proc_response != 0 )
    Dcache2proc_load_grant = 1;
/*
    if((mem2proc_response == mem2proc_tag) && (mem2proc_response != 0))
    begin
      Dcache2proc_data_outB = mem2proc_data;
      Dcache2proc_valid_outB = 1;
      Dcache2proc_LQ_idxB = proc2Dcache_LQ_idx;
    end
*/
  end// Load has the hishest priority

  else if(proc2Dcache_store_write_en)
  begin
    proc2mem_data = proc2Dcache_store_data;
    proc2mem_addr = {proc2Dcache_store_addr[63:3], 3'd0};
    proc2mem_command = `BUS_STORE;
    next_MSHR_idx_valid[mem2proc_response] = 0;
    if(mem2proc_response != 0 )
    Dcache2proc_store_grant = 1;
  end// store

//TODO: ADD PREFETCH and PORTS 
  else if ((Icache2controller_valid == 0) && (proc2Icache_request))
  begin 
    next_MSHR_addr[mem2proc_response] = {proc2Icache_addr[63:3], 3'd0};
    //next_MSHR_idx[mem2proc_response] =  proc2Icache_fetch_idx;
    next_MSHR_busy[mem2proc_response] = 1;
    next_MSHR_ID[mem2proc_response] = 0;
    proc2mem_addr = {proc2Icache_addr[63:3],3'd0};
    proc2mem_command = `BUS_LOAD;
    next_MSHR_idx_valid[mem2proc_response] = 0;

    if(mem2proc_response != 0) 
    Icache2proc_grant = 1;
/*
    if((mem2proc_response == mem2proc_tag) && (mem2proc_response != 0))
    begin
      Icache2proc_data_outB = mem2proc_data;
      Icache2proc_valid_outB = 1;
      Icache2proc_addr_outB = proc2Icache_addr;
    end
*/
  end // Instruction fetch

  else //if(prefetch2Icache_request == 1) 
  begin
    next_MSHR_addr[mem2proc_response] = {prefetch2Icache_addr[63:3],3'd0};
    //next_MSHR_idx[mem2proc_response] =  prefetch2Icache_prefetch_idx;
    next_MSHR_busy[mem2proc_response] = 1;
    next_MSHR_ID[mem2proc_response] = 0;
    next_MSHR_prefetch[mem2proc_response] = 1;
    proc2mem_addr = {prefetch2Icache_addr[63:3],3'd0};
    proc2mem_command = `BUS_LOAD;
    next_MSHR_idx_valid[mem2proc_response] = 0;

    if(mem2proc_response != 0 )
    Icache2prefetch_grant = 1;
  end// prefetch    

end
//synopsys sync_set_reset "reset"
always @(posedge clock)
begin
  if(reset | branch_recovery)
  begin
    MSHR_ID <= `SD 0;
    MSHR_busy <= `SD 0;
    MSHR_prefetch <= `SD 0;
    MSHR_idx_valid <= `SD 0;
  end

  else
  begin
    for(i = 1; i<= 15; i=i+1)
    begin
      MSHR_addr[i] <= `SD next_MSHR_addr[i];
      MSHR_idx[i] <= `SD next_MSHR_idx[i];
    end
    MSHR_ID <= `SD next_MSHR_ID;
    MSHR_busy <= `SD next_MSHR_busy;
    MSHR_prefetch <= `SD next_MSHR_prefetch;
    MSHR_idx_valid <= `SD next_MSHR_idx_valid;
  end
end
   
endmodule  
