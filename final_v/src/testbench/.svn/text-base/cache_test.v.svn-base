
`timescale 1ns/100ps


module cache_test();

// Registers and wires used in the testbench
reg            clock; 
reg            reset;

//Input from IF (fetch instruction)
reg   [63:0]   proc2Icache_addr;
//reg   [4:0]    proc2Icache_prefetch_idx;
reg            proc2Icache_request;

reg   [63:0]   prefetch2Icache_addr;
reg            prefetch2Icache_request;

//Input from Processor for load
reg   [63:0]   proc2Dcache_load_addr;
reg            proc2Dcache_LQ_idx;
reg            proc2Dcache_load_request;
 
//Input from Processor for store
reg   [63:0]   proc2Dcache_store_addr;
reg   [63:0]   proc2Dcache_store_data;
reg            proc2Dcache_store_write_en;
reg   [3:0]    proc2Dcache_SQ_idx;

//Input from Icache
wire   [63:0]   Icache2controller_data;
wire            Icache2controller_valid;

//Input from Dcache for load
wire   [63:0]   Dcache2controller_data;
wire            Dcache2controller_valid;

     
wire   [3:0]    mem2proc_tag;
wire   [3:0]    mem2proc_response;
wire   [63:0]   mem2proc_data;

wire   [63:0]    proc2mem_addr;          
wire   [1:0]     proc2mem_command;
wire   [63:0]    proc2mem_data;

//output to Icache to load instruction
wire   [53:0]    Icache_current_tag;
wire   [6:0]     Icache_current_idx;

//Output to Icache to write from memory, because of load miss
wire   [53:0]    MSHR2Icache_last_tag;
wire   [6:0]     MSHR2Icache_last_idx;
wire             MSHR2Icache_last_data_write_en;
wire   [63:0]    MSHR2Icache_last_data;

//Output to Icache to write from processor,because of the store in Dcache,
//coherency,connect to Icache wrA;
wire   [53:0]    Dcache2Icache_coherence_tag;
wire   [6:0]     Dcache2Icache_coherence_idx;
wire             Dcache2Icache_coherence_data_write_en;
wire   [63:0]    Dcache2Icache_coherence_data;

//Output to Dcache for load Inst
wire   [54:0]    controller2Dcache_current_tag;
wire   [5:0]     controller2Dcache_current_idx;

//Output to Dcache for store Inst
wire   [54:0]    controller2Dcache_store_tag;
wire   [5:0]     controller2Dcache_store_idx;
wire   [63:0]    controller2Dcache_store_data;
wire             controller2Dcache_store_write_en;

//Output to Dcache for the load miss, connect to wrB  
wire   [54:0]    MSHR2Dcache_last_tag;
wire   [5:0]     MSHR2Dcache_last_idx;
wire             MSHR2Dcache_last_data_write_en;
wire   [63:0]    MSHR2Dcache_last_data;

//Output to IF prefetcher
wire   [63:0]    Icache2proc_data_outA;  //from Icache
wire             Icache2proc_valid_outA;
//wire   [3:0]     Icache2proc_prefetch_idxA;

wire             Icache2proc_grant;
wire             Icache2prefetch_grant;
wire             Dcache2proc_load_grant;
wire             Dcache2proc_store_grant;

wire   [63:0]    Icache2proc_data_outB;  //from mem
wire             Icache2proc_valid_outB;
//wire   [3:0]     Icache2proc_prefetch_idxB;

//Valid load from Dcache
wire   [63:0]    Dcache2proc_data_outA; //from Dcache
wire             Dcache2proc_valid_outA;
wire   [4:0]     Dcache2proc_LQ_idxA;

wire   [63:0]    Dcache2proc_data_outB;   //connect to Dcache_last_data
wire             Dcache2proc_valid_outB;  //connect to Dcache_last_data write_en
wire   [4:0]     Dcache2proc_LQ_idxB;  //read from MSHR

wire             MSHR_full; //to prefetcher and LQ

//Instantiate the cachecontroller
cachecontroller cachecontroller_0(
                 //input
                 .clock(clock),
                 .reset(reset),

                 .mem2proc_tag(mem2proc_tag),
                 .mem2proc_response(mem2proc_response),
                 .mem2proc_data(mem2proc_data),
                 
                 .proc2Icache_addr(proc2Icache_addr),
                 //.proc2Icache_prefetch_idx(proc2Icache_prefetch_idx),
                 .proc2Icache_request(proc2Icache_request),

                 .prefetch2Icache_addr(prefetch2Icache_addr),
                 .prefetch2Icache_request(prefetch2Icache_request),
 
                 .Icache2controller_data(Icache2controller_data),
                 .Icache2controller_valid(Icache2controller_valid),

                 .proc2Dcache_load_addr(proc2Dcache_load_addr),
                 .proc2Dcache_LQ_idx(proc2Dcache_LQ_idx),                
                 .proc2Dcache_load_request(proc2Dcache_load_request),

                 .proc2Dcache_store_addr(proc2Dcache_store_addr),
                 .proc2Dcache_store_data(proc2Dcache_store_data),
                 .proc2Dcache_store_write_en(proc2Dcache_store_write_en),                 
                 .proc2Dcache_SQ_idx(proc2Dcache_SQ_idx),

                 .Dcache2controller_data(Dcache2controller_data),
                 .Dcache2controller_valid(Dcache2controller_valid),
              
                 //output
                 .proc2mem_addr(proc2mem_addr),
                 .proc2mem_command(proc2mem_command),
                 .proc2mem_data(proc2mem_data),

                 .Icache_current_tag(Icache_current_tag), 
                 .Icache_current_idx(Icache_current_idx),
                                            
                 .MSHR2Icache_last_tag(MSHR2Icache_last_tag),
                 .MSHR2Icache_last_idx(MSHR2Icache_last_idx),
                 .MSHR2Icache_last_data_write_en(MSHR2Icache_last_data_write_en),
                 .MSHR2Icache_last_data(MSHR2Icache_last_data),
             
                 .Dcache2Icache_coherence_tag(Dcache2Icache_coherence_tag),
                 .Dcache2Icache_coherence_idx(Dcache2Icache_coherence_idx),
                 .Dcache2Icache_coherence_data_write_en(Dcache2Icache_coherence_data_write_en),
                 .Dcache2Icache_coherence_data(Dcache2Icache_coherence_data),

                 .controller2Dcache_current_tag(controller2Dcache_current_tag),
                 .controller2Dcache_current_idx(controller2Dcache_current_idx),

                 .controller2Dcache_store_tag(controller2Dcache_store_tag),
                 .controller2Dcache_store_idx(controller2Dcache_store_idx),
                 .controller2Dcache_store_data(controller2Dcache_store_data),
                 .controller2Dcache_store_write_en(controller2Dcache_store_write_en),

                 .MSHR2Dcache_last_tag(MSHR2Dcache_last_tag),
                 .MSHR2Dcache_last_idx(MSHR2Dcache_last_idx),
                 .MSHR2Dcache_last_data_write_en(MSHR2Dcache_last_data_write_en),
                 .MSHR2Dcache_last_data(MSHR2Dcache_last_data),

                 .Icache2proc_data_outA(Icache2proc_data_outA),
                 .Icache2proc_valid_outA(Icache2proc_valid_outA),
                 //.Icache2proc_prefetch_idxA(Icache2proc_prefetch_idxA),

                 .Icache2proc_data_outB(Icache2proc_data_outB),
                 .Icache2proc_valid_outB(Icache2proc_valid_outB),
                 //.Icache2proc_prefetch_idxB(Icache2proc_prefetch_idxB),

                 .Dcache2proc_data_outA(Dcache2proc_data_outA),
                 .Dcache2proc_valid_outA(Dcache2proc_valid_outA), 
                 .Dcache2proc_LQ_idxA(Dcache2proc_LQ_idxA),

                 .Dcache2proc_data_outB(Dcache2proc_data_outB),
                 .Dcache2proc_valid_outB(Dcache2proc_valid_outB),
                 .Dcache2proc_LQ_idxB(Dcache2proc_LQ_idxB),

                 .MSHR_full(MSHR_full),
                 .Icache2proc_grant(Icache2proc_grant),
                 .Icache2prefetch_grant(Icache2prefetch_grant),
                 .Dcache2proc_load_grant(Dcache2proc_load_grant),
                 .Dcache2proc_store_grant(Dcache2proc_store_grant)                     
     
);

// Instantiate the Data Memory
mem memory (// Inputs
          .clk               (clock),
          .proc2mem_command  (proc2mem_command),
          .proc2mem_addr     (proc2mem_addr),
          .proc2mem_data     (proc2mem_data),

           // Outputs

          .mem2proc_response (mem2proc_response),
          .mem2proc_data     (mem2proc_data),
          .mem2proc_tag      (mem2proc_tag)
         );

Dcache Dcache_0(
               .clock(clock), 
               .reset(reset),
               .wrA_en(controller2Dcache_store_write_en), 
               .wrA_tag(controller2Dcache_store_tag), 
               .wrA_idx(controller2Dcache_store_idx), 
               .wrA_data(controller2Dcache_store_data), 
	       .wrB_en(MSHR2Dcache_last_data_write_en), 
               .wrB_tag(MSHR2Dcache_last_tag), 
               .wrB_idx(MSHR2Dcache_last_idx), 
               .wrB_data(mem2proc_data),
	       .rd_tag(controller2Dcache_current_tag), 
               .rd_idx(controller2Dcache_current_idx), 
               .rd_data(Dcache2controller_data), 
               .rd_valid(Dcache2controller_valid)
               );

Icache Icache_0(
                .clock(clock), 
                .reset(reset), 
	        .wrA_en(Dcache2Icache_coherence_data_write_en), 
                .wrA_tag(Dcache2Icache_coherence_tag), 
                .wrA_idx(Dcache2Icache_coherence_idx), 
                .wrA_data(Dcache2Icache_coherence_data),
                .wrB_en(MSHR2Icache_last_data_write_en), 
                .wrB_tag(MSHR2Icache_last_tag), 
                .wrB_idx(MSHR2Icache_last_idx), 
                .wrB_data(mem2proc_data),
		.rd_tag(Icache_current_tag), 
                .rd_idx(Icache_current_idx), 
                .rd_data(Icache2controller_data), 
                .rd_valid(Icache2controller_valid)
                );


always
begin
  #5;
  clock = ~clock;
end

task show_mem_with_decimal;
 input [31:0] start_addr;
 input [31:0] end_addr;
 integer k;
 integer showing_data;
 begin
  $display("@@@");
  showing_data=0;
  for(k=start_addr;k<=end_addr; k=k+1)
    if (memory.unified_memory[k] != 0)
    begin
      $display("@@@ mem[%5d] = %x : %0d", k*8, memory.unified_memory[k], 
                                               memory.unified_memory[k]);
      showing_data=1;
    end
    else if(showing_data!=0)
    begin
      $display("@@@");
      showing_data=0;
    end
  $display("@@@");
 end
endtask  // task show_mem_with_decimal

always @(negedge clock)
begin
  if(reset)
  begin

  end
  else
  begin
     show_mem_with_decimal(0,`MEM_64BIT_LINES - 1); 
  end
end

initial
begin
  clock = 1'b0;
  reset = 1;

  proc2Icache_addr = 0;
  //proc2Icache_prefetch_idx = 0;
  proc2Icache_request = 0;

  proc2Dcache_load_addr = 0;
  proc2Dcache_LQ_idx = 0;
  proc2Dcache_load_request = 0;

  proc2Dcache_store_addr = 0;
  proc2Dcache_store_data = 0;
  proc2Dcache_store_write_en = 0;
  proc2Dcache_SQ_idx = 0;
  
  @(posedge clock);
  @(posedge clock);
  $readmemh("program.mem", memory.unified_memory);

  @(posedge clock);
  @(posedge clock);
  @(negedge clock);
  reset = 0; 

  @(posedge clock);
  proc2Icache_addr = 64'd0;
  proc2Icache_request = 1;
  
  prefetch2Icache_addr = 64'd8;
  prefetch2Icache_request = 1;

  proc2Dcache_load_addr = 0;
  proc2Dcache_LQ_idx = 2;
  proc2Dcache_load_request = 0;

  proc2Dcache_store_addr = 0;
  proc2Dcache_store_data = 0;
  proc2Dcache_store_write_en = 0;
  proc2Dcache_SQ_idx = 0;
 
  @(posedge clock);
  proc2Icache_addr = 64'd0;
  proc2Icache_request = 0;

  prefetch2Icache_addr = 64'd8;
  prefetch2Icache_request = 1;

  proc2Dcache_load_addr = 64'd16;
  proc2Dcache_LQ_idx = 3;
  proc2Dcache_load_request = 0;

  proc2Dcache_store_addr = 0;
  proc2Dcache_store_data = 0;
  proc2Dcache_store_write_en = 0;
  proc2Dcache_SQ_idx = 0;

  @(posedge clock);
  proc2Icache_addr = 64'd0;
  proc2Icache_request = 0;

  prefetch2Icache_addr = 64'd16;
  prefetch2Icache_request = 1;

  proc2Dcache_load_addr = 64'd16;
  proc2Dcache_LQ_idx = 0;
  proc2Dcache_load_request = 0;

  proc2Dcache_store_addr = 64'd16;
  proc2Dcache_store_data = 64'd16;
  proc2Dcache_store_write_en = 0;
  proc2Dcache_SQ_idx = 4'd2;

  @(posedge clock);
  proc2Icache_addr = 64'd0;
  proc2Icache_request = 0;

  prefetch2Icache_addr = 64'd24;
  prefetch2Icache_request = 1;

  proc2Dcache_load_addr = 64'd16;
  proc2Dcache_LQ_idx = 0;
  proc2Dcache_load_request = 0;

  proc2Dcache_store_addr = 64'd16;
  proc2Dcache_store_data = 64'd16;
  proc2Dcache_store_write_en = 0;
  proc2Dcache_SQ_idx = 4'd2;

  @(posedge clock);
  proc2Icache_addr = 64'd8;
  proc2Icache_request = 0;

  prefetch2Icache_addr = 64'd24;
  prefetch2Icache_request = 1;

  proc2Dcache_load_addr = 64'd16;
  proc2Dcache_LQ_idx = 0;
  proc2Dcache_load_request = 0;

  proc2Dcache_store_addr = 64'd16;
  proc2Dcache_store_data = 64'd16;
  proc2Dcache_store_write_en = 0;
  proc2Dcache_SQ_idx = 4'd2;

  @(posedge clock);
  proc2Dcache_store_write_en = 0;
  proc2Dcache_load_request = 0;
  proc2Icache_request = 0;
   @(posedge clock);
  proc2Icache_request=0;
  proc2Dcache_load_request = 0;
  @(posedge clock);
  @(posedge clock);
  @(posedge clock);
  @(posedge clock);
  @(posedge clock);
  @(posedge clock);
  @(posedge clock);
  proc2Icache_addr = 64'd8;
  proc2Icache_request = 1;

  @(posedge clock);
  @(posedge clock);
  @(posedge clock);
  @(posedge clock);
  @(posedge clock);
  @(posedge clock);
  @(posedge clock);
  @(posedge clock);
  @(posedge clock);
  @(posedge clock);
  @(posedge clock);
  @(posedge clock);
  @(posedge clock);
  @(posedge clock);
  @(posedge clock);
  @(posedge clock);
  @(posedge clock);
  @(posedge clock);
  @(posedge clock);
  @(posedge clock);
  @(posedge clock);


  $finish;

end
endmodule
