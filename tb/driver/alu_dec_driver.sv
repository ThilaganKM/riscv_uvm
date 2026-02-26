class alu_dec_driver extends uvm_driver #(alu_dec_seq_item);

  `uvm_component_utils(alu_dec_driver)

  virtual alu_dec_if vif;

  function new(string name = "alu_dec_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db #(virtual alu_dec_if)::get(this, "", "vif", vif))
      `uvm_fatal("DRV", "Failed to get VIF")
  endfunction

  virtual task run_phase(uvm_phase phase);

    alu_dec_seq_item req;

    forever begin

      seq_item_port.get_next_item(req);

      @(posedge vif.clk);

      vif.opb5      <= req.opb5;
      vif.funct3    <= req.funct3;
      vif.funct7b5  <= req.funct7b5;
      vif.ALUOp     <= req.ALUOp;

      `uvm_info("ALU_DEC_DRV",
        $sformatf("Driven: opb5=%0b funct3=%0b funct7b5=%0b ALUOp=%0b",
                  req.opb5, req.funct3, req.funct7b5, req.ALUOp),
        UVM_LOW)

      seq_item_port.item_done();

    end

  endtask

endclass