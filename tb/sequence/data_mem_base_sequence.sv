class data_mem_base_sequence extends uvm_sequence #(dmem_seq_item);

  `uvm_object_utils(data_mem_base_sequence)

  function new(string name="data_mem_base_sequence");
    super.new(name);
  endfunction

  task body();
    dmem_seq_item req;

    repeat(150) begin
      req = dmem_seq_item::type_id::create("req");
      start_item(req);
      assert(req.randomize());
      finish_item(req);
    end
  endtask

endclass