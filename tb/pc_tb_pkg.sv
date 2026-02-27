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
  // ALU
  //--------------------------------------------------

  `include "sequence/alu_base_sequence.sv"
  `include "sequencer/alu_sequencer.sv"
  `include "driver/alu_driver.sv"
  `include "monitor/alu_monitor.sv"
  `include "scoreboard/alu_scoreboard.sv"
  `include "agent/alu_agent.sv"
  `include "env/alu_env.sv"
  `include "test/alu_test.sv"

  //--------------------------------------------------
  // ALU DECODER ✅ ADDED
  //--------------------------------------------------

  `include "sequence/alu_dec_base_sequence.sv"
  `include "sequencer/alu_dec_sequencer.sv"
  `include "driver/alu_dec_driver.sv"
  `include "monitor/alu_dec_monitor.sv"
  `include "scoreboard/alu_dec_scoreboard.sv"
  `include "agent/alu_dec_agent.sv"
  `include "env/alu_dec_env.sv"
  `include "test/alu_dec_test.sv"

   //--------------------------------------------------
    // FORWARDING UNIT
    //--------------------------------------------------

  `include "sequence/fwd_base_sequence.sv"
  `include "sequencer/fwd_sequencer.sv"
  `include "driver/fwd_driver.sv"
  `include "monitor/fwd_monitor.sv"
  `include "scoreboard/fwd_scoreboard.sv"
  `include "agent/fwd_agent.sv"
  `include "env/fwd_env.sv"
  `include "test/fwd_test.sv"

    //--------------------------------------------------
  // HAZARD UNIT
  //--------------------------------------------------

  `include "sequence/haz_base_sequence.sv"
  `include "sequencer/haz_sequencer.sv"
  `include "driver/haz_driver.sv"
  `include "monitor/haz_monitor.sv"
  `include "scoreboard/haz_scoreboard.sv"
  `include "agent/haz_agent.sv"
  `include "env/haz_env.sv"
  `include "test/haz_test.sv"
  //--------------------------------------------------
// MAIN DECODER
//--------------------------------------------------

  `include "sequence/main_dec_base_sequence.sv"
  `include "sequencer/main_dec_sequencer.sv"
  `include "driver/main_dec_driver.sv"
  `include "monitor/main_dec_monitor.sv"
  `include "scoreboard/main_dec_scoreboard.sv"
  `include "agent/main_dec_agent.sv"
  `include "env/main_dec_env.sv"
  `include "test/main_dec_test.sv"

endpackage