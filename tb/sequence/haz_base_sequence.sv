class haz_base_sequence extends uvm_sequence #(haz_seq_item);

  `uvm_object_utils(haz_base_sequence)

  function new(string name = "haz_base_sequence");
    super.new(name);
  endfunction

  virtual task body();

    haz_seq_item req;

    repeat (200) begin   // slightly larger since hazard space is small

      req = haz_seq_item::type_id::create("req");

      start_item(req);
      assert(req.randomize());
      finish_item(req);

    end

  endtask

endclass