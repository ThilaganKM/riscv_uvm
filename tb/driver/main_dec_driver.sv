class main_dec_driver extends uvm_driver #(main_dec_seq_item);

  `uvm_component_utils(main_dec_driver)

  virtual main_dec_if vif;

  function new(string name = "main_dec_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db #(virtual main_dec_if)::get(this, "", "vif", vif))
      `uvm_fatal("MAIN_DEC_DRV", "Failed to get VIF")
  endfunction

  virtual task run_phase(uvm_phase phase);

    main_dec_seq_item req;

    forever begin

      seq_item_port.get_next_item(req);

      @(posedge vif.clk);

      vif.op <= req.op;

      `uvm_info("MAIN_DEC_DRV",
        $sformatf("Driven: op = %07b", req.op),
        UVM_LOW)

      seq_item_port.item_done();

    end

  endtask

endclass