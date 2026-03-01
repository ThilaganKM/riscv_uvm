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

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            commit_valid <= 0;
            commit_pc    <= 0;
            commit_rd    <= 0;
            commit_data  <= 0;
        end
        else begin
            commit_valid <= core.RegWriteW;

            if (core.RegWriteW) begin
                commit_rd   <= core.rdW;
                commit_data <= core.ResultW;
                commit_pc   <= core.PCPlus4W - 32'd4;
            end
        end
    end

endmodule