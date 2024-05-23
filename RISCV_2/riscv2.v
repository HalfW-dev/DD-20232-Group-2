module riscv2(clk, rst_n, instruction_R, ALUResult_R, Read_data1_R, Read_data2_R);
    parameter n = 32;
    input clk, rst_n;
    input [n-1:0] instruction_R;
    input [n-1:0] Read_data1_R, Read_data2_R;
    output wire [n-1:0] ALUResult_R;
wire [n-1:0] Instruction_R;
//assign Instruction_R = instruction_R;
wire [n-1:0] PC_in_R, PC_next_R, PC_out_R;
wire [n-1:0] Immediate_R;
wire [n-1:0]  Data_out_R, Write_data_R;
wire PCSel_R;
wire [2:0] ImmSel_R;
wire RegWEn_R, BrUn_R, BrEq_R, BrLT_R, Bsel_R, Asel_R, MemRW_R;
wire [3:0] ALUSel_R;
wire [1:0] WBSel_R;
wire [n-1:0] Mux2_out, Mux3_out;

Program_Counter PC(
    .clk(clk),
    .rst_n(rst_n),
    .PC_in(PC_in_R),
    .PC_next(PC_next_R)
);

PCadd4 P4(
    .PC_next(PC_next_R),
    .PC_out(PC_out_R)
);

Instruction_Memory IM(
    .clk(clk),
    .rst_n(rst_n),
    .read_address(PC_next_R),
    .Instruction_out(Instruction_R)
);

Immediate_Generator IG(
    .Opcode(instruction_R[6:0]),
    .ImmSel(ImmSel_R),
    .instruction(instruction_R),
    .ImmExt(Immediate_R)
);

Register_File RF(
    .clk(clk),
    .rst_n(rst_n),
    .RegWrite(RegWEn_R),
    .rs1(instruction_R[19:15]),
    .rs2(instruction_R[24:20]),
    .rd(instruction_R[11:7]),
    .Write_data(Write_data_R),
    .Read_data1(Read_data1_R),
    .Read_data2(Read_data2_R)
);

Branch_Comp BC(
    .A(Read_data1_R),
    .B(Read_data2_R)
    ,.BrUn(BrUn_R)
    ,.BrEq(BrEq_R)
    ,.BrLT(BrLT_R)
);

Control C(
    .Inst(instruction_R[30])
    ,.func3(instruction_R[14:12])
    ,.Opcode_m(instruction_R[6:2])
    ,.BrEq(BrEq_R)
    ,.BrLT(BrLT_R)
    ,.PCSel(PCSel_R)
    ,.ImmSel(ImmSel_R)
    ,.BrUn(BrUn_R)
    ,.ASel(Asel_R)
    ,.BSel(Bsel_R)
    ,.ALUSel(ALUSel_R)
    ,.MemRW(MemRW_R)
    ,.RegWEn(RegWEn_R)
    ,.WBSel(WBSel_R)
);

Mux mux1(
    .A(PC_out_R)
    ,.B(ALUResult_R)
    ,.Sel(PCSel_R)
    ,.Mux_out(PC_in_R)
);
Mux mux2(
    .A(Read_data1_R)
    ,.B(PC_next_R)
    ,.Sel(Asel_R)
    ,.Mux_out(Mux2_out)
);

Mux mux3(
    .A(Read_data2_R)
    ,.B(Immediate_R)
    ,.Sel(Bsel_R)
    ,.Mux_out(Mux3_out)
);

ALU A1(
    .A(Mux2_out)
    ,.B(Mux3_out)
    ,.ALUSel(ALUSel_R)
    ,.ALUResult(ALUResult_R)
);

Data_Memory DM(
    .clk(clk)
    ,.rst_n(rst_n)
    ,.MemRW(MemRW_R)
    ,.address(ALUResult_R)
    ,.Writedata(Read_data2_R)
    ,.Data_out(Data_out_R)
);

Mux41 mux4(
    .Sel(WBSel_R)
    ,.A(Data_out_R)
    ,.B(ALUResult_R)
    ,.C(PC_out_R)
    ,.Mux_out(Write_data_R)
);
endmodule