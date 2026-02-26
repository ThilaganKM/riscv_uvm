interface rf_if(input logic clk);

  logic reset;

  logic [4:0]  A1;
  logic [4:0]  A2;
  logic [4:0]  A3;
  logic [31:0] wd3;
  logic        we;

  logic [31:0] rd1;
  logic [31:0] rd2;

  //--------------------------------------------------
  // DRIVER
  //--------------------------------------------------

  modport DRIVER (
    output reset,
    output A1,
    output A2,
    output A3,
    output wd3,
    output we,

    input rd1,
    input rd2,
    input clk
  );

  //--------------------------------------------------
  // MONITOR
  //--------------------------------------------------

  modport MONITOR (
    input reset,
    input A1,
    input A2,
    input A3,
    input wd3,
    input we,

    input rd1,
    input rd2,
    input clk
  );

endinterface