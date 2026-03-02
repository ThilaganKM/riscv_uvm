class pipeline_test extends uvm_test;

  `uvm_component_utils(pipeline_test)

  pipeline_env env;

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = pipeline_env::type_id::create("env",this);
  endfunction

  task run_phase(uvm_phase phase);

    riscv_rand_instr rand_instr;

    phase.raise_objection(this);

    // Generate 64 random instructions
    for(int i=0;i<64;i++) begin

        rand_instr = new();

        if(!rand_instr.randomize())
        `uvm_fatal("RAND_FAIL","Randomization failed")

        env.sb.instr_mem[i] = rand_instr.instr;

        `uvm_info("RAND_GEN",
        $sformatf("mem[%0d] = %h", i, rand_instr.instr),
        UVM_LOW)

    end

    // Run simulation
    repeat(500) @(posedge env.sb.vif.clk);

    phase.drop_objection(this);

  endtask

endclass