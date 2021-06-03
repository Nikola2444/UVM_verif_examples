


class calc_monitor extends uvm_monitor;

    // control fileds
   bit checks_enable = 1;
   bit coverage_enable = 1;

    uvm_analysis_port #(calc_seq_item) input_item_collected_port;
    uvm_analysis_port #(calc_seq_item) output_item_collected_port;
    

   typedef enum {wait_for_cmd, wait_for_resp} monitoring_stages;
    monitoring_stages calc_monitoring_stages = wait_for_cmd;
    `uvm_component_utils_begin(calc_monitor)
	`uvm_field_int(checks_enable, UVM_DEFAULT)
	`uvm_field_int(coverage_enable, UVM_DEFAULT)
    `uvm_component_utils_end

    // The virtual interface used to drive and view HDL signals.
   virtual 	interface calc_if vif;
   
   covergroup command_check;       
       option.per_instance = 1;
       cmd: coverpoint vif.req_cmd_in {
	   bins add = {4'b0001};
	   bins sub = {4'b0010};
	   bins shift_left = {4'b0101};
	   bins shift_right = {4'b0110};
       }
    endgroup
   // current transaction
   calc_seq_item curr_it;


   
       
       
   // coverage can go here
   // ...

   function new(string name = "calc_monitor", uvm_component parent = null);
       super.new(name,parent);      
       input_item_collected_port = new("input_item_collected_port", this);
       output_item_collected_port = new("output_item_collected_port", this);
       command_check = new();
       
   endfunction

   function void connect_phase(uvm_phase phase);
       super.connect_phase(phase);
       if (!uvm_config_db#(virtual calc_if)::get(this, "", "calc_if", vif))
         `uvm_fatal("NOVIF",{"virtual interface must be set:",get_full_name(),".vif"})
   endfunction : connect_phase
   
   task main_phase(uvm_phase phase);
       forever begin
	   curr_it = calc_seq_item::type_id::create("curr_it", this);
	   // collect transactions
	   @(posedge vif.clk);
	   
	   case (calc_monitoring_stages)
	       wait_for_cmd: begin
		   if (vif.req_cmd_in != 0 ) begin
		       //input_item_collected_port.write(curr_it); // send to ref model - ref model is outside of scoreboard
		       command_check.sample();		       
		       calc_monitoring_stages = wait_for_resp;		       
		   end 		     
	       end
	       wait_for_resp: begin
		   if (vif.out_resp == 1 ) begin
		       //output_item_collected_port.write(curr_it); // send to scoreboard
		       calc_monitoring_stages = wait_for_cmd;		       
		   end 		     
	       end
	   endcase
	   // send it through TLM
	   
       end
   endtask : main_phase

endclass : calc_monitor
