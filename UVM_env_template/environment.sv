`ifndef CALC_ENV_SV
 `define CALC_ENV_SV

class calc_env extends uvm_env;

   calc_agent agent;
   calc_config cfg;
   virtual interface calc_if vif;
   `uvm_component_utils (calc_env)

   function new(string name = "calc_env", uvm_component parent = null);
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
      uvm_config_db#(calc_config)::set(this, "agent", "calc_config", cfg);
      uvm_config_db#(virtual calc_if)::set(this, "agent", "calc_if", vif);
      /*****************************************************************/
      agent = calc_agent::type_id::create("agent", this);
      
   endfunction : build_phase

endclass : calc_env

`endif
