class alu_dec_seq_item extends uvm_sequence_item;

  //--------------------------------------------------
  // Inputs to DUT
  //--------------------------------------------------

  rand bit        opb5;
  rand bit [2:0]  funct3;
  rand bit        funct7b5;
  rand bit [1:0]  ALUOp;

  //--------------------------------------------------
  // Observed Output
  //--------------------------------------------------

  bit [2:0] ALUControl;

  //--------------------------------------------------
  // Constraints (CRITICAL FOR FAST CLEAN SIMS)
  //--------------------------------------------------

  // Only legal ALUOp values used by design
  constraint aluop_c {
    ALUOp inside {2'b00, 2'b01, 2'b10};
  }

  `uvm_object_utils_begin(alu_dec_seq_item)

    `uvm_field_int(opb5,       UVM_ALL_ON)
    `uvm_field_int(funct3,     UVM_ALL_ON)
    `uvm_field_int(funct7b5,   UVM_ALL_ON)
    `uvm_field_int(ALUOp,      UVM_ALL_ON)
    `uvm_field_int(ALUControl, UVM_ALL_ON)

  `uvm_object_utils_end

  function new(string name = "alu_dec_seq_item");
    super.new(name);
  endfunction

endclass