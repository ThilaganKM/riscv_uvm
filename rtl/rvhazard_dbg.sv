module rvhazard_dbg(
    input  logic clk,
    input  logic reset,

    // Commit interface (for scoreboard)
    output logic        commit_valid,
    output logic [31:0] commit_pc,
    output logic [4:0]  commit_rd,
    output logic [31:0] commit_data
);

    // Instantiate original core
    rvhazard core(
        .clk(clk),
        .reset(reset)
    );

    //------------------------------------------------------
    // Hierarchical taps (legal in verification wrapper)
    //------------------------------------------------------

    assign commit_valid = core.RegWriteW;
    assign commit_rd    = core.rdW;
    assign commit_data  = core.ResultW;
    assign commit_pc    = core.PCPlus4W - 4;

endmodule