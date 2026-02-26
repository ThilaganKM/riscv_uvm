import uvm_pkg::*;
import riscv_txn_pkg::*;
import pc_tb_pkg::*;
`include "uvm_macros.svh"
class rf_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(rf_scoreboard)

  //--------------------------------------------------
  // Analysis Import → Receives from Monitor
  //--------------------------------------------------

  uvm_analysis_imp #(rf_seq_item, rf_scoreboard) ap_imp;

  //--------------------------------------------------
  // Golden Register Model
  //--------------------------------------------------

  logic [31:0] golden_rf [0:31];

  //--------------------------------------------------
  // Constructor
  //--------------------------------------------------

  function new(string name = "rf_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction

  //--------------------------------------------------
  // Build Phase → Initialize Model
  //--------------------------------------------------

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    ap_imp = new("ap_imp", this);

    //------------------------------------------
    // Match DUT initialization
    //------------------------------------------

    for (int i = 0; i < 32; i++)
      golden_rf[i] = 32'd4;

    //------------------------------------------
    // Architectural x0 rule
    //------------------------------------------

    golden_rf[0] = 32'd0;

  endfunction

  //--------------------------------------------------
  // Write → Reference Model + Checks
  //--------------------------------------------------

  virtual function void write(rf_seq_item pkt);

    logic [31:0] expected_rd1;
    logic [31:0] expected_rd2;

    //--------------------------------------------------
    // ✅ MODEL SYNCHRONOUS WRITE
    //--------------------------------------------------

    if (pkt.we && pkt.A3 != 0)
      golden_rf[pkt.A3] = pkt.wd3;

    //--------------------------------------------------
    // ✅ ENFORCE x0 IMMUTABILITY
    //--------------------------------------------------

    golden_rf[0] = 32'd0;

    //--------------------------------------------------
    // ✅ MODEL ASYNCHRONOUS READS
    //--------------------------------------------------

    expected_rd1 = (pkt.A1 != 0) ? golden_rf[pkt.A1] : 32'd0;
    expected_rd2 = (pkt.A2 != 0) ? golden_rf[pkt.A2] : 32'd0;

    //--------------------------------------------------
    // ✅ COMPARISON
    //--------------------------------------------------

    if (pkt.rd1 !== expected_rd1)
      `uvm_error("RF_SB", $sformatf(
        "RD1 MISMATCH: Addr=%0d Expected=%h Observed=%h",
        pkt.A1, expected_rd1, pkt.rd1
      ))

    if (pkt.rd2 !== expected_rd2)
      `uvm_error("RF_SB", $sformatf(
        "RD2 MISMATCH: Addr=%0d Expected=%h Observed=%h",
        pkt.A2, expected_rd2, pkt.rd2
      ))

  endfunction

endclass