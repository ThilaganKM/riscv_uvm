class alu_dec_test extends uvm_test;

  `uvm_component_utils(alu_dec_test)

  alu_dec_env env;

  function new(string name = "alu_dec_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env = alu_dec_env::type_id::create("env", this);

  endfunction

  task run_phase(uvm_phase phase);

    alu_dec_base_sequence seq;

    phase.raise_objection(this);

    seq = alu_dec_base_sequence::type_id::create("seq");
    seq.start(env.agent.seqr);

    phase.drop_objection(this);

  endtask

endclass