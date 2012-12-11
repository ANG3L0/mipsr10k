module SQ_test();

reg    clock;
reg    reset;

reg [4:0]   rob_idxA;
reg [4:0]   rob_idxB;
reg         id_wr_mem_enA;
reg         id_wr_mem_enB; 
reg         id_valid_IRA;
reg         id_valid_IRB;

reg [4:0]   ALU_SQ_idxA;
reg [4:0]   ALU_SQ_idxB;
reg [63:0]  ALU_store_dataA; //get from RS when issue
reg [63:0]  ALU_store_dataB;        
reg [63:0]  ALU_store_addrA;
reg [63:0]  ALU_store_addrB;
reg         ALU_wr_mem_enA;
reg         ALU_wr_mem_enB; 

reg         ROB2SQ_retire_en;
reg [63:0]  LQ2SQ_addr;
reg [4:0]   LQ2SQ_tail;
reg         LQ2SQ_search_en;
reg [4:0]   LQ2SQ_LQ_idx;

reg         branch_recovery;

wire        store_request;
wire [63:0] store_retire_addr;
wire [63:0] store_retire_data;

wire [4:0]  SQ2RS_idxA;
wire [4:0]  SQ2RS_idxB;
wire        SQ2RS_idxA_write_en;
wire        SQ2RS_idxB_write_en;

wire [4:0]  tail; 
wire [4:0]  next_tail;

wire [63:0] SQ2LQ_data;
wire        SQ2LQ_write_en;
wire [4:0]  SQ2LQ_LQ_idx;

wire        SQ_full;
wire        SQ_almost_full;

integer [5:0] i;
SQ SQ_0(
        //input
        .clock(clock),
        .reset(reset),
 
        .rob_idxA(rob_idxA),
        .rob_idxB(rob_idxB),

        .id_wr_mem_enA(id_wr_mem_enA),
        .id_wr_mem_enB(id_wr_mem_enB), 
        .id_valid_IRA(id_valid_IRA),
        .id_valid_IRB(id_valid_IRB),

        .ALU_SQ_idxA(ALU_SQ_idxA),
        .ALU_SQ_idxB(ALU_SQ_idxB),
        .ALU_store_dataA(ALU_store_dataA), //get from RS when issue
        .ALU_store_dataB(ALU_store_dataB),        
        .ALU_store_addrA(ALU_store_addrA),
        .ALU_store_addrB(ALU_store_addrB),
        .ALU_wr_mem_enA(ALU_wr_mem_enA),
        .ALU_wr_mem_enB(ALU_wr_mem_enB), 

        .ROB2SQ_retire_en(ROB2SQ_retire_en),

        .LQ2SQ_addr(LQ2SQ_addr),
        .LQ2SQ_tail(LQ2SQ_tail),
        .LQ2SQ_search_en(LQ2SQ_search_en),
        .LQ2SQ_LQ_idx(LQ2SQ_LQ_idx),

        .branch_recovery(branch_recovery),
        
        //output
        .store_request(store_request),
        .store_retire_addr(store_retire_addr),
        .store_retire_data(store_retire_data),

        .SQ2RS_idxA(SQ2RS_idxA),
        .SQ2RS_idxB(SQ2RS_idxB),
        .SQ2RS_idxA_write_en(SQ2RS_idxA_write_en),
        .SQ2RS_idxB_write_en(SQ2RS_idxB_wrote_en),

        .tail(tail), 
        .next_tail(next_tail),
  
        .SQ2LQ_data(SQ2LQ_data),
        .SQ2LQ_write_en(SQ2LQ_write_en),
        .SQ2LQ_LQ_idx(SQ2LQ_LQ_idx),

        .SQ_full(SQ_full),
        .SQ_almost_full(SQ_alsmot_full)

);

always
begin
  #5
  clock = ~clock;
end

initial
begin
  clock = 1;
  reset = 1;

  ALU_SQ_idxA = 0;
  ALU_SQ_idxB = 0;
  ALU_store_dataA = 0;
  ALU_store_dataB = 0;        
  ALU_store_addrA = 0;
  ALU_store_addrB = 0;
  ALU_wr_mem_enA = 0;
  ALU_wr_mem_enB = 0; 

  ROB2SQ_retire_en =0;

  LQ2SQ_addr = 0;
  LQ2SQ_tail = 0;
  LQ2SQ_search_en = 0;
  LQ2SQ_LQ_idx = 0;

  branch_recovery = 0;

  @(negedge clock);
  reset = 0;

//dispatch test
/*
  for(i=0; i<16; i=i+1)
  begin
    
    id_wr_mem_enA = 1;
    id_wr_mem_enB = 1;
    id_valid_IRA = 1;
    id_valid_IRB = 1;
    @(negedge clock);
  end
*/

//execute/complete 
  @(negedge clock);
  id_wr_mem_enA = 1;
  id_wr_mem_enB = 1;
  id_valid_IRA = 1;
  id_valid_IRB = 1;

  @(negedge clock);
  @(negedge clock);
  @(negedge clock);
  @(negedge clock);
  id_wr_mem_enA = 0;
  id_wr_mem_enB = 0;
  id_valid_IRA = 0;
  id_valid_IRB = 0;
  @(negedge clock);
  ALU_SQ_idxA = 5'd5;
  ALU_SQ_idxB = 6'd6;
  ALU_store_dataA = 64'd5;
  ALU_store_dataB = 64'd6;        
  ALU_store_addrA = 64'd55;
  ALU_store_addrB = 64'd66;
  ALU_wr_mem_enA = 1;
  ALU_wr_mem_enB = 1; 
  @(negedge clock);
  ALU_wr_mem_enA = 0;
  ALU_wr_mem_enB = 0;
  @(negedge clock); 

//retire test
  @(negedge clock);
  ROB2SQ_retire_en = 1;
  @(negedge clock);
  ROB2SQ_retire_en = 0;
  @(negedge clock);
$finish;
end

endmodule
