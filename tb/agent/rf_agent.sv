import uvm_pkg::*;
import riscv_txn_pkg::*;
`include "uvm_macros.svh"
class rf_agent extends uvm_agent;

  `uvm_component_utils(rf_agent)

  //--------------------------------------------------
  // Components
  //--------------------------------------------------

  rf_sequencer sequencer;
  rf_driver    driver;
  rf_monitor   monitor;

  //--------------------------------------------------
  // Virtual Interface
  //--------------------------------------------------

  virtual rf_if vif;

  //--------------------------------------------------
  // Constructor
  //--------------------------------------------------

  function new(string name = "rf_agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  //--------------------------------------------------
  // Build Phase
  //--------------------------------------------------

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    //------------------------------------------
    // Get Interface
    //------------------------------------------

    if (!uvm_config_db #(virtual rf_if)::get(this, "", "vif", vif))
      `uvm_fatal("RF_AGENT", "Virtual interface not set")

    //------------------------------------------
    // Create Components
    //------------------------------------------

    sequencer = rf_sequencer::type_id::create("sequencer", this);
    driver    = rf_driver   ::type_id::create("driver", this);
    monitor   = rf_monitor  ::type_id::create("monitor", this);

    //------------------------------------------
    // Pass Interface Down
    //------------------------------------------

    uvm_config_db #(virtual rf_if.DRIVER)::set(this, "driver", "vif", vif);
    uvm_config_db #(virtual rf_if.MONITOR)::set(this, "monitor", "vif", vif);

  endfunction

  //--------------------------------------------------
  // Connect Phase
  //--------------------------------------------------

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    //------------------------------------------
    // Driver ↔ Sequencer
    //------------------------------------------

    driver.seq_item_port.connect(sequencer.seq_item_export);

  endfunction

endclass