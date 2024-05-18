module Immediate_Generator (Opcode, instruction, ImmExt);
    parameter n = 32;
    input [6:0] Opcode;
    input [n-1:0] instruction;
    output reg [n-1:0] ImmExt;
    
    always @(Opcode, instruction) begin
        case (Opcode)
            7'b0010011 : ImmExt = {{20{instruction[31]}}, instruction[31:20]}; // R instruction
            7'b0100011 : ImmExt = {{20{instruction[31]}}, instruction[31:25],  instruction[11:7]}; // S instruction
            7'b1100011 : ImmExt = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0}; //B instruction
            default: ImmExt = {{20{instruction[31]}}, instruction[31:20]};
        endcase
    end
endmodule