`ifndef CALC_DRIVER_SV
 `define CALC_DRIVER_SV
class calc_driver extends uvm_driver#(calc_seq_item);

    `uvm_component_utils(calc_driver)
    
   virtual interface calc_if vif;
   int 	   reset_clk_duration = 7;
   bit [6 : 0] reset_system = 127;
   bit [6 : 0] un_reset_system = 0;
   
   typedef enum {send_op1_and_cmd, send_op2, wait_for_resp} driving_stages;
   driving_stages calc1_driving_stages = send_op1_and_cmd;
   
   function new(string name = "calc_driver", uvm_component parent = null);
\       super.new(name,parent);
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
	   //State machine neophodan kako bi se ispostovao
	   //nacin slanja operanada i komande opisan u
	   //materijalu za vezbe
           @(posedge vif.clk);
	   #1 // Ovo ce u buducnosti biti reseno sa block-ing clock-om
	     if (vif.rst != 7'h7f) begin	       
		 case (calc1_driving_stages)
		     send_op1_and_cmd: begin	
			 `uvm_info(get_type_name(),
				   $sformatf("vif.out_resp1 = %d", vif.out_resp1),
				   UVM_LOW)
			 if(vif.out_resp1 == 2'b00)begin
			     vif.req1_cmd_in = req.command;
			     vif.req1_data_in = req.operand1;
			     calc1_driving_stages = send_op2;		      
			 end
		     end
		     send_op2: begin
			 vif.req1_data_in = req.operand2;
			 vif.req1_cmd_in = 0;
			 calc1_driving_stages = wait_for_resp;		    
		     end
		     wait_for_resp: begin
			 if (vif.out_resp1 == 1) begin
			     calc1_driving_stages = send_op1_and_cmd;
			     `uvm_info(get_type_name(),
				       $sformatf("vif.out_resp1 = %d", vif.out_resp1),
				       UVM_LOW)
			 end
		     end
		 endcase; // case (calc1_driving_stages)	       	       
	     end // if (reset != 7'h7f)
	     else begin
		 vif.req1_cmd_in = 0;	       
		 vif.req1_data_in = 0;	       	 
	     end
           seq_item_port.item_done();
       end
   endtask : main_phase

endclass : calc_driver

`endif

