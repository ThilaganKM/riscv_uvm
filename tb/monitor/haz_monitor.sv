class haz_monitor extends uvm_monitor;

  `uvm_component_utils(haz_monitor)

  virtual haz_if vif;

  uvm_analysis_port #(haz_seq_item) ap;

  function new(string name = "haz_monitor", uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db #(virtual haz_if)::get(this, "", "vif", vif))
      `uvm_fatal("HAZ_MON", "Failed to get VIF")
  endfunction

  virtual task run_phase(uvm_phase phase);

    haz_seq_item tx;

    forever begin

      @(posedge vif.clk);

      // Delta-cycle stabilization (important even for combinational logic)
      #1;

      tx = haz_seq_item::type_id::create("tx");

      // Sample inputs
      tx.Rs1D        = vif.Rs1D;
      tx.Rs2D        = vif.Rs2D;
      tx.RdE         = vif.RdE;
      tx.PCSrcE      = vif.PCSrcE;
      tx.ResultSrcE0 = vif.ResultSrcE0;

      // Sample outputs
      tx.StallF = vif.StallF;
      tx.StallD = vif.StallD;
      tx.FlushE = vif.FlushE;
      tx.FlushD = vif.FlushD;

      `uvm_info("HAZ_MON",
        $sformatf("Observed: Rs1D=%0d Rs2D=%0d RdE=%0d | PCSrcE=%0b ResultSrcE0=%0b || StallF=%0b StallD=%0b FlushE=%0b FlushD=%0b",
                  tx.Rs1D, tx.Rs2D, tx.RdE,
                  tx.PCSrcE, tx.ResultSrcE0,
                  tx.StallF, tx.StallD, tx.FlushE, tx.FlushD),
        UVM_LOW)

      ap.write(tx);

    end

  endtask

endclass