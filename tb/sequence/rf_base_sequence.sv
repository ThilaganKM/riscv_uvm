class rf_base_sequence extends uvm_sequence #(rf_seq_item);

  `uvm_object_utils(rf_base_sequence)

  //--------------------------------------------------
  // Constructor
  //--------------------------------------------------

  function new(string name = "rf_base_sequence");
    super.new(name);
  endfunction

  //--------------------------------------------------
  // Body → Stimulus Generation
  //--------------------------------------------------

  virtual task body();

    rf_seq_item pkt;

    repeat (30) begin

      //------------------------------------------
      // Create transaction
      //------------------------------------------

      pkt = rf_seq_item::type_id::create("pkt");

      start_item(pkt);

      //------------------------------------------
      // Randomize stimulus
      //------------------------------------------

      if (!pkt.randomize() with {

        // Encourage meaningful traffic
        we dist {1 := 6, 0 := 4};

      })
        `uvm_error("RF_SEQ", "Randomization failed")

      finish_item(pkt);

    end

  endtask

endclass