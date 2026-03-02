class riscv_rand_instr;

  // --------------------------------------------
  // Fields
  // --------------------------------------------
  rand bit [6:0]  opcode;
  rand bit [4:0]  rd;
  rand bit [4:0]  rs1;
  rand bit [4:0]  rs2;
  rand bit [2:0]  funct3;
  rand bit        funct7b5;   // only bit 30 matters
  rand bit [11:0] imm_i;

  bit [31:0] instr;

  // --------------------------------------------
  // Opcode constraint
  // --------------------------------------------
  constraint opcode_c {
    opcode inside {
      7'b0110011,  // R-type
      7'b0010011   // I-type
    };
  }

  // --------------------------------------------
  // Register constraints
  // --------------------------------------------
  constraint reg_c {
    rd  inside {[1:31]};   // avoid x0 write
    rs1 inside {[0:31]};
    rs2 inside {[0:31]};
  }

  // --------------------------------------------
  // R-Type constraints
  // --------------------------------------------
  constraint rtype_c {
    if(opcode == 7'b0110011) {

      funct3 inside {3'b000,3'b010,3'b110,3'b111};

      // ADD / SUB control
      if(funct3 == 3'b000)
        funct7b5 inside {0,1};
      else
        funct7b5 == 0;  // other ops ignore funct7, keep 0
    }
  }

  // --------------------------------------------
  // I-Type constraints
  // --------------------------------------------
  constraint itype_c {
    if(opcode == 7'b0010011) {

      funct3 inside {3'b000,3'b010,3'b110,3'b111};

      // no funct7 in I-type
      funct7b5 == 0;

      // limit immediate range for stability
      imm_i inside {[-32:31]};
    }
  }

  // --------------------------------------------
  // Post Randomize → Assemble instruction
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