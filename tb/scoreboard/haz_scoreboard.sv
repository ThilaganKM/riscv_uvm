class haz_scoreboard extends uvm_component;

  `uvm_component_utils(haz_scoreboard)

  uvm_analysis_imp #(haz_seq_item, haz_scoreboard) analysis_export;

  function new(string name = "haz_scoreboard", uvm_component parent);
    super.new(name, parent);
    analysis_export = new("analysis_export", this);
  endfunction


  // Golden model for hazard logic
  function void write(haz_seq_item tx);

    bit expected_lwStall;
    bit exp_StallF, exp_StallD, exp_FlushE, exp_FlushD;

    expected_lwStall = tx.ResultSrcE0 &&
                       ((tx.Rs1D == tx.RdE) || (tx.Rs2D == tx.RdE)) &&
                       (tx.RdE != 0);

    exp_StallF = expected_lwStall;
    exp_StallD = expected_lwStall;
    exp_FlushE = expected_lwStall | tx.PCSrcE;
    exp_FlushD = tx.PCSrcE;

    // Compare outputs

    if (tx.StallF !== exp_StallF)
      `uvm_error("HAZ_SB", $sformatf("StallF mismatch! Exp=%0b Act=%0b",
                                      exp_StallF, tx.StallF))

    if (tx.StallD !== exp_StallD)
      `uvm_error("HAZ_SB", $sformatf("StallD mismatch! Exp=%0b Act=%0b",
                                      exp_StallD, tx.StallD))

    if (tx.FlushE !== exp_FlushE)
      `uvm_error("HAZ_SB", $sformatf("FlushE mismatch! Exp=%0b Act=%0b",
                                      exp_FlushE, tx.FlushE))

    if (tx.FlushD !== exp_FlushD)
      `uvm_error("HAZ_SB", $sformatf("FlushD mismatch! Exp=%0b Act=%0b",
                                      exp_FlushD, tx.FlushD))

    if ((tx.StallF === exp_StallF) &&
        (tx.StallD === exp_StallD) &&
        (tx.FlushE === exp_FlushE) &&
        (tx.FlushD === exp_FlushD))
      `uvm_info("HAZ_SB", "Hazard match", UVM_LOW)

  endfunction

endclass