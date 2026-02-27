class control_unit_monitor extends uvm_monitor;

  `uvm_component_utils(control_unit_monitor)

  virtual control_unit_if vif;

  uvm_analysis_port #(ctrl_seq_item) ap;

  function new(string name = "control_unit_monitor", uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db #(virtual control_unit_if)::get(this, "", "vif", vif))
      `uvm_fatal("CTRL_MON", "Failed to get VIF")
  endfunction

  virtual task run_phase(uvm_phase phase);

    ctrl_seq_item tx;

    forever begin

      @(posedge vif.clk);
      #1;  // stabilization delay

      tx = ctrl_seq_item::type_id::create("tx");

      // Capture inputs
      tx.op       = vif.op;
      tx.Zero     = vif.Zero;
      tx.funct3   = vif.funct3;
      tx.funct7b5 = vif.funct7b5;

      // Capture outputs
      tx.Branch     = vif.Branch;
      tx.Jump       = vif.Jump;
      tx.ResultSrc  = vif.ResultSrc;
      tx.MemWrite   = vif.MemWrite;
      tx.ImmSrc     = vif.ImmSrc;
      tx.RegWrite   = vif.RegWrite;
      tx.ALUSrc     = vif.ALUSrc;
      tx.ALUControl = vif.ALUControl;

      `uvm_info("CTRL_MON",
        $sformatf("Observed: op=%07b funct3=%0b funct7b5=%0b | RW=%0b MemW=%0b Branch=%0b Jump=%0b ALUSrc=%0b ImmSrc=%0b ResultSrc=%0b ALUCtrl=%0b",
                  tx.op,
                  tx.funct3,
                  tx.funct7b5,
                  tx.RegWrite,
                  tx.MemWrite,
                  tx.Branch,
                  tx.Jump,
                  tx.ALUSrc,
                  tx.ImmSrc,
                  tx.ResultSrc,
                  tx.ALUControl),
        UVM_LOW)

      ap.write(tx);

    end

  endtask

endclass