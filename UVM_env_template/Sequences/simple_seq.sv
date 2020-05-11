`ifndef CALC_SIMPLE_SEQ_SV
 `define CALC_SIMPLE_SEQ_SV

class calc_simple_seq extends calc_base_seq;

   `uvm_object_utils (calc_simple_seq)

   function new(string name = "calc_simple_seq");
      super.new(name);
   endfunction

   virtual task body();
      // simple example - just send one item
      `uvm_do(req);
   endtask : body

endclass : calc_simple_seq

`endif
