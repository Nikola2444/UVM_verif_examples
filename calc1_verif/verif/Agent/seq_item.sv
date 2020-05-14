`ifndef CALC_SEQ_ITEM_SV
 `define CALC_SEQ_ITEM_SV

parameter DATA_WIDTH = 32;
parameter RESP_WIDTH = 2;
parameter CMD_WIDTH = 4;

class calc_seq_item extends uvm_sequence_item;

   rand bit [CMD_WIDTH - 1 : 0]   command;
   rand bit [DATA_WIDTH - 1 : 0]  operand1;
   rand bit [DATA_WIDTH - 1 : 0]  operand2;   

   constraint operand1_data_constraint { operand1 < 5; }
   // Zbog postojanja bug-a u dizajnu operand 2 je ogranicen
   // na vrednost manju od 16 jer u suprotnom dut ne radi/
   // ispravno
   constraint operand2_data_constraint { operand2 < 5; }
   

   `uvm_object_utils_begin(calc_seq_item)      
      `uvm_field_int(command, UVM_DEFAULT)
      `uvm_field_int(operand1, UVM_DEFAULT)
      `uvm_field_int(operand2, UVM_DEFAULT)
   `uvm_object_utils_end

   function new (string name = "calc_seq_item");
      super.new(name);
   endfunction // new

endclass : calc_seq_item

`endif
