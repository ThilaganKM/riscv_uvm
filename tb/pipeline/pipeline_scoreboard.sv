class pipeline_scoreboard extends uvm_component;

  `uvm_component_utils(pipeline_scoreboard)

  // ----------------------------------------
  // Architectural State
  // ----------------------------------------
  bit [31:0] regs [31:0];

  // Instruction memory mirror
  logic [31:0] instr_mem [0:63];

  // ----------------------------------------
  // Interfaces from DUT
  // ----------------------------------------
  logic clk;

  logic        commit_valid;
  logic [31:0] commit_pc;
  logic [4:0]  commit_rd;
  logic [31:0] commit_data;

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  // ----------------------------------------
  // Build Phase
  // ----------------------------------------
  function void build_phase(uvm_phase phase);

    if(!uvm_config_db#(logic)::get(this,"","clk",clk))
      `uvm_fatal("PIPE_SB","Clock not set")

    uvm_config_db#(logic)::get(this,"","commit_valid",commit_valid);
    uvm_config_db#(logic[31:0])::get(this,"","commit_pc",commit_pc);
    uvm_config_db#(logic[4:0])::get(this,"","commit_rd",commit_rd);
    uvm_config_db#(logic[31:0])::get(this,"","commit_data",commit_data);

    // Initialize architectural registers
    foreach (regs[i])
      regs[i] = 0;

    // Load instruction memory
    $readmemh("inst.mem", instr_mem);

  endfunction


  // ----------------------------------------
  // Run Phase – ISA-Level Checking
  // ----------------------------------------
  task run_phase(uvm_phase phase);

    logic [31:0] instr;
    logic [6:0]  opcode;
    logic [2:0]  funct3;
    logic [6:0]  funct7;
    logic [4:0]  rs1, rs2, rd;
    logic [31:0] imm;
    logic [31:0] expected;
    @(posedge clk);
    $display("CLK tick: commit_valid=%0b pc=%h rd=%0d data=%h",
            commit_valid, commit_pc, commit_rd, commit_data);
    forever begin
      @(posedge clk);

      if (commit_valid && commit_rd != 0) begin

        // Fetch instruction from scoreboard mirror
        instr = instr_mem[commit_pc >> 2];

        opcode = instr[6:0];
        rd     = instr[11:7];
        funct3 = instr[14:12];
        rs1    = instr[19:15];
        rs2    = instr[24:20];
        funct7 = instr[31:25];

        expected = commit_data; // default safe value

        //-----------------------------------------
        // Golden Model Execution
        //-----------------------------------------
        case(opcode)

          // ADDI (I-type arithmetic)
          7'b0010011: begin
            imm = {{20{instr[31]}}, instr[31:20]};
            expected = regs[rs1] + imm;
          end

          // R-type (ADD only for now)
          7'b0110011: begin
            if (funct3 == 3'b000 && funct7 == 7'b0000000) begin
              expected = regs[rs1] + regs[rs2]; // ADD
            end
          end

          default: begin
            // For now ignore other instructions
            expected = commit_data;
          end

        endcase

        //-----------------------------------------
        // Compare
        //-----------------------------------------
        if (commit_data !== expected) begin
          `uvm_error("PIPE_SB",
            $sformatf("Mismatch at PC=%h rd=%0d Expected=%h Actual=%h",
                      commit_pc, commit_rd, expected, commit_data))
        end
        else begin
          `uvm_info("PIPE_SB",
            $sformatf("PASS: PC=%h rd=%0d data=%h",
                      commit_pc, commit_rd, commit_data),
            UVM_LOW)
        end

        //-----------------------------------------
        // Update architectural state
        //-----------------------------------------
        regs[commit_rd] = commit_data;

      end
    end

  endtask

endclass