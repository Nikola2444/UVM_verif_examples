//  Library:  calc1
//  Module:  Hold Register
//  Author:  Naseer Siddique

 module holdreg(hold_data1, hold_data2, hold_prio_req, c_clk, req_cmd_in, req_data_in, reset);

   input c_clk;
   input [0:3] req_cmd_in;
   input [1:7] reset;
   input [0:31] req_data_in;
   
   output [0:3] hold_prio_req;
   output [0:31] hold_data1, hold_data2;
 

   reg [0:3] 	 cmd_hold, hold_prio_reg;
   wire [0:3] 	 cmd_hold_q;
   reg [0:31] 	 hold_data1_q, hold_data2_q;
   
   always 
     @ (posedge c_clk) begin
	fork
	   
	   cmd_hold[0:3] <= (reset[1] == 1) ?  4'b0 : req_cmd_in[0:3];
	   hold_prio_reg[0:3] <= cmd_hold[0:3];

	join
	     
     end
   

   always
     @ (posedge c_clk) begin
	fork
	   hold_data1_q[0:31] <= 
				 (reset[1]) ? 32'b0 : 
				 (req_cmd_in[0:3] != 4'b0) ? req_data_in[0:31] : 
				 hold_data1_q[0:31];

	   hold_data2_q[0:31] <= 
				 (reset[1]) ? 32'b0 : (cmd_hold[0:3] != 4'b0) ? 
				 req_data_in[0:31] : hold_data2_q[0:31];
	join
		     
     end
   
   
   assign hold_data1 = hold_data1_q;
   assign hold_data2 = hold_data2_q;
   assign hold_prio_req = hold_prio_reg;
   
endmodule // holdreg



   
