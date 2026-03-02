module data_mem(
    input  logic        clk,
    input  logic        reset,   // <-- ADD RESET
    input  logic        we,
    input  logic [31:0] A,
    input  logic [31:0] WD,
    output logic [31:0] ReadData
);

    logic [31:0] dm [63:0];

    // Asynchronous read
    assign ReadData = dm[A[31:2]];

    // Single procedural driver
    always_ff @(posedge clk) begin

        if (reset) begin
            for (int i = 0; i < 64; i++)
                dm[i] <= 32'd0;
        end

        else if (we) begin
            dm[A[31:2]] <= WD;
        end

    end

endmodule