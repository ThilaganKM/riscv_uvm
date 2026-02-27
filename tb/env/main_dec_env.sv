class main_dec_env extends uvm_env;

  `uvm_component_utils(main_dec_env)

  main_dec_agent      agent;
  main_dec_scoreboard sb;

  function new(string name = "main_dec_env", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    agent = main_dec_agent::type_id::create("agent", this);
    sb    = main_dec_scoreboard::type_id::create("sb", this);

  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    agent.mon.ap.connect(sb.analysis_export);

  endfunction

endclass