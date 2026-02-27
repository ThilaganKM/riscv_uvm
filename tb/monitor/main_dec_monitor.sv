class main_dec_monitor extends uvm_monitor;

  `uvm_component_utils(main_dec_monitor)

  virtual main_dec_if vif;

  uvm_analysis_port #(main_dec_seq_item) ap;

  function new(string name = "main_dec_monitor", uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db #(virtual main_dec_if)::get(this, "", "vif", vif))
      `uvm_fatal("MAIN_DEC_MON", "Failed to get VIF")
  endfunction

  virtual task run_phase(uvm_phase phase);

    main_dec_seq_item tx;

    forever begin

      @(posedge vif.clk);
      #1;  // stabilization delay

      tx = main_dec_seq_item::type_id::create("tx");

      // Capture input
      tx.op = vif.op;

      // Capture outputs
      tx.RegWrite = vif.RegWrite;
      tx.ResultSrc = vif.ResultSrc;
      tx.ALUOp = vif.ALUOp;
      tx.ImmSrc = vif.ImmSrc;
      tx.ALUSrc = vif.ALUSrc;
      tx.MemWrite = vif.MemWrite;
      tx.Jump = vif.Jump;
      tx.Branch = vif.Branch;

      `uvm_info("MAIN_DEC_MON",
        $sformatf("Observed: op=%07b | RW=%0b ALUSrc=%0b MemW=%0b Branch=%0b Jump=%0b ALUOp=%0b ImmSrc=%0b ResultSrc=%0b",
                  tx.op,
                  tx.RegWrite,
                  tx.ALUSrc,
                  tx.MemWrite,
                  tx.Branch,
                  tx.Jump,
                  tx.ALUOp,
                  tx.ImmSrc,
                  tx.ResultSrc),
        UVM_LOW)

      ap.write(tx);

    end

  endtask

endclass