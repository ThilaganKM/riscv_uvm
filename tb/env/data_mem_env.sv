class data_mem_env extends uvm_env;

  `uvm_component_utils(data_mem_env)

  data_mem_agent agent;
  data_mem_scoreboard sb;

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    agent = data_mem_agent::type_id::create("agent",this);
    sb    = data_mem_scoreboard::type_id::create("sb",this);
  endfunction

  function void connect_phase(uvm_phase phase);
    agent.mon.ap.connect(sb.analysis_export);
  endfunction

endclass