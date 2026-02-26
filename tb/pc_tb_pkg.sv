package pc_tb_pkg;

  import uvm_pkg::*;
  import riscv_txn_pkg::*;

  `include "uvm_macros.svh"
    
  `include "sequence/pc_base_sequence.sv"
  `include "sequencer/pc_sequencer.sv"
  `include "driver/pc_driver.sv"
  `include "monitor/pc_monitor.sv"
  `include "scoreboard/pc_scoreboard.sv"
  `include "agent/pc_agent.sv"
  `include "env/pc_env.sv"
  `include "test/pc_test.sv"

  `include "sequence/rf_base_sequence.sv"
  `include "sequencer/rf_sequencer.sv"
  `include "driver/rf_driver.sv"
  `include "monitor/rf_monitor.sv"
  `include "scoreboard/rf_scoreboard.sv"
  `include "agent/rf_agent.sv"
  `include "env/rf_env.sv"
  `include "test/rf_test.sv"

endpackage