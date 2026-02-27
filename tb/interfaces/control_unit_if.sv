interface control_unit_if(input logic clk);

  // Inputs to DUT
  logic [6:0] op;
  logic       Zero;
  logic [2:0] funct3;
  logic       funct7b5;

  // Outputs from DUT
  logic       Branch;
  logic       Jump;
  logic [1:0] ResultSrc;
  logic       MemWrite;
  logic [1:0] ImmSrc;
  logic       RegWrite;
  logic       ALUSrc;
  logic [2:0] ALUControl;

  //--------------------------------------------------
  // DRIVER
  //--------------------------------------------------

  modport DRIVER (
    output op,
    output Zero,
    output funct3,
    output funct7b5,

    input  Branch,
    input  Jump,
    input  ResultSrc,
    input  MemWrite,
    input  ImmSrc,
    input  RegWrite,
    input  ALUSrc,
    input  ALUControl,
    input  clk
  );

  //--------------------------------------------------
  // MONITOR
  //--------------------------------------------------

  modport MONITOR (
    input op,
    input Zero,
    input funct3,
    input funct7b5,

    input Branch,
    input Jump,
    input ResultSrc,
    input MemWrite,
    input ImmSrc,
    input RegWrite,
    input ALUSrc,
    input ALUControl,
    input clk
  );

endinterface