class main_dec_test extends uvm_test;

  `uvm_component_utils(main_dec_test)

  main_dec_env env;

  function new(string name = "main_dec_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env = main_dec_env::type_id::create("env", this);

  endfunction

  task run_phase(uvm_phase phase);

    main_dec_base_sequence seq;

    phase.raise_objection(this);

    seq = main_dec_base_sequence::type_id::create("seq");
    seq.start(env.agent.seqr);

    phase.drop_objection(this);

  endtask

endclass