class pipeline_scoreboard extends uvm_component;

  `uvm_component_utils(pipeline_scoreboard)

  virtual pipeline_if vif;

  //--------------------------------------------------
  // Architectural Register Model
  //--------------------------------------------------
  bit [31:0] regs [31:0];

  //--------------------------------------------------
  // Instruction Memory Mirror
  //--------------------------------------------------
  logic [31:0] instr_mem [0:255];

  //--------------------------------------------------
  // Data Memory Mirror
  //--------------------------------------------------
  bit [31:0] data_mem [0:255];

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  //--------------------------------------------------
  // Build Phase
  //--------------------------------------------------
  function void build_phase(uvm_phase phase);

    if(!uvm_config_db#(virtual pipeline_if)::get(this,"","vif",vif))
      `uvm_fatal("PIPE_SB","VIF not set")

    foreach(regs[i]) regs[i] = 0;
    foreach(data_mem[i]) data_mem[i] = 0;

    $readmemh("inst.mem", instr_mem);

  endfunction


  //--------------------------------------------------
  // Immediate Generators
  //--------------------------------------------------
  function automatic logic [31:0] imm_i(logic [31:0] instr);
    return {{20{instr[31]}}, instr[31:20]};
  endfunction

  function automatic logic [31:0] imm_s(logic [31:0] instr);
    return {{20{instr[31]}}, instr[31:25], instr[11:7]};
  endfunction

  function automatic logic [31:0] imm_b(logic [31:0] instr);
    return {{19{instr[31]}},
            instr[31],
            instr[7],
            instr[30:25],
            instr[11:8],
            1'b0};
  endfunction

  function automatic logic [31:0] imm_u(logic [31:0] instr);
    return {instr[31:12],12'b0};
  endfunction

  function automatic logic [31:0] imm_j(logic [31:0] instr);
    return {{11{instr[31]}},
            instr[31],
            instr[19:12],
            instr[20],
            instr[30:21],
            1'b0};
  endfunction


  //--------------------------------------------------
  // Run Phase
  //--------------------------------------------------
  task run_phase(uvm_phase phase);

    logic [31:0] instr;
    logic [6:0]  opcode;
    logic [2:0]  funct3;
    logic [6:0]  funct7;
    logic [4:0]  rs1, rs2, rd;
    logic [31:0] expected;
    logic [31:0] addr;
    logic [31:0] pc_next;

    forever begin
      @(posedge vif.clk);

      if(vif.commit_valid) begin

        instr  = instr_mem[vif.commit_pc >> 2];
        opcode = instr[6:0];
        rd     = instr[11:7];
        funct3 = instr[14:12];
        rs1    = instr[19:15];
        rs2    = instr[24:20];
        funct7 = instr[31:25];

        expected = 32'hDEADBEEF; // intentional poison default

        //--------------------------------------------------
        // DECODE
        //--------------------------------------------------
        case(opcode)

          //=============================
          // R-TYPE
          //=============================
          7'b0110011: begin
            case({funct7,funct3})
              {7'b0000000,3'b000}: expected = regs[rs1] + regs[rs2]; // ADD
              {7'b0100000,3'b000}: expected = regs[rs1] - regs[rs2]; // SUB
              {7'b0000000,3'b111}: expected = regs[rs1] & regs[rs2];
              {7'b0000000,3'b110}: expected = regs[rs1] | regs[rs2];
              {7'b0000000,3'b100}: expected = regs[rs1] ^ regs[rs2];
              {7'b0000000,3'b001}: expected = regs[rs1] << regs[rs2][4:0];
              {7'b0000000,3'b101}: expected = regs[rs1] >> regs[rs2][4:0];
              {7'b0100000,3'b101}: expected = $signed(regs[rs1]) >>> regs[rs2][4:0];
              {7'b0000000,3'b010}: expected = 
                    ($signed(regs[rs1]) < $signed(regs[rs2])) ? 1 : 0;
              {7'b0000000,3'b011}: expected = 
                    (regs[rs1] < regs[rs2]) ? 1 : 0;
              default: begin
                `uvm_error("PIPE_SB","Unsupported R-type");
              end
            endcase
          end

          //=============================
          // I-TYPE ALU
          //=============================
          7'b0010011: begin
            logic [31:0] imm = imm_i(instr);
            case(funct3)
              3'b000: expected = regs[rs1] + imm;
              3'b111: expected = regs[rs1] & imm;
              3'b110: expected = regs[rs1] | imm;
              3'b100: expected = regs[rs1] ^ imm;
              3'b010: expected =
                    ($signed(regs[rs1]) < $signed(imm)) ? 1 : 0;
              3'b011: expected =
                    (regs[rs1] < imm) ? 1 : 0;
              3'b001: expected = regs[rs1] << instr[24:20];
              3'b101: begin
                if(funct7 == 7'b0100000)
                  expected = $signed(regs[rs1]) >>> instr[24:20];
                else
                  expected = regs[rs1] >> instr[24:20];
              end
              default: begin
                `uvm_error("PIPE_SB","Unsupported I-type");
              end
            endcase
          end

          //=============================
          // LOAD
          //=============================
          7'b0000011: begin
            addr = regs[rs1] + imm_i(instr);
            expected = data_mem[addr >> 2];
          end

          //=============================
          // STORE
          //=============================
          7'b0100011: begin
            addr = regs[rs1] + imm_s(instr);
            data_mem[addr >> 2] = regs[rs2];
          end

          //=============================
          // LUI
          //=============================
          7'b0110111: expected = imm_u(instr);

          //=============================
          // AUIPC
          //=============================
          7'b0010111: expected = vif.commit_pc + imm_u(instr);

          //=============================
          // JAL
          //=============================
          7'b1101111: expected = vif.commit_pc + 4;

          //=============================
          // JALR
          //=============================
          7'b1100111: expected = vif.commit_pc + 4;

          default: begin
            // ignore unsupported
          end
        endcase


        //--------------------------------------------------
        // Comparison (only when writing register)
        //--------------------------------------------------
        if(rd != 0 && opcode != 7'b0100011) begin

          if(vif.commit_data !== expected) begin
            `uvm_error("PIPE_SB",
              $sformatf("Mismatch PC=%h rd=%0d Exp=%h Act=%h",
                        vif.commit_pc,
                        rd,
                        expected,
                        vif.commit_data))
          end
          else begin
            `uvm_info("PIPE_SB",
              $sformatf("PASS PC=%h rd=%0d data=%h",
                        vif.commit_pc,
                        rd,
                        vif.commit_data),
              UVM_LOW)
          end

          regs[rd] = vif.commit_data;
        end

        // Enforce x0 invariant
        regs[0] = 0;

      end
    end
  endtask

endclass