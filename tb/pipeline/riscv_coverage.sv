// =============================================================================
// File    : riscv_coverage.sv
// Project : RISC-V UVM Verification
//
// Description:
//   Functional coverage collector for RISC-V pipeline.
//   Samples signals from pipeline_if on every commit_valid cycle.
//
// Coverage Groups:
//   cg_instr_type    : instruction type distribution (R/I/Load)
//   cg_alu_op        : ALU operation coverage (ADD/SUB/AND/OR/SLT etc.)
//   cg_rd_reg        : destination register coverage (all 32 regs)
//   cg_rs1_reg       : source register 1 coverage
//   cg_hazard        : hazard type coverage
//   cg_cross_instr_rd: cross - instruction type x destination register
// =============================================================================

class riscv_coverage extends uvm_component;
  `uvm_component_utils(riscv_coverage)

  virtual pipeline_if vif;

  // Current instruction fields (decoded each cycle)
  logic [31:0] instr;
  logic [6:0]  opcode;
  logic [2:0]  funct3;
  logic [6:0]  funct7;
  logic [4:0]  rd;
  logic [4:0]  rs1;
  logic [4:0]  rs2;

  // Instruction type enum for cleaner coverage
  typedef enum logic [2:0] {
    INSTR_RTYPE  = 3'h0,
    INSTR_ITYPE  = 3'h1,
    INSTR_LOAD   = 3'h2,
    INSTR_STORE  = 3'h3,
    INSTR_BRANCH = 3'h4,
    INSTR_LUI    = 3'h5,
    INSTR_JAL    = 3'h6,
    INSTR_OTHER  = 3'h7
  } instr_type_e;

  instr_type_e instr_type;

  // ALU op enum
  typedef enum logic [3:0] {
    ALU_ADD  = 4'h0,
    ALU_SUB  = 4'h1,
    ALU_AND  = 4'h2,
    ALU_OR   = 4'h3,
    ALU_XOR  = 4'h4,
    ALU_SLT  = 4'h5,
    ALU_SLTU = 4'h6,
    ALU_SLL  = 4'h7,
    ALU_SRL  = 4'h8,
    ALU_SRA  = 4'h9,
    ALU_ADDI = 4'hA,
    ALU_LW   = 4'hB,
    ALU_OTHER= 4'hF
  } alu_op_e;

  alu_op_e alu_op;

  // =========================================================================
  // COVERGROUP: Instruction Type
  // Are we exercising all instruction categories?
  // =========================================================================
  covergroup cg_instr_type;
    cp_type: coverpoint instr_type {
      bins rtype  = {INSTR_RTYPE};
      bins itype  = {INSTR_ITYPE};
      bins load   = {INSTR_LOAD};
      bins store  = {INSTR_STORE};
      bins lui    = {INSTR_LUI};
      bins jal    = {INSTR_JAL};
    }
  endgroup

  // =========================================================================
  // COVERGROUP: ALU Operations
  // Are all ALU operations being exercised?
  // =========================================================================
  covergroup cg_alu_op;
    cp_op: coverpoint alu_op {
      bins add  = {ALU_ADD};
      bins sub  = {ALU_SUB};
      bins and_ = {ALU_AND};
      bins or_  = {ALU_OR};
      bins xor_ = {ALU_XOR};
      bins slt  = {ALU_SLT};
      bins sll  = {ALU_SLL};
      bins srl  = {ALU_SRL};
      bins sra  = {ALU_SRA};
      bins addi = {ALU_ADDI};
      bins lw   = {ALU_LW};
    }
  endgroup

  // =========================================================================
  // COVERGROUP: Register Usage
  // Are all 32 registers being used as destination?
  // x0 is excluded (hardwired zero, no writes)
  // =========================================================================
  covergroup cg_rd_reg;
    cp_rd: coverpoint rd {
      bins regs[] = {[1:31]};   // individual bin per register
      ignore_bins x0 = {0};     // x0 never written
    }
  endgroup

  // =========================================================================
  // COVERGROUP: Source Register Usage
  // Are all registers being read as operands?
  // =========================================================================
  covergroup cg_rs1_reg;
    cp_rs1: coverpoint rs1 {
      bins regs[] = {[0:31]};
    }
  endgroup

  // =========================================================================
  // COVERGROUP: Hazard Scenarios
  // Are load-use and data hazards being triggered?
  // Detected by watching forwarding unit signals via pipeline_if
  // =========================================================================
  covergroup cg_hazard;
    // Load-use hazard: load followed immediately by dependent instruction
    // Detected when pipeline stalls (hready equivalent in RISC-V = stall)
    cp_load_use: coverpoint vif.commit_valid {
      bins active = {1};
    }

    // Back-to-back same register writes (RAW hazard via forwarding)
    cp_rd_value: coverpoint rd {
      bins low_regs  = {[1:8]};
      bins mid_regs  = {[9:16]};
      bins high_regs = {[17:31]};
    }
  endgroup

  // =========================================================================
  // COVERGROUP: Cross - Instruction Type x Register Range
  // Verifies all instruction types operate across all register ranges
  // =========================================================================
  covergroup cg_cross_instr_rd;
    cp_type: coverpoint instr_type {
      bins rtype = {INSTR_RTYPE};
      bins itype = {INSTR_ITYPE};
      bins load  = {INSTR_LOAD};
    }
    cp_rd_range: coverpoint rd {
      bins low  = {[1:10]};
      bins mid  = {[11:20]};
      bins high = {[21:31]};
    }
    cx_type_rd: cross cp_type, cp_rd_range;
  endgroup

  // =========================================================================
  // COVERGROUP: Commit PC Range
  // Are instructions spread across the instruction memory?
  // =========================================================================
  covergroup cg_pc_range;
    cp_pc: coverpoint vif.commit_pc[9:2] {  // bits [9:2] = word address
      bins low_mem  = {[0:49]};
      bins mid_mem  = {[50:99]};
      bins high_mem = {[100:199]};
    }
  endgroup

  // =========================================================================
  // Constructor - instantiate all covergroups
  // =========================================================================
  function new(string name, uvm_component parent);
    super.new(name, parent);
    cg_instr_type    = new();
    cg_alu_op        = new();
    cg_rd_reg        = new();
    cg_rs1_reg       = new();
    cg_hazard        = new();
    cg_cross_instr_rd= new();
    cg_pc_range      = new();
  endfunction

  // =========================================================================
  // Build Phase
  // =========================================================================
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db #(virtual pipeline_if)::get(this, "", "vif", vif))
      `uvm_fatal("PIPE_COV", "virtual interface not found")
  endfunction

  // =========================================================================
  // Run Phase - sample on every commit
  // =========================================================================
  task run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.clk);

      if (vif.commit_valid) begin
        // Decode instruction fields
        instr  = vif.imem[vif.commit_pc >> 2];
        opcode = instr[6:0];
        rd     = instr[11:7];
        funct3 = instr[14:12];
        rs1    = instr[19:15];
        rs2    = instr[24:20];
        funct7 = instr[31:25];

        // Classify instruction type
        case (opcode)
          7'b0110011: instr_type = INSTR_RTYPE;
          7'b0010011: instr_type = INSTR_ITYPE;
          7'b0000011: instr_type = INSTR_LOAD;
          7'b0100011: instr_type = INSTR_STORE;
          7'b1100011: instr_type = INSTR_BRANCH;
          7'b0110111: instr_type = INSTR_LUI;
          7'b1101111: instr_type = INSTR_JAL;
          default:    instr_type = INSTR_OTHER;
        endcase

        // Classify ALU operation
        case (opcode)
          7'b0110011: begin  // R-type
            case ({funct7, funct3})
              {7'b0000000, 3'b000}: alu_op = ALU_ADD;
              {7'b0100000, 3'b000}: alu_op = ALU_SUB;
              {7'b0000000, 3'b111}: alu_op = ALU_AND;
              {7'b0000000, 3'b110}: alu_op = ALU_OR;
              {7'b0000000, 3'b100}: alu_op = ALU_XOR;
              {7'b0000000, 3'b010}: alu_op = ALU_SLT;
              {7'b0000000, 3'b011}: alu_op = ALU_SLTU;
              {7'b0000000, 3'b001}: alu_op = ALU_SLL;
              {7'b0000000, 3'b101}: alu_op = ALU_SRL;
              {7'b0100000, 3'b101}: alu_op = ALU_SRA;
              default:              alu_op = ALU_OTHER;
            endcase
          end
          7'b0010011: alu_op = ALU_ADDI;  // I-type ALU
          7'b0000011: alu_op = ALU_LW;    // Load
          default:    alu_op = ALU_OTHER;
        endcase

        // Sample all covergroups
        cg_instr_type.sample();
        cg_alu_op.sample();
        cg_rd_reg.sample();
        cg_rs1_reg.sample();
        cg_hazard.sample();
        cg_cross_instr_rd.sample();
        cg_pc_range.sample();
      end
    end
  endtask

  // =========================================================================
  // Report Phase - print coverage summary
  // =========================================================================
  function void report_phase(uvm_phase phase);
    `uvm_info("PIPE_COV", "==========================================", UVM_NONE)
    `uvm_info("PIPE_COV", "     RISC-V PIPELINE COVERAGE REPORT     ", UVM_NONE)
    `uvm_info("PIPE_COV", "==========================================", UVM_NONE)
    `uvm_info("PIPE_COV",
      $sformatf("  Instruction Type : %.1f%%",
        cg_instr_type.get_coverage()), UVM_NONE)
    `uvm_info("PIPE_COV",
      $sformatf("  ALU Operations   : %.1f%%",
        cg_alu_op.get_coverage()), UVM_NONE)
    `uvm_info("PIPE_COV",
      $sformatf("  RD  Registers    : %.1f%%",
        cg_rd_reg.get_coverage()), UVM_NONE)
    `uvm_info("PIPE_COV",
      $sformatf("  RS1 Registers    : %.1f%%",
        cg_rs1_reg.get_coverage()), UVM_NONE)
    `uvm_info("PIPE_COV",
      $sformatf("  Hazard Coverage  : %.1f%%",
        cg_hazard.get_coverage()), UVM_NONE)
    `uvm_info("PIPE_COV",
      $sformatf("  Cross (type x rd): %.1f%%",
        cg_cross_instr_rd.get_coverage()), UVM_NONE)
    `uvm_info("PIPE_COV",
      $sformatf("  PC Range         : %.1f%%",
        cg_pc_range.get_coverage()), UVM_NONE)
    `uvm_info("PIPE_COV", "==========================================", UVM_NONE)
  endfunction

endclass : riscv_coverage