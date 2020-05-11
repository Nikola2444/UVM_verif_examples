// Library:  calc1
// Module:  Top-level wiring
// Author:  Naseer Siddique

`include "alu_input_stage.v"
`include "alu_output_stage.v"
`include "exdbin_mac.v"
`include "holdreg.v"
`include "mux_out.v"
`include "priority.v"
`include "shifter.v"

module calc_top (out_data1, out_data2, out_data3, out_data4, out_resp1, out_resp2, out_resp3, out_resp4, c_clk, req1_cmd_in, req1_data_in, req2_cmd_in, req2_data_in, req3_cmd_in, req3_data_in, req4_cmd_in, req4_data_in, reset);

   output [0:31] out_data1, 
		 out_data2, 
		 out_data3, 
		 out_data4;

   output [0:1]  out_resp1, 
		 out_resp2, 
		 out_resp3, 
		 out_resp4;


   input 	 c_clk;

   input [0:3]  req1_cmd_in, 
		 req2_cmd_in, 
		 req3_cmd_in, 
		 req4_cmd_in;
   
   input [0:31]  req1_data_in,		
		 req2_data_in, 
		 req3_data_in, 
		 req4_data_in;
      
   input [1:7] 	 reset;

   wire [0:63] 	 add_sum, 
		 fxu_areg_q,
		 fxu_breg_q,
		 shift_out,
		 shift_places,
		 shift_val;

   wire [0:31] 	 hold1_data1,
 		 hold1_data2,
		 hold2_data1,
		 hold2_data2,
		 hold3_data1,
		 hold3_data2,
		 hold4_data1,
		 hold4_data2,
		 mux1_req_data1,
		 mux1_req_data2,
		 mux2_req_data1,
		 mux2_req_data2,
		 mux3_req_data1,
		 mux3_req_data2,
		 mux4_req_data1,
		 mux4_req_data2;
   
   wire [0:3] 	 hold1_prio_req,
		 hold2_prio_req,
		 hold3_prio_req,
		 hold4_prio_req,
		 prio_alu1_in_cmd,
		 prio_alu2_in_cmd;
   
   wire [0:1] 	 mux1_req_resp1,
		 mux1_req_resp2,
		 mux2_req_resp1,
		 mux2_req_resp2,
		 mux3_req_resp1,
		 mux3_req_resp2,
		 mux4_req_resp1,
		 mux4_req_resp2,
		 prio_alu1_in_req_id,
		 prio_alu1_out_req_id,
		 prio_alu2_in_req_id,
		 prio_alu2_out_req_id;
   
   wire 	 prio_alu1_out_vld,
		 prio_alu2_out_vld,
		 add_ovfl,
		 shift_ovfl;
	      
   wire [0:3] error_found;
   assign error_found = 4'b0000;

   exdbin_mac adder (
		     .alu_cmd ( prio_alu1_in_cmd[0:3] ),
		     .bin_ovfl ( add_ovfl ),
		     .bin_sum ( add_sum[0:63] ),
		     .fxu_areg_q ( fxu_areg_q[0:63] ),
		     .fxu_breg_q ( fxu_breg_q[0:63] ),
		     .local_error_found ( error_found[0] )
		     );
   
        
   holdreg holdreg1(
		    .c_clk ( c_clk ),
		    .hold_data1 ( hold1_data1[0:31] ),
		    .hold_data2 ( hold1_data2[0:31] ),
		    .hold_prio_req ( hold1_prio_req[0:3] ),
		    .req_cmd_in ( req1_cmd_in[0:3] ),
		    .req_data_in ( req1_data_in[0:31] ),
		    .reset ( reset [1: 7] )
		    );

     holdreg holdreg2(
		    .c_clk ( c_clk ),
		    .hold_data1 ( hold2_data1[0:31] ),
		    .hold_data2 ( hold2_data2[0:31] ),
		    .hold_prio_req ( hold2_prio_req[0:3] ),
		    .req_cmd_in ( req2_cmd_in[0:3] ),
		    .req_data_in ( req2_data_in[0:31] ),
		    .reset ( reset [1: 7] )
		    );

     holdreg holdreg3(
		    .c_clk ( c_clk ),
		    .hold_data1 ( hold3_data1[0:31] ),
		    .hold_data2 ( hold3_data2[0:31] ),
		    .hold_prio_req ( hold3_prio_req[0:3] ),
		    .req_cmd_in ( req3_cmd_in[0:3] ),
		    .req_data_in ( req3_data_in[0:31] ),
		    .reset ( reset [1: 7] )
		    );

     holdreg holdreg4(
		    .c_clk ( c_clk ),
		    .hold_data1 ( hold4_data1[0:31] ),
		    .hold_data2 ( hold4_data2[0:31] ),
		    .hold_prio_req ( hold4_prio_req[0:3] ),
		    .req_cmd_in ( req4_cmd_in[0:3] ),
		    .req_data_in ( req4_data_in[0:31] ),
		    .reset ( reset [1: 7] )
		    );

   alu_input_stage in_stage1(
			     .alu_data1 ( fxu_areg_q[0:63]),
			     .alu_data2 ( fxu_breg_q[0:63]),
			     .hold1_data1 ( hold1_data1[0:31]),
			     .hold1_data2 ( hold1_data2[0:31]),
			     .hold2_data1 ( hold2_data1[0:31]),
			     .hold2_data2 ( hold2_data2[0:31]),
			     .hold3_data1 ( hold3_data1[0:31]),
			     .hold3_data2 ( hold3_data2[0:31]),
			     .hold4_data1 ( hold4_data1[0:31]),
			     .hold4_data2 ( hold4_data2[0:31]),
			     .prio_alu_in_cmd ( prio_alu1_in_cmd[0:3]),
			     .prio_alu_in_req_id ( prio_alu1_in_req_id[0:1])
			     );

    alu_input_stage in_stage2(
			     .alu_data1 ( shift_val[0:63]),
			     .alu_data2 ( shift_places[0:63]),
			     .hold1_data1 ( hold1_data1[0:31]),
			     .hold1_data2 ( hold1_data2[0:31]),
			     .hold2_data1 ( hold2_data1[0:31]),
			     .hold2_data2 ( hold2_data2[0:31]),
			     .hold3_data1 ( hold3_data1[0:31]),
			     .hold3_data2 ( hold3_data2[0:31]),
			     .hold4_data1 ( hold4_data1[0:31]),
			     .hold4_data2 ( hold4_data2[0:31]),
			     .prio_alu_in_cmd ( prio_alu2_in_cmd[0:3]),
			     .prio_alu_in_req_id ( prio_alu2_in_req_id[0:1])
			     );
   
   mux_out mux_out1(
		    .req_data1 ( mux1_req_data1[0:31]),
		    .req_data2 ( mux1_req_data2[0:31]),
		    .req_data ( out_data1[0:31]),
		    .req_resp1 ( mux1_req_resp1[0:1]),
		    .req_resp2 ( mux1_req_resp2[0:1]),
		    .req_resp ( out_resp1[0:1])
		    );

   mux_out mux_out2(
		    .req_data1 ( mux2_req_data1[0:31]),
		    .req_data2 ( mux2_req_data2[0:31]),
		    .req_data ( out_data2[0:31]),
		    .req_resp1 ( mux2_req_resp1[0:1]),
		    .req_resp2 ( mux2_req_resp2[0:1]),
		    .req_resp ( out_resp2[0:1])
		    );

   mux_out mux_out3(
		    .req_data1 ( mux3_req_data1[0:31]),
		    .req_data2 ( mux3_req_data2[0:31]),
		    .req_data ( out_data3[0:31]),
		    .req_resp1 ( mux3_req_resp1[0:1]),
		    .req_resp2 ( mux3_req_resp2[0:1]),
		    .req_resp ( out_resp3[0:1])
		    );

   mux_out mux_out4(
		    .req_data1 ( mux4_req_data1[0:31]),
		    .req_data2 ( mux4_req_data2[0:31]),
		    .req_data ( out_data4[0:31]),
		    .req_resp1 ( mux4_req_resp1[0:1]),
		    .req_resp2 ( mux4_req_resp2[0:1]),
		    .req_resp ( out_resp4[0:1])
		    );

   alu_output_stage out_stage1(
			       .alu_overflow ( add_ovfl),
			       .alu_result ( add_sum[0:63]),
			       .c_clk ( c_clk),
			       .local_error_found ( error_found[2]),
			       .out_data1 ( mux1_req_data1[0:31]),
			       .out_data2 ( mux2_req_data1[0:31]),
			       .out_data3 ( mux3_req_data1[0:31]),
			       .out_data4 ( mux4_req_data1[0:31]),
			       .out_resp1 ( mux1_req_resp1[0:1]),
			       .out_resp2 ( mux2_req_resp1[0:1]),
			       .out_resp3 ( mux3_req_resp1[0:1]),
			       .out_resp4 ( mux4_req_resp1[0:1]),
			       .prio_alu_out_req_id ( prio_alu1_out_req_id[0:1]),
			       .prio_alu_out_vld ( prio_alu1_out_vld ),
			       .reset ( reset[1:7])
			       );

      alu_output_stage out_stage2(
			       .alu_overflow ( shift_ovfl),
			       .alu_result ( shift_out[0:63]),
			       .c_clk ( c_clk),
			       .local_error_found ( error_found[2]),
			       .out_data1 ( mux1_req_data2[0:31]),
			       .out_data2 ( mux2_req_data2[0:31]),
			       .out_data3 ( mux3_req_data2[0:31]),
			       .out_data4 ( mux4_req_data2[0:31]),
			       .out_resp1 ( mux1_req_resp2[0:1]),
			       .out_resp2 ( mux2_req_resp2[0:1]),
			       .out_resp3 ( mux3_req_resp2[0:1]),
			       .out_resp4 ( mux4_req_resp2[0:1]),
			       .prio_alu_out_req_id ( prio_alu2_out_req_id[0:1]),
			       .prio_alu_out_vld ( prio_alu2_out_vld ),
			       .reset ( reset[1:7])
			       );

   priority priority_logic (
			    .c_clk ( c_clk),
			    .hold1_prio_req ( hold1_prio_req[0:3]),
			    .hold2_prio_req ( hold2_prio_req[0:3]),
			    .hold3_prio_req ( hold3_prio_req[0:3]),
			    .hold4_prio_req ( hold4_prio_req[0:3]),
			    .local_error_found ( error_found[3]),
			    .prio_alu1_in_cmd ( prio_alu1_in_cmd[0:3]),
			    .prio_alu1_in_req_id ( prio_alu1_in_req_id[0:1]),
			    .prio_alu1_out_req_id ( prio_alu1_out_req_id[0:1]),
			    .prio_alu1_out_vld ( prio_alu1_out_vld),
			    .prio_alu2_in_cmd ( prio_alu2_in_cmd[0:3]),
			    .prio_alu2_in_req_id ( prio_alu2_in_req_id[0:1]),
			    .prio_alu2_out_req_id ( prio_alu2_out_req_id[0:1]),
			    .prio_alu2_out_vld ( prio_alu2_out_vld),
			    .reset ( reset[1:7])
			    );
   
   shifter shifter1(
		    .bin_ovfl ( shift_ovfl),
		    .local_error_found ( error_found[1]),
		    .shift_cmd ( prio_alu2_in_cmd[0:3]),
		    .shift_out ( shift_out[0:63]),
		    .shift_places ( shift_places[0:63]),
		    .shift_val ( shift_val[0:63])
		    );

endmodule // calc1_top





	
		       
