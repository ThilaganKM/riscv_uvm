class alu_monitor extends uvm_monitor;

  `uvm_component_utils(alu_monitor)

  virtual alu_if vif;

  uvm_analysis_port #(alu_seq_item) ap;

  function new(string name = "alu_monitor", uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db #(virtual alu_if)::get(this, "", "vif", vif))
      `uvm_fatal("MON", "Failed to get VIF")
  endfunction

  virtual task run_phase(uvm_phase phase);

    alu_seq_item tx;

    forever begin

      @(posedge vif.clk);

      // Small delta-cycle stabilization (VERY IMPORTANT)
      #1;

      tx = alu_seq_item::type_id::create("tx");

      tx.SrcA       = vif.SrcA;
      tx.SrcB       = vif.SrcB;
      tx.ALUControl = vif.ALUControl;

      // Reuse fields for observed outputs (common lightweight trick)
      // Scoreboard will compute golden result
      `uvm_info("ALU_MON",
        $sformatf("Observed: SrcA=%0h SrcB=%0h ALUControl=%0b Result=%0h Zero=%0b",
                  vif.SrcA, vif.SrcB, vif.ALUControl,
                  vif.ALUResult, vif.Zero),
        UVM_LOW)

      ap.write(tx);

    end

  endtask

endclass