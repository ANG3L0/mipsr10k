

  module testbench;
  
  reg clock;
  reg reset;
  
//  wire [63:0] Imem2proc_data;
  reg one_ins_en_in;
  reg non_ins_en_in;

  // distinct  inputs for memory
  reg  [1:0]  proc2mem_command;
  reg  [63:0] proc2mem_data;
  wire [63:0] proc2Imem_addr; 
 
  // distinct  output for memory
  wire  [3:0]  mem2proc_response;
  wire  [63:0] mem2proc_data;
  wire  [3:0]  mem2proc_tag; 

  // output for the next stage
  wire    [1:0]   id_opa_select_outA;
  wire    [1:0]   id_opb_select_outA;
  wire    [1:0]   id_opa_select_outB;
  wire    [1:0]   id_opb_select_outB;
  wire    [4:0]   id_dest_reg_idx_outA;
  wire    [4:0]   id_dest_reg_idx_outB;
  wire    [4:0]   id_alu_func_outA;
  wire    [4:0]   id_alu_func_outB;
  wire   [31:0]   id_IRA_out;
  wire   [31:0]   id_IRB_out;
  wire            id_IRA_valid_out;
  wire            id_IRB_valid_out;





  pipeline pipeline_0 ( //inputs
                       .clock(clock),
                       .reset(reset),
                       .one_ins_en_in(one_ins_en_in),
                       .non_ins_en_in(non_ins_en_in),
                       .mem2proc_data(mem2proc_data),
                        // outputs
                       .proc2Imem_addr(proc2Imem_addr),
                       .id_opa_select_outA(id_opa_select_outA),
                       .id_opb_select_outA(id_opb_select_outA),
                       .id_opa_select_outB(id_opa_select_outB),
                       .id_opb_select_outB(id_opb_select_outB),
                       
                       .id_dest_reg_idx_outA(id_dest_reg_idx_outA),
                       .id_dest_reg_idx_outB(id_dest_reg_idx_outB),
                       .id_alu_func_outA(id_alu_func_outA),
                       .id_alu_func_outB(id_alu_func_outB),
                       .id_IRA_out(id_IRA_out),
                       .id_IRB_out(id_IRB_out),
                       .id_IRA_valid_out(id_IRA_valid_out),
                       .id_IRB_valid_out(id_IRB_valid_out)

);


   mem memory ( // inputs
                .clk              (clock),
                .proc2mem_command (proc2mem_command),
                .proc2mem_addr    (proc2Imem_addr), 
                .proc2mem_data    (proc2mem_data),
                 
                // outputs
                .mem2proc_response(mem2proc_response),
                .mem2proc_data    (mem2proc_data),  
                .mem2proc_tag     (mem2proc_tag)
                 );

  always
  begin 
  #5 ;
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

  initial begin
  clock = 1'b0;
  reset = 1'b0;
  one_ins_en_in = 1'b0;
  non_ins_en_in = 1'b0;  
  proc2mem_data = 64'b0;
  proc2mem_command = `BUS_LOAD;
   
  $display("@@\n@@\n@@  %t  Asserting System reset......", $realtime);
 @(negedge clock)   
  reset = 1'b1;
//  @(posedge clock);   
//  @(posedge clock);
  $readmemh("program.mem", memory.unified_memory);
    
//  @(posedge clock);
//  @(posedge clock); 
//  `SD;


  $display ("I am done with the memmory allocation");
 @(negedge clock);
  reset = 1'b0;

  @(negedge clock);
   one_ins_en_in = 1'b0;
   non_ins_en_in = 1'b0;
  
  @(negedge clock); 
   one_ins_en_in = 1'b0;
   non_ins_en_in = 1'b0;

  @(negedge clock);
   one_ins_en_in = 1'b1;
   non_ins_en_in = 1'b0;

  @(negedge clock);
   one_ins_en_in = 1'b0;
   non_ins_en_in = 1'b0;

  @(negedge clock);
   one_ins_en_in = 1'b0;
   non_ins_en_in = 1'b0;

  @(negedge clock);
   one_ins_en_in = 1'b0;
   non_ins_en_in = 1'b1;

  @(negedge clock);
   one_ins_en_in = 1'b1;
   non_ins_en_in = 1'b0;
 
  @(negedge clock);
   one_ins_en_in = 1'b0;
   non_ins_en_in = 1'b0;
  
  @(negedge clock);
  @(negedge clock);
  @(negedge clock);
  @(negedge clock);
  $finish;

  end 

endmodule







