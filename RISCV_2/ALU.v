module ALU (A, B, ALUSel, ALUResult);
    parameter n = 32;
    input [n-1:0] A, B;
   // input [n-1:0] imm;
    input [3:0] ALUSel;
   // output reg zero;
    output reg [n-1:0] ALUResult;
   // reg [n-1:0] PC;

    always @(A or B or ALUSel) begin
        case (ALUSel)

        //add
            4'b0000 : begin
                ALUResult = A + B;
            end 

            //sub
            4'b0001 : begin
                ALUResult = A - B;
            end

            //addi
            4'b0010 : begin
                ALUResult = A + B;
            end

            //lw

            //sw have not had an idea yet

            //beq 0/+4
            4'b0101: begin
                if(A == B) ALUResult = ALUResult + 4;
                else ALUResult = ALUResult;
            end

            //beq 1/ALU
            4'b0110: begin
                if(A == B) ALUResult = ALUResult + B;
                else ALUResult = ALUResult;
            end

            //bne 0/ALU
            4'b0111: begin
                if(A != B) ALUResult = ALUResult + B;
                else ALUResult = ALUResult;
            end

            //bne 1/+4
            4'b1000: begin
                if(A != B) ALUResult = ALUResult + 4;
                else ALUResult = ALUResult;
            end

            //blt
            4'b1001: begin
                if(A >= B) ALUResult = ALUResult + B;
                else ALUResult = ALUResult;
            end

            //bltu
            4'b1010: begin
                if(A < B) ALUResult = ALUResult + B;
                else ALUResult = ALUResult;
            end

            //jalr
            4'b1011: begin
                ALUResult = A + B;
                ALUResult = ALUResult + 4;
            end

            //jal
            4'b1100: begin
                ALUResult = ALUResult + B;
                ALUResult = ALUResult + 4;
            end

            //auiALUResult
            4'b1101: begin
                ALUResult = ALUResult + (B << 12);
            end
            default: ALUResult = A;
        endcase
    end
endmodule



// always @(A or B or ALUSel) begin
//     case (ALUSel)

//     //add
//         4'b0000 : begin
//             ALUResult = A + B;
//         end 

//         //sub
//         4'b0001 : begin
//             ALUResult = A - B;
//         end

//         //addi
//         4'b0010 : begin
//             ALUResult = A + B;
//         end

//         //lw

//         //sw have not had an idea yet

//         //beq 0/+4
//         4'b0101: begin
//             if(A == B) PC = PC + 4;
//             else PC = PC;
//         end

//         //beq 1/ALU
//         4'b0110: begin
//             if(A == B) PC = PC + B;
//             else PC = PC;
//         end

//         //bne 0/ALU
//         4'b0111: begin
//             if(A != B) PC = PC + B;
//             else PC = PC;
//         end

//         //bne 1/+4
//         4'b1000: begin
//             if(A != B) PC = PC + 4;
//             else PC = PC;
//         end

//         //blt
//         4'b1001: begin
//             if(A >= B) PC = PC + B;
//             else PC = PC;
//         end

//         //bltu
//         4'b1010: begin
//             if(A < B) PC = PC + B;
//             else PC = PC;
//         end

//         //jalr
//         4'b1011: begin
//             PC = A + B;
//             ALUResult = PC + 4;
//         end

//         //jal
//         4'b1100: begin
//             PC = PC + B;
//             ALUResult = PC + 4;
//         end

//         //auipc
//         4'b1101: begin
//             ALUResult = PC + (B << 12);
//         end
//         default: ALUResult = A;
//     endcase
// end