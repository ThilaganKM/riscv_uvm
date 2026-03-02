module control_unit(
    input  logic [6:0] op,
    output logic       Branch,
    output logic       Jump,
    output logic [1:0] ResultSrc,
    output logic       MemWrite,
    output logic [1:0] ImmSrc,
    output logic       RegWrite,
    output logic       ALUSrc,
    output logic [1:0] ALUOp
);

    main_decoder md(
        .op(op),
        .RegWrite(RegWrite),
        .ResultSrc(ResultSrc),
        .ALUOp(ALUOp),
        .ImmSrc(ImmSrc),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .Jump(Jump),
        .Branch(Branch)
    );

endmodule