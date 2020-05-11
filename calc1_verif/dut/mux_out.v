//  Library:  calc1
//  Module:  Output Mux
//  Author: Naseer Siddique

module mux_out(req_data, req_resp, req_data1, req_data2, req_resp1, req_resp2);
   
   output [0:31] req_data;
   output [0:1]  req_resp;
   
   input [0:31]  req_data1, req_data2;
   input [0:1] 	 req_resp1, req_resp2;
   
   assign 	 req_resp[0:1] = 
		 (req_resp1[0:1] != 2'b00) ? req_resp1 :
		 ( req_resp2[0:1] != 2'b00 )  ? req_resp2 :
		 2'b00;

   assign 	 req_data[0:31] = 
		 ( req_resp1[0:1] != 2'b00 ) ? req_data1 :
		 ( req_resp2[0:1] != 2'b00 ) ? req_data2 :
		 32'b0;
   
      
   
endmodule // mux_out


