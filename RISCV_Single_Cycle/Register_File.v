module Register_File (clk, rst_n,Write_data_out, RegWrite, rs1, rs2, rd, Write_data, Read_data1, Read_data2);
    parameter n = 32;
    input clk, rst_n, RegWrite;
    input [4:0] rs1, rs2, rd;
    input [n-1:0] Write_data;
    output reg [n-1:0] Write_data_out;
   // output reg [n-1:0] Registers [n-1:0];
    input [n-1:0] Read_data1, Read_data2;

   reg [n-1:0] Registers [n-1:0];

    integer i;
    always @(posedge clk) begin
        if(~rst_n) begin
            for(i = 0; i < n; i = i+1)
                Registers[i] <= 32'h0; 
        end
        else if(RegWrite) begin
            Registers[rd] <= Write_data;

        end
    end

    always @(posedge clk) begin
        if(~rst_n) begin
            Write_data_out <= 0;
        end
        else if(RegWrite) begin
            Write_data_out <= Write_data;
            
        end
    end
    always @(Read_data1, Read_data2) begin
        Registers[rs1] = Read_data1;
        Registers[rs2] = Read_data2;
    end
    // assign Read_data1 = Registers[rs1];
    // assign Read_data2 = Registers[rs2];
endmodule