class fwd_base_sequence extends uvm_sequence #(fwd_seq_item);

  `uvm_object_utils(fwd_base_sequence)

  function new(string name = "fwd_base_sequence");
    super.new(name);
  endfunction

  virtual task body();

    fwd_seq_item req;

    repeat (200) begin   // increase slightly to stress RAW combos

      req = fwd_seq_item::type_id::create("req");

      start_item(req);
      assert(req.randomize());
      finish_item(req);

    end

  endtask

endclass