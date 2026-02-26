import uvm_pkg::*;
import riscv_txn_pkg::*;
`include "uvm_macros.svh"
class rf_env extends uvm_env;

  `uvm_component_utils(rf_env)

  //--------------------------------------------------
  // Components
  //--------------------------------------------------

  rf_agent       agent;
  rf_scoreboard  scoreboard;

  //--------------------------------------------------
  // Constructor
  //--------------------------------------------------

  function new(string name = "rf_env", uvm_component parent);
    super.new(name, parent);
  endfunction

  //--------------------------------------------------
  // Build Phase
  //--------------------------------------------------

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    //------------------------------------------
    // Create Components
    //------------------------------------------

    agent      = rf_agent      ::type_id::create("agent", this);
    scoreboard = rf_scoreboard ::type_id::create("scoreboard", this);

  endfunction

  //--------------------------------------------------
  // Connect Phase
  //--------------------------------------------------

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    //------------------------------------------
    // Monitor → Scoreboard
    //------------------------------------------

    agent.monitor.ap.connect(scoreboard.ap_imp);

  endfunction

endclass