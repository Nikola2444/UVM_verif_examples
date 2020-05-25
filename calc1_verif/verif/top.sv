module calc_verif_top;

   import uvm_pkg::*;     // import the UVM library
`include "uvm_macros.svh" // Include the UVM macros

   import calc_test_pkg::*;

   logic clk;
   logic [6 : 0] rst = 0;

   // interface
   calc_if calc_vif_1(clk, rst);
   calc_if calc_vif_2(clk, rst);
   calc_if calc_vif_3(clk, rst);
   calc_if calc_vif_4(clk, rst);
   
   // DUT
   calc_top DUT(
                .c_clk        ( clk ),
                .reset        ( rst ),
                .out_data1    ( calc_vif_1.out_data ),
                .out_data2    ( calc_vif_2.out_data ),
                .out_data3    ( calc_vif_3.out_data ),
                .out_data4    ( calc_vif_4.out_data ),
                .out_resp1    ( calc_vif_1.out_resp ),
                .out_resp2    ( calc_vif_2.out_resp ),
                .out_resp3    ( calc_vif_3.out_resp ),
                .out_resp4    ( calc_vif_4.out_resp ),
                .req1_cmd_in  ( calc_vif_1.req_cmd_in ),
                .req1_data_in ( calc_vif_1.req_data_in ),
                .req2_cmd_in  ( calc_vif_2.req_cmd_in ),
                .req2_data_in ( calc_vif_2.req_data_in ),
                .req3_cmd_in  ( calc_vif_3.req_cmd_in ),
                .req3_data_in ( calc_vif_3.req_data_in ),
                .req4_cmd_in  ( calc_vif_4.req_cmd_in ),
                .req4_data_in ( calc_vif_4.req_data_in )
                );

   // run test
   initial begin     
       uvm_config_db#(virtual calc_if)::set(null, "uvm_test_top.env", "calc_if_1", calc_vif_1);
       uvm_config_db#(virtual calc_if)::set(null, "uvm_test_top.env", "calc_if_2", calc_vif_2);
       uvm_config_db#(virtual calc_if)::set(null, "uvm_test_top.env", "calc_if_3", calc_vif_3);
       uvm_config_db#(virtual calc_if)::set(null, "uvm_test_top.env", "calc_if_4", calc_vif_4);
       run_test();
   end
   // clock and reset init.
   initial begin
       clk <= 1;                  
       rst <= 7'h7f;
       for (int i = 0; i < 8; i++) begin
	   @(posedge clk);
       end
       rst <= 0;
   end

   // clock generation
   always #50 clk = ~clk;

endmodule : calc_verif_top
