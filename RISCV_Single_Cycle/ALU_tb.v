module ALU_tb;
parameter n = 32;
reg [n-1:0] A, B;
reg [3:0] ALUcontrol_in;
wire zero;
wire [n-1:0] ALUResult;

ALU a(
    .A(A),
    .B(B),
    .ALUcontrol_in(ALUcontrol_in),
    .zero(zero),
    .ALUResult(ALUResult)
);

initial begin
    A = 32'h4;
    B = 32'h5;
    ALUcontrol_in = 4'b0000;
    #5;
    ALUcontrol_in = 4'b0001;
    #5;
    ALUcontrol_in = 4'b0010;
    #5;
    ALUcontrol_in = 4'b0011;
    #5;
    ALUcontrol_in = 4'b0100;
    #5;
    ALUcontrol_in = 4'b0101;
    #5;
    ALUcontrol_in = 4'b0110;
    #500;
    $finish;

end

endmodule