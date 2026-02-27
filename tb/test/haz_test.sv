class haz_test extends uvm_test;

  `uvm_component_utils(haz_test)

  haz_env env;

  function new(string name = "haz_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env = haz_env::type_id::create("env", this);

  endfunction

  task run_phase(uvm_phase phase);

    haz_base_sequence seq;

    phase.raise_objection(this);

    seq = haz_base_sequence::type_id::create("seq");
    seq.start(env.agent.seqr);

    phase.drop_objection(this);

  endtask

endclass