class data_mem_agent extends uvm_agent;

  `uvm_component_utils(data_mem_agent)

  data_mem_driver drv;
  data_mem_monitor mon;
  data_mem_sequencer seqr;

  virtual data_mem_if vif;

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    if(!uvm_config_db#(virtual data_mem_if)::get(this,"","vif",vif))
      `uvm_fatal("DMEM_AGENT","No VIF")

    drv  = data_mem_driver::type_id::create("drv",this);
    mon  = data_mem_monitor::type_id::create("mon",this);
    seqr = data_mem_sequencer::type_id::create("seqr",this);

    uvm_config_db#(virtual data_mem_if)::set(this,"drv","vif",vif);
    uvm_config_db#(virtual data_mem_if)::set(this,"mon","vif",vif);
  endfunction

  function void connect_phase(uvm_phase phase);
    drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction

endclass