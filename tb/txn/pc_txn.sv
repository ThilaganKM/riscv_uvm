import uvm_pkg::*;
`include "uvm_macros.svh"
class pc_txn extends uvm_sequence_item;

    rand bit reset;
    rand bit en;
    rand bit [31:0] PCNext;
    logic [31:0] PC; 
    `uvm_object_utils(pc_txn)

    function new(string name = "pc_txn");
        super.new(name);
    endfunction

endclass