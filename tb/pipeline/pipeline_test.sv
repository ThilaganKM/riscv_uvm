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
    phase.raise_objection(this);

    repeat (300) begin
        #10;  // 1 full clock cycle
    end

    phase.drop_objection(this);
  endtask

endclass