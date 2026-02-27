class data_mem_test extends uvm_test;

  `uvm_component_utils(data_mem_test)

  data_mem_env env;

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    env = data_mem_env::type_id::create("env",this);
  endfunction

  task run_phase(uvm_phase phase);
    data_mem_base_sequence seq;
    phase.raise_objection(this);

    seq = data_mem_base_sequence::type_id::create("seq");
    seq.start(env.agent.seqr);

    phase.drop_objection(this);
  endtask

endclass