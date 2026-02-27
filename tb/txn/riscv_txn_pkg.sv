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

    //--------------------------------------------------
  // Forwarding Unit Transaction
  //--------------------------------------------------

  class fwd_seq_item extends uvm_sequence_item;

    // Inputs
    rand bit [4:0] Rs1E, Rs2E;
    rand bit [4:0] RdM, RdW;
    rand bit       RegWriteM, RegWriteW;

    // Observed Outputs
    bit [1:0] ForwardAE;
    bit [1:0] ForwardBE;

    // Optional: bias toward non-zero registers
    constraint reg_range_c {
      Rs1E inside {[0:31]};
      Rs2E inside {[0:31]};
      RdM  inside {[0:31]};
      RdW  inside {[0:31]};
    }

    `uvm_object_utils(fwd_seq_item)

    function new(string name = "fwd_seq_item");
      super.new(name);
    endfunction

  endclass

  //--------------------------------------------------
  // Hazard Unit Transaction
  //--------------------------------------------------

  class haz_seq_item extends uvm_sequence_item;

    // Inputs to DUT
    rand bit [4:0] Rs1D;
    rand bit [4:0] Rs2D;
    rand bit [4:0] RdE;
    rand bit       PCSrcE;
    rand bit       ResultSrcE0;

    // Observed Outputs
    bit StallF;
    bit StallD;
    bit FlushE;
    bit FlushD;

    // Light distribution (encourage non-zero rd)
    constraint rd_dist_c {
      RdE dist {0 := 1, [1:31] := 9};
    }

    `uvm_object_utils(haz_seq_item)

    function new(string name = "haz_seq_item");
      super.new(name);
    endfunction

  endclass

    //--------------------------------------------------
  // Main Decoder Transaction
  //--------------------------------------------------

  class main_dec_seq_item extends uvm_sequence_item;

    // Input
    rand bit [6:0] op;

    // Observed Outputs
    bit RegWrite;
    bit [1:0] ResultSrc;
    bit [1:0] ALUOp;
    bit [1:0] ImmSrc;
    bit ALUSrc;
    bit MemWrite;
    bit Jump;
    bit Branch;

    // Constrain to supported opcodes
    constraint opcode_c {
      op inside {
        7'b0000011, // Load
        7'b0100011, // Store
        7'b0110011, // R-type
        7'b1100011, // Branch
        7'b0010011, // I-type arithmetic
        7'b1101111  // JAL
      };
    }

    `uvm_object_utils(main_dec_seq_item)

    function new(string name = "main_dec_seq_item");
      super.new(name);
    endfunction

  endclass

  //--------------------------------------------------
// Control Unit Transaction
//--------------------------------------------------

class ctrl_seq_item extends uvm_sequence_item;

  // Inputs
  rand bit [6:0] op;
  rand bit [2:0] funct3;
  rand bit       funct7b5;
  rand bit       Zero;

  // Outputs
  bit Branch;
  bit Jump;
  bit [1:0] ResultSrc;
  bit MemWrite;
  bit [1:0] ImmSrc;
  bit RegWrite;
  bit ALUSrc;
  bit [2:0] ALUControl;

  // Constrain opcodes to supported subset
  constraint opcode_c {
    op inside {
      7'b0000011,
      7'b0100011,
      7'b0110011,
      7'b1100011,
      7'b0010011,
      7'b1101111
    };
  }

  `uvm_object_utils(ctrl_seq_item)

  function new(string name = "ctrl_seq_item");
    super.new(name);
  endfunction

endclass

endpackage