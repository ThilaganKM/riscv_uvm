`timescale 1ns / 1ps

module rvhazard(
    input logic clk,
    input logic reset,
    pipeline_if vif
);

/////////////////////////
// Pipeline Control
/////////////////////////
logic ZeroE;
logic StallF, StallD;
logic FlushE, FlushD;
logic PCSrcE;

/////////////////////////
// Forwarding
/////////////////////////
logic [1:0] ForwardAE, ForwardBE;

/////////////////////////
// Control Signals
/////////////////////////
logic RegWriteD, RegWriteE, RegWriteM, RegWriteW;
logic MemWriteD, MemWriteE, MemWriteM;
logic JumpD, BranchD, JumpE, BranchE;
logic ALUSrcD, ALUSrcE;
logic [1:0] ResultSrcD, ResultSrcE, ResultSrcM, ResultSrcW;
logic [1:0] ALUOpD, ALUOpE;
logic [1:0] ImmSrcD;

/////////////////////////
// Data
/////////////////////////
logic [31:0] SrcAE, SrcBE, SrcB;
logic [31:0] ALUResultE, ALUResultM, ALUResultW;
logic [31:0] ReadDataM, ReadDataW;
logic [31:0] PCTargetE, PCNext;
logic [31:0] ResultW;
logic [31:0] RD1D, RD2D, RD1E, RD2E, RD2M;
logic [31:0] ImmExtendD, ImmExtendE;

/////////////////////////
// PC & Instruction
/////////////////////////
logic [31:0] InstrF, InstrD;
logic [31:0] PCF, PCD, PCE;
logic [31:0] PCPlus4F, PCPlus4D, PCPlus4E, PCPlus4M, PCPlus4W;

/////////////////////////
// Register Addresses
/////////////////////////
logic [4:0] rs1E, rs2E, rdE, rdM, rdW;

/////////////////////////
// funct pipeline
/////////////////////////
logic [2:0] funct3E;
logic funct7b5E;

/////////////////////////
// ALU Control (EX stage)
/////////////////////////
logic [2:0] ALUControlE;

assign PCSrcE = (BranchE & ZeroE) | JumpE;

//////////////////////////////////////////////////////////
// Forwarding Unit
//////////////////////////////////////////////////////////
forwarding_unit fwd(
    .Rs1E(rs1E),
    .Rs2E(rs2E),
    .RdM(rdM),
    .RdW(rdW),
    .RegWriteM(RegWriteM),
    .RegWriteW(RegWriteW),
    .ForwardAE(ForwardAE),
    .ForwardBE(ForwardBE)
);

//////////////////////////////////////////////////////////
// PC Logic
//////////////////////////////////////////////////////////
Adder PCPlus4Adder(.A(PCF), .B(32'd4), .Sum(PCPlus4F));
Adder PCTargetAdder(.A(PCE), .B(ImmExtendE), .Sum(PCTargetE));

mux2 PCMux(.d0(PCPlus4F), .d1(PCTargetE), .s(PCSrcE), .y(PCNext));

program_counter pc(
    .clk(clk),
    .reset(reset),
    .en(~StallF),
    .PCNext(PCNext),
    .PC(PCF)
);

instr_mem imem(
    .A(PCF),
    .RD(InstrF),
    .mem(vif.imem)
);

//////////////////////////////////////////////////////////
// IF/ID
//////////////////////////////////////////////////////////
IF_ID ifid(
    .clk(clk),
    .reset(reset),
    .en(~StallD),
    .flush(FlushD),
    .InstrF(InstrF),
    .PCF(PCF),
    .PCPlus4F(PCPlus4F),
    .InstrD(InstrD),
    .PCD(PCD),
    .PCPlus4D(PCPlus4D)
);

//////////////////////////////////////////////////////////
// Register File
//////////////////////////////////////////////////////////
register_file rf(
    .clk(clk),
    .reset(reset),
    .A1(InstrD[19:15]),
    .A2(InstrD[24:20]),
    .A3(rdW),
    .wd3(ResultW),
    .we(RegWriteW),
    .rd1(RD1D),
    .rd2(RD2D)
);

//////////////////////////////////////////////////////////
// Immediate Extend
//////////////////////////////////////////////////////////
ExtendUnit extend(
    .Instr(InstrD),
    .ImmSrc(ImmSrcD),
    .ImmExtend(ImmExtendD)
);

//////////////////////////////////////////////////////////
// Control Unit (NO ALUControl HERE)
//////////////////////////////////////////////////////////
control_unit ctrl(
    .op(InstrD[6:0]),
    .Branch(BranchD),
    .Jump(JumpD),
    .ResultSrc(ResultSrcD),
    .MemWrite(MemWriteD),
    .ImmSrc(ImmSrcD),
    .RegWrite(RegWriteD),
    .ALUSrc(ALUSrcD),
    .ALUOp(ALUOpD)
);

//////////////////////////////////////////////////////////
// Hazard Unit
//////////////////////////////////////////////////////////
HazardUnit hz(
    .Rs1D(InstrD[19:15]),
    .Rs2D(InstrD[24:20]),
    .RdE(rdE),
    .PCSrcE(PCSrcE),
    .ResultSrcE0(ResultSrcE[0]),
    .StallF(StallF),
    .StallD(StallD),
    .FlushE(FlushE),
    .FlushD(FlushD)
);

//////////////////////////////////////////////////////////
// ID/EX
//////////////////////////////////////////////////////////
ID_IE idex(
    .clk(clk),
    .reset(reset),
    .flush(FlushE),

    .rd1D(RD1D),
    .rd2D(RD2D),
    .PCD(PCD),
    .rs1D(InstrD[19:15]),
    .rs2D(InstrD[24:20]),
    .rdD(InstrD[11:7]),
    .ImmExtendD(ImmExtendD),
    .PCPlus4D(PCPlus4D),

    .RegWriteD(RegWriteD),
    .ResultSrcD(ResultSrcD),
    .MemWriteD(MemWriteD),
    .JumpD(JumpD),
    .BranchD(BranchD),
    .ALUSrcD(ALUSrcD),

    .ALUOpD(ALUOpD),
    .funct3D(InstrD[14:12]),
    .funct7b5D(InstrD[30]),

    .rd1E(RD1E),
    .rd2E(RD2E),
    .PCE(PCE),
    .rs1E(rs1E),
    .rs2E(rs2E),
    .rdE(rdE),
    .ImmExtendE(ImmExtendE),
    .PCPlus4E(PCPlus4E),

    .RegWriteE(RegWriteE),
    .ResultSrcE(ResultSrcE),
    .MemWriteE(MemWriteE),
    .JumpE(JumpE),
    .BranchE(BranchE),
    .ALUSrcE(ALUSrcE),

    .ALUOpE(ALUOpE),
    .funct3E(funct3E),
    .funct7b5E(funct7b5E)
);

//////////////////////////////////////////////////////////
// ALU Decoder (EX stage)
//////////////////////////////////////////////////////////
Alu_decoder alu_dec(
    .funct3(funct3E),
    .funct7b5(funct7b5E),
    .ALUOp(ALUOpE),
    .ALUControl(ALUControlE)
);

//////////////////////////////////////////////////////////
// Forwarding MUXes
//////////////////////////////////////////////////////////
mux3to1 muxA(.d0(RD1E), .d1(ResultW), .d2(ALUResultM), .s(ForwardAE), .y(SrcAE));
mux3to1 muxB(.d0(RD2E), .d1(ResultW), .d2(ALUResultM), .s(ForwardBE), .y(SrcB));
mux2 muxImm(.d0(SrcB), .d1(ImmExtendE), .s(ALUSrcE), .y(SrcBE));

//////////////////////////////////////////////////////////
// ALU
//////////////////////////////////////////////////////////
ALU alu(
    .SrcA(SrcAE),
    .SrcB(SrcBE),
    .ALUControl(ALUControlE),
    .ALUResult(ALUResultE),
    .Zero(ZeroE)
);

//////////////////////////////////////////////////////////
// EX/MEM
//////////////////////////////////////////////////////////
IE_IM exmem(
    .clk(clk),
    .reset(reset),
    .ALUResultE(ALUResultE),
    .RD2E(RD2E),
    .RegWriteE(RegWriteE),
    .MemWriteE(MemWriteE),
    .ResultSrcE(ResultSrcE),
    .rdE(rdE),
    .PCPlus4E(PCPlus4E),

    .ALUResultM(ALUResultM),
    .RD2M(RD2M),
    .RegWriteM(RegWriteM),
    .MemWriteM(MemWriteM),
    .ResultSrcM(ResultSrcM),
    .rdM(rdM),
    .PCPlus4M(PCPlus4M)
);

//////////////////////////////////////////////////////////
// Data Memory
//////////////////////////////////////////////////////////
data_mem dmem(
    .clk(clk),
    .reset(reset),
    .we(MemWriteM),
    .A(ALUResultM),
    .WD(RD2M),
    .ReadData(ReadDataM)
);

//////////////////////////////////////////////////////////
// MEM/WB
//////////////////////////////////////////////////////////
IM_IW memwb(
    .clk(clk),
    .reset(reset),
    .ALUResultM(ALUResultM),
    .ReadDataM(ReadDataM),
    .PCPlus4M(PCPlus4M),
    .RegWriteM(RegWriteM),
    .ResultSrcM(ResultSrcM),
    .rdM(rdM),

    .ALUResultW(ALUResultW),
    .ReadDataW(ReadDataW),
    .PCPlus4W(PCPlus4W),
    .rdW(rdW),
    .RegWriteW(RegWriteW),
    .ResultSrcW(ResultSrcW)
);

//////////////////////////////////////////////////////////
// Writeback MUX
//////////////////////////////////////////////////////////
mux3to1 wb_mux(
    .d0(ALUResultW),
    .d1(ReadDataW),
    .d2(PCPlus4W),
    .s(ResultSrcW),
    .y(ResultW)
);

endmodule

bind rvhazard rvhazard_sva sva_inst (
    .clk(clk),
    .reset(reset),

    .RegWriteW(RegWriteW),
    .rdW(rdW),

    .StallD(StallD),
    .FlushD(FlushD),
    .PCSrcE(PCSrcE),

    .InstrD(InstrD),

    .rdE(rdE),
    .ResultSrcE(ResultSrcE),

    .ForwardAE(ForwardAE),
    .ForwardBE(ForwardBE),
    .SrcAE(SrcAE),
    .SrcB(SrcB),
    .ALUResultM(ALUResultM)
);