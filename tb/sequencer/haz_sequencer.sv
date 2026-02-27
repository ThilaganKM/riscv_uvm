class haz_sequencer extends uvm_sequencer #(haz_seq_item);

  `uvm_component_utils(haz_sequencer)

  function new(string name = "haz_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction

endclass