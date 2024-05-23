module Mux41 (Sel, A, B, C, Mux_out);
    parameter n = 32;
    input [1:0] Sel;
    input [n-1:0] A, B, C;
    output reg [n-1:0] Mux_out;

    always @(Sel, A, B, C) begin
        case (Sel)
            2'b00 : Mux_out = A;
            2'b01 : Mux_out = B;
            2'b10 : Mux_out = C; 
            default: Mux_out = 0;
        endcase
    end
endmodule