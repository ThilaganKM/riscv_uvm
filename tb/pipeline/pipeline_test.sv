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

    // 🔥 DECLARATIONS MUST COME FIRST
    riscv_rand_instr rand_instr;

    phase.raise_objection(this);

    // --------------------------------
    // Random Instruction Generation
    // --------------------------------
    for(int i=0;i<64;i++) begin

      rand_instr = new();

      if(!rand_instr.randomize())
        `uvm_fatal("RAND_FAIL","Randomization failed")

      $root.tb_pipeline_top.dut.core.imem.mem[i] = rand_instr.instr;
      env.sb.instr_mem[i] = rand_instr.instr; // keep mirror in sync

      `uvm_info("RAND_GEN",
        $sformatf("mem[%0d] = %h", i, rand_instr.instr),
        UVM_LOW)

    end

    // --------------------------------
    // Run Pipeline
    // --------------------------------
    repeat(500) @(posedge env.sb.vif.clk);

    phase.drop_objection(this);

  endtask

endclass