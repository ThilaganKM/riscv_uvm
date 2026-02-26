class alu_dec_monitor extends uvm_monitor;

  `uvm_component_utils(alu_dec_monitor)

  virtual alu_dec_if vif;

  uvm_analysis_port #(alu_dec_seq_item) ap;

  function new(string name = "alu_dec_monitor", uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db #(virtual alu_dec_if)::get(this, "", "vif", vif))
      `uvm_fatal("MON", "Failed to get VIF")
  endfunction

  virtual task run_phase(uvm_phase phase);

    alu_dec_seq_item tx;

    forever begin

      @(posedge vif.clk);

      #1;  // ✅ stabilization (VERY IMPORTANT)

      tx = alu_dec_seq_item::type_id::create("tx");

      tx.opb5      = vif.opb5;
      tx.funct3    = vif.funct3;
      tx.funct7b5  = vif.funct7b5;
      tx.ALUOp     = vif.ALUOp;

      // ✅ CRITICAL
      tx.ALUControl = vif.ALUControl;

      `uvm_info("ALU_DEC_MON",
        $sformatf("Observed: opb5=%0b funct3=%0b funct7b5=%0b ALUOp=%0b → ALUControl=%0b",
                  tx.opb5, tx.funct3, tx.funct7b5, tx.ALUOp, tx.ALUControl),
        UVM_LOW)

      ap.write(tx);

    end

  endtask

endclass