//  Library:  calc1
//  Module: ALU Input Stage
//  Author: Naseer SIddique

module alu_input_stage (alu_data1, alu_data2, hold1_data1, hold1_data2, hold2_data1, hold2_data2, hold3_data1, hold3_data2, hold4_data1, hold4_data2, prio_alu_in_cmd, prio_alu_in_req_id);

   output [0:63] alu_data1, alu_data2;

   wire [0:63] 	 alu_data1, alu_data2;
   
   input [0:31]  hold1_data1, hold1_data2, 
		 hold2_data1, hold2_data2, 
		 hold3_data1, hold3_data2, 
		 hold4_data1, hold4_data2;

   input [0:3] 	 prio_alu_in_cmd;
   input [0:1] 	 prio_alu_in_req_id;

   assign alu_data1[32:63] =
	  prio_alu_in_req_id[0:1] == 2'b00 ? hold1_data1[0:31] :
	  prio_alu_in_req_id[0:1] == 2'b01 ? hold2_data1[0:31] :
	  prio_alu_in_req_id[0:1] == 2'b10 ? hold3_data1[0:31] :
	  prio_alu_in_req_id[0:1] == 2'b11 ? hold4_data1[0:31] :
	  32'b0;
   
   assign alu_data2[32:63] =
	  prio_alu_in_req_id[0:1] == 2'b00 ? hold1_data2[0:31] :
	  prio_alu_in_req_id[0:1] == 2'b01 ? hold2_data2[0:31] :
	  prio_alu_in_req_id[0:1] == 2'b10 ? hold3_data2[0:31] :
	  prio_alu_in_req_id[0:1] == 2'b11 ? hold4_data2[0:31] :
	  32'b0;

   assign alu_data1[0:31] = 32'b0;
   assign alu_data2[0:31] = 32'b0;
   
endmodule // alu_input_stage
