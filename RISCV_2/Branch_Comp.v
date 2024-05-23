module Branch_Comp (A, B, BrUn, BrEq, BrLT);
    parameter n = 32;
    input [n-1:0] A, B;
    input BrUn;
    output reg BrEq, BrLT;

    always @(A, B, BrUn) begin
        if (A == B) BrEq = 1;
        else begin
            if(BrUn == 1'b1) begin
                if($unsigned(A) < $unsigned(B)) BrLT = 1'b1;
                else BrLT = 1'b0;
            end
            else begin
                if($signed(A) < $signed(B)) BrLT = 1'b1;
                else BrLT = 1'b0;
            end
        end
    end
endmodule