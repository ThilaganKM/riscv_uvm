class alu_dec_env extends uvm_env;

  `uvm_component_utils(alu_dec_env)

  alu_dec_agent      agent;
  alu_dec_scoreboard sb;

  function new(string name = "alu_dec_env", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    agent = alu_dec_agent::type_id::create("agent", this);
    sb    = alu_dec_scoreboard::type_id::create("sb", this);

  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    agent.mon.ap.connect(sb.analysis_export);

  endfunction

endclass