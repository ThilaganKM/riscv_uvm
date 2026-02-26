import uvm_pkg::*;
import riscv_txn_pkg::*;
import pc_tb_pkg::*;
`include "uvm_macros.svh"
class rf_driver extends uvm_driver #(rf_seq_item);

  `uvm_component_utils(rf_driver)

  //--------------------------------------------------
  // Virtual Interface
  //--------------------------------------------------

  virtual rf_if.DRIVER vif;

  //--------------------------------------------------
  // Constructor
  //--------------------------------------------------

  function new(string name = "rf_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  //--------------------------------------------------
  // Build Phase → Get Interface
  //--------------------------------------------------

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db #(virtual rf_if.DRIVER)::get(this, "", "vif", vif))
      `uvm_fatal("RF_DRIVER", "Virtual interface not set")
  endfunction

  //--------------------------------------------------
  // Run Phase → Drive Transactions
  //--------------------------------------------------

  virtual task run_phase(uvm_phase phase);

    rf_seq_item req;

    forever begin

      //------------------------------------------
      // Get next transaction
      //------------------------------------------

      seq_item_port.get_next_item(req);

      //------------------------------------------
      // Drive stimulus
      //------------------------------------------

      vif.A1  <= req.A1;
      vif.A2  <= req.A2;
      vif.A3  <= req.A3;
      vif.wd3 <= req.wd3;
      vif.we  <= req.we;

      //------------------------------------------
      // IMPORTANT → Sync write behavior
      //------------------------------------------

      @(posedge vif.clk);

      //------------------------------------------
      // Transaction complete
      //------------------------------------------

      seq_item_port.item_done();

    end

  endtask

endclass