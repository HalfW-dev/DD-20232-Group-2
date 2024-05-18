module Mux (Sel, A, B, Mux_out);
    parameter n = 32;
    input Sel;
    input [n-1:0] A, B;
    output wire [n-1:0] Mux_out;

    assign Mux_out = (Sel == 1'b0) ? A : B;
endmodule