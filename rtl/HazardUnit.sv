`timescale 1ns / 1ps

module HazardUnit(
    input  logic [4:0] Rs1D,
    input  logic [4:0] Rs2D,
    input  logic [4:0] RdE,
    input  logic       PCSrcE,
    input  logic       ResultSrcE0,

    output logic StallF,
    output logic StallD,
    output logic FlushE,
    output logic FlushD
);

logic lwStall;

//--------------------------------------------------
// Load-Use Hazard Detection
//--------------------------------------------------

assign lwStall = ResultSrcE0 &&
                 ((Rs1D == RdE) || (Rs2D == RdE)) &&
                 (RdE != 0);

assign FlushE = lwStall | PCSrcE;
assign FlushD = PCSrcE;

assign StallF = lwStall;
assign StallD = lwStall;


//--------------------------------------------------
// Assertions (Combinational safe)
//--------------------------------------------------

`ifdef ASSERT_ON
    always_comb begin
        if (ResultSrcE0 &&
            ((RdE == Rs1D) || (RdE == Rs2D)) &&
            (RdE != 0))
        begin
            assert (StallF && StallD && FlushE)
            else $error("Load-use hazard not handled correctly!");
        end
    end
`endif


//--------------------------------------------------
// Functional Coverage
//--------------------------------------------------

`ifdef COVERAGE_ON

covergroup hazard_cg;
    option.per_instance = 1;

    coverpoint lwStall {
        bins load_use = {1};
    }

    coverpoint PCSrcE {
        bins branch_taken = {1};
    }
endgroup

hazard_cg hz_cov;

initial begin
    hz_cov = new();
end

always_comb begin
    hz_cov.sample();
end

`endif

endmodule