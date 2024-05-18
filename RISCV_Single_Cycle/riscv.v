module riscv(clk, rst_n, instruction_R, ALUResult_R, Write_data_out_R, Read_data1_R, Read_data2_R);
    parameter n = 32;
    input clk, rst_n;
    input [n-1:0] instruction_R;
    input [n-1:0] Read_data1_R, Read_data2_R;
    output wire [n-1:0] ALUResult_R;
    output wire [n-1:0] Write_data_out_R;
  //  output reg [n-1:0] DataMemory_R [2*n-1:0];
  //  output wire [n-1:0] Registers_R [n-1:0];
  //  output reg [n-1:0] Imemory_R [0:2*n-1]; 
//wire [n-1:0] Imemory_R [0:2*n-1]; 
//wire [n-1:0] DataMemory_R [2*n-1:0];
wire [n-1:0] PC_in_R, PC_next_R, PC_out_R, Instruction_out_R, ImmExt_R;
wire [n-1:0]  Data_out_R, Write_data_R;

//wire [6:0] Opcode_R;
wire Branch_R, MemRead_R, MemtoReg_R, MemWrite_R, RegWrite_R, ALUSrc_R, zero_R;
wire [1:0] ALUOp_R;
wire [3:0] ALUcontrol_in_R;    
//wire Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, zero, andout;
// wire Sel1_R, Sel2_R, Sel3_R;
// wire [n-1:0] A1_R, A2_R, A3_R,B1_R, B2_R, B3_R, Mux1_out_R, Mux2_out_R, Mux3_out_R;
wire [n-1:0] Mux2_out_R;
wire [n-1:0] sum1_R;
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
   // .Imemory(Imemory_R)
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
    .Read_data2(Read_data2_R),
    .Write_data_out(Write_data_out_R)
   // .Registers(Registers_R)
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
   // .DataMemory(DataMemory_R),
    .Data_out(Data_out_R)
);

adder add1(
    .in1(PC_next_R),
    .in2(ImmExt_R),
    .sum(sum1_R)
);

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
    .B(Data_out_R),
    .Sel(MemtoReg_R),
    .Mux_out(Write_data_R)
);

endmodule