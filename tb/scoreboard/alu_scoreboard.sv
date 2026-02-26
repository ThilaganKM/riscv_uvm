class alu_scoreboard extends uvm_component;

  `uvm_component_utils(alu_scoreboard)

  uvm_analysis_imp #(alu_seq_item, alu_scoreboard) analysis_export;

  function new(string name = "alu_scoreboard", uvm_component parent);
    super.new(name, parent);
    analysis_export = new("analysis_export", this);
  endfunction

  // Golden model computation
  function logic [31:0] golden_alu(
      logic [31:0] SrcA,
      logic [31:0] SrcB,
      logic [2:0]  ALUControl
  );

    logic [31:0] result;

    case (ALUControl)

      3'b000: result = SrcA + SrcB;             // ADD
      3'b001: result = SrcA - SrcB;             // SUB
      3'b010: result = SrcA & SrcB;             // AND
      3'b011: result = SrcA | SrcB;             // OR
      3'b101: result = SrcA >> SrcB[4:0];       // SHIFT RIGHT (CRITICAL)

      default: result = 32'b0;

    endcase

    return result;

  endfunction


  virtual function void write(alu_seq_item tx);

    logic [31:0] expected;
    logic        expected_zero;

    expected = golden_alu(tx.SrcA, tx.SrcB, tx.ALUControl);
    expected_zero = (expected == 0);

    if (expected !== tx.ALUResult) begin

      `uvm_error("ALU_SB",
        $sformatf("Mismatch!\nSrcA=%0h SrcB=%0h ALUCtrl=%0b\nExpected=%0h Actual=%0h",
                  tx.SrcA, tx.SrcB, tx.ALUControl,
                  expected, tx.ALUResult))

    end
    else begin

      `uvm_info("ALU_SB",
        $sformatf("Match: Result=%0h", expected),
        UVM_LOW)

    end

    if (expected_zero !== tx.Zero) begin

      `uvm_error("ALU_SB",
        $sformatf("Zero Flag Mismatch!\nExpectedZero=%0b ActualZero=%0b",
                  expected_zero, tx.Zero))

    end

  endfunction

endclass