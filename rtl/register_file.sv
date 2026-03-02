module register_file (

    input  logic        clk,
    input  logic        reset,

    input  logic [4:0]  A1,
    input  logic [4:0]  A2,
    input  logic [4:0]  A3,

    input  logic [31:0] wd3,
    input  logic        we,

    output logic [31:0] rd1,
    output logic [31:0] rd2
);

    logic [31:0] rf [0:31];
    integer i;

    //----------------------------------------------
    // Sequential Write
    //----------------------------------------------

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1)
                rf[i] <= 32'd0;
        end
        else if (we && (A3 != 0)) begin
            rf[A3] <= wd3;
        end
    end

    //----------------------------------------------
    // Read with Write-Through Bypass
    //----------------------------------------------

    assign rd1 = (A1 == 0) ? 32'b0 :
                 (we && (A1 == A3) && (A3 != 0)) ? wd3 :
                 rf[A1];

    assign rd2 = (A2 == 0) ? 32'b0 :
                 (we && (A2 == A3) && (A3 != 0)) ? wd3 :
                 rf[A2];

`ifdef ASSERT_ON
    // x0 must never change
    assert property (@(posedge clk) rf[0] == 32'd0)
        else $error("x0 register corrupted!");
`endif
endmodule