class pc_base_sequence extends uvm_sequence #(pc_seq_item);

    `uvm_object_utils(pc_base_sequence)

    function new(string name = "pc_base_sequence");
        super.new(name);
    endfunction

    virtual task body();

        pc_seq_item pkt;

        //------------------------------------------
        // RESET PHASE
        //------------------------------------------

        pkt = pc_seq_item::type_id::create("pkt");

        start_item(pkt);
        pkt.reset  = 1;
        pkt.en     = 0;
        pkt.PCNext = 0;
        finish_item(pkt);

        //------------------------------------------
        // NORMAL OPERATION
        //------------------------------------------

        repeat (20) begin

            pkt = pc_seq_item::type_id::create("pkt");

            start_item(pkt);

            if (!pkt.randomize() with {
                reset == 0;
                en    == 1;
            })
                `uvm_error("SEQ", "Randomization failed")

            finish_item(pkt);

        end

    endtask

endclass