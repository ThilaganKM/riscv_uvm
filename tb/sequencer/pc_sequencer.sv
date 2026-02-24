import pc_txn_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class pc_sequencer extends uvm_sequencer #(pc_txn);

    `uvm_component_utils(pc_sequencer)

    function new(string name = "pc_sequencer", uvm_component parent);
        super.new(name, parent);
    endfunction

endclass