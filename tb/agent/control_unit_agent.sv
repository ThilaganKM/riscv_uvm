class control_unit_agent extends uvm_agent;

  `uvm_component_utils(control_unit_agent)

  control_unit_driver     drv;
  control_unit_monitor    mon;
  control_unit_sequencer  seqr;

  virtual control_unit_if vif;

  function new(string name = "control_unit_agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db #(virtual control_unit_if)::get(this, "", "vif", vif))
      `uvm_fatal("CTRL_AGENT", "Failed to get VIF")

    seqr = control_unit_sequencer::type_id::create("seqr", this);
    drv  = control_unit_driver::type_id::create("drv", this);
    mon  = control_unit_monitor::type_id::create("mon", this);

    uvm_config_db #(virtual control_unit_if)::set(this, "drv", "vif", vif);
    uvm_config_db #(virtual control_unit_if)::set(this, "mon", "vif", vif);

  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    drv.seq_item_port.connect(seqr.seq_item_export);

  endfunction

endclass