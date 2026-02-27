//--------------------------------------------------
// Main Decoder Transaction
//--------------------------------------------------

class main_dec_seq_item extends uvm_sequence_item;

  // Input
  rand bit [6:0] op;

  // Outputs (observed)
  bit RegWrite;
  bit [1:0] ResultSrc;
  bit [1:0] ALUOp;
  bit [1:0] ImmSrc;
  bit ALUSrc;
  bit MemWrite;
  bit Jump;
  bit Branch;

  // Constrain to valid RV32I opcodes you support
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