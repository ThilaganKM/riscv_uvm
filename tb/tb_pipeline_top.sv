`timescale 1ns/1ps
import uvm_pkg::*;
import pipeline_pkg::*;
`include "uvm_macros.svh"

module tb_pipeline_top;

  //----------------------------------------
  // Clock
  //----------------------------------------
  logic clk;
  always #5 clk = ~clk;

  //----------------------------------------
  // Reset
  //----------------------------------------
  logic reset;

  //----------------------------------------
  // Commit Interface Wires
  //----------------------------------------
  logic        commit_valid;
  logic [31:0] commit_pc;
  logic [4:0]  commit_rd;
  logic [31:0] commit_data;

  //----------------------------------------
  // DUT
  //----------------------------------------
  rvhazard_dbg dut (
    .clk(clk),
    .reset(reset),
    .commit_valid(commit_valid),
    .commit_pc(commit_pc),
    .commit_rd(commit_rd),
    .commit_data(commit_data)
  );

  //----------------------------------------
  // Reset Sequence
  //----------------------------------------
  initial begin
    clk = 0;
    reset = 1;
    repeat(5) @(posedge clk);
    reset = 0;
  end

  always @(posedge clk) begin
    $display("CLK | PC=%h | RegWriteW=%b | rdW=%0d | ResultW=%h",
            dut.core.PCF,
            dut.core.RegWriteW,
            dut.core.rdW,
            dut.core.ResultW);
  end

  //----------------------------------------
  // Pass commit interface via config_db
  //----------------------------------------
  initial begin
    uvm_config_db#(logic)::set(null, "*", "clk", clk);
    uvm_config_db#(logic)::set(null, "*", "commit_valid", commit_valid);
    uvm_config_db#(logic[31:0])::set(null, "*", "commit_pc", commit_pc);
    uvm_config_db#(logic[4:0])::set(null, "*", "commit_rd", commit_rd);
    uvm_config_db#(logic[31:0])::set(null, "*", "commit_data", commit_data);

    run_test("pipeline_test");
  end

endmodule