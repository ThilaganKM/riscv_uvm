interface alu_dec_if(input logic clk);

  logic        opb5;
  logic [2:0]  funct3;
  logic        funct7b5;
  logic [1:0]  ALUOp;

  logic [2:0]  ALUControl;

  //--------------------------------------------------
  // DRIVER
  //--------------------------------------------------

  modport DRIVER (
    output opb5,
    output funct3,
    output funct7b5,
    output ALUOp,

    input  ALUControl,
    input  clk
  );

  //--------------------------------------------------
  // MONITOR
  //--------------------------------------------------

  modport MONITOR (
    input opb5,
    input funct3,
    input funct7b5,
    input ALUOp,

    input ALUControl,
    input clk
  );

endinterface