class riscv_rand_instr;

  rand bit [6:0]  opcode;
  rand bit [4:0]  rd;
  rand bit [4:0]  rs1;
  rand bit [4:0]  rs2;
  rand bit [2:0]  funct3;
  rand bit [6:0]  funct7;
  rand bit [11:0] imm_i;

  bit [31:0] instr;

  // --------------------------------
  // Opcode Selection (Add LOAD)
  // --------------------------------
  constraint opcode_c {
    opcode dist {
      7'b0110011 := 40,  // R-type
      7'b0010011 := 40,  // I-type
      7'b0000011 := 20   // LOAD
    };
  }

  constraint reg_c {
    rd  inside {[1:31]};
    rs1 inside {[0:31]};
    rs2 inside {[0:31]};
  }

  // --------------------------------
  // R-Type (only supported ops)
  // --------------------------------
  constraint rtype_c {
    if (opcode == 7'b0110011) {
      (funct3 == 3'b000 && funct7 == 7'b0000000) || // ADD
      (funct3 == 3'b000 && funct7 == 7'b0100000) || // SUB
      (funct3 == 3'b111 && funct7 == 7'b0000000) || // AND
      (funct3 == 3'b110 && funct7 == 7'b0000000) || // OR
      (funct3 == 3'b010 && funct7 == 7'b0000000);   // SLT
    }
  }

  // --------------------------------
  // I-Type ALU
  // --------------------------------
  constraint itype_c {
    if (opcode == 7'b0010011) {
      funct3 inside {3'b000,3'b111,3'b110,3'b010}; // ADDI ANDI ORI SLTI
    }
  }

  // --------------------------------
  // LOAD (LW only)
  // --------------------------------
  constraint load_c {
    if (opcode == 7'b0000011) {
      funct3 == 3'b010; // LW
    }
  }

  // --------------------------------
  // Dependency Bias (Load-Use Stress)
  // --------------------------------
  constraint dependency_bias {
    if (opcode == 7'b0000011) {
      imm_i inside {[0:32]}; // small offsets
    }
  }

  function void post_randomize();

    if (opcode == 7'b0110011)
      instr = {funct7, rs2, rs1, funct3, rd, opcode};

    else
      instr = {imm_i, rs1, funct3, rd, opcode};

  endfunction

endclass