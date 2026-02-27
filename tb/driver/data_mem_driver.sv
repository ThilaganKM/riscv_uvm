class data_mem_driver extends uvm_driver #(dmem_seq_item);

  `uvm_component_utils(data_mem_driver)

  virtual data_mem_if vif;

  function new(string name="data_mem_driver", uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    if(!uvm_config_db#(virtual data_mem_if)::get(this,"","vif",vif))
      `uvm_fatal("DMEM_DRV","No VIF")
  endfunction

  task run_phase(uvm_phase phase);
    dmem_seq_item req;

    forever begin
      seq_item_port.get_next_item(req);

      @(posedge vif.clk);

      vif.we <= req.we;
      vif.A  <= req.A;
      vif.WD <= req.WD;

      `uvm_info("DMEM_DRV",
        $sformatf("Driven: we=%0b A=%0d WD=%0h",
          req.we, req.A[31:2], req.WD),
        UVM_LOW)

      seq_item_port.item_done();
    end
  endtask

endclass