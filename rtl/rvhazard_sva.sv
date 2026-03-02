`timescale 1ns/1ps

module rvhazard_sva (rvhazard core);

  // ==========================================
  // Clocking block
  // ==========================================
  default clocking cb @(posedge core.clk); endclocking
  default disable iff (core.reset);

  // ======================================================
  // 1️⃣ x0 MUST NEVER BE WRITTEN
  // ======================================================
  property x0_never_written;
    core.RegWriteW |-> (core.rdW != 5'd0);
  endproperty

  assert property (x0_never_written)
    else $error("SVA FAIL: Attempt to write x0");



  // ======================================================
  // 2️⃣ LOAD-USE HAZARD MUST STALL
  // If EX stage is load and ID uses that rd → StallD must assert
  // ======================================================
  property load_use_stall;
    (core.ResultSrcE[0] &&    // load in EX stage
     (core.rdE != 5'd0) &&
     ((core.InstrD[19:15] == core.rdE) ||
      (core.InstrD[24:20] == core.rdE)))
    |-> core.StallD;
  endproperty

  assert property (load_use_stall)
    else $error("SVA FAIL: Load-use hazard not stalled");



  // ======================================================
  // 3️⃣ FLUSH ON TAKEN BRANCH
  // If PCSrcE is high → FlushD must assert
  // ======================================================
  property branch_flush;
    core.PCSrcE |-> core.FlushD;
  endproperty

  assert property (branch_flush)
    else $error("SVA FAIL: Branch did not flush decode stage");



  // ======================================================
  // 4️⃣ STALL FREEZES IF/ID REGISTER
  // If StallD → InstrD must stay stable next cycle
  // ======================================================
  property stall_holds_decode;
    core.StallD |=> $stable(core.InstrD);
  endproperty

  assert property (stall_holds_decode)
    else $error("SVA FAIL: Decode stage changed during stall");



  // ======================================================
  // 5️⃣ FORWARDING CORRECTNESS (EX hazard)
  // If forwarding from MEM → SrcAE must equal ALUResultM
  // ======================================================
  property forwardA_from_MEM;
    (core.ForwardAE == 2'b10) |-> (core.SrcAE == core.ALUResultM);
  endproperty

  assert property (forwardA_from_MEM)
    else $error("SVA FAIL: ForwardA mismatch from MEM stage");



  property forwardB_from_MEM;
    (core.ForwardBE == 2'b10) |-> (core.SrcB == core.ALUResultM);
  endproperty

  assert property (forwardB_from_MEM)
    else $error("SVA FAIL: ForwardB mismatch from MEM stage");



  // ======================================================
  // 6️⃣ WRITEBACK ENABLE MUST MATCH rdW
  // If RegWriteW asserted → rdW must not be X
  // ======================================================
  property no_unknown_writeback;
    core.RegWriteW |-> !$isunknown(core.rdW);
  endproperty

  assert property (no_unknown_writeback)
    else $error("SVA FAIL: Unknown rdW during writeback");

endmodule