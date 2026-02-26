interface alu_if(input logic clk);

    logic [31:0] SrcA;
    logic [31:0] SrcB;
    logic [2:0]  ALUControl;

    logic [31:0] ALUResult;
    logic        Zero;

    // Optional clocking block (recommended for clean timing)
    clocking drv_cb @(posedge clk);
        output SrcA, SrcB, ALUControl;
        input  ALUResult, Zero;
    endclocking

    clocking mon_cb @(posedge clk);
        input SrcA, SrcB, ALUControl;
        input ALUResult, Zero;
    endclocking

endinterface