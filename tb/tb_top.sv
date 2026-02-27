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

    pc_if  pcif(clk);
    rf_if  rfif(clk);
    alu_if aluif(clk);     // ✅ ADD ALU INTERFACE
    alu_dec_if alu_dec_if_inst(clk);
    fwd_if fwd_if_inst(clk);
    haz_if haz_if_inst(clk);
    main_dec_if main_dec_if_inst(clk);
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

    register_file rf_dut (
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

    ALU alu_dut (              // ✅ ADD ALU DUT
        .SrcA       (aluif.SrcA),
        .SrcB       (aluif.SrcB),
        .ALUControl (aluif.ALUControl),
        .ALUResult  (aluif.ALUResult),
        .Zero       (aluif.Zero)
    );

    Alu_decoder alu_dec_dut (
        .opb5       (alu_dec_if_inst.opb5),
        .funct3     (alu_dec_if_inst.funct3),
        .funct7b5   (alu_dec_if_inst.funct7b5),
        .ALUOp      (alu_dec_if_inst.ALUOp),
        .ALUControl (alu_dec_if_inst.ALUControl)
    );

    forwarding_unit fwd_dut (
    .Rs1E(fwd_if_inst.Rs1E),
    .Rs2E(fwd_if_inst.Rs2E),
    .RdM(fwd_if_inst.RdM),
    .RdW(fwd_if_inst.RdW),
    .RegWriteM(fwd_if_inst.RegWriteM),
    .RegWriteW(fwd_if_inst.RegWriteW),
    .ForwardAE(fwd_if_inst.ForwardAE),
    .ForwardBE(fwd_if_inst.ForwardBE)
    );

    HazardUnit haz_dut (
    .Rs1D        (haz_if_inst.Rs1D),
    .Rs2D        (haz_if_inst.Rs2D),
    .RdE         (haz_if_inst.RdE),
    .PCSrcE      (haz_if_inst.PCSrcE),
    .ResultSrcE0 (haz_if_inst.ResultSrcE0),
    .StallF      (haz_if_inst.StallF),
    .StallD      (haz_if_inst.StallD),
    .FlushE      (haz_if_inst.FlushE),
    .FlushD      (haz_if_inst.FlushD)
    );
    main_decoder main_dec_dut (
    .op(main_dec_if_inst.op),
    .RegWrite(main_dec_if_inst.RegWrite),
    .ResultSrc(main_dec_if_inst.ResultSrc),
    .ALUOp(main_dec_if_inst.ALUOp),
    .ImmSrc(main_dec_if_inst.ImmSrc),
    .ALUSrc(main_dec_if_inst.ALUSrc),
    .MemWrite(main_dec_if_inst.MemWrite),
    .Jump(main_dec_if_inst.Jump),
    .Branch(main_dec_if_inst.Branch)
    );

    //--------------------------------------------------
    // UVM Configuration
    //--------------------------------------------------

    initial begin

        clk = 0;

        //------------------------------------------
        // Pass Interfaces
        //------------------------------------------

        uvm_config_db #(virtual pc_if )::set(null, "*", "vif", pcif);
        uvm_config_db #(virtual rf_if )::set(null, "*", "vif", rfif);
        uvm_config_db #(virtual alu_if)::set(null, "*", "vif", aluif); // ✅ ADD
        uvm_config_db #(virtual alu_dec_if)::set(null, "*", "vif", alu_dec_if_inst);
        uvm_config_db #(virtual fwd_if)::set(null, "*", "vif", fwd_if_inst);
        uvm_config_db #(virtual haz_if)::set(null, "*", "vif", haz_if_inst);
        uvm_config_db #(virtual main_dec_if)::set(null, "*", "vif", main_dec_if_inst);
        //------------------------------------------
        // Run Test
        //------------------------------------------

        run_test();

    end

endmodule