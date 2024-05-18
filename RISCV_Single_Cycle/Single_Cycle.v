module Instruction_Memory (clk, rst_n, read_address, Instruction_out);
    parameter n = 32;
    input clk;
    input rst_n;
    input [n-1:0] read_address;
    output reg [n-1:0] Instruction_out;

   reg [n-1:0] Imemory [0:2*n-1]; //mem of 64 each 32 bit wide
//reg [32:0] Imemory [63:0];
integer i;
assign Instruction_out = Imemory[read_address];
always @(posedge clk) begin
    if(~rst_n) begin
        for(i = 0; i < 2*n; i = i+1)
            Imemory[i] = 32'b0; 
    end
end    
endmodule

module Program_Counter (clk, rst_n, PC_in, PC_out);
    parameter n = 32;
    input clk;
    input rst_n;
    input [n-1:0] PC_in;
    output reg [n-1:0] PC_out;
    always @(posedge clk) begin
        if(~rst_n) begin
            PC_out <= 32'h0;
        end
        else
            PC_out <= PC_in;
    end    
endmodule

module PCadd4 (fromPC, nexttoPC);
    parameter n = 32;
    input [n-1:0] fromPC;
    output [n-1:0] nexttoPC;

    assign nexttoPC = fromPC + 32'h4;
endmodule

module adder (in1, in2, sum);
    parameter n = 32;
    input [n-1:0] in1, in2;
    output [n-1:0] sum;
    assign sum = in1 + in2;
endmodule

module Register_File (clk, rst_n, RegWrite, Rs1, Rs2, Rd, Write_data, Read_data1, Read_data2);
    parameter n = 32;
    input clk, rst_n, RegWrite;
    input [4:0] Rs1, Rs2, Rd;
    input [n-1:0] Write_data;
    output reg [n-1:0] Read_data1, Read_data2;

    reg [n-1:0] Registers [n-1:0];

    integer i;
    always @(posedge clk) begin
        if(~rst_n) begin
            for(i = 0; i < n; i = i+1)
                Registers[i] = 32'h0; 
        end
        else if(RegWrite) begin
            Registers[Rd] = Write_data;
        end
    end

    assign Read_data1 = Registers[Rs1];
    assign Read_data2 = Registers[Rs2];
endmodule

module Immediate_Generator (Opcode, instruction, ImmExt);
    parameter n = 32;
    input [6:0] Opcode;
    input [n-1:0] instruction;
    output reg [n-1:0] ImmExt;
    
    always @(Opcode, instruction) begin
        case (Opcode)
            7'b0010011 : ImmExt = {{20{instruction[31]}}, instruction[31:20]}; // I instruction
            7'b0100011 : ImmExt = {{20{instruction[31]}}, instruction[31:25],  instruction[11:7]}; // S instruction
            7'b1100011 : ImmExt = {{20{instruction[31]}}, instruction[30:25], instruction[11:8], 1'b0}; //SB type
            default: ImmExt = {{20{instruction[31]}}, instruction[31:20]};
        endcase
    end
endmodule

module Control_Unit (Opcode, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, ALUOp);
    parameter n = 32;
    input [6:0] Opcode;
    output reg Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
    output reg [1:0] ALUOp;

    always @(*) begin
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

module ALU (A, B, ALUcontrol_in, ALUResult, zero);
    parameter n = 32;
    input [n-1:0] A, B;
    input [3:0] ALUcontrol_in;
    output reg zero;
    output reg [n-1:0] ALUResult;

    always @(A or B or ALUcontrol_in) begin
        case (ALUcontrol_in)
            4'b000 : begin
                zero = 0;
                ALUResult <= A&B;
            end 

            4'b0001 : begin
                zero = 0;
                ALUResult <= A|B;
            end

            4'b0010 : begin
                zero = 0;
                ALUResult <= A+B;
            end

            4'b0110 : begin
                if(A==B) zero = 1;
                else begin
                    zero = 0;
                    ALUResult <= A-B;
                end
            end
            default: begin
                zero = 0;
                ALUResult <= A;
            end
        endcase
    end
endmodule

module ALU_Control (ALUOp, func7, func3, ALUcontrol_out);
    input [1:0] ALUOp;
    input func7;
    input [14:12] func3;
    output reg [3:0] ALUcontrol_out;

    always @(*) begin
        case ({ALUOp, func7, func3})
            6'b00_0_000 : ALUcontrol_out = 4'b0010;
            6'b01_0_000 : ALUcontrol_out = 4'b0110;
            6'b10_0_000 : ALUcontrol_out = 4'b0010;
            6'b10_1_000 : ALUcontrol_out = 4'b0110;
            6'b10_0_111 : ALUcontrol_out = 4'b0000;
            6'b10_0_110 : ALUcontrol_out = 4'b0011;
             
            default: ALUcontrol_out = 4'b000;
        endcase
    end
endmodule

module Data_Memory (clk, rst_n, MemWrite, MemRead, address, Writedata, Data_out);
    parameter n = 32;
    input clk, rst_n, MemWrite, MemRead;
    input [n-1:0] address, Writedata;
    output wire [n-1:0] Data_out;

    reg [n-1:0] DataMemory [2*n-1:0];
    assign Data_out = (MemRead) ? DataMemory[address] : 32'b0;

    integer i;
    always @(posedge clk) begin
        if(~rst_n) begin
            for(i = 0; i < 2*n; i = i+1)
                DataMemory[i] <= 32'b0; 
        end
        else if(MemWrite)
            DataMemory[address] <= Writedata;
    end
endmodule

module Mux1 (Sel, A1, B1, Mux1_out);
    parameter n = 32;
    input Sel;
    input [n-1:0] A1, B1;
    output wire [n-1:0] Mux1_out;

    assign Mux1_out = (Sel == 1'b0) ? A1 : B1;
endmodule

module And (branch, zero, andout);
    input branch, zero;
    output wire andout;
    assign andout = branch & zero;
endmodule

module Top (
    input clk, rst_n
);
parameter n = 32;
wire [n-1:0] PC_outTop;    
endmodule

module riscv(clk, rst_n, instruction_R, ALUResult_R, Write_data_R);
    parameter n = 32;
    input clk, rst_n;
    input [n-1:0] instruction_R;
    output wire [n-1:0] ALUResult_R;
    output wire [n-1:0] Write_data_R;

wire [n-1:0] PC_in_R, PC_next_R, PC_out_R, Instruction_out_R, ImmExt_R;
wire [n-1:0] Read_data1_R, Read_data2_R, Data_out_R;

//wire [6:0] Opcode_R;
wire Branch_R, MemRead_R, MemtoReg_R, MemWrite_R, RegWrite_R, ALUSrc_R, zero_R;
wire [1:0] ALUOp_R;
wire [3:0] ALUcontrol_in_R;    
wire Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, zero, andout;
// wire Sel1_R, Sel2_R, Sel3_R;
// wire [n-1:0] A1_R, A2_R, A3_R,B1_R, B2_R, B3_R, Mux1_out_R, Mux2_out_R, Mux3_out_R;
wire [n-1:0] Mux1_out_R, Mux2_out_R, Mux3_out_R;
wire [n-1:0] sum1_R, sum2_R, sum3_R;
wire andout_R;
assign andout_R = Branch_R & zero_R;
Program_Counter PC(
    .clk(clk),
    .rst_n(rst_n),
    .PC_in(PC_in_R),
    .PC_next(PC_next_R)
);

PCadd4 PC4(
    .PC_next(PC_next_R),
    .PC_out(PC_out_R)
);

Instruction_Memory IM(
    .clk(clk),
    .rst_n(rst_n),
    .read_address(PC_next_R),
    .Instruction_out(Instruction_out_R)
);

Register_File RF(
    .clk(clk),
    .rst_n(rst_n),
    .RegWrite(RegWrite_R),
    .rs1(instruction_R[19:15]),
    .rs2(instruction_R[24:20]),
    .rd(instruction_R[11:7]),
    .Write_data(Write_data_R),
    .Read_data1(Read_data1_R),
    .Read_data2(Read_data2_R)
);

Immediate_Generator IG(
    .Opcode(instruction_R[6:0]),
    .instruction(instruction_R),
    .ImmExt(ImmExt_R)
);

Control C(
    .Opcode(instruction_R[6:0]),
    .Branch(Branch_R),
    .MemRead(MemRead_R),
    .MemtoReg(MemtoReg_R),
    .ALUOp(ALUOp_R),
    .MemWrite(MemWrite_R),
    .ALUSrc(ALUSrc_R),
    .RegWrite(RegWrite_R)
);

ALU A(
    .A(Read_data1_R),
    .B(Mux2_out_R),
    .ALUcontrol_in(ALUcontrol_in_R),
    .zero(zero_R),
    .ALUResult(ALUResult_R)
);

ALU_Control AC(
    .ALUOp(ALUOp_R),
    .func7(instruction_R[30]),
    .func3(instruction_R[14:12]),
    .ALUcontrol_out(ALUcontrol_in_R)
);

Data_Memory DM(
    .clk(clk),
    .rst_n(rst_n),
    .MemWrite(MemWrite_R),
    .MemRead(MemRead_R),
    .address(ALUResult_R),
    .Writedata(Read_data2_R),
    .Data_out(Data_out_R)
);

adder add1(
    .in1(PC_next_R),
    .in2(ImmExt_R),
    .sum(sum1_R)
);

// And_mod and_mod1 (
//     .branch(Branch_R),
//     .zero(zero_R),
//     .andout(andout_R)
// );
Mux mux1 (
    .A(PC_out_R),
    .B(sum1_R),
    .Sel(andout_R),
    .Mux_out(PC_in_R)
);

Mux mux2 (
    .A(Read_data2_R),
    .B(ImmExt_R),
    .Sel(ALUSrc_R),
    .Mux_out(Mux2_out_R)
);

Mux mux3 (
    .A(ALUResult_R),
    .B(Write_data_R),
    .Sel(MemtoReg_R),
    .Mux_out(Write_data_R)
);

endmodule