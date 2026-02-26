class alu_driver extends uvm_driver #(alu_seq_item);

  `uvm_component_utils(alu_driver)

  virtual alu_if vif;

  function new(string name = "alu_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db #(virtual alu_if)::get(this, "", "vif", vif))
      `uvm_fatal("DRV", "Failed to get VIF")
  endfunction

  virtual task run_phase(uvm_phase phase);

    alu_seq_item req;

    forever begin

      seq_item_port.get_next_item(req);

      @(posedge vif.clk);

      vif.SrcA       <= req.SrcA;
      vif.SrcB       <= req.SrcB;
      vif.ALUControl <= req.ALUControl;

      `uvm_info("ALU_DRV",
        $sformatf("Driven: SrcA=%0h SrcB=%0h ALUControl=%0b",
                  req.SrcA, req.SrcB, req.ALUControl),
        UVM_LOW)

      seq_item_port.item_done();

    end

  endtask

endclass