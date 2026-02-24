import uvm_pkg::*;
`include "uvm_macros.svh"
interface pc_if(input logic clk);

    logic reset;
    logic en;
    logic [31:0] PCNext;
    logic [31:0] PC;

    modport DRIVER (
        output reset,
        output en,
        output PCNext,
        input  PC
    );

    modport MONITOR (
        input reset,
        input en,
        input PCNext,
        input PC,
        input clk
    );

endinterface