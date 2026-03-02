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
    .pipe_if(pipe_if)
  );
    //----------------------------------------
    // Default Memory Initialization (NOP)
    //----------------------------------------
  initial begin
    for(int i=0;i<256;i++)
        pipe_if.imem[i] = 32'h00000013; // ADDI x0,x0,0
  end

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
  initial begin
      $dumpfile("wave.vcd");
      $dumpvars(0, tb_pipeline_top);
  end

endmodule