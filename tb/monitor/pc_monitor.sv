import uvm_pkg::*;
import riscv_txn_pkg::*;
class pc_monitor extends uvm_monitor;

    `uvm_component_utils(pc_monitor)

    virtual pc_if.MONITOR vif;

    uvm_analysis_port #(pc_seq_item) ap;

    function new(string name = "pc_monitor", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db #(virtual pc_if.MONITOR)::get(this, "", "vif", vif))
            `uvm_fatal("MON", "Virtual interface not set")

        ap = new("ap", this);
    endfunction

    virtual task run_phase(uvm_phase phase);

        pc_seq_item pkt;

        forever begin

            @(posedge vif.clk);

            pkt = pc_seq_item::type_id::create("pkt");

            pkt.reset  = vif.reset;
            pkt.en     = vif.en;
            pkt.PCNext = vif.PCNext;
            pkt.PC     = vif.PC;


            ap.write(pkt);

        end

    endtask

endclass