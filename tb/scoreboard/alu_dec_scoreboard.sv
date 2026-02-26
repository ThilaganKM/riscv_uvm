class alu_dec_scoreboard extends uvm_component;

  `uvm_component_utils(alu_dec_scoreboard)

  uvm_analysis_imp #(alu_dec_seq_item, alu_dec_scoreboard) analysis_export;

  function new(string name = "alu_dec_scoreboard", uvm_component parent);
    super.new(name, parent);
    analysis_export = new("analysis_export", this);
  endfunction

  //--------------------------------------------------
  // Golden Model
  //--------------------------------------------------

  function bit [2:0] golden_decode(alu_dec_seq_item tx);

    bit [2:0] result;
    bit       RtypeSub;

    RtypeSub = tx.opb5 & tx.funct7b5;

    case (tx.ALUOp)

      2'b00: result = 3'b000;   // Load / Store → ADD
      2'b01: result = 3'b001;   // Branch → SUB

      default: begin

        case (tx.funct3)

          3'b000: result = (RtypeSub) ? 3'b001 : 3'b000; // SUB / ADD
          3'b010: result = 3'b101;                       // SLT
          3'b110: result = 3'b011;                       // OR
          3'b111: result = 3'b010;                       // AND

          default: result = 3'bxxx;

        endcase

      end

    endcase

    return result;

  endfunction

  //--------------------------------------------------
  // Comparison Logic
  //--------------------------------------------------

  virtual function void write(alu_dec_seq_item tx);

    bit [2:0] expected;

    expected = golden_decode(tx);

    if (expected !== tx.ALUControl) begin

      `uvm_error("ALU_DEC_SB",
        $sformatf("Mismatch!\nopb5=%0b funct3=%0b funct7b5=%0b ALUOp=%0b\nExpected=%0b Actual=%0b",
                  tx.opb5, tx.funct3, tx.funct7b5, tx.ALUOp,
                  expected, tx.ALUControl))

    end
    else begin

      `uvm_info("ALU_DEC_SB",
        $sformatf("Match → ALUControl=%0b", expected),
        UVM_LOW)

    end

  endfunction

endclass