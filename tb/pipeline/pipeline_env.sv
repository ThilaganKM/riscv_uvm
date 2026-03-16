class pipeline_env extends uvm_env;

  `uvm_component_utils(pipeline_env)

  pipeline_scoreboard sb;
  riscv_coverage      cov;    // ADD

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sb  = pipeline_scoreboard::type_id::create("sb",  this);
    cov = riscv_coverage::type_id::create("cov", this);  // ADD
  endfunction

endclass