`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/07/2025 03:13:45 PM
// Design Name: 32-bit Instruction Memory
// Module Name: instr_mem
// Project Name: 5-Stage Pipelined RISC-V Processor
// Target Devices: FPGA / ASIC
// Tool Versions: Any SystemVerilog compatible
// Description: 
//      This module implements the instruction memory (IM) used in the RISC-V processor.
//      It stores instructions in a memory array and outputs the instruction at the 
//      given address. Instructions are preloaded from a memory initialization file.
// 
// Dependencies: "inst.mem" file containing program instructions in hexadecimal format
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//      - Memory is word-addressable (32-bit per entry).
//      - Access uses A[31:2] to account for word-aligned addresses.
//      - Used in the IF stage to fetch instructions.
//////////////////////////////////////////////////////////////////////////////////

module instr_mem(
    input  logic [31:0] A,   // Address input (byte address)
    output logic [31:0] RD   // Instruction output
);

    // Instruction memory array (64 words of 32 bits)
    logic [31:0] mem [63:0];

    initial begin
        $display("Current working dir unknown but loading inst.mem");
    end

    // Initialize memory from external file "inst.mem"
    initial begin
        $display("=== LOADING INSTRUCTION MEMORY ===");
        $readmemh("inst.mem", mem);
        for (int i=0; i<8; i++)
            $display("mem[%0d] = %h", i, mem[i]);
    end

    // Word-aligned read (divide address by 4)
    assign RD = mem[A[31:2]];

endmodule
