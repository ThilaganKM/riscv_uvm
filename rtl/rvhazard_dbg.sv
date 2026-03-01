module rvhazard_dbg(
    input  logic clk,
    input  logic reset,

    output logic        commit_valid,
    output logic [31:0] commit_pc,
    output logic [4:0]  commit_rd,
    output logic [31:0] commit_data
);

    rvhazard core(
        .clk(clk),
        .reset(reset)
    );

    assign commit_valid = core.RegWriteW;
    assign commit_rd    = core.rdW;
    assign commit_data  = core.ResultW;
    assign commit_pc    = core.PCPlus4W - 32'd4;
    always @(posedge clk) begin
        if (core.RegWriteW && core.rdW == 4) begin
            $display("=== SUB COMMIT DEBUG ===");
            $display("WB PC        = %h", commit_pc);
            $display("WB rd        = %0d", core.rdW);
            $display("WB Result    = %0d", core.ResultW);

            $display("EX ALUControl= %0d", core.ALUControlE);
            $display("EX SrcA      = %0d", core.SrcAE);
            $display("EX SrcB      = %0d", core.SrcBE);

            $display("MEM ALUResult= %0d", core.ALUResultM);
            $display("================================");
        end
    end
    always @(posedge clk) begin
        if (core.rdE == 4) begin
            $display("ID/EX STAGE DEBUG:");
            $display("ALUControlD = %0d", core.ALUControlD);
            $display("ALUControlE = %0d", core.ALUControlE);
            $display("funct3      = %0d", core.InstrD[14:12]);
            $display("funct7b5    = %0d", core.InstrD[30]);
        end
    end

endmodule