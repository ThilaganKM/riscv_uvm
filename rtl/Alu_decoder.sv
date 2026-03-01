module Alu_decoder(
    input  logic [2:0] funct3,
    input  logic       funct7b5,
    input  logic [1:0] ALUOp,
    output logic [2:0] ALUControl
);

always_comb begin
    case (ALUOp)
        2'b00: ALUControl = 3'b000; // ADD (load/store)
        2'b01: ALUControl = 3'b001; // SUB (branch compare)
        2'b10: begin
            case (funct3)
                3'b000: ALUControl = (funct7b5) ? 3'b001 : 3'b000; // SUB / ADD
                3'b010: ALUControl = 3'b100; // SLT
                3'b110: ALUControl = 3'b011; // OR
                3'b111: ALUControl = 3'b010; // AND
                default: ALUControl = 3'b000;
            endcase
        end
        default: ALUControl = 3'b000;
    endcase
end

endmodule