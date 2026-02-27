class haz_agent extends uvm_agent;

  `uvm_component_utils(haz_agent)

  haz_driver    drv;
  haz_monitor   mon;
  haz_sequencer seqr;

  virtual haz_if vif;

  function new(string name = "haz_agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db #(virtual haz_if)::get(this, "", "vif", vif))
      `uvm_fatal("HAZ_AGENT", "Failed to get VIF")

    seqr = haz_sequencer::type_id::create("seqr", this);
    drv  = haz_driver::type_id::create("drv", this);
    mon  = haz_monitor::type_id::create("mon", this);

    uvm_config_db #(virtual haz_if)::set(this, "drv", "vif", vif);
    uvm_config_db #(virtual haz_if)::set(this, "mon", "vif", vif);

  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    drv.seq_item_port.connect(seqr.seq_item_export);

  endfunction

endclass