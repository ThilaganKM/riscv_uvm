module rvhazard_dbg(
    input  logic clk,
    input  logic reset,
    pipeline_if pipe_if
);

    rvhazard core(
        .clk(clk),
        .reset(reset),
        .vif(pipe_if)
    );

    assign pipe_if.commit_valid = core.RegWriteW;
    assign pipe_if.commit_rd    = core.rdW;
    assign pipe_if.commit_data  = core.ResultW;
    assign pipe_if.commit_pc    = core.PCPlus4W - 32'd4;

endmodule