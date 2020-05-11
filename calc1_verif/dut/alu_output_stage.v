//  Library:  calc1
//  Module:  ALU Output Stage
//  Author: Naseer Siddique

module alu_output_stage(out_data1, out_data2, out_data3, out_data4, out_resp1, out_resp2, out_resp3, out_resp4, c_clk,alu_overflow, alu_result,  local_error_found, prio_alu_out_req_id, prio_alu_out_vld, reset);
   
   output [0:31] out_data1, out_data2, out_data3, out_data4;
   output [0:1]  out_resp1, out_resp2, out_resp3, out_resp4;

   input [0:63] alu_result;
   input [0:1] 	prio_alu_out_req_id;
   input [1:7] 	reset;
   input 	c_clk, 
		alu_overflow, 
		local_error_found, 
		prio_alu_out_vld;
   
   wire [0:31] 	hold_data;
   wire [0:1] 	hold_resp, hold_id;

   assign hold_id[0:1] = prio_alu_out_req_id[0:1];
	
   assign hold_resp[0:1] = 
	  (~prio_alu_out_vld) ? 2'b00 :
	  (~local_error_found) ? 2'b01 :
	  (alu_result[31]) ? 2'b10 :
	  2'b01;

   assign hold_data[0:31] = (prio_alu_out_vld) ? alu_result[32:63] : 32'b0;
   
   assign out_resp1[0:1] = (hold_id[0:1] == 2'b00) ? hold_resp[0:1] : 2'b00;
   
   assign   out_resp2[0:1] = (hold_id[0:1] == 2'b01) ? hold_resp[0:1] : 2'b00;
   
   assign   out_resp3[0:1] = (hold_id[0:1] == 2'b10) ? hold_resp[0:1] : 2'b00;
   
   assign   out_resp4[0:1] = (hold_id[0:1] == 2'b11) ? hold_resp[0:1] : 2'b00;
   
   assign   out_data1[0:31] = (hold_id[0:1] == 2'b00) ? hold_data[0:31] : 32'b0;
   
   assign   out_data2[0:31] = (hold_id[0:1] == 2'b01) ? hold_data[0:31] : 32'b0;
   
   assign   out_data3[0:31] = (hold_id[0:1] == 2'b10) ? hold_data[0:31] : 32'b0;
   
   assign   out_data4[0:31] = (hold_id[0:1] == 2'b11) ? hold_data[0:31] : 32'b0;
      
endmodule
