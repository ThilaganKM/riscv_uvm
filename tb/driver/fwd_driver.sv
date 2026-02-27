class fwd_driver extends uvm_driver #(fwd_seq_item);

  `uvm_component_utils(fwd_driver)

  virtual fwd_if vif;

  function new(string name = "fwd_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db #(virtual fwd_if)::get(this, "", "vif", vif))
      `uvm_fatal("FWD_DRV", "Failed to get VIF")
  endfunction

  virtual task run_phase(uvm_phase phase);

    fwd_seq_item req;

    forever begin

      seq_item_port.get_next_item(req);

      @(posedge vif.clk);

      // Drive inputs
      vif.Rs1E      <= req.Rs1E;
      vif.Rs2E      <= req.Rs2E;
      vif.RdM       <= req.RdM;
      vif.RdW       <= req.RdW;
      vif.RegWriteM <= req.RegWriteM;
      vif.RegWriteW <= req.RegWriteW;

      `uvm_info("FWD_DRV",
        $sformatf("Driven: Rs1E=%0d Rs2E=%0d RdM=%0d RdW=%0d RegWriteM=%0b RegWriteW=%0b",
                  req.Rs1E, req.Rs2E, req.RdM, req.RdW,
                  req.RegWriteM, req.RegWriteW),
        UVM_LOW)

      seq_item_port.item_done();

    end

  endtask

endclass