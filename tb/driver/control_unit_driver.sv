class control_unit_driver extends uvm_driver #(ctrl_seq_item);

  `uvm_component_utils(control_unit_driver)

  virtual control_unit_if vif;

  function new(string name = "control_unit_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db #(virtual control_unit_if)::get(this, "", "vif", vif))
      `uvm_fatal("CTRL_DRV", "Failed to get VIF")
  endfunction

  virtual task run_phase(uvm_phase phase);

    ctrl_seq_item req;

    forever begin

      seq_item_port.get_next_item(req);

      @(posedge vif.clk);

      // Drive inputs
      vif.op       <= req.op;
      vif.Zero     <= req.Zero;
      vif.funct3   <= req.funct3;
      vif.funct7b5 <= req.funct7b5;

      `uvm_info("CTRL_DRV",
        $sformatf("Driven: op=%07b funct3=%0b funct7b5=%0b Zero=%0b",
                  req.op, req.funct3, req.funct7b5, req.Zero),
        UVM_LOW)

      seq_item_port.item_done();

    end

  endtask

endclass