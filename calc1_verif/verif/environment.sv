`ifndef CALC_ENV_SV
 `define CALC_ENV_SV

class calc_env extends uvm_env;

    calc_agent agent1, agent2, agent3, agent4;
    calc_config cfg;
   virtual interface calc_if  vif_1;
   virtual interface calc_if  vif_2;
   virtual interface calc_if  vif_3;
   virtual interface calc_if  vif_4;

   
   `uvm_component_utils (calc_env)

   function new(string name = "calc_env", uvm_component parent = null);
       super.new(name,parent);
   endfunction

   function void build_phase(uvm_phase phase);
       super.build_phase(phase);
       /************Geting from configuration database*******************/
       if (!uvm_config_db#(virtual calc_if)::get(this, "", "calc_if_1", vif_1))
         `uvm_fatal("NOVIF",{"virtual interface must be set:",get_full_name(),".vif_1"})
       if (!uvm_config_db#(virtual calc_if)::get(this, "", "calc_if_2", vif_2))
         `uvm_fatal("NOVIF",{"virtual interface must be set:",get_full_name(),".vif_2"})
       if (!uvm_config_db#(virtual calc_if)::get(this, "", "calc_if_3", vif_3))
         `uvm_fatal("NOVIF",{"virtual interface must be set:",get_full_name(),".vif_3"})
       if (!uvm_config_db#(virtual calc_if)::get(this, "", "calc_if_4", vif_4))
         `uvm_fatal("NOVIF",{"virtual interface must be set:",get_full_name(),".vif_4"})
       
       if(!uvm_config_db#(calc_config)::get(this, "", "calc_config", cfg))
         `uvm_fatal("NOCONFIG",{"Config object must be set for: ",get_full_name(),".cfg"})
       /*****************************************************************/


       /************Setting to configuration database********************/
       uvm_config_db#(calc_config)::set(this, "*agent", "calc_config", cfg);
       uvm_config_db#(virtual calc_if)::set(this, "interface1_agent", "calc_if", vif_1);
       uvm_config_db#(virtual calc_if)::set(this, "interface2_agent", "calc_if", vif_2);
       uvm_config_db#(virtual calc_if)::set(this, "interface3_agent", "calc_if", vif_3);
       uvm_config_db#(virtual calc_if)::set(this, "interface4_agent", "calc_if", vif_4);
       /*****************************************************************/
       agent1 = calc_agent::type_id::create("interface1_agent", this);
       agent2 = calc_agent::type_id::create("interface2_agent", this);
       agent3 = calc_agent::type_id::create("interface3_agent", this);
       agent4 = calc_agent::type_id::create("interface4_agent", this);
       
   endfunction : build_phase

endclass : calc_env

`endif
