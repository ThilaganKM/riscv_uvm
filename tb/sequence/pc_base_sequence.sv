virtual task body();

    pc_seq_item pkt;

    //------------------------------------------
    // Apply RESET ONCE
    //------------------------------------------

    pkt = pc_seq_item::type_id::create("pkt");

    start_item(pkt);
    pkt.reset  = 1;
    pkt.en     = 0;
    pkt.PCNext = 0;
    finish_item(pkt);

    //------------------------------------------
    // Normal Operation
    //------------------------------------------

    repeat (20) begin

        pkt = pc_seq_item::type_id::create("pkt");

        start_item(pkt);

        if (!pkt.randomize() with {
            reset == 0;   // ✅ NEVER random reset
            en    == 1;   // ✅ Always update PC
        })
            `uvm_error("SEQ", "Randomization failed")

        finish_item(pkt);

    end

endtask