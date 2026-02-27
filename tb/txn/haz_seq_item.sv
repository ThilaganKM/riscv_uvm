class haz_seq_item extends uvm_sequence_item;

  //--------------------------------------------------
  // Inputs to DUT
  //--------------------------------------------------

  rand bit [4:0] Rs1D;
  rand bit [4:0] Rs2D;
  rand bit [4:0] RdE;

  rand bit       PCSrcE;
  rand bit       ResultSrcE0;

  //--------------------------------------------------
  // Observed Outputs
  //--------------------------------------------------

  bit StallF;
  bit StallD;
  bit FlushE;
  bit FlushD;

  //--------------------------------------------------
  // Constraints (Keep Randomization Clean)
  //--------------------------------------------------

  // Registers are valid RISC-V regs (0-31 automatically by width)
  // No illegal encodings needed.

  // Encourage realistic hazard testing
  constraint reg_dist_c {
    RdE dist { 0 := 1, [1:31] := 9 }; 
  }

  // Branch and load signals randomized evenly
  constraint control_dist_c {
    PCSrcE      dist {0 := 5, 1 := 5};
    ResultSrcE0 dist {0 := 5, 1 := 5};
  }

  `uvm_object_utils_begin(haz_seq_item)

    `uvm_field_int(Rs1D,        UVM_ALL_ON)
    `uvm_field_int(Rs2D,        UVM_ALL_ON)
    `uvm_field_int(RdE,         UVM_ALL_ON)
    `uvm_field_int(PCSrcE,      UVM_ALL_ON)
    `uvm_field_int(ResultSrcE0, UVM_ALL_ON)

    `uvm_field_int(StallF, UVM_ALL_ON)
    `uvm_field_int(StallD, UVM_ALL_ON)
    `uvm_field_int(FlushE, UVM_ALL_ON)
    `uvm_field_int(FlushD, UVM_ALL_ON)

  `uvm_object_utils_end

  function new(string name = "haz_seq_item");
    super.new(name);
  endfunction

endclass