class fwd_agent extends uvm_agent;

  `uvm_component_utils(fwd_agent)

  fwd_driver     drv;
  fwd_monitor    mon;
  fwd_sequencer  seqr;

  virtual fwd_if vif;

  function new(string name = "fwd_agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db #(virtual fwd_if)::get(this, "", "vif", vif))
      `uvm_fatal("FWD_AGENT", "Failed to get VIF")

    seqr = fwd_sequencer::type_id::create("seqr", this);
    drv  = fwd_driver::type_id::create("drv", this);
    mon  = fwd_monitor::type_id::create("mon", this);

    // Pass VIF down
    uvm_config_db #(virtual fwd_if)::set(this, "drv", "vif", vif);
    uvm_config_db #(virtual fwd_if)::set(this, "mon", "vif", vif);

  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    drv.seq_item_port.connect(seqr.seq_item_export);

  endfunction

endclass