package pc_txn_pkg;


  class pc_txn extends uvm_sequence_item;

    rand bit reset;
    rand bit en;
    rand bit [31:0] PCNext;
         bit [31:0] PC;

    `uvm_object_utils(pc_txn)

    function new(string name = "pc_txn");
      super.new(name);
    endfunction

  endclass

endpackage