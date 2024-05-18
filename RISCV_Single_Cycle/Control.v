module Control (Opcode, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, ALUOp);
    parameter n = 32;
    input [6:0] Opcode;
    output reg Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
    output reg [1:0] ALUOp;

    always @(Opcode) begin
        case (Opcode)
            //R-type instruction
            7'b0110011: 
            begin
                ALUSrc = 0;
                MemtoReg = 0;
                RegWrite = 1;
                MemRead = 0; 
                MemWrite = 0; 
                Branch = 0;
                ALUOp = 2'b10;
            end 

            //Load instruction
            7'b0000011: 
            begin
                ALUSrc = 1;
                MemtoReg = 1;
                RegWrite = 1;
                MemRead = 1; 
                MemWrite = 0; 
                Branch = 0;
                ALUOp = 2'b00;
            end

            //Store instruction
            7'b0100011:
            begin
                ALUSrc = 1;
                MemtoReg = 0;
                RegWrite = 0;
                MemRead = 0; 
                MemWrite = 1; 
                Branch = 0;
                ALUOp = 2'b00;
            end

            //Branch-equal instruction
            7'b1100011:
            begin
                ALUSrc = 0;
                MemtoReg = 0;
                RegWrite = 0;
                MemRead = 0; 
                MemWrite = 0; 
                Branch = 1;
                ALUOp = 2'b01;
            end
            default: begin
                ALUSrc = 0;
                MemtoReg = 0;
                RegWrite = 1;
                MemRead = 0; 
                MemWrite = 0; 
                Branch = 0;
                ALUOp = 2'b10;
            end
        endcase
    end
endmodule