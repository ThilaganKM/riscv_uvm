import uvm_pkg::*;
import riscv_txn_pkg::*;
class rf_monitor extends uvm_monitor;

  `uvm_component_utils(rf_monitor)

  //--------------------------------------------------
  // Virtual Interface
  //--------------------------------------------------

  virtual rf_if.MONITOR vif;

  //--------------------------------------------------
  // Analysis Port → Sends to Scoreboard
  //--------------------------------------------------

  uvm_analysis_port #(rf_seq_item) ap;

  //--------------------------------------------------
  // Constructor
  //--------------------------------------------------

  function new(string name = "rf_monitor", uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction

  //--------------------------------------------------
  // Build Phase → Get Interface
  //--------------------------------------------------

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db #(virtual rf_if.MONITOR)::get(this, "", "vif", vif))
      `uvm_fatal("RF_MONITOR", "Virtual interface not set")
  endfunction

  //--------------------------------------------------
  // Run Phase → Sample DUT
  //--------------------------------------------------

  virtual task run_phase(uvm_phase phase);

    rf_seq_item item;

    forever begin

      //------------------------------------------
      // Sample at clock edge (stable point)
      //------------------------------------------

      @(posedge vif.clk);

      //------------------------------------------
      // Create transaction
      //------------------------------------------

      item = rf_seq_item::type_id::create("item");

      //------------------------------------------
      // Capture DUT signals
      //------------------------------------------

      item.A1  = vif.A1;
      item.A2  = vif.A2;
      item.A3  = vif.A3;
      item.wd3 = vif.wd3;
      item.we  = vif.we;

      item.rd1 = vif.rd1;
      item.rd2 = vif.rd2;

      //------------------------------------------
      // Send to scoreboard
      //------------------------------------------

      ap.write(item);

    end

  endtask

endclass