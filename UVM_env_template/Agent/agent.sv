class calc_agent extends uvm_agent;

   // components
   calc_driver drv;
   calc_sequencer seqr;
   calc_monitor mon;
   virtual interface calc_if vif;
   // configuration
   calc_config cfg;
   int value;   
   `uvm_component_utils_begin (calc_agent)
      `uvm_field_object(cfg, UVM_DEFAULT)
   `uvm_component_utils_end

   function new(string name = "calc_agent", uvm_component parent = null);
      super.new(name,parent);
   endfunction

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      /************Geting from configuration database*******************/
      if (!uvm_config_db#(virtual calc_if)::get(this, "", "calc_if", vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set:",get_full_name(),".vif"})
      
      if(!uvm_config_db#(calc_config)::get(this, "", "calc_config", cfg))
        `uvm_fatal("NOCONFIG",{"Config object must be set for: ",get_full_name(),".cfg"})
      /*****************************************************************/
      
      /************Setting to configuration database********************/
            uvm_config_db#(virtual calc_if)::set(this, "*", "calc_if", vif);
      /*****************************************************************/
      
      mon = calc_monitor::type_id::create("mon", this);
      if(cfg.is_active == UVM_ACTIVE) begin
         drv = calc_driver::type_id::create("drv", this);
         seqr = calc_sequencer::type_id::create("seqr", this);
      end
   endfunction : build_phase

   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      if(cfg.is_active == UVM_ACTIVE) begin
         drv.seq_item_port.connect(seqr.seq_item_export);
      end
   endfunction : connect_phase

endclass : calc_agent
