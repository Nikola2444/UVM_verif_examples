`ifndef CALC_SIMPLE_SEQ_SV
 `define CALC_SIMPLE_SEQ_SV

class calc_simple_seq extends calc_base_seq;

   `uvm_object_utils (calc_simple_seq)

   function new(string name = "calc_simple_seq");
      super.new(name);
   endfunction

   virtual task body();
      // Za sada je sekvenca jako jednostavna i vrlo verovatno ce biti
      // promenjena u buducnosti
      for (int i = 0; i < 100; i++) begin
	  `uvm_do_with(req, { req.command == 1 || req.command == 2 || req.command == 5 || req.command == 6;})
      end
   endtask : body

endclass : calc_simple_seq

`endif
