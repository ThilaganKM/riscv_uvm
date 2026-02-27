class control_unit_base_sequence extends uvm_sequence #(ctrl_seq_item);

  `uvm_object_utils(control_unit_base_sequence)

  function new(string name = "control_unit_base_sequence");
    super.new(name);
  endfunction

  virtual task body();

    ctrl_seq_item req;

    repeat (150) begin  // Slightly higher to stress funct combinations

      req = ctrl_seq_item::type_id::create("req");

      start_item(req);
      assert(req.randomize());
      finish_item(req);

    end

  endtask

endclass