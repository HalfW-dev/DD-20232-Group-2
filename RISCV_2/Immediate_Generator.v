module Immediate_Generator (Opcode, instruction, ImmExt, ImmSel);
    parameter n = 32;
    input [6:0] Opcode;
    input [2:0] ImmSel;
    input [n-1:0] instruction;
    output reg [n-1:0] ImmExt;
    
    always @(Opcode, instruction, ImmSel) begin
        case ({Opcode, ImmSel})
            // 7'b0010011 : ImmExt = {{20{instruction[31]}}, instruction[31:20]}; // R instruction
            // 7'b0100011 : ImmExt = {{20{instruction[31]}}, instruction[31:25],  instruction[11:7]}; // S instruction
            // 7'b1100011 : ImmExt = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0}; //B instruction
            // 7'b0010011 : ImmExt = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0}; //I instruction 1
            // 7'b0000011 : ImmExt = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0}; //I instruction 2 lw
            // 7'b0100011 : ImmExt = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0}; //S instruction
            // 7'b1101111 : ImmExt = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0}; //J instruction jal
            // 7'b1100111 : ImmExt = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0}; //I instruction jalr
            // 7'b0010111 : ImmExt = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0}; //U instruction


            // 7'b0110011: ImmExt = {{20{instruction[31]}}, instruction[31:20]}; // R instruction
            // 7'b0010011: ImmExt = {{21{instruction[31]}}, instruction[30:25], instruction[24:21], instruction[20]};   // ADDI     -> I-Type
            // 7'b0000011: ImmExt = {{21{instruction[31]}}, instruction[30:25], instruction[24:21], instruction[20]};   // LW       -> I-Type??
            // 7'b0100011: ImmExt = {{21{instruction[31]}}, instruction[30:25], instruction[11:7]};     // SW       -> S-Type
            // 7'b1100011: ImmExt = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], {1{1'b0}}};  // BRANCH -> B-Type
            // 7'b1101111: ImmExt = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:25], instruction[24:21], {1{1'b0}}};  // JAL -> J-Type
            // 7'b0010111: ImmExt = {instruction[31:12], {12{1'b0}} };             // AUIPC    -> U-Type
            // 7'b1100111 : ImmExt = {{20{instruction[31]}}, instruction[31:20]}; //I instruction jalr

            10'b0110011_101: ImmExt = {{20{instruction[31]}}, instruction[31:20]}; // R instruction
            10'b0010011_000: ImmExt = {{21{instruction[31]}}, instruction[30:25], instruction[24:21], instruction[20]};   // ADDI     -> I-Type
            10'b0000011_000: ImmExt = {{21{instruction[31]}}, instruction[30:25], instruction[24:21], instruction[20]};   // LW       -> I-Type??
            10'b0100011_001: ImmExt = {{21{instruction[31]}}, instruction[30:25], instruction[11:7]};     // SW       -> S-Type
            10'b1100011_010: ImmExt = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], {1{1'b0}}};  // BRANCH -> B-Type
            10'b1101111_011: ImmExt = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:25], instruction[24:21], {1{1'b0}}};  // JAL -> J-Type
            10'b0010111_100: ImmExt = {instruction[31:12], {12{1'b0}} };             // AUIPC    -> U-Type
            10'b1100111_000: ImmExt = {{20{instruction[31]}}, instruction[31:20]}; //I instruction jalr
            default: ImmExt = {{20{instruction[31]}}, instruction[31:20]};
        endcase
    end
endmodule