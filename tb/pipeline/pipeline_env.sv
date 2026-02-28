class pipeline_env extends uvm_env;
  `uvm_component_utils(pipeline_env)

  pipeline_scoreboard sb;

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    sb = pipeline_scoreboard::type_id::create("sb",this);
  endfunction
endclass