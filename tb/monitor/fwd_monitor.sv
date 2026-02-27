class fwd_monitor extends uvm_monitor;

  `uvm_component_utils(fwd_monitor)

  virtual fwd_if vif;

  uvm_analysis_port #(fwd_seq_item) ap;

  function new(string name = "fwd_monitor", uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db #(virtual fwd_if)::get(this, "", "vif", vif))
      `uvm_fatal("FWD_MON", "Failed to get VIF")
  endfunction

  virtual task run_phase(uvm_phase phase);

    fwd_seq_item tx;

    forever begin

      @(posedge vif.clk);
      #1;  // stabilization

      tx = fwd_seq_item::type_id::create("tx");

      // Capture inputs
      tx.Rs1E      = vif.Rs1E;
      tx.Rs2E      = vif.Rs2E;
      tx.RdM       = vif.RdM;
      tx.RdW       = vif.RdW;
      tx.RegWriteM = vif.RegWriteM;
      tx.RegWriteW = vif.RegWriteW;

      // Capture outputs
      tx.ForwardAE = vif.ForwardAE;
      tx.ForwardBE = vif.ForwardBE;

      `uvm_info("FWD_MON",
        $sformatf("Observed: Rs1E=%0d Rs2E=%0d RdM=%0d RdW=%0d RW_M=%0b RW_W=%0b → FwdA=%0b FwdB=%0b",
                  tx.Rs1E, tx.Rs2E, tx.RdM, tx.RdW,
                  tx.RegWriteM, tx.RegWriteW,
                  tx.ForwardAE, tx.ForwardBE),
        UVM_LOW)

      ap.write(tx);

    end

  endtask

endclass