`ifndef CALC_DRIVER_SV
 `define CALC_DRIVER_SV
class calc_driver extends uvm_driver#(calc_seq_item);

    `uvm_component_utils(calc_driver)
    
   virtual interface calc_if vif;
   int 	   reset_clk_duration = 7;
   bit [6 : 0] reset_system = 127;
   bit [6 : 0] un_reset_system = 0;
   
   typedef enum {send_op1_and_cmd, send_op2, wait_for_resp} driving_stages;
   driving_stages calc_driving_stages = send_op1_and_cmd;
   
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
                     UVM_LOW)
	   //State machine neophodan kako bi se ispostovao
	   //protokol slanja operanada i komande opisan u
	   //materijalu za vezbe
           @(posedge vif.clk);
	   #1 // Ovo ce u buducnosti biti reseno sa block-ing clock-om
	     if (vif.rst != 7'h7f) begin	       
		 case (calc_driving_stages)
		     send_op1_and_cmd: begin	
			 if(vif.out_resp == 2'b00)begin
			     vif.req_cmd_in = req.command;
			     vif.req_data_in = req.operand1;
			     calc_driving_stages = send_op2;		      
			 end
		     end
		     send_op2: begin
			 vif.req_data_in = req.operand2;
			 vif.req_cmd_in = 0;
			 calc_driving_stages = wait_for_resp;		    
		     end
		     wait_for_resp: begin
			 if (vif.out_resp == 1) begin
			     calc_driving_stages = send_op1_and_cmd;
			 end
		     end
		 endcase; // case (calc_driving_stages)	       	       
	     end // if (reset != 7'h7f)
	     else begin
		 vif.req_cmd_in = 0;	       
		 vif.req_data_in = 0;	       	 
	     end
           seq_item_port.item_done();
       end
   endtask : main_phase

endclass : calc_driver

`endif

