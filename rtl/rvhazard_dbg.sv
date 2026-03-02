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
        if (core.rdE == 4) begin
            $display("=== REAL EX STAGE FOR SUB ===");
            $display("ALUOpE     = %0d", core.ALUOpE);
            $display("funct3E    = %0d", core.funct3E);
            $display("funct7b5E  = %0d", core.funct7b5E);
            $display("ALUControl = %0d", core.ALUControlE);
            $display("SrcAE      = %0d", core.SrcAE);
            $display("SrcBE      = %0d", core.SrcBE);
            $display("=============================");
        end
    end

endmodule