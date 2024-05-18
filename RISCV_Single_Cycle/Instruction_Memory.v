module Instruction_Memory(clk, rst_n, read_address, Instruction_out);
    parameter n = 32;
    input clk;
    input rst_n;
    input [n-1:0] read_address;
   // input [n-1:0] datain;
    output wire [n-1:0] Instruction_out;

   reg [n-1:0] Imemory [0:2*n-1]; //mem of 64 each 32 bit wide

integer i;
assign Instruction_out = Imemory[read_address];
always @(posedge clk) begin
    if(~rst_n) begin
        for(i = 0; i < 2*n; i = i+1)
            Imemory[i] <= 32'b0; 
    end
  //  else Instruction_out <= datain;
end    
endmodule