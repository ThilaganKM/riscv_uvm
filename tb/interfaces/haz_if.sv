interface haz_if(input logic clk);

  //==================================================
  // Inputs to DUT
  //==================================================
  logic [4:0] Rs1D;
  logic [4:0] Rs2D;
  logic [4:0] RdE;
  logic       PCSrcE;
  logic       ResultSrcE0;

  //==================================================
  // Outputs from DUT
  //==================================================
  logic StallF;
  logic StallD;
  logic FlushE;
  logic FlushD;

  //--------------------------------------------------
  // DRIVER
  //--------------------------------------------------
  modport DRIVER (
    output Rs1D,
    output Rs2D,
    output RdE,
    output PCSrcE,
    output ResultSrcE0,

    input  StallF,
    input  StallD,
    input  FlushE,
    input  FlushD,

    input  clk
  );

  //--------------------------------------------------
  // MONITOR
  //--------------------------------------------------
  modport MONITOR (
    input Rs1D,
    input Rs2D,
    input RdE,
    input PCSrcE,
    input ResultSrcE0,

    input StallF,
    input StallD,
    input FlushE,
    input FlushD,

    input clk
  );

endinterface