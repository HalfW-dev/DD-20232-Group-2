module adder (in1, in2, sum);
    parameter n = 32;
    input [n-1:0] in1, in2;
    output [n-1:0] sum;
    assign sum = in1 + in2;
endmodule