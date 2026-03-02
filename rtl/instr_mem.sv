`timescale 1ns / 1ps

module instr_mem(
    input  logic [31:0] A,
    output logic [31:0] RD,
    input  logic [31:0] mem [0:255]   // memory from testbench
);

    assign RD = mem[A[31:2]];

endmodule