   module mem_stage( // inputs 
                    clock,
                    reset,
                    ex_mem_rega,
                    ex_mem_alu_result,
                    ex_mem_rd_mem,
                    ex_mem_wr_mem,
                    Dmem2proc_data,
                    // Outputs
                    mem_result_out,
                    proc2Dmem_command,
                    proc2Dmem_addr,
                    proc2Dmem_data 
                   );

       input 		clock;
       input 		reset;
       input 	[63:0]  ex_mem_rega;
       input    [63:0]  ex_mem_alu_result;
       input            ex_mem_rd_mem;
       input            ex_mem_wr_mem;
       input    [63:0]  Dmem2proc_data;

       output   [63:0]  mem_result_out;
       output   [1:0]   proc2Dmem_command; 
       output   [63:0]  proc2Dmem_addr;
       output   [63:0]  proc2Dmem_data;

      assign  proc2Dmem_command = 
          ex_mem_wr_mem ? `BUS_STORE
                        : ex_mem_rd_mem ? `BUS_LOAD
                                        : `BUS_NONE;
      assign  proc2Dmem_data = ex_mem_rega;
      assign  proc2Dmem_addr = ex_mem_alu_result;
      assign  mem_result_out = (ex_mem_rd_mem) ? Dmem2proc_data : ex_mem_alu_result;

  endmodule



