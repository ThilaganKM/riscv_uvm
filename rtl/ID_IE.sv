module ID_IE(
    input logic clk,
    input logic reset,
    input logic flush,

    input logic [31:0] rd1D, rd2D,
    input logic [31:0] PCD,
    input logic [4:0] rs1D, rs2D, rdD,
    input logic [31:0] ImmExtendD, PCPlus4D,
    input logic RegWriteD,
    input logic [1:0] ResultSrcD,
    input logic MemWriteD, JumpD, BranchD, ALUSrcD,

    input logic [1:0] ALUOpD,
    input logic [2:0] funct3D,
    input logic funct7b5D,

    output logic [31:0] rd1E, rd2E,
    output logic [31:0] PCE,
    output logic [4:0] rs1E, rs2E, rdE,
    output logic [31:0] ImmExtendE, PCPlus4E,
    output logic RegWriteE,
    output logic [1:0] ResultSrcE,
    output logic MemWriteE, JumpE, BranchE, ALUSrcE,

    output logic [1:0] ALUOpE,
    output logic [2:0] funct3E,
    output logic funct7b5E
);

always_ff @(posedge clk) begin
    if (reset || flush) begin
        rd1E <= 0;
        rd2E <= 0;
        PCE <= 0;
        rs1E <= 0;
        rs2E <= 0;
        rdE <= 0;
        ImmExtendE <= 0;
        PCPlus4E <= 0;
        RegWriteE <= 0;
        ResultSrcE <= 0;
        MemWriteE <= 0;
        JumpE <= 0;
        BranchE <= 0;
        ALUSrcE <= 0;
        ALUOpE <= 0;
        funct3E <= 0;
        funct7b5E <= 0;
    end else begin
        rd1E <= rd1D;
        rd2E <= rd2D;
        PCE <= PCD;
        rs1E <= rs1D;
        rs2E <= rs2D;
        rdE <= rdD;
        ImmExtendE <= ImmExtendD;
        PCPlus4E <= PCPlus4D;
        RegWriteE <= RegWriteD;
        ResultSrcE <= ResultSrcD;
        MemWriteE <= MemWriteD;
        JumpE <= JumpD;
        BranchE <= BranchD;
        ALUSrcE <= ALUSrcD;
        ALUOpE <= ALUOpD;
        funct3E <= funct3D;
        funct7b5E <= funct7b5D;
    end
end

endmodule