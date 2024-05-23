module Data_Memory (clk, rst_n, MemRW, address, Writedata, Data_out);
    parameter n = 32;
    input clk, rst_n, MemRW;
    input [n-1:0] address, Writedata;
    reg [n-1:0] DataMemory [2*n-1:0];
    output wire [n-1:0] Data_out;


    assign Data_out = (MemRW) ? DataMemory[address] : 32'b0;

    integer i;
    always @(posedge clk) begin
        if(~rst_n) begin
            for(i = 0; i < 2*n; i = i+1)
                DataMemory[i] <= 32'b0; 
        end
        else if(~MemRW)
            DataMemory[address] <= Writedata;
    end
endmodule