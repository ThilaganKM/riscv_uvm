package pc_tb_pkg;

  import uvm_pkg::*;
  import riscv_txn_pkg::*;

  `include "uvm_macros.svh"

  //--------------------------------------------------
  // PC
  //--------------------------------------------------

  `include "sequence/pc_base_sequence.sv"
  `include "sequencer/pc_sequencer.sv"
  `include "driver/pc_driver.sv"
  `include "monitor/pc_monitor.sv"
  `include "scoreboard/pc_scoreboard.sv"
  `include "agent/pc_agent.sv"
  `include "env/pc_env.sv"
  `include "test/pc_test.sv"

  //--------------------------------------------------
  // REGISTER FILE
  //--------------------------------------------------

  `include "sequence/rf_base_sequence.sv"
  `include "sequencer/rf_sequencer.sv"
  `include "driver/rf_driver.sv"
  `include "monitor/rf_monitor.sv"
  `include "scoreboard/rf_scoreboard.sv"
  `include "agent/rf_agent.sv"
  `include "env/rf_env.sv"
  `include "test/rf_test.sv"

  //--------------------------------------------------
  // ALU ✅ ADD BLOCK
  //--------------------------------------------------

  `include "sequence/alu_base_sequence.sv"
  `include "sequencer/alu_sequencer.sv"
  `include "driver/alu_driver.sv"
  `include "monitor/alu_monitor.sv"
  `include "scoreboard/alu_scoreboard.sv"
  `include "agent/alu_agent.sv"
  `include "env/alu_env.sv"
  `include "test/alu_test.sv"

endpackage