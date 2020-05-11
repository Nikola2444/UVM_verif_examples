`ifndef CALC_DRIVER_SV
 `define CALC_DRIVER_SV
class calc_driver extends uvm_driver#(calc_seq_item);

   `uvm_component_utils(calc_driver)
   
   virtual interface calc_if vif;
   
   function new(string name = "calc_driver", uvm_component parent = null);
      super.new(name,parent);
      if (!uvm_config_db#(virtual calc_if)::get(this, "", "calc_if", vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set:",get_full_name(),".vif"})
   endfunction

   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      if (!uvm_config_db#(virtual calc_if)::get(this, "", "calc_if", vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
   endfunction : connect_phase

   
   task main_phase(uvm_phase phase);
      forever begin
         seq_item_port.get_next_item(req);
         `uvm_info(get_type_name(),
                   $sformatf("Driver sending...\n%s", req.sprint()),
                   UVM_HIGH)
         // do actual driving here
			   /* TODO */
         seq_item_port.item_done();
      end
   endtask : main_phase

endclass : calc_driver

`endif

