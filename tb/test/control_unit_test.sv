class control_unit_test extends uvm_test;

  `uvm_component_utils(control_unit_test)

  control_unit_env env;

  function new(string name = "control_unit_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env = control_unit_env::type_id::create("env", this);

  endfunction

  task run_phase(uvm_phase phase);

    control_unit_base_sequence seq;

    phase.raise_objection(this);

    seq = control_unit_base_sequence::type_id::create("seq");
    seq.start(env.agent.seqr);

    phase.drop_objection(this);

  endtask

endclass