class haz_driver extends uvm_driver #(haz_seq_item);

  `uvm_component_utils(haz_driver)

  virtual haz_if vif;

  function new(string name = "haz_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db #(virtual haz_if)::get(this, "", "vif", vif))
      `uvm_fatal("HAZ_DRV", "Failed to get VIF")
  endfunction

  virtual task run_phase(uvm_phase phase);

    haz_seq_item req;

    forever begin

      seq_item_port.get_next_item(req);

      @(posedge vif.clk);

      // Drive DUT inputs
      vif.Rs1D        <= req.Rs1D;
      vif.Rs2D        <= req.Rs2D;
      vif.RdE         <= req.RdE;
      vif.PCSrcE      <= req.PCSrcE;
      vif.ResultSrcE0 <= req.ResultSrcE0;

      `uvm_info("HAZ_DRV",
        $sformatf("Driven: Rs1D=%0d Rs2D=%0d RdE=%0d PCSrcE=%0b ResultSrcE0=%0b",
                  req.Rs1D, req.Rs2D, req.RdE,
                  req.PCSrcE, req.ResultSrcE0),
        UVM_LOW)

      seq_item_port.item_done();

    end

  endtask

endclass