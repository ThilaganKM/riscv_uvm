class control_unit_scoreboard extends uvm_component;

  `uvm_component_utils(control_unit_scoreboard)

  uvm_analysis_imp #(ctrl_seq_item, control_unit_scoreboard) analysis_export;

  function new(string name = "control_unit_scoreboard", uvm_component parent);
    super.new(name, parent);
    analysis_export = new("analysis_export", this);
  endfunction


  // --------------------------------------------------
  // Golden: main_decoder logic
  // --------------------------------------------------

  function void compute_main_decode(
      input  ctrl_seq_item tx,
      output bit RegWrite,
      output bit [1:0] ResultSrc,
      output bit [1:0] ALUOp,
      output bit [1:0] ImmSrc,
      output bit ALUSrc,
      output bit MemWrite,
      output bit Jump,
      output bit Branch
  );

    case (tx.op)

      7'b0000011: begin // Load
        RegWrite = 1; ImmSrc = 2'b00; ALUSrc = 1;
        MemWrite = 0; ResultSrc = 2'b01;
        Branch = 0; ALUOp = 2'b00; Jump = 0;
      end

      7'b0100011: begin // Store
        RegWrite = 0; ImmSrc = 2'b01; ALUSrc = 1;
        MemWrite = 1; ResultSrc = 2'b00;
        Branch = 0; ALUOp = 2'b00; Jump = 0;
      end

      7'b0110011: begin // R-type
        RegWrite = 1; ImmSrc = 2'b00; ALUSrc = 0;
        MemWrite = 0; ResultSrc = 2'b00;
        Branch = 0; ALUOp = 2'b10; Jump = 0;
      end

      7'b1100011: begin // Branch
        RegWrite = 0; ImmSrc = 2'b10; ALUSrc = 0;
        MemWrite = 0; ResultSrc = 2'b00;
        Branch = 1; ALUOp = 2'b01; Jump = 0;
      end

      7'b0010011: begin // I-type arithmetic
        RegWrite = 1; ImmSrc = 2'b00; ALUSrc = 1;
        MemWrite = 0; ResultSrc = 2'b00;
        Branch = 0; ALUOp = 2'b10; Jump = 0;
      end

      7'b1101111: begin // JAL
        RegWrite = 1; ImmSrc = 2'b11; ALUSrc = 0;
        MemWrite = 0; ResultSrc = 2'b10;
        Branch = 0; ALUOp = 2'b00; Jump = 1;
      end

      default: begin
        RegWrite = 0; ImmSrc = 0; ALUSrc = 0;
        MemWrite = 0; ResultSrc = 0;
        Branch = 0; ALUOp = 0; Jump = 0;
      end
    endcase

  endfunction


  // --------------------------------------------------
  // Golden: ALU Decoder logic
  // --------------------------------------------------

  function bit [2:0] compute_alu_control(
      input bit [1:0] ALUOp,
      input bit [2:0] funct3,
      input bit       funct7b5,
      input bit       opb5
  );

    bit RtypeSub;
    RtypeSub = opb5 & funct7b5;

    case (ALUOp)

      2'b00: return 3'b000; // ADD (load/store)
      2'b01: return 3'b001; // SUB (branch)

      default: begin
        case (funct3)
          3'b000: return (RtypeSub) ? 3'b001 : 3'b000;
          3'b010: return 3'b101;
          3'b110: return 3'b011;
          3'b111: return 3'b010;
          default: return 3'b000;
        endcase
      end
    endcase

  endfunction


  // --------------------------------------------------
  // Compare
  // --------------------------------------------------

  virtual function void write(ctrl_seq_item tx);

    bit exp_RegWrite;
    bit [1:0] exp_ResultSrc;
    bit [1:0] exp_ALUOp;
    bit [1:0] exp_ImmSrc;
    bit exp_ALUSrc;
    bit exp_MemWrite;
    bit exp_Jump;
    bit exp_Branch;
    bit [2:0] exp_ALUControl;

    compute_main_decode(tx,
        exp_RegWrite,
        exp_ResultSrc,
        exp_ALUOp,
        exp_ImmSrc,
        exp_ALUSrc,
        exp_MemWrite,
        exp_Jump,
        exp_Branch);

    exp_ALUControl = compute_alu_control(
        exp_ALUOp,
        tx.funct3,
        tx.funct7b5,
        tx.op[5]
    );

    if (tx.RegWrite   !== exp_RegWrite)
      `uvm_error("CTRL_SB", "RegWrite mismatch")

    if (tx.ResultSrc  !== exp_ResultSrc)
      `uvm_error("CTRL_SB", "ResultSrc mismatch")

    if (tx.MemWrite   !== exp_MemWrite)
      `uvm_error("CTRL_SB", "MemWrite mismatch")

    if (tx.ImmSrc     !== exp_ImmSrc)
      `uvm_error("CTRL_SB", "ImmSrc mismatch")

    if (tx.ALUSrc     !== exp_ALUSrc)
      `uvm_error("CTRL_SB", "ALUSrc mismatch")

    if (tx.Branch     !== exp_Branch)
      `uvm_error("CTRL_SB", "Branch mismatch")

    if (tx.Jump       !== exp_Jump)
      `uvm_error("CTRL_SB", "Jump mismatch")

    if (tx.ALUControl !== exp_ALUControl)
      `uvm_error("CTRL_SB", "ALUControl mismatch")

    `uvm_info("CTRL_SB", "Control unit match", UVM_LOW)

  endfunction

endclass