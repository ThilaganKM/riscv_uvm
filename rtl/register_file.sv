module register_file (
    input  logic        clk,
    input  logic [4:0]  A1,
    input  logic [4:0]  A2,
    input  logic [4:0]  A3,
    input  logic [31:0] wd3,
    input  logic        we,
    output logic [31:0] rd1,
    output logic [31:0] rd2
);

    logic [31:0] rf [31:0];

    always_ff @(posedge clk) begin
        if (we && A3 != 0)
            rf[A3] <= wd3;
    end

    assign rd1 = (A1 != 0) ? rf[A1] : 32'b0;
    assign rd2 = (A2 != 0) ? rf[A2] : 32'b0;

endmodule