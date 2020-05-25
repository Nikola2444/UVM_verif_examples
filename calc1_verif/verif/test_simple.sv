`ifndef TEST_SIMPLE_SV
 `define TEST_SIMPLE_SV

class test_simple extends test_base;

    `uvm_component_utils(test_simple)

    virtual_seq  vseq;

    function new(string name = "test_simple", uvm_component parent = null);
	super.new(name,parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	vseq = virtual_seq::type_id::create("vseq");
    endfunction : build_phase

    task main_phase(uvm_phase phase);
	phase.raise_objection(this);
	
	init_vseq(vseq);
	vseq.start(null);
	
	phase.drop_objection(this);
    endtask : main_phase

endclass

`endif
