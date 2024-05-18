module ALU (A, B, ALUcontrol_in, ALUResult, zero);
    parameter n = 32;
    input [n-1:0] A, B;
    input [3:0] ALUcontrol_in;
    output reg zero;
    output reg [n-1:0] ALUResult;

    always @(A or B or ALUcontrol_in) begin
        case (ALUcontrol_in)
            //add
            4'b0000 : begin
                zero = 0;
                ALUResult <= A+B;
            end 

            //sub
            4'b0001 : begin
                if(A==B) zero = 1;
                else begin
                    zero = 0;
                    ALUResult <= A-B;
                end
            end

            //xor
            4'b0010 : begin
                zero = 0;
                ALUResult <= A^B;
            end

            //or
            4'b0011 : begin
                zero = 0;
                ALUResult <= A|B;
            end

            //and
            4'b0100 : begin
                zero = 0;
                ALUResult <= A&B;
            end

            //shift left logical
            4'b0101 : begin
                zero = 0;
                ALUResult <= A<<B;
            end

            //shift right logical
            4'b0110 : begin
                zero = 0;
                ALUResult <= A>>B;
            end

            //set less than
            4'b0111 : begin
                zero = 0;
                ALUResult <= (A < B) ? 1 : 0;
            end
            
            default: begin
                zero = 0;
                ALUResult <= A;
            end
        endcase
    end
endmodule