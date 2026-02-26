class rf_sequencer extends uvm_sequencer #(rf_seq_item);

  `uvm_component_utils(rf_sequencer)

  //--------------------------------------------------
  // Constructor
  //--------------------------------------------------

  function new(string name = "rf_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction

endclass