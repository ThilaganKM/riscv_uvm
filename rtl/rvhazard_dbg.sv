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
            $display("SUB DEBUG: PC=%h SrcA=%0d SrcB=%0d ALUControl=%0d Result=%0d",
                    commit_pc,
                    core.SrcAE,
                    core.SrcBE,
                    core.ALUControlE,
                    core.ResultW);
        end
    end

endmodule