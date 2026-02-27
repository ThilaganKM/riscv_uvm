class main_dec_base_sequence extends uvm_sequence #(main_dec_seq_item);

  `uvm_object_utils(main_dec_base_sequence)

  function new(string name = "main_dec_base_sequence");
    super.new(name);
  endfunction

  virtual task body();

    main_dec_seq_item req;

    // Enough iterations to cover all opcodes multiple times
    repeat (100) begin

      req = main_dec_seq_item::type_id::create("req");

      start_item(req);
      assert(req.randomize());
      finish_item(req);

    end

  endtask

endclass