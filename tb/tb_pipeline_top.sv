`timescale 1ns/1ps
import uvm_pkg::*;
import pipeline_pkg::*;
`include "uvm_macros.svh"

module tb_pipeline_top;

  //----------------------------------------
  // Clock
  //----------------------------------------
  logic clk = 0;
  always #5 clk = ~clk;

  //----------------------------------------
  // Reset
  //----------------------------------------
  logic reset;

  //----------------------------------------
  // Interface
  //----------------------------------------
  pipeline_if pipe_if(clk);

  //----------------------------------------
  // DUT
  //----------------------------------------
  rvhazard_dbg dut (
    .clk(clk),
    .reset(reset),
    .commit_valid(pipe_if.commit_valid),
    .commit_pc(pipe_if.commit_pc),
    .commit_rd(pipe_if.commit_rd),
    .commit_data(pipe_if.commit_data)
  );

  //----------------------------------------
  // Reset
  //----------------------------------------
  initial begin
    reset = 1;
    repeat(5) @(posedge clk);
    reset = 0;
  end

  //----------------------------------------
  // Debug
  //----------------------------------------
  always @(posedge clk) begin
    $display("T=%0t | PC=%h | commit_valid=%b | rd=%0d | data=%h",
              $time,
              pipe_if.commit_pc,
              pipe_if.commit_valid,
              pipe_if.commit_rd,
              pipe_if.commit_data);
  end

  //----------------------------------------
  // UVM Setup
  //----------------------------------------
  initial begin
    uvm_config_db#(virtual pipeline_if)::set(null,"*","vif",pipe_if);
    run_test("pipeline_test");
  end

endmodule