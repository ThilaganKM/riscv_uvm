import uvm_pkg::*;
import riscv_txn_pkg::*;
import pc_tb_pkg::*;

`include "uvm_macros.svh"

class rf_driver extends uvm_driver #(rf_seq_item);

  `uvm_component_utils(rf_driver)

  virtual rf_if.DRIVER vif;

  function new(string name = "rf_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db #(virtual rf_if.DRIVER)::get(this, "", "vif", vif))
      `uvm_fatal("RF_DRIVER", "Virtual interface not set")
  endfunction

  virtual task run_phase(uvm_phase phase);

    rf_seq_item req;

    //------------------------------------------
    // RESET SEQUENCE ✅ CRITICAL
    //------------------------------------------

    vif.reset <= 1;

    repeat (3) @(posedge vif.clk);

    vif.reset <= 0;

    //------------------------------------------
    // Optional interface stabilization
    //------------------------------------------

    vif.we  <= 0;
    vif.A1  <= 0;
    vif.A2  <= 0;
    vif.A3  <= 0;
    vif.wd3 <= 0;

    //------------------------------------------
    // NORMAL DRIVER LOOP
    //------------------------------------------

    forever begin

      seq_item_port.get_next_item(req);

      vif.A1  <= req.A1;
      vif.A2  <= req.A2;
      vif.A3  <= req.A3;
      vif.wd3 <= req.wd3;
      vif.we  <= req.we;

      @(posedge vif.clk);

      seq_item_port.item_done();

    end

  endtask

endclass