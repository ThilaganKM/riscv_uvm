`timescale 1ns/1ps

module rvhazard_sva;

  // ==========================================
  // 1️⃣ x0 NEVER WRITTEN
  // ==========================================
  assert property (@(posedge clk)
                   disable iff (reset)
                   RegWriteW |-> (rdW != 5'd0))
    else $error("SVA FAIL: Attempt to write x0");



  // ==========================================
  // 2️⃣ LOAD-USE MUST STALL
  // ==========================================
  assert property (@(posedge clk)
                   disable iff (reset)
                   (ResultSrcE[0] &&
                    (rdE != 5'd0) &&
                    ((InstrD[19:15] == rdE) ||
                     (InstrD[24:20] == rdE)))
                   |-> StallD)
    else $error("SVA FAIL: Load-use hazard not stalled");



  // ==========================================
  // 3️⃣ BRANCH MUST FLUSH
  // ==========================================
  assert property (@(posedge clk)
                   disable iff (reset)
                   PCSrcE |-> FlushD)
    else $error("SVA FAIL: Branch did not flush decode");



  // ==========================================
  // 4️⃣ STALL FREEZES DECODE
  // ==========================================
  assert property (@(posedge clk)
                   disable iff (reset)
                   StallD |=> $stable(InstrD))
    else $error("SVA FAIL: Decode changed during stall");



  // ==========================================
  // 5️⃣ FORWARDING CORRECTNESS
  // ==========================================
  assert property (@(posedge clk)
                   disable iff (reset)
                   (ForwardAE == 2'b10) |-> (SrcAE == ALUResultM))
    else $error("SVA FAIL: ForwardA incorrect");

  assert property (@(posedge clk)
                   disable iff (reset)
                   (ForwardBE == 2'b10) |-> (SrcB == ALUResultM))
    else $error("SVA FAIL: ForwardB incorrect");

endmodule