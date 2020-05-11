`ifndef CALC_SEQ_ITEM_SV
 `define CALC_SEQ_ITEM_SV

parameter DATA_WIDTH = 32;
parameter RESP_WIDTH = 2;
parameter CMD_WIDTH = 4;

class calc_seq_item extends uvm_sequence_item;

   rand bit [CMD_WIDTH - 1 : 0]   req1_cmd_in;
   rand bit [DATA_WIDTH - 1 : 0]  req1_data_in;
   rand bit [CMD_WIDTH - 1 : 0]   req2_cmd_in;
   rand bit [DATA_WIDTH - 1 : 0]  req2_data_in;
   rand bit [CMD_WIDTH - 1 : 0]   req3_cmd_in;
   rand bit [DATA_WIDTH - 1 : 0]  req3_data_in;
   rand bit [CMD_WIDTH - 1 : 0]   req4_cmd_in;
   rand bit [DATA_WIDTH - 1 : 0]  req4_data_in;
   bit [6 : 0] 		     reset = 7'h7f;

   constraint reg1_data_constraint { reg1_data_in < 50; }
   constraint reg2_data_constraint { reg2_data_in < 50; }
   constraint reg3_data_constraint { reg3_data_in < 50; }
   constraint reg4_data_constraint { reg4_data_in < 50; }
   

   `uvm_object_utils_begin(calc_seq_item)      
      `uvm_field_int(req1_cmd_in, UVM_DEFAULT)
      `uvm_field_int(req2_cmd_in, UVM_DEFAULT)
      `uvm_field_int(req3_cmd_in, UVM_DEFAULT)
      `uvm_field_int(req4_cmd_in, UVM_DEFAULT)
      `uvm_field_int(req1_data_in, UVM_DEFAULT)
      `uvm_field_int(req2_data_in, UVM_DEFAULT)
      `uvm_field_int(req3_data_in, UVM_DEFAULT)
      `uvm_field_int(req4_data_in, UVM_DEFAULT)
      `uvm_field_int(reset, UVM_DEFAULT)      
   `uvm_object_utils_end

   function new (string name = "calc_seq_item");
      super.new(name);
   endfunction // new

endclass : calc_seq_item

`endif
