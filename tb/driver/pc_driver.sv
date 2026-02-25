class pc_driver extends uvm_driver #(pc_txn);

    `uvm_component_utils(pc_driver)

    virtual pc_if.DRIVER vif;

    function new(string name = "pc_driver", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db #(virtual pc_if.DRIVER)::get(this, "", "vif", vif))
            `uvm_fatal("DRV", "Virtual interface not set")
    endfunction

    virtual task run_phase(uvm_phase phase);

        pc_txn pkt;

        forever begin

            seq_item_port.get_next_item(pkt);

            @(posedge vif.clk);

            vif.reset  <= pkt.reset;
            vif.en     <= pkt.en;
            vif.PCNext <= pkt.PCNext;

            seq_item_port.item_done();

        end

    endtask

endclass