package pc_txn_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class pc_seq_item extends uvm_sequence_item;

    rand bit reset;
    rand bit en;
    rand bit [31:0] PCNext;
         bit [31:0] PC;

    `uvm_object_utils(pc_seq_item)

    function new(string name = "pc_seq_item");
      super.new(name);
    endfunction

  endclass

endpackage