`define CDBWIDTH        6

module archtable_testbench;
  reg           clk;
  reg           reset;
  reg	        retire_enA;
  reg	        retire_enB;
  reg   [5:0]	retire_valueA;
  reg	[5:0]	retire_valueB;
  reg   [4:0]	retire_indexA;
  reg	[4:0]	retire_indexB;

archtable archtable
( .clk(clk),
  .reset(reset),
  .retire_enA(retire_enA),
  .retire_enB(retire_enB),
  .retire_valueA(retire_valueA),
  .retire_valueB(retire_valueB),
  .retire_indexA(retire_indexA),
  .retire_indexB(retire_indexB)

);


//always @(correct)
//	begin
//	#2
//	if(!correct)
//	begin
//		$display("@@@ Incorrect at time %4.0f", $time);
//		$finish;
//	end
//end
always
  #5 clk=~clk;

initial 
begin
 // $monitor("Time:%4.0f, retire_enA:%b, retire_enB:%b, retire_valueA:%d, retire_valueB:%d, retire_indexA:%d, retire_indexA:%d", )
  clk = 0;
  reset = 1;
  @(negedge clk);
  reset = 0;
  retire_enA = 0;
  retire_enB = 0;
  retire_valueA = 6'd0;
  retire_valueB = 6'd0;
  retire_indexA = 5'd0;
  retire_indexB = 5'd0;
  @(negedge clk);
  retire_enA = 0;
  retire_enB = 1;
  retire_valueA = 6'd0;
  retire_valueB = 6'd45;
  retire_indexA = 5'd0;
  retire_indexB = 5'd2;
  @(negedge clk);
  retire_enA = 1;
  retire_enB = 0;
  retire_valueA = 6'd23;
  retire_valueB = 6'd0;
  retire_indexA = 5'd30;
  retire_indexB = 5'd0;
  @(negedge clk);
  retire_enA = 1;
  retire_enB = 1;
  retire_valueA = 6'd48;
  retire_valueB = 6'd13;
  retire_indexA = 5'd18;
  retire_indexB = 5'd4;
  #10
  $finish;
end
endmodule
  
  

