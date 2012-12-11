module cache(
            // input
            clock,
            reset,

            proc2Icache_addr,
            proc2Icache_request,

            prefetch2Icache_addr,
            prefetch2Icache_request,

            proc2Dcache_load_addr,
            proc2Dcache_LQ_idx,
            proc2Dcache_load_request,

            proc2Dcache_store_addr,
            proc2Dcache_store_data,
            proc2Dcache_store_write_en,
            proc2Dcache_SQ_idx,

            mem2proc_tag,
            mem2proc_response,
            mem2proc_data,

            branch_recovery,
            //output
            proc2mem_addr,
            proc2mem_command,
            proc2mem_data,

            Icache2proc_data_outA,  //from Icache
            Icache2proc_valid_outA,

            Icache2proc_grant,
            Icache2prefetch_grant,
            Dcache2proc_load_grant,
            Dcache2proc_store_grant,

            Icache2proc_data_outB,  //from mem
            Icache2proc_valid_outB,

            Dcache2proc_data_outA, //from Dcache
            Dcache2proc_valid_outA,
            Dcache2proc_LQ_idxA,

            Dcache2proc_data_outB,   //connect to Dcache_last_data
            Dcache2proc_valid_outB,  //connect to Dcache_last_data write_en
            Dcache2proc_LQ_idxB,  //read from MSHR

            MSHR_full, //to prefetcher and LQ
            Icache2proc_addr_outB

);

input		  clock;
input             reset;

input  [63:0]          proc2Icache_addr;
input            proc2Icache_request;

input   [63:0]         prefetch2Icache_addr;
input            prefetch2Icache_request;

input    [63:0]        proc2Dcache_load_addr;
input    [2:0]       proc2Dcache_LQ_idx;
input            proc2Dcache_load_request;

input    [63:0]        proc2Dcache_store_addr;
input    [63:0]        proc2Dcache_store_data;
input            proc2Dcache_store_write_en;
input    [2:0]        proc2Dcache_SQ_idx;

input    [3:0]        mem2proc_tag;
input    [3:0]        mem2proc_response;
input    [63:0]       mem2proc_data;

input                 branch_recovery;

output	[63:0]	 proc2mem_addr;
output  [1:0]          proc2mem_command;
output   [63:0]         proc2mem_data;

output    [63:0]        Icache2proc_data_outA;  //from Icache
output            Icache2proc_valid_outA;

output            Icache2proc_grant;
output            Icache2prefetch_grant;
output            Dcache2proc_load_grant;
output            Dcache2proc_store_grant;

output    [63:0]        Icache2proc_data_outB;  //from mem
output            Icache2proc_valid_outB;

output     [63:0]       Dcache2proc_data_outA; //from Dcache
output            Dcache2proc_valid_outA;
output      [2:0]      Dcache2proc_LQ_idxA;

output      [63:0]      Dcache2proc_data_outB;   //connect to Dcache_last_data
output            Dcache2proc_valid_outB;  //connect to Dcache_last_data write_en
output      [2:0]      Dcache2proc_LQ_idxB;  //read from MSHR

output            MSHR_full; //to prefetcher and LQ
output     [63:0] Icache2proc_addr_outB;

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
//wire   [1:0]     proc2mem_command;
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
              
                 .branch_recovery(branch_recovery),
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
                 .Dcache2proc_store_grant(Dcache2proc_store_grant),

                 .Icache2proc_addr_outB(Icache2proc_addr_outB)                     
     
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

endmodule
