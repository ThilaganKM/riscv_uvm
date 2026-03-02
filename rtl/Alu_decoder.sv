module Alu_decoder(
    input  logic [2:0] funct3,
    input  logic       funct7b5,
    input  logic [1:0] ALUOp,
    output logic [2:0] ALUControl
);

always_comb begin
    case (ALUOp)

        2'b00: ALUControl = 3'b000; // ADD

        2'b01: ALUControl = 3'b001; // SUB

        2'b10: begin // R-type
            case (funct3)
                3'b000: ALUControl = funct7b5 ? 3'b001 : 3'b000;
                3'b010: ALUControl = 3'b100;
                3'b110: ALUControl = 3'b011;
                3'b111: ALUControl = 3'b010;
                default: ALUControl = 3'b000;
            endcase
        end

        2'b11: begin // I-type arithmetic
            case (funct3)
                3'b000: ALUControl = 3'b000; // ADDI always ADD
                3'b010: ALUControl = 3'b100; // SLTI
                3'b110: ALUControl = 3'b011; // ORI
                3'b111: ALUControl = 3'b010; // ANDI
                default: ALUControl = 3'b000;
            endcase
        end

    endcase
end

endmodule