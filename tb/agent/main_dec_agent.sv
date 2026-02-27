class main_dec_agent extends uvm_agent;

  `uvm_component_utils(main_dec_agent)

  main_dec_driver     drv;
  main_dec_monitor    mon;
  main_dec_sequencer  seqr;

  virtual main_dec_if vif;

  function new(string name = "main_dec_agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db #(virtual main_dec_if)::get(this, "", "vif", vif))
      `uvm_fatal("MAIN_DEC_AGENT", "Failed to get VIF")

    seqr = main_dec_sequencer::type_id::create("seqr", this);
    drv  = main_dec_driver::type_id::create("drv", this);
    mon  = main_dec_monitor::type_id::create("mon", this);

    // Pass VIF down
    uvm_config_db #(virtual main_dec_if)::set(this, "drv", "vif", vif);
    uvm_config_db #(virtual main_dec_if)::set(this, "mon", "vif", vif);

  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    drv.seq_item_port.connect(seqr.seq_item_export);

  endfunction

endclass