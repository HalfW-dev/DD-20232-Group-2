// module Control (Opcode, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, ALUOp);
//     parameter n = 32;
//     input [6:0] Opcode;
//     output reg Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
//     output reg [1:0] ALUOp;

//     always @(Opcode) begin
//         case (Opcode)
//             //R-type instruction
//             7'b0110011: 
//             begin
//                 ALUSrc = 0;
//                 MemtoReg = 0;
//                 RegWrite = 1;
//                 MemRead = 0; 
//                 MemWrite = 0; 
//                 Branch = 0;
//                 ALUOp = 2'b10;
//             end 

//             //Load instruction
//             7'b0000011: 
//             begin
//                 ALUSrc = 1;
//                 MemtoReg = 1;
//                 RegWrite = 1;
//                 MemRead = 1; 
//                 MemWrite = 0; 
//                 Branch = 0;
//                 ALUOp = 2'b00;
//             end

//             //Store instruction
//             7'b0100011:
//             begin
//                 ALUSrc = 1;
//                 MemtoReg = 0;
//                 RegWrite = 0;
//                 MemRead = 0; 
//                 MemWrite = 1; 
//                 Branch = 0;
//                 ALUOp = 2'b00;
//             end

//             //Branch-equal instruction
//             7'b1100011:
//             begin
//                 ALUSrc = 0;
//                 MemtoReg = 0;
//                 RegWrite = 0;
//                 MemRead = 0; 
//                 MemWrite = 0; 
//                 Branch = 1;
//                 ALUOp = 2'b01;
//             end
//             default: begin
//                 ALUSrc = 0;
//                 MemtoReg = 0;
//                 RegWrite = 1;
//                 MemRead = 0; 
//                 MemWrite = 0; 
//                 Branch = 0;
//                 ALUOp = 2'b10;
//             end
//         endcase
//     end
// endmodule

module Control (
    input Inst,
    input [14:12] func3,
    input [6:2] Opcode_m,
    input BrEq, BrLT,
    output reg PCSel,
    output reg [2:0] ImmSel,
    output reg BrUn,
    output reg ASel,
    output reg BSel,
    output reg [3:0] ALUSel,
    output reg MemRW,
    output reg RegWEn,
    output reg [1:0] WBSel
);

// Encoding
// PCSel:  +4 = 0, 
//         ALU = 1

// ImmSel: I = 000
//         S = 001
//         B = 010
//         J = 011
//         H = 100
//         R = 101

// ASel: Reg = 0
//        PC = 1

// BSel: Reg = 0
//       Imm = 1

// MemRW:  Read = 1
//        Write = 0

// WBSel: ALU = 01
//        Mem = 00
//       PC+4 = 10

    always @(Inst, func3, Opcode_m, BrEq, BrLT) begin
        casez ({Inst,func3,Opcode_m, BrEq, BrLT})

            //add
            11'b0_000_01100_?? : begin
                PCSel = 0;
                ImmSel = 3'b101;
              //  BrUn =
                ASel = 0;
                BSel = 0;
                ALUSel = 4'b0000;
                MemRW = 1;
                RegWEn = 1;
                WBSel = 2'b01;
            end 

            //sub
            11'b1_000_01100_?? : begin
                PCSel = 0;
                ImmSel = 3'b101;
              //  BrUn =
                ASel = 0;
                BSel = 0;
                ALUSel = 4'b0001;
                MemRW = 1;
                RegWEn = 1;
                WBSel = 2'b01;
            end 

            //addi
            11'b?_000_00100_?? : begin
                PCSel = 0;
                ImmSel = 3'b000;
            //    BrUn =
                ASel = 0;
                BSel = 1;
                ALUSel = 4'b0010;
                MemRW = 1; 
                RegWEn = 1;
                WBSel = 2'b01;
            end 

            //lw
            11'b?_000_00000_?? : begin
                PCSel = 0;
                ImmSel = 3'b000;
             //   BrUn =
                ASel = 0;
                BSel = 1;
                ALUSel = 4'b0011; 
                MemRW = 1; 
                RegWEn = 1;
                WBSel = 2'b00;
            end 

            //sw
            11'b?_000_01000_?? : begin
                PCSel = 0;
                ImmSel = 3'b001;
            //    BrUn =
                ASel = 0;
                BSel = 1;
                ALUSel = 4'b0100;
                MemRW = 0;
                RegWEn = 0;
              //  WBSel = 
            end 

            //beq 0/+4
            11'b?_000_11000_0? : begin
                PCSel = 0;
                ImmSel = 3'b010;
               // BrUn =
                ASel = 1;
                BSel = 1;
                ALUSel = 4'b0101; 
                MemRW = 1; 
                RegWEn = 0;
              //  WBSel = 
            end 

            //beq 1/ALU
            11'b?_000_11000_1? : begin
                PCSel = 1;
                ImmSel = 3'b010;
             //   BrUn =
                ASel = 1;
                BSel = 1;
                ALUSel = 4'b0110;
                MemRW = 1; 
                RegWEn = 0;
              //  WBSel = 
            end 

            //bne 0/ALU
            11'b?_000_11000_0? : begin
                PCSel = 1;
                ImmSel = 3'b010;
              //  BrUn =
                ASel = 1;
                BSel = 1;
                ALUSel = 4'b0111;
                MemRW = 1; 
                RegWEn = 0;
              //  WBSel = 
            end 

            //bne 1/+4
            11'b?_000_11000_1? : begin
                PCSel = 0;
                ImmSel = 3'b010;
               // BrUn =
                ASel = 1;
                BSel = 1;
                ALUSel = 4'b1000;
                MemRW = 1; 
                RegWEn = 0;
            //    WBSel = 
            end 

            //blt
            11'b?_000_11000_?1 : begin
                PCSel = 1;
                ImmSel = 3'b010;
                BrUn = 0;
                ASel = 1;
                BSel = 1;
                ALUSel = 4'b1001; 
                MemRW = 1; 
                RegWEn = 0;
             //   WBSel = 
            end 

            //bltu
            11'b?_000_11000_?1 : begin
                PCSel = 1;
                ImmSel = 3'b010;
                BrUn = 1;
                ASel = 1;
                BSel = 1;
                ALUSel = 4'b1010;
                MemRW = 1; 
                RegWEn = 0;
              //  WBSel = 
            end 

            //jalr
            11'b?_000_11011_?? : begin
                PCSel = 1;
                ImmSel = 3'b000;
              //  BrUn =
                ASel = 0;
                BSel = 1;
                ALUSel = 4'b1011;
                MemRW = 1; 
                RegWEn = 1;
                WBSel = 2'b10;
            end 

            //jal
            11'b?_000_11011_?? : begin
                PCSel = 1;
                ImmSel = 3'b011;
              //  BrUn =
                ASel = 1;
                BSel = 1;
                ALUSel = 4'b1100;
                MemRW = 1; 
                RegWEn = 1;
                WBSel = 2'b10;
            end 

            //auipc
            11'b?_000_00101_?? : begin
                PCSel = 0;
                ImmSel = 3'b100;
              //  BrUn =
                ASel = 1;
                BSel = 1;
                ALUSel = 4'b1101;
                MemRW = 1; 
                RegWEn = 1;
                WBSel = 2'b01;
            end 
            default: begin
                PCSel = 0;
              //  ImmSel = 3'b
              //  BrUn =
                ASel = 0;
                BSel = 0;
                ALUSel = 4'b0000;
                MemRW = 1;
                RegWEn = 1;
                WBSel = 2'b01;
            end 
        endcase
    end
endmodule