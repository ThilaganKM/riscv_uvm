class alu_base_sequence extends uvm_sequence #(alu_seq_item);

  `uvm_object_utils(alu_base_sequence)

  function new(string name = "alu_base_sequence");
    super.new(name);
  endfunction

  virtual task body();

    alu_seq_item req;

    repeat (100) begin   // simple traffic burst (tune later)

      req = alu_seq_item::type_id::create("req");

      start_item(req);
      assert(req.randomize());
      finish_item(req);

    end

  endtask

endclass