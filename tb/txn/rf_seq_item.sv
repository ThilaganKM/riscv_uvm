class rf_seq_item extends uvm_sequence_item;

  //--------------------------------------------------
  // Stimulus (Inputs to DUT)
  //--------------------------------------------------

  rand bit [4:0]  A1;     // Read address 1
  rand bit [4:0]  A2;     // Read address 2
  rand bit [4:0]  A3;     // Write address
  rand bit [31:0] wd3;    // Write data
  rand bit        we;     // Write enable

  //--------------------------------------------------
  // Observations (Outputs from DUT)
  //--------------------------------------------------

       bit [31:0] rd1;    // Read data 1
       bit [31:0] rd2;    // Read data 2

  `uvm_object_utils(rf_seq_item)

  //--------------------------------------------------
  // Constructor
  //--------------------------------------------------

  function new(string name = "rf_seq_item");
    super.new(name);
  endfunction

endclass