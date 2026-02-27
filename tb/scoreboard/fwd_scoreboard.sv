class fwd_scoreboard extends uvm_component;

  `uvm_component_utils(fwd_scoreboard)

  uvm_analysis_imp #(fwd_seq_item, fwd_scoreboard) analysis_export;

  function new(string name = "fwd_scoreboard", uvm_component parent);
    super.new(name, parent);
    analysis_export = new("analysis_export", this);
  endfunction

  // --------------------------------------------------
  // Golden Model Logic
  // --------------------------------------------------

  function bit [1:0] compute_forward(
      bit [4:0] Rs,
      bit [4:0] RdM,
      bit [4:0] RdW,
      bit       RegWriteM,
      bit       RegWriteW
  );

    if ((Rs == RdM) && RegWriteM && (Rs != 0))
      return 2'b10;   // MEM priority
    else if ((Rs == RdW) && RegWriteW && (Rs != 0))
      return 2'b01;   // WB
    else
      return 2'b00;   // No forward

  endfunction


  // --------------------------------------------------
  // Comparison
  // --------------------------------------------------

  virtual function void write(fwd_seq_item tx);

    bit [1:0] expA, expB;

    expA = compute_forward(tx.Rs1E, tx.RdM, tx.RdW,
                           tx.RegWriteM, tx.RegWriteW);

    expB = compute_forward(tx.Rs2E, tx.RdM, tx.RdW,
                           tx.RegWriteM, tx.RegWriteW);

    if (expA !== tx.ForwardAE) begin
      `uvm_error("FWD_SB",
        $sformatf("ForwardAE Mismatch!\nRs1E=%0d RdM=%0d RdW=%0d RW_M=%0b RW_W=%0b\nExpected=%0b Actual=%0b",
                  tx.Rs1E, tx.RdM, tx.RdW,
                  tx.RegWriteM, tx.RegWriteW,
                  expA, tx.ForwardAE))
    end

    if (expB !== tx.ForwardBE) begin
      `uvm_error("FWD_SB",
        $sformatf("ForwardBE Mismatch!\nRs2E=%0d RdM=%0d RdW=%0d RW_M=%0b RW_W=%0b\nExpected=%0b Actual=%0b",
                  tx.Rs2E, tx.RdM, tx.RdW,
                  tx.RegWriteM, tx.RegWriteW,
                  expB, tx.ForwardBE))
    end

    if ((expA === tx.ForwardAE) && (expB === tx.ForwardBE)) begin
      `uvm_info("FWD_SB",
        $sformatf("Match: FwdA=%0b FwdB=%0b", expA, expB),
        UVM_LOW)
    end

  endfunction

endclass