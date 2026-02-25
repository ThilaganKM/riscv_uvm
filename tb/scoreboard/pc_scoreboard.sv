class pc_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(pc_scoreboard)

    uvm_analysis_imp #(pc_seq_item, pc_scoreboard) ap_imp;

    logic [31:0] expected_pc;

    function new(string name = "pc_scoreboard", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        ap_imp = new("ap_imp", this);

        expected_pc = 32'h00000000;
    endfunction

    virtual function void write(pc_seq_item pkt);

        logic [31:0] golden_pc;

        //--------------------------------------------------
        // Golden Reference Model
        //--------------------------------------------------

        if (pkt.reset)
            golden_pc = 32'h00000000;
        else if (pkt.en)
            golden_pc = pkt.PCNext;
        else
            golden_pc = expected_pc;

        //--------------------------------------------------
        // Comparison
        //--------------------------------------------------

        if (pkt.PC !== golden_pc)
            `uvm_error("SB", $sformatf(
                "PC MISMATCH: Expected = %0h, Observed = %0h",
                golden_pc, pkt.PC
            ))

        //--------------------------------------------------
        // Update State
        //--------------------------------------------------

        expected_pc = golden_pc;

    endfunction

endclass