class data_mem_monitor extends uvm_monitor;

  `uvm_component_utils(data_mem_monitor)

  virtual data_mem_if vif;
  uvm_analysis_port #(dmem_seq_item) ap;

  function new(string name, uvm_component parent);
    super.new(name,parent);
    ap = new("ap",this);
  endfunction

  function void build_phase(uvm_phase phase);
    if(!uvm_config_db#(virtual data_mem_if)::get(this,"","vif",vif))
      `uvm_fatal("DMEM_MON","No VIF")
  endfunction

  task run_phase(uvm_phase phase);
    dmem_seq_item tx;

    forever begin
      @(posedge vif.clk);
      #1;

      tx = dmem_seq_item::type_id::create("tx");

      tx.we       = vif.we;
      tx.A        = vif.A;
      tx.WD       = vif.WD;
      tx.ReadData = vif.ReadData;

      `uvm_info("DMEM_MON",
        $sformatf("Observed: we=%0b A=%0d WD=%0h RD=%0h",
          tx.we, tx.A[31:2], tx.WD, tx.ReadData),
        UVM_LOW)

      ap.write(tx);
    end
  endtask

endclass