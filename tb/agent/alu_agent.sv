class alu_agent extends uvm_agent;

  `uvm_component_utils(alu_agent)

  alu_driver    drv;
  alu_monitor   mon;
  alu_sequencer seqr;   // ✅ UPDATED

  virtual alu_if vif;

  function new(string name = "alu_agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db #(virtual alu_if)::get(this, "", "vif", vif))
      `uvm_fatal("AGENT", "Failed to get VIF")

    seqr = alu_sequencer::type_id::create("seqr", this);
    drv  = alu_driver::type_id::create("drv", this);
    mon  = alu_monitor::type_id::create("mon", this);

    uvm_config_db #(virtual alu_if)::set(this, "drv", "vif", vif);
    uvm_config_db #(virtual alu_if)::set(this, "mon", "vif", vif);

  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    drv.seq_item_port.connect(seqr.seq_item_export);

  endfunction

endclass