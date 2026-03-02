`timescale 1ns / 1ps

module forwarding_unit(
    input  logic [4:0] Rs1E, Rs2E,
    input  logic [4:0] RdM, RdW,
    input  logic       RegWriteM, RegWriteW,
    output logic [1:0] ForwardAE, ForwardBE
);

//--------------------------------------------------
// Forwarding Logic (Combinational)
//--------------------------------------------------

always_comb begin

    // MEM stage has priority over WB
    if ((Rs1E == RdM) && RegWriteM && (Rs1E != 0))
        ForwardAE = 2'b10;
    else if ((Rs1E == RdW) && RegWriteW && (Rs1E != 0))
        ForwardAE = 2'b01;
    else
        ForwardAE = 2'b00;

    if ((Rs2E == RdM) && RegWriteM && (Rs2E != 0))
        ForwardBE = 2'b10;
    else if ((Rs2E == RdW) && RegWriteW && (Rs2E != 0))
        ForwardBE = 2'b01;
    else
        ForwardBE = 2'b00;

end

//--------------------------------------------------
// Assertions (Immediate combinational assertions)
//--------------------------------------------------

`ifdef ASSERT_ON
    always_comb begin
        if (RegWriteM && RegWriteW &&
            (RdM == Rs1E) && (RdW == Rs1E) && (RdM != 0))
            assert (ForwardAE == 2'b10)
            else $error("Forwarding priority error: MEM should override WB");
    end
`endif


//--------------------------------------------------
// Functional Coverage (Combinational sampling)
//--------------------------------------------------

`ifdef COVERAGE_ON

covergroup fwd_cg;
    option.per_instance = 1;

    coverpoint ForwardAE {
        bins no_fwd   = {2'b00};
        bins from_wb  = {2'b01};
        bins from_mem = {2'b10};
    }

    coverpoint ForwardBE {
        bins no_fwd   = {2'b00};
        bins from_wb  = {2'b01};
        bins from_mem = {2'b10};
    }
endgroup

fwd_cg fwd_cov;

initial begin
    fwd_cov = new();
end

always_comb begin
    fwd_cov.sample();
end

`endif

endmodule