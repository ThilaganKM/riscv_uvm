import uvm_pkg::*;
import riscv_txn_pkg::*;
`include "uvm_macros.svh"
class rf_test extends uvm_test;

  `uvm_component_utils(rf_test)

  //--------------------------------------------------
  // Environment
  //--------------------------------------------------

  rf_env env;

  //--------------------------------------------------
  // Constructor
  //--------------------------------------------------

  function new(string name = "rf_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  //--------------------------------------------------
  // Build Phase → Create Environment
  //--------------------------------------------------

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env = rf_env::type_id::create("env", this);

  endfunction

  //--------------------------------------------------
  // Run Phase → Start Sequence
  //--------------------------------------------------

  virtual task run_phase(uvm_phase phase);

    rf_base_sequence seq;

    //------------------------------------------
    // Raise objection → keep sim alive
    //------------------------------------------

    phase.raise_objection(this);

    //------------------------------------------
    // Create & start sequence
    //------------------------------------------

    seq = rf_base_sequence::type_id::create("seq");

    seq.start(env.agent.sequencer);

    //------------------------------------------
    // Drop objection → allow sim end
    //------------------------------------------

    phase.drop_objection(this);

  endtask

endclass