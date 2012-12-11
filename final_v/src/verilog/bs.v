`define CDBWIDTH 6



   module bs ( // inputs 
               clock,
               reset,
               id_uncond_branchA,
               id_cond_branchA,
               id_uncond_branchB,
               id_cond_branchB, 
               id_destAidx,
               id_destBidx,
               rob_branch_idxA_in,   // this is for the set up case
               rob_branch_idxB_in,
               fl_headA_in,
               fl_headB_in,
               next_fl_headA_in,
               next_fl_headB_in,
               rob_branch_retire_in,
               rob_broadcastA_in,      // this is for the retire case
               IRA_valid,
               IRB_valid,
               // outputs
               fl_broadcastA_out
               );
   input 		                      clock;
   input 		                      reset;
   input 		                      id_uncond_branchA;
   input 		                      id_cond_branchA;
   input 	   	                    id_uncond_branchB;
   input 		                      id_cond_branchB;
   input    [`CDBWIDTH-2:0]       id_destAidx;
   input    [`CDBWIDTH-2:0]       id_destBidx;
   input    [`CDBWIDTH-2:0]       rob_branch_idxA_in;
   input    [`CDBWIDTH-2:0] 	    rob_branch_idxB_in;
   input    [`CDBWIDTH-2:0]       fl_headA_in;
   input    [`CDBWIDTH-2:0]       fl_headB_in;                 
   input    [`CDBWIDTH-2:0]       next_fl_headA_in;
   input    [`CDBWIDTH-2:0]       next_fl_headB_in;                 
   input    [`CDBWIDTH-2:0]       rob_broadcastA_in;
   input                          rob_branch_retire_in;
   input                          IRA_valid;
   input                          IRB_valid;

   output  reg  [`CDBWIDTH-2:0]       fl_broadcastA_out;
/////////////////internal reg and i
   reg      [`CDBWIDTH-2:0]       fl_head [31:0];
   reg      [5:0]                i;
///////////////////////////////////// second level control signal
   wire    branchA;
   wire    branchB;
   assign branchA = (id_uncond_branchA | id_cond_branchA) && IRA_valid;
   assign branchB = (id_uncond_branchB | id_cond_branchB) && IRB_valid;

      
      always @(posedge clock)
      begin
           if (reset)
             begin
             for (i=0; i < 'd32; i = i + 1)
              fl_head[i] <= 5'd31;
             end 
            else  begin
                 if (branchA && ~branchB) begin
                    if (id_destAidx==`ZERO_REG_5)
                      fl_head[rob_branch_idxA_in] <= fl_headA_in;
                    else
                      fl_head[rob_branch_idxA_in] <= fl_headA_in+1'b1;
                 end
                 if (branchB && ~branchA) begin
                      fl_head[rob_branch_idxB_in] <= next_fl_headA_in;
                 end
                 if (branchA && branchB) begin
                    if (id_destAidx==`ZERO_REG_5 && id_destBidx==`ZERO_REG_5) begin
                      fl_head[rob_branch_idxA_in] <= fl_headA_in;
                      fl_head[rob_branch_idxB_in] <= fl_headA_in;
                    end else if (id_destAidx==`ZERO_REG_5 && ~(id_destBidx==`ZERO_REG_5)) begin
                      fl_head[rob_branch_idxA_in] <= fl_headA_in;
                      fl_head[rob_branch_idxB_in] <= next_fl_headA_in;
                    end else if (~(id_destAidx==`ZERO_REG_5) && id_destBidx==`ZERO_REG_5) begin
                      fl_head[rob_branch_idxA_in] <= fl_headA_in+1'b1;
                      fl_head[rob_branch_idxB_in] <= next_fl_headA_in;
                    end else begin
                      fl_head[rob_branch_idxA_in] <= fl_headA_in+1'b1;
                      fl_head[rob_branch_idxB_in] <= next_fl_headA_in;
                    end
                 end
                 end 
            // LOL: assert property(@(posedge clock)
            //   branchA && branchB |=> (id_destAidx==`ZERO_REG_5 && id_destBidx==`ZERO_REG_5)
            // )
            // else $error("LOLHIT!");
      end 

       always @*
         begin
         fl_broadcastA_out = 5'd31;
         if (rob_branch_retire_in)
             fl_broadcastA_out = fl_head[rob_broadcastA_in];
         end 
   endmodule 
          







 




   
             












