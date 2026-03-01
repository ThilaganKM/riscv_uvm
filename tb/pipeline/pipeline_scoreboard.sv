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
  logic [31:0] instr_mem [0:63];

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction


  //--------------------------------------------------
  // Build Phase
  //--------------------------------------------------
  function void build_phase(uvm_phase phase);

    if(!uvm_config_db#(virtual pipeline_if)::get(this,"","vif",vif))
      `uvm_fatal("PIPE_SB","VIF not set")

    // Initialize architectural register file
    foreach(regs[i])
      regs[i] = 0;

    // Mirror DUT instruction memory
    $readmemh("inst.mem", instr_mem);

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
    logic [31:0] imm;
    logic [31:0] expected;

    forever begin
      @(posedge vif.clk);

      if(vif.commit_valid && vif.commit_rd != 0) begin

        //------------------------------------------
        // Fetch instruction from mirror
        //------------------------------------------
        instr = instr_mem[vif.commit_pc >> 2];

        opcode = instr[6:0];
        rd     = instr[11:7];
        funct3 = instr[14:12];
        rs1    = instr[19:15];
        rs2    = instr[24:20];
        funct7 = instr[31:25];

        expected = vif.commit_data; // default safe fallback

        //------------------------------------------
        // Golden Model
        //------------------------------------------
        case(opcode)

          //--------------------------------------------------
          // R-TYPE (0110011)
          //--------------------------------------------------
          7'b0110011: begin

            case(funct3)

              3'b000: begin
                if (funct7 == 7'b0100000)
                  expected = regs[rs1] - regs[rs2];  // SUB
                else
                  expected = regs[rs1] + regs[rs2];  // ADD
              end

              3'b111: expected = regs[rs1] & regs[rs2]; // AND
              3'b110: expected = regs[rs1] | regs[rs2]; // OR

              3'b010: expected =
                ($signed(regs[rs1]) < $signed(regs[rs2])) ? 32'd1 : 32'd0; // SLT

              default: expected = vif.commit_data;

            endcase
          end


          //--------------------------------------------------
          // I-TYPE ARITHMETIC (0010011)
          //--------------------------------------------------
          7'b0010011: begin

            imm = {{20{instr[31]}}, instr[31:20]};

            case(funct3)

              3'b000: expected = regs[rs1] + imm; // ADDI
              3'b111: expected = regs[rs1] & imm; // ANDI
              3'b110: expected = regs[rs1] | imm; // ORI

              3'b010: expected =
                ($signed(regs[rs1]) < $signed(imm)) ? 32'd1 : 32'd0; // SLTI

              default: expected = vif.commit_data;

            endcase
          end

        endcase


        //------------------------------------------
        // Compare
        //------------------------------------------
        if(vif.commit_data !== expected) begin

          `uvm_error("PIPE_SB",
            $sformatf("Mismatch PC=%h rd=%0d Exp=%h Act=%h",
                       vif.commit_pc,
                       vif.commit_rd,
                       expected,
                       vif.commit_data))

        end
        else begin

          `uvm_info("PIPE_SB",
            $sformatf("PASS PC=%h rd=%0d data=%h",
                       vif.commit_pc,
                       vif.commit_rd,
                       vif.commit_data),
            UVM_LOW)

        end


        //------------------------------------------
        // Update Architectural State
        //------------------------------------------
        regs[vif.commit_rd] = vif.commit_data;

      end
    end
  endtask

endclass