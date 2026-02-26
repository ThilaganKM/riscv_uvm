class alu_dec_sequencer extends uvm_sequencer #(alu_dec_seq_item);

  `uvm_component_utils(alu_dec_sequencer)

  function new(string name = "alu_dec_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction

endclass