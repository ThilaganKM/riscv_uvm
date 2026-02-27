interface data_mem_if(input logic clk);

  logic we;
  logic [31:0] A;
  logic [31:0] WD;
  logic [31:0] ReadData;

  modport DRIVER (
    output we,
    output A,
    output WD,
    input  ReadData,
    input  clk
  );

  modport MONITOR (
    input we,
    input A,
    input WD,
    input ReadData,
    input clk
  );

endinterface