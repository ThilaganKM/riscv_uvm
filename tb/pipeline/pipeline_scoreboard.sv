class pipeline_scoreboard extends uvm_component;

  `uvm_component_utils(pipeline_scoreboard)

  bit [31:0] regs[31:0];

  logic        commit_valid;
  logic [31:0] commit_pc;
  logic [4:0]  commit_rd;
  logic [31:0] commit_data;

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    uvm_config_db#(logic)::get(this,"","commit_valid",commit_valid);
    uvm_config_db#(logic[31:0])::get(this,"","commit_pc",commit_pc);
    uvm_config_db#(logic[4:0])::get(this,"","commit_rd",commit_rd);
    uvm_config_db#(logic[31:0])::get(this,"","commit_data",commit_data);
  endfunction

  task run_phase(uvm_phase phase);

    forever begin
      @(posedge commit_valid);

      if (commit_rd != 0) begin
        regs[commit_rd] = commit_data;
        `uvm_info("PIPE_SB",
          $sformatf("Commit: rd=%0d data=%h pc=%h",
                     commit_rd, commit_data, commit_pc),
          UVM_LOW)
      end
    end

  endtask

endclass