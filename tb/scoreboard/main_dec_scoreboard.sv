class main_dec_scoreboard extends uvm_component;

  `uvm_component_utils(main_dec_scoreboard)

  uvm_analysis_imp #(main_dec_seq_item, main_dec_scoreboard) analysis_export;

  function new(string name = "main_dec_scoreboard", uvm_component parent);
    super.new(name, parent);
    analysis_export = new("analysis_export", this);
  endfunction

  //--------------------------------------------------
  // Golden Model
  //--------------------------------------------------

  function void compute_expected(
      input  main_dec_seq_item tx,
      output bit exp_RegWrite,
      output bit [1:0] exp_ResultSrc,
      output bit [1:0] exp_ALUOp,
      output bit [1:0] exp_ImmSrc,
      output bit exp_ALUSrc,
      output bit exp_MemWrite,
      output bit exp_Jump,
      output bit exp_Branch
  );

    case (tx.op)

      7'b0000011: begin // Load
        exp_RegWrite = 1;
        exp_ImmSrc   = 2'b00;
        exp_ALUSrc   = 1;
        exp_MemWrite = 0;
        exp_ResultSrc= 2'b01;
        exp_Branch   = 0;
        exp_ALUOp    = 2'b00;
        exp_Jump     = 0;
      end

      7'b0100011: begin // Store
        exp_RegWrite = 0;
        exp_ImmSrc   = 2'b01;
        exp_ALUSrc   = 1;
        exp_MemWrite = 1;
        exp_ResultSrc= tx.ResultSrc; // don't care
        exp_Branch   = 0;
        exp_ALUOp    = 2'b00;
        exp_Jump     = 0;
      end

      7'b0110011: begin // R-type
        exp_RegWrite = 1;
        exp_ImmSrc   = tx.ImmSrc; // don't care
        exp_ALUSrc   = 0;
        exp_MemWrite = 0;
        exp_ResultSrc= 2'b00;
        exp_Branch   = 0;
        exp_ALUOp    = 2'b10;
        exp_Jump     = 0;
      end

      7'b1100011: begin // Branch
        exp_RegWrite = 0;
        exp_ImmSrc   = 2'b10;
        exp_ALUSrc   = 0;
        exp_MemWrite = 0;
        exp_ResultSrc= tx.ResultSrc; // don't care
        exp_Branch   = 1;
        exp_ALUOp    = 2'b01;
        exp_Jump     = 0;
      end

      7'b0010011: begin // I-type arithmetic
        exp_RegWrite = 1;
        exp_ImmSrc   = 2'b00;
        exp_ALUSrc   = 1;
        exp_MemWrite = 0;
        exp_ResultSrc= 2'b00;
        exp_Branch   = 0;
        exp_ALUOp    = 2'b10;
        exp_Jump     = 0;
      end

      7'b1101111: begin // JAL
        exp_RegWrite = 1;
        exp_ImmSrc   = 2'b11;
        exp_ALUSrc   = tx.ALUSrc; // don't care
        exp_MemWrite = 0;
        exp_ResultSrc= 2'b10;
        exp_Branch   = 0;
        exp_ALUOp    = tx.ALUOp;  // don't care
        exp_Jump     = 1;
      end

      default: begin
        exp_RegWrite = 0;
        exp_ImmSrc   = 2'b00;
        exp_ALUSrc   = 0;
        exp_MemWrite = 0;
        exp_ResultSrc= 2'b00;
        exp_Branch   = 0;
        exp_ALUOp    = 2'b00;
        exp_Jump     = 0;
      end

    endcase

  endfunction


  //--------------------------------------------------
  // Compare
  //--------------------------------------------------

  virtual function void write(main_dec_seq_item tx);

    bit exp_RegWrite;
    bit [1:0] exp_ResultSrc;
    bit [1:0] exp_ALUOp;
    bit [1:0] exp_ImmSrc;
    bit exp_ALUSrc;
    bit exp_MemWrite;
    bit exp_Jump;
    bit exp_Branch;

    compute_expected(tx,
      exp_RegWrite,
      exp_ResultSrc,
      exp_ALUOp,
      exp_ImmSrc,
      exp_ALUSrc,
      exp_MemWrite,
      exp_Jump,
      exp_Branch);

    if (tx.RegWrite !== exp_RegWrite)
      `uvm_error("MAIN_DEC_SB", "RegWrite mismatch")

    if (tx.ALUSrc !== exp_ALUSrc)
      `uvm_error("MAIN_DEC_SB", "ALUSrc mismatch")

    if (tx.MemWrite !== exp_MemWrite)
      `uvm_error("MAIN_DEC_SB", "MemWrite mismatch")

    if (tx.Branch !== exp_Branch)
      `uvm_error("MAIN_DEC_SB", "Branch mismatch")

    if (tx.Jump !== exp_Jump)
      `uvm_error("MAIN_DEC_SB", "Jump mismatch")

    // Compare only meaningful fields
    if (tx.op != 7'b0100011 && tx.op != 7'b1100011)
      if (tx.ResultSrc !== exp_ResultSrc)
        `uvm_error("MAIN_DEC_SB", "ResultSrc mismatch")

    if (tx.op != 7'b0110011)
      if (tx.ImmSrc !== exp_ImmSrc)
        `uvm_error("MAIN_DEC_SB", "ImmSrc mismatch")

    if (tx.op != 7'b1101111)
      if (tx.ALUOp !== exp_ALUOp)
        `uvm_error("MAIN_DEC_SB", "ALUOp mismatch")

    `uvm_info("MAIN_DEC_SB", "Control vector match", UVM_LOW)

  endfunction

endclass