
// module Program_Counter (clk, rst_n,PC_present, PC_out);
//     parameter n = 32;
//     input clk;
//     input rst_n;
//     input [n-1:0] PC_present;
//     output wire [n-1:0] PC_out;
//     reg [n-1:0] PC_next;
//     always @(posedge clk) begin
//         if(~rst_n) begin
//             PC_next <= 32'h0;
//         end
//         else
//             PC_next <= PC_present;
//     end 
//     assign PC_out = PC_next + 32'h4;   
// endmodule

module Program_Counter (clk, rst_n, PC_in, PC_next);
    parameter n = 32;
    input clk;
    input rst_n;
    input [n-1:0] PC_in;
    output reg [n-1:0] PC_next;
    always @(posedge clk) begin
        if(~rst_n) begin
            PC_next <= 32'h0;
        end
        else
            PC_next <= PC_in;
    end    
endmodule

module PCadd4 (PC_next, PC_out);
    parameter n = 32;
    input [n-1:0] PC_next;
    output [n-1:0] PC_out;

    assign PC_out = PC_next + 32'h4;
endmodule