interface alu_if(input logic clk);

  logic [31:0] SrcA;
  logic [31:0] SrcB;
  logic [2:0]  ALUControl;

  logic [31:0] ALUResult;
  logic        Zero;

  //--------------------------------------------------
  // DRIVER
  //--------------------------------------------------

  modport DRIVER (
    output SrcA,
    output SrcB,
    output ALUControl,

    input  ALUResult,
    input  Zero,
    input  clk
  );

  //--------------------------------------------------
  // MONITOR
  //--------------------------------------------------

  modport MONITOR (
    input SrcA,
    input SrcB,
    input ALUControl,

    input ALUResult,
    input Zero,
    input clk
  );

endinterface