package pc_tb_pkg;

  import uvm_pkg::*;
  import pc_txn_pkg::*;

  `include "uvm_macros.svh"

  `include "interfaces/pc_if.sv"
  `include "sequence/pc_base_sequence.sv"
  `include "sequencer/pc_sequencer.sv"
  `include "driver/pc_driver.sv"
  `include "monitor/pc_monitor.sv"
  `include "scoreboard/pc_scoreboard.sv"
  `include "agent/pc_agent.sv"
  `include "env/pc_env.sv"
  `include "test/pc_test.sv"

endpackage