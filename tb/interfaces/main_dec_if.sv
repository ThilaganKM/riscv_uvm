interface main_dec_if(input logic clk);

  // Input to DUT
  logic [6:0] op;

  // Outputs from DUT
  logic RegWrite;
  logic [1:0] ResultSrc;
  logic [1:0] ALUOp;
  logic [1:0] ImmSrc;
  logic ALUSrc;
  logic MemWrite;
  logic Jump;
  logic Branch;

  //--------------------------------------------------
  // DRIVER
  //--------------------------------------------------

  modport DRIVER (
    output op,

    input  RegWrite,
    input  ResultSrc,
    input  ALUOp,
    input  ImmSrc,
    input  ALUSrc,
    input  MemWrite,
    input  Jump,
    input  Branch,
    input  clk
  );

  //--------------------------------------------------
  // MONITOR
  //--------------------------------------------------

  modport MONITOR (
    input op,
    input RegWrite,
    input ResultSrc,
    input ALUOp,
    input ImmSrc,
    input ALUSrc,
    input MemWrite,
    input Jump,
    input Branch,
    input clk
  );

endinterface