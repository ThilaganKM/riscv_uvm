interface fwd_if(input logic clk);

  // Inputs to DUT
  logic [4:0] Rs1E, Rs2E;
  logic [4:0] RdM, RdW;
  logic       RegWriteM, RegWriteW;

  // Outputs from DUT
  logic [1:0] ForwardAE, ForwardBE;

  //--------------------------------------------------
  // DRIVER
  //--------------------------------------------------

  modport DRIVER (
    output Rs1E,
    output Rs2E,
    output RdM,
    output RdW,
    output RegWriteM,
    output RegWriteW,

    input  ForwardAE,
    input  ForwardBE,
    input  clk
  );

  //--------------------------------------------------
  // MONITOR
  //--------------------------------------------------

  modport MONITOR (
    input Rs1E,
    input Rs2E,
    input RdM,
    input RdW,
    input RegWriteM,
    input RegWriteW,

    input ForwardAE,
    input ForwardBE,
    input clk
  );

endinterface