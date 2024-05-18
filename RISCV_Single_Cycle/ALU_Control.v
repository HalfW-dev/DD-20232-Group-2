module ALU_Control (ALUOp, func7, func3, ALUcontrol_out);
    input [1:0] ALUOp;
    input func7;
    input [14:12] func3;
    output reg [3:0] ALUcontrol_out;

    always @(*) begin
        case ({ALUOp, func7, func3})

            6'b10_0_000 : ALUcontrol_out = 4'b0000;  // R-type - add
            6'b10_1_000 : ALUcontrol_out = 4'b0001;  // R type - subtract
            6'b10_0_100 : ALUcontrol_out = 4'b0010;  // R type - xor
            6'b10_0_110 : ALUcontrol_out = 4'b0011;  // R type - or
            6'b10_0_111 : ALUcontrol_out = 4'b0100;  // R type - and
            6'b10_0_001 : ALUcontrol_out = 4'b0101;  // R type - shift left logical
            6'b10_0_010 : ALUcontrol_out = 4'b0110;  // R type - or shift right logical
         //   6'b10_0_110 : ALUcontrol_out = 4'b0001;  // R type - or shift right arithmetic - msb extends
            6'b10_0_110 : ALUcontrol_out = 4'b0111;  // R type - or set less than
        //    6'b10_0_110 : ALUcontrol_out = 4'b0001;  // R type - or set less than - zero extends
            6'b00_0_000 : ALUcontrol_out = 4'b0010;  //load double word & store double word - add
            6'b01_0_000 : ALUcontrol_out = 4'b0110;  // branch if equal - subtract
            
            

            default: ALUcontrol_out = 4'b000;
        endcase
    end
endmodule