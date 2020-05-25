`ifndef CALC_IF_SV
 `define CALC_IF_SV

interface calc_if (input clk, logic [6 : 0] rst);

   parameter DATA_WIDTH = 32;
   parameter RESP_WIDTH = 2;
   parameter CMD_WIDTH = 4;

   logic [DATA_WIDTH - 1 : 0]  out_data;   
   logic [RESP_WIDTH - 1 : 0]  out_resp;      
   logic [CMD_WIDTH - 1 : 0]   req_cmd_in = 0;
   logic [DATA_WIDTH - 1 : 0]  req_data_in = 0;
   
endinterface : calc_if

`endif
