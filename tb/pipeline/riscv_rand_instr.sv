class riscv_rand_instr;

  // --------------------------------------------
  // Fields
  // --------------------------------------------
  rand bit [6:0]  opcode;
  rand bit [4:0]  rd;
  rand bit [4:0]  rs1;
  rand bit [4:0]  rs2;
  rand bit [2:0]  funct3;
  rand bit        funct7;
  rand bit signed [11:0] imm_i;

  bit [31:0] instr;

  // --------------------------------------------
  // Opcode constraint
  // --------------------------------------------
  constraint opcode_c {
    opcode inside {7'b0110011, 7'b0010011};
  }

  // --------------------------------------------
  // Register constraints
  // --------------------------------------------
  constraint reg_c {
    rd  inside {[1:31]};
    rs1 inside {[0:31]};
    rs2 inside {[0:31]};
  }

  // --------------------------------------------
  // R-Type constraints
  // --------------------------------------------
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

  // --------------------------------------------
  // I-Type constraints
  // --------------------------------------------
  constraint itype_c {
    if (opcode == 7'b0010011) {

        funct3 inside {
        3'b000, // ADDI
        3'b111, // ANDI
        3'b110, // ORI
        3'b010  // SLTI
        };

        // Prevent shift encodings
        if (funct3 == 3'b001 || funct3 == 3'b101)
        funct7 == 7'b0000000;
    }
  }

  // --------------------------------------------
  // Assemble Instruction
  // --------------------------------------------
  function void post_randomize();

    if(opcode == 7'b0110011) begin
      instr = { {6'b000000,funct7b5},
                rs2,
                rs1,
                funct3,
                rd,
                opcode };
    end
    else begin
      instr = { imm_i,
                rs1,
                funct3,
                rd,
                opcode };
    end

  endfunction

endclass