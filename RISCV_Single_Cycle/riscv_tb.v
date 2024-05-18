// module riscv(clk, rst_n, instruction_R, ALUResult_R, Write_data_R);
//     parameter n = 32;
//     input clk, rst_n;
//     input [n-1:0] instruction_R;
//     output wire [n-1:0] ALUResult_R;
//     output wire [n-1:0] Write_data_R;
`timescale 1ns/1ps
module riscv_tb;
    parameter n = 32;
    parameter CLOCK = 10;
    reg clk;
    reg rst_n;
    reg [n-1:0] instruction_R;
    reg [n-1:0] Read_data1_R;
    reg [n-1:0] Read_data2_R;
    wire [n-1:0] ALUResult_R;
    wire [n-1:0] Write_data_R;
    wire [n-1:0] Write_data_out_R;
    // wire [n-1:0] DataMemory_R [2*n-1:0];
   // wire [n-1:0] Registers_R [n-1:0];
    // wire [n-1:0] Imemory_R [0:2*n-1]; 

    riscv r1(
        .clk(clk),
        .rst_n(rst_n),
        .instruction_R(instruction_R),
        .Read_data1_R(Read_data1_R),
        .Read_data2_R(Read_data2_R),
        .ALUResult_R(ALUResult_R),
        // .DataMemory_R(DataMemory_R),
        // .Registers_R(Registers_R),
        // .Imemory_R(Imemory_R),
        .Write_data_out_R(Write_data_out_R)
    );

    always #(CLOCK/2) clk = ~clk;
    initial begin
        Read_data1_R = 32'h1;
        Read_data2_R = 32'h2;
        clk = 0;
        rst_n = 0;
        instruction_R = 0;
        #(2*CLOCK);
        Read_data1_R = 32'h5;
        Read_data2_R = 32'h8;
        rst_n = 1;
        instruction_R = 32'b0000000_00010_00001_000_00100_0110011; // add
        #(CLOCK)
        instruction_R = 32'b0100000_00011_00001_000_00110_0110011; //sub
        Read_data1_R = 32'h1;
        Read_data2_R = 32'h2;
        #(CLOCK/2);
        Read_data1_R = 32'h15;
        Read_data2_R = 32'h8;
        #(CLOCK/2);
        Read_data1_R = 32'h10;
        Read_data2_R = 32'h5;
        instruction_R = 32'b0100000_01010_00001_111_10100_0110011; //and
        #(CLOCK/2);
        instruction_R = 32'b0100000_10010_00001_110_00101_0110011; //or
        Read_data1_R = 32'h8;
        Read_data2_R = 32'h15;
        #(CLOCK/2);
        instruction_R = 32'b0100000_01010_00001_001_10100_0110011; //shift left
        Read_data1_R = 32'h1;
        Read_data2_R = 32'h2;
        #(CLOCK/2);
        instruction_R = 32'b0100000_10010_00001_010_00101_0110011; //shift right
        Read_data1_R = 32'h23;
        Read_data2_R = 32'h1;
        #(CLOCK/2);
        instruction_R = 32'b0100000_10010_00001_110_00101_0110011; //set less than
        Read_data1_R = 32'h8;
        Read_data2_R = 32'h15;
        Read_data1_R = 32'h23;
        Read_data2_R = 32'h1;
        #(CLOCK/2);
        #(200*CLOCK);
        $finish;
    end
    initial begin
        $monitor("At time %t, instruction_R: %b, ALUResult_R: %b, Write_data_R: %b", $time, instruction_R, ALUResult_R, Write_data_R);
    end
endmodule