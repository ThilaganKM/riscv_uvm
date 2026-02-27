class control_unit_sequencer extends uvm_sequencer #(ctrl_seq_item);

  `uvm_component_utils(control_unit_sequencer)

  function new(string name = "control_unit_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction

endclass