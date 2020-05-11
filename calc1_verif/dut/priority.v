//  Library:  calc1
//  Priority Logic
//  Author: Naseer Siddique

module priority ( prio_alu1_in_cmd, prio_alu1_in_req_id, prio_alu1_out_req_id, prio_alu1_out_vld, prio_alu2_in_cmd, prio_alu2_in_req_id, prio_alu2_out_req_id, prio_alu2_out_vld, c_clk, hold1_prio_req, hold2_prio_req, hold3_prio_req, hold4_prio_req, local_error_found, reset);
   

   output [0:3] prio_alu1_in_cmd, prio_alu2_in_cmd;
   output [0:1] prio_alu1_out_req_id, prio_alu1_in_req_id, prio_alu2_in_req_id, prio_alu2_out_req_id;
   output 	prio_alu1_out_vld, prio_alu2_out_vld;

   input 	c_clk, local_error_found;
   input [0:3] 	hold1_prio_req, hold2_prio_req, hold3_prio_req, hold4_prio_req;
   input [1:7] 	reset;
   
   reg [0:3] 	cmd1, cmd2, cmd3, cmd4;
   reg 		delay1, delay2;

   wire 	cmd1_reset, cmd2_reset, cmd3_reset, cmd4_reset;
   
   reg [0:1] 	prio_req1_id_q, prio_req2_id_q;
   
   reg 	prio_alu1_out_vld_q, prio_alu2_out_vld_q;

   always
     @ (negedge c_clk) begin
	fork
	   delay1 <= prio_alu1_out_vld_q;
	   delay2 <= prio_alu2_out_vld_q;
	   
	   cmd1[0:3] <= 
			(hold1_prio_req[0:3] != 4'b0) ? hold1_prio_req[0:3] :
			(cmd1_reset) ? 4'b0 :
			cmd1[0:3];
	   
	   cmd2[0:3] <=
		       (hold2_prio_req[0:3] != 4'b0) ? hold2_prio_req[0:3] :
		       (cmd2_reset) ? 4'b0 :
		       cmd2[0:3];
	   
	   cmd3[0:3] <=
		       (hold3_prio_req[0:3] != 4'b0) ? hold3_prio_req[0:3] :
		       (cmd3_reset) ? 4'b0 :
		       cmd3[0:3];
	   
	   cmd4[0:3] <=
		       (hold4_prio_req[0:3] != 4'b0) ? hold4_prio_req[0:3] :
		       (cmd4_reset) ? 4'b0 :
		       cmd4[0:3];
	join
	
	   
     end // always @ (negedge c_clk)

     always
     @ (delay1 or delay2 or cmd1 or cmd2 or cmd3 or cmd4) begin
	
	if (delay1) 
	  prio_alu1_out_vld_q <= 1'b0;
	else if ( (cmd1 != 4'b0000) && (cmd1 < 4'b0100) )
	  prio_alu1_out_vld_q <= 1'b1;
	else if ( (cmd2 != 4'b0000) && (cmd2 < 4'b0100) )
	  prio_alu1_out_vld_q <= 1'b1;
	else if ( (cmd3 != 4'b0000) && (cmd3 < 4'b0100) )
	  prio_alu1_out_vld_q <= 1'b1;
	else if ( (cmd4 != 4'b0000) && (cmd4 < 4'b0100) && local_error_found )
	  prio_alu1_out_vld_q <= 1'b1;
	else if ( (cmd4 != 4'b0000) && (cmd4 < 4'b0100) )
	  prio_alu1_out_vld_q <= 1'b0;
	else prio_alu1_out_vld_q <= 1'b0;
		
	if (delay2)
	  prio_alu2_out_vld_q <= 1'b0;
	else if (cmd1 > 4'b0011)
	  prio_alu2_out_vld_q <= 1'b1;
	else if (cmd2 > 4'b0011)
	  prio_alu2_out_vld_q <= 1'b1;
	else if (cmd3 > 4'b0011)
	  prio_alu2_out_vld_q <= 1'b1;
	else if (cmd4 > 4'b0011)
	  prio_alu2_out_vld_q <= 1'b1;
	else prio_alu2_out_vld_q <= 1'b0;
        
	if ( (cmd1 != 4'b0000) && (cmd1 < 4'b0100) )
	  prio_req1_id_q[0:1] <= 2'b00;      
	else if ( (cmd2 != 4'b0000) && (cmd2 < 4'b0100) )
	  prio_req1_id_q[0:1] <= 2'b01;
	else if ( (cmd3 != 4'b0000) && (cmd3 < 4'b0100) )
	  prio_req1_id_q[0:1] <= 2'b10;
	else if ( (cmd4 != 4'b0000) && (cmd4 < 4'b0100) )
	  prio_req1_id_q[0:1] <= 2'b11;
	else prio_req1_id_q[0:1] <= 2'b00;
	
	if ( cmd1 > 4'b0011 )
	  prio_req2_id_q <= 2'b00;
	else if ( cmd2 > 4'b0011 )
	  prio_req2_id_q <= 2'b01;
	else if ( cmd3 > 4'b0011 )
	  prio_req2_id_q <= 2'b10;
	else if ( cmd4 > 4'b0011 )
	  prio_req2_id_q <= 2'b11;
	else prio_req2_id_q <= 2'b00;
	
     end // always @ (delay1 or or delay2 or cmd1 or cmd2 or cmd3 or cmd4)

   assign prio_alu1_in_req_id[0:1] = prio_req1_id_q[0:1];
   assign prio_alu2_in_req_id[0:1] = prio_req2_id_q[0:1];
   assign prio_alu1_out_req_id[0:1] = prio_req1_id_q[0:1];
   assign prio_alu2_out_req_id[0:1] = prio_req2_id_q[0:1];
   assign prio_alu1_out_vld = prio_alu1_out_vld_q;
   assign prio_alu2_out_vld = prio_alu2_out_vld_q;
   
   assign prio_alu1_in_cmd[0:3] =
	  (prio_req1_id_q[0:1] == 2'b00) ? cmd1[0:3] :
	  (prio_req1_id_q[0:1] == 2'b01) ? cmd2[0:3] :
	  (prio_req1_id_q[0:1] == 2'b10) ? cmd3[0:3] :
	  (prio_req1_id_q[0:1] == 2'b11) ? cmd4[0:3] :
	  4'b0;
   
   assign prio_alu2_in_cmd[0:3] =
	  (prio_req2_id_q[0:1] == 2'b00) ? cmd1[0:3] :
	  (prio_req2_id_q[0:1] == 2'b01) ? cmd2[0:3] :
	  (prio_req2_id_q[0:1] == 2'b10) ? cmd3[0:3] :
	  (prio_req2_id_q[0:1] == 2'b11) ? cmd4[0:3] :
	  4'b0;
   
   
   assign cmd1_reset =
	  (prio_alu1_out_vld_q && (prio_req1_id_q[0:1] == 2'b00) ) ? 1 :
	  (prio_alu2_out_vld_q && (prio_req2_id_q[0:1] == 2'b00) ) ? 1 :
	  0;
   
   assign cmd2_reset =
	  (prio_alu1_out_vld_q && (prio_req1_id_q[0:1] == 2'b01) ) ? 1 :
	  (prio_alu2_out_vld_q && (prio_req2_id_q[0:1] == 2'b01) ) ? 1 :
	  0;
   
   assign cmd3_reset =
	  (prio_alu1_out_vld_q && (prio_req1_id_q[0:1] == 2'b10) ) ? 1 :
	  (prio_alu2_out_vld_q && (prio_req2_id_q[0:1] == 2'b10) ) ? 1 :
	  0;
   
   assign cmd4_reset =
	  (prio_alu1_out_vld_q && (prio_req1_id_q[0:1] == 2'b11) ) ? 1 :
	  (prio_alu2_out_vld_q && (prio_req2_id_q[0:1] == 2'b11) ) ? 1 :
	  0;
   
endmodule // priority
