import uvm_pkg::*;
import pc_tb_pkg::*;

module tb_top;

    //--------------------------------------------------
    // Clock
    //--------------------------------------------------

    logic clk;

    always #5 clk = ~clk;

    //--------------------------------------------------
    // Interfaces
    //--------------------------------------------------

    pc_if pcif(clk);
    rf_if rfif(clk);      // ✅ ADD RF INTERFACE

    //--------------------------------------------------
    // DUTs
    //--------------------------------------------------

    program_counter pc_dut (
        .clk    (clk),
        .reset  (pcif.reset),
        .en     (pcif.en),
        .PCNext (pcif.PCNext),
        .PC     (pcif.PC)
    );

    register_file rf_dut (   // ✅ ADD REGISTER FILE
        .clk   (clk),
        .reset (rfif.reset),

        .A1  (rfif.A1),
        .A2  (rfif.A2),
        .A3  (rfif.A3),

        .wd3 (rfif.wd3),
        .we  (rfif.we),

        .rd1 (rfif.rd1),
        .rd2 (rfif.rd2)
    );

    //--------------------------------------------------
    // UVM Configuration
    //--------------------------------------------------

    initial begin

        clk = 0;
        //------------------------------------------
        // RESET SEQUENCE ✅ CRITICAL
        //------------------------------------------

        rfif.reset = 1;     // Assert reset
        pcif.reset = 1;     // (optional but good practice)

        #20;

        rfif.reset = 0;     // Deassert reset
        pcif.reset = 0;


        //------------------------------------------
        // Pass Interfaces
        //------------------------------------------

        uvm_config_db #(virtual pc_if)::set(null, "*", "vif", pcif);
        uvm_config_db #(virtual rf_if)::set(null, "*", "vif", rfif);

        //------------------------------------------
        // Run Test
        //------------------------------------------

        run_test();

    end

endmodule