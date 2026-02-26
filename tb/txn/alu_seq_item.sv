class alu_seq_item extends uvm_sequence_item;

  rand logic [31:0] SrcA;
  rand logic [31:0] SrcB;
  rand logic [2:0]  ALUControl;

  // Constrain to legal ALU ops
  constraint alu_ctrl_c {
    ALUControl inside {3'b000, 3'b001, 3'b010, 3'b011, 3'b101};
  }

  `uvm_object_utils_begin(alu_seq_item)
    `uvm_field_int(SrcA, UVM_ALL_ON)
    `uvm_field_int(SrcB, UVM_ALL_ON)
    `uvm_field_int(ALUControl, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "alu_seq_item");
    super.new(name);
  endfunction

endclass