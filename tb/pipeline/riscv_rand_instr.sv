class riscv_rand_instr;

  // -----------------------------
  // Fields
  // -----------------------------
  rand bit [6:0]  opcode;
  rand bit [4:0]  rd;
  rand bit [4:0]  rs1;
  rand bit [4:0]  rs2;
  rand bit [2:0]  funct3;
  rand bit [6:0]  funct7;
  rand bit [11:0] imm_i;

  bit [31:0] instr;

  // -----------------------------
  // Only R-type and I-type ALU
  // -----------------------------
  constraint opcode_c {
    opcode inside {7'b0110011, 7'b0010011};
  }

  constraint reg_c {
    rd  inside {[1:31]};   // avoid x0 write
    rs1 inside {[0:31]};
    rs2 inside {[0:31]};
  }

  // -----------------------------
  // R-TYPE (ONLY WHAT ALU SUPPORTS)
  // -----------------------------
  constraint rtype_c {
    if (opcode == 7'b0110011) {

      // ADD
      (funct3 == 3'b000 && funct7 == 7'b0000000) ||

      // SUB
      (funct3 == 3'b000 && funct7 == 7'b0100000) ||

      // AND
      (funct3 == 3'b111 && funct7 == 7'b0000000) ||

      // OR
      (funct3 == 3'b110 && funct7 == 7'b0000000) ||

      // SLT
      (funct3 == 3'b010 && funct7 == 7'b0000000);
    }
  }

  // -----------------------------
  // I-TYPE (ONLY WHAT ALU SUPPORTS)
  // -----------------------------
  constraint itype_c {
    if (opcode == 7'b0010011) {

      funct3 inside {
        3'b000, // ADDI
        3'b111, // ANDI
        3'b110, // ORI
        3'b010  // SLTI
      };
    }
  }

  // -----------------------------
  // Instruction Packing
  // -----------------------------
  function void post_randomize();

    if (opcode == 7'b0110011) begin
      instr = {funct7, rs2, rs1, funct3, rd, opcode};
    end
    else begin
      instr = {imm_i, rs1, funct3, rd, opcode};
    end

  endfunction

endclass