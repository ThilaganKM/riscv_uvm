class main_dec_sequencer extends uvm_sequencer #(main_dec_seq_item);

  `uvm_component_utils(main_dec_sequencer)

  function new(string name = "main_dec_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction

endclass