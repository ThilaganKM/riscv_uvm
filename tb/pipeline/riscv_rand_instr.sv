class riscv_rand_instr;

  rand bit [6:0]  opcode;
  rand bit [4:0]  rd;
  rand bit [4:0]  rs1;
  rand bit [4:0]  rs2;
  rand bit [2:0]  funct3;
  rand bit [6:0]  funct7;
  rand bit [11:0] imm_i;

  bit [31:0] instr;

  //---------------------------------------------
  // Constraint: Only support safe RV32I ALU ops
  //---------------------------------------------
  constraint opcode_c {
    opcode inside {
      7'b0110011,  // R-type
      7'b0010011   // I-type
    };
  }

  constraint reg_c {
    rd  inside {[1:31]};  // avoid x0
    rs1 inside {[0:31]};
    rs2 inside {[0:31]};
  }

  constraint rtype_c {
    if(opcode == 7'b0110011) {
      funct3 inside {3'b000,3'b111,3'b110,3'b100,3'b010};
      funct7 inside {7'b0000000,7'b0100000};
    }
  }

  //---------------------------------------------
  function void post_randomize();

    if(opcode == 7'b0110011) begin
      instr = {funct7, rs2, rs1, funct3, rd, opcode};
    end
    else begin
      instr = {imm_i, rs1, funct3, rd, opcode};
    end

  endfunction

endclass