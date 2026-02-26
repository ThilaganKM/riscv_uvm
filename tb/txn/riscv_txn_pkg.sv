package riscv_txn_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  //--------------------------------------------------
  // PC Transaction
  //--------------------------------------------------

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

  //--------------------------------------------------
  // Register File Transaction
  //--------------------------------------------------

  class rf_seq_item extends uvm_sequence_item;

    rand bit [4:0]  A1, A2, A3;
    rand bit [31:0] wd3;
    rand bit        we;

         bit [31:0] rd1, rd2;

    `uvm_object_utils(rf_seq_item)

    function new(string name = "rf_seq_item");
      super.new(name);
    endfunction

  endclass

  //--------------------------------------------------
  // ALU Transaction
  //--------------------------------------------------

  class alu_seq_item extends uvm_sequence_item;

    rand bit [31:0] SrcA;
    rand bit [31:0] SrcB;
    rand bit [2:0]  ALUControl;

         bit [31:0] ALUResult;
         bit        Zero;

    constraint alu_ctrl_c {
      ALUControl inside {3'b000, 3'b001, 3'b010, 3'b011, 3'b101};
    }

    `uvm_object_utils(alu_seq_item)

    function new(string name = "alu_seq_item");
      super.new(name);
    endfunction

  endclass

  //--------------------------------------------------
  // ALU DECODER Transaction ✅ ADDED
  //--------------------------------------------------

  class alu_dec_seq_item extends uvm_sequence_item;

    rand bit        opb5;
    rand bit [2:0]  funct3;
    rand bit        funct7b5;
    rand bit [1:0]  ALUOp;

         bit [2:0]  ALUControl;

    constraint aluop_c {
      ALUOp inside {2'b00, 2'b01, 2'b10};
    }

    `uvm_object_utils(alu_dec_seq_item)

    function new(string name = "alu_dec_seq_item");
      super.new(name);
    endfunction

  endclass

endpackage