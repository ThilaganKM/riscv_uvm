class pc_test extends uvm_test;

    `uvm_component_utils(pc_test)

    pc_env env;

    function new(string name = "pc_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        //--------------------------------------------------
        // Create Environment
        //--------------------------------------------------

        env = pc_env::type_id::create("env", this);

    endfunction

    virtual task run_phase(uvm_phase phase);

        pc_base_sequence seq;

        phase.raise_objection(this);

        //--------------------------------------------------
        // Create & Start Sequence
        //--------------------------------------------------

        seq = pc_base_sequence::type_id::create("seq");

        seq.start(env.agent.sequencer);

        phase.drop_objection(this);

    endtask

endclass