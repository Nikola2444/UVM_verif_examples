`ifndef CALC_VIRTUAL_SEQ_SV
 `define CALC_VIRTUAL_SEQ_SV

class virtual_seq extends calc_base_seq;

    `uvm_object_utils (virtual_seq)

    uvm_sequencer #(calc_seq_item) interface1_seqr;
    uvm_sequencer #(calc_seq_item) interface2_seqr;
    uvm_sequencer #(calc_seq_item) interface3_seqr;; 
    uvm_sequencer #(calc_seq_item) interface4_seqr;;
    
    function new(string name = "virtual_seq");
	super.new(name);
    endfunction

    virtual task body();

	calc_simple_seq interface1_seq = calc_simple_seq::type_id::create("interface1_seq1");
	calc_simple_seq interface2_seq = calc_simple_seq::type_id::create("interface1_seq2");
	calc_simple_seq interface3_seq = calc_simple_seq::type_id::create("interface1_seq3");
	calc_simple_seq interface4_seq = calc_simple_seq::type_id::create("interface1_seq4");
	fork  
	    interface1_seq.start(interface1_seqr);
	
	    interface2_seq.start(interface2_seqr);
	
	    interface3_seq.start(interface3_seqr);
	
	    interface4_seq.start(interface4_seqr);

	join
	
    endtask : body

endclass : virtual_seq

`endif
