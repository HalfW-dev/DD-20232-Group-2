`timescale 1ps/1ps
module count_s_tb();
    reg set_s;
    reg clk;
    wire [5:0] cnt_s;
    //wire pulse_min;
    count_s dut(
        .set_s(set_s),
        .clk(clk),
        .cnt_s(cnt_s),
        .pulse_min(pulse_min)
    );
    always #5 clk = ~clk;

    // Initial values
    initial begin
        set_s = 0; // Set the initial value of set_s
        clk = 0;   // Initialize clk
        #10;
        set_s = 1; // Deassert set_s after 10 time units
    end

    // Monitor
    always @(posedge clk) begin
        $display("At time %t: cnt_s = %d, pulse_min = %b", $time, cnt_s, pulse_min);
    end
endmodule